# Requires: RSAT GroupPolicy + ActiveDirectory modules
Import-Module GroupPolicy
Import-Module ActiveDirectory

# =========================
# CONFIG (pnpt.local lab)
# =========================
$DomainFqdn = "pnpt.local"
$GpoName    = "PNPT-User-Launch-ISE-Admin"
$TargetUser = "pnpt\pnpt" # domain\sam
$TaskName   = "Launch PowerShell ISE (Admin)"

# Link at domain root so it works "on any box"
$LinkTargetDn = "DC=pnpt,DC=local"

# GPP Scheduled Tasks CSE GUID pair (Scheduled Tasks preference)
# Stored in gPCUserExtensionNames as: [{AADCED64...}{CAB54552...}]
$SchedTasksPrefCseGuid  = "{AADCED64-746C-4633-A97C-D61349046527}"
$SchedTasksPrefToolGuid = "{CAB54552-DEEA-4691-817E-ED4A4D1AFC72}"

# Root ScheduledTasks.xml CLSIDs
$ScheduledTasksRootClsid = "{CC63F200-7309-4ba0-B154-A71CD118DBCC}"
$TaskV2Clsid             = "{D8896631-B747-47a7-84A6-C155337F3BC8}"

# =========================
# Resolve user + SID
# =========================
$domain, $sam = $TargetUser.Split("\", 2)
$userObj = Get-ADUser -Identity $sam -ErrorAction Stop
$userSid = $userObj.SID.Value

# =========================
# Create / get GPO
# =========================
$gpo = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $GpoName
}

# =========================
# Link GPO (domain root)
# =========================
New-GPLink -Name $GpoName -Target $LinkTargetDn -Enforced:$false -LinkEnabled Yes -ErrorAction SilentlyContinue | Out-Null

# =========================
# Security filtering:
# - pnpt\pnpt: Apply
# - Authenticated Users: Read only (no apply)
# =========================
Set-GPPermission -Name $GpoName -TargetName $TargetUser -TargetType User  -PermissionLevel GpoApply -ErrorAction Stop
Set-GPPermission -Name $GpoName -TargetName "Authenticated Users" -TargetType Group -PermissionLevel GpoRead -ErrorAction SilentlyContinue

# =========================
# Write GPP ScheduledTasks.xml into SYSVOL (User-side)
# Location:
# \\pnpt.local\SYSVOL\pnpt.local\Policies\{GPO-GUID}\User\Preferences\ScheduledTasks\ScheduledTasks.xml
# =========================
$gpoGuidBraced = "{0}" -f $gpo.Id.ToString("B").ToUpper()   # already braced
$policyRoot    = "\\$DomainFqdn\SYSVOL\$DomainFqdn\Policies\$gpoGuidBraced"
$prefDir       = Join-Path $policyRoot "User\Preferences\ScheduledTasks"
$xmlPath       = Join-Path $prefDir "ScheduledTasks.xml"

New-Item -Path $prefDir -ItemType Directory -Force | Out-Null

# Build a deterministic UID for the preference item (stable across reruns)
# (You can change this if you want a new preference item each run.)
$prefItemUid = [Guid]::NewGuid().ToString("B").ToUpper()
$changedStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

# Task XML (Task Scheduler schema)
# - LogonTrigger for this user SID
# - Runs as that user SID
# - HighestAvailable = "Run with highest privileges"
# Note: Using SID in UserId avoids name->SID mapping failures.  :contentReference[oaicite:1]{index=1}
$scheduledTasksXml = @"
<?xml version="1.0" encoding="utf-8"?>
<ScheduledTasks clsid="$ScheduledTasksRootClsid">
  <TaskV2 clsid="$TaskV2Clsid"
          name="$TaskName"
          image="2"
          changed="$changedStamp"
          uid="$prefItemUid"
          userContext="1"
          removePolicy="1">
    <Properties action="U" name="$TaskName" runAs="$userSid" logonType="InteractiveToken">
      <Task version="1.3">
        <RegistrationInfo>
          <Author>$TargetUser</Author>
          <Description>Launch PowerShell ISE elevated at logon for $TargetUser</Description>
        </RegistrationInfo>

        <Principals>
          <Principal id="Author">
            <UserId>$userSid</UserId>
            <LogonType>InteractiveToken</LogonType>
            <RunLevel>HighestAvailable</RunLevel>
          </Principal>
        </Principals>

        <Settings>
          <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
          <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
          <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
          <AllowHardTerminate>true</AllowHardTerminate>
          <StartWhenAvailable>true</StartWhenAvailable>
          <AllowStartOnDemand>true</AllowStartOnDemand>
          <Enabled>true</Enabled>
          <Hidden>false</Hidden>
          <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
          <Priority>7</Priority>
        </Settings>

        <Triggers>
          <LogonTrigger>
            <Enabled>true</Enabled>
            <UserId>$userSid</UserId>
          </LogonTrigger>
        </Triggers>

        <Actions Context="Author">
          <Exec>
            <Command>C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe</Command>
          </Exec>
        </Actions>

      </Task>
    </Properties>
  </TaskV2>
</ScheduledTasks>
"@

# Write XML as UTF-8 (no BOM is generally safest for GPP XML)
[System.IO.File]::WriteAllText($xmlPath, $scheduledTasksXml, (New-Object System.Text.UTF8Encoding($false)))

# =========================
# Update the GPO's AD attributes so clients PROCESS Scheduled Tasks preference
# - gPCUserExtensionNames must include the Scheduled Tasks preference GUID pair
# - versionNumber (user half) must increment
# - GPT.INI version must match (high 16 bits user / low 16 bits machine)
# =========================
$gpoAdDn = "CN=$gpoGuidBraced,CN=Policies,CN=System,$LinkTargetDn"
$gpoAd   = Get-ADObject -Identity $gpoAdDn -Properties gPCUserExtensionNames, versionNumber

$pair = "[${SchedTasksPrefCseGuid}${SchedTasksPrefToolGuid}]"

$currentExt = [string]$gpoAd.gPCUserExtensionNames
if ([string]::IsNullOrWhiteSpace($currentExt)) {
    # If empty, add just the scheduled tasks pair
    $newExt = $pair
} elseif ($currentExt -notlike "*$pair*") {
    $newExt = $currentExt + $pair
} else {
    $newExt = $currentExt
}

# Increment USER version in versionNumber (high 16 bits)
$oldVer = [int]$gpoAd.versionNumber
$newVer = $oldVer + 0x00010000

Set-ADObject -Identity $gpoAdDn -Replace @{
    gPCUserExtensionNames = $newExt
    versionNumber         = $newVer
}

# Update GPT.INI to match versionNumber
$gptIniPath = Join-Path $policyRoot "GPT.INI"
if (-not (Test-Path $gptIniPath)) {
    New-Item -Path $gptIniPath -ItemType File -Force | Out-Null
    Set-Content -Path $gptIniPath -Value "[General]`r`nVersion=0`r`n" -Encoding ASCII
}

$gpt = Get-Content $gptIniPath -Raw
if ($gpt -notmatch "(?im)^Version=\d+") {
    $gpt = $gpt.TrimEnd() + "`r`nVersion=0`r`n"
}

$gpt = [regex]::Replace($gpt, "(?im)^Version=\d+", ("Version={0}" -f $newVer))
Set-Content -Path $gptIniPath -Value $gpt -Encoding ASCII

Write-Host "Done."
Write-Host "GPO: $GpoName"
Write-Host "Linked at: $LinkTargetDn"
Write-Host "User: $TargetUser (SID: $userSid)"
Write-Host "ScheduledTasks.xml: $xmlPath"
Write-Host ""
Write-Host "On a client, log on as $TargetUser and run: gpupdate /force"

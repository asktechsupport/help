Import-Module GroupPolicy

# ===== CONFIG =====
$DomainFqdn = "pnpt.local"
$GpoName    = "UserLogon-GPUpdateForce-PNPT"
$OuDn       = "OU=Testing,OU=Servers,OU=Resources,OU=pnpt.local,DC=pnpt,DC=local"
$TaskName   = "GPUpdateForce_OnLogon_PNPT"

# The specific account that should trigger the task
$TriggerUser = "PNPT\PNPT"

# ===== CREATE / GET GPO =====
$gpo = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $GpoName
}

# ===== LINK GPO TO OU (idempotent-ish) =====
try {
    New-GPLink -Name $GpoName -Target $OuDn -Enforced:$false -LinkEnabled Yes -ErrorAction Stop | Out-Null
} catch {
    # Most common reason: link already exists
}

# ===== Write GPP Scheduled Task XML into SYSVOL =====
$GpoGuid    = "{" + $gpo.Id.Guid.ToString().ToUpper() + "}"
$PolicyRoot = "\\$DomainFqdn\SYSVOL\$DomainFqdn\Policies\$GpoGuid"
$SchedDir   = Join-Path $PolicyRoot "Machine\Preferences\ScheduledTasks"
$SchedXml   = Join-Path $SchedDir "ScheduledTasks.xml"

New-Item -Path $SchedDir -ItemType Directory -Force | Out-Null

# Command to run at logon (runs as SYSTEM; triggers only when PNPT\PNPT logs on)
$Cmd = "gpupdate /force"

$Xml = @"
<?xml version="1.0" encoding="utf-8"?>
<ScheduledTasks>
  <TaskV2 name="$TaskName" image="0">
    <Properties action="U" taskName="$TaskName" runAs="SYSTEM">
      <Task version="1.2">
        <Triggers>
          <LogonTrigger>
            <Enabled>true</Enabled>
            <UserId>$TriggerUser</UserId>
          </LogonTrigger>
        </Triggers>
        <Principals>
          <Principal id="Author">
            <UserId>S-1-5-18</UserId>
            <RunLevel>HighestAvailable</RunLevel>
          </Principal>
        </Principals>
        <Settings>
          <Enabled>true</Enabled>
          <ExecutionTimeLimit>PT15M</ExecutionTimeLimit>
          <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
          <StartWhenAvailable>true</StartWhenAvailable>
        </Settings>
        <Actions Context="Author">
          <Exec>
            <Command>cmd.exe</Command>
            <Arguments>/c $Cmd</Arguments>
          </Exec>
        </Actions>
      </Task>
    </Properties>
  </TaskV2>
</ScheduledTasks>
"@

Set-Content -Path $SchedXml -Value $Xml -Encoding UTF8

Write-Host "Done."
Write-Host "GPO:   $GpoName"
Write-Host "Linked to: $OuDn"
Write-Host "Task:  $TaskName (triggers on logon of $TriggerUser, runs gpupdate /force as SYSTEM)"
Write-Host "XML:   $SchedXml"

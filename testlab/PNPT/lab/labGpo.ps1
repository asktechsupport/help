# Import the GroupPolicy module
Import-Module GroupPolicy

# Define variables
$GPOName = "pnptLab-gpoSettings"
$AppLockerPath = "HKLM\SOFTWARE\Policies\Microsoft\Windows\SrpV2"
$ApplockerExecutableKey = "$AppLockerPath\ExecutableRules"
$GPOAuditPath = "HKLM\SOFTWARE\Policies\Microsoft\Windows\System"
$auditCategory = "Audit Policy Change"
$auditSubcategory = "Audit Audit Policy Change"
$auditCommand = "auditpol /set /subcategory:'$auditSubcategory' /success:enable /failure:enable"
$domain = (Get-ADDomain).DNSRoot
$EdgeKey = "HKLM\SOFTWARE\Policies\Microsoft\Edge"

# Create a new GPO if it doesn't already exist
if (-not (Get-GPO -Name $GPOName -ErrorAction SilentlyContinue)) {
    $GPO = New-GPO -Name $GPOName -Domain $domain
    Write-Host "GPO Created: $($GPO.DisplayName)"
} else {
    $GPO = Get-GPO -Name $GPOName
    Write-Host "GPO '$GPOName' already exists."
}

# Disable Windows Defender for lab purposes
Set-GPRegistryValue -Name "Disable Windows Defender" -Key "HKLM\Software\Policies\Microsoft\Windows Defender" -ValueName "DisableAntiSpyware" -Type Dword -Value 1


# Guest Account Status Reinforcement
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -ValueName "DisableGuestAccount" -Type Dword -Value 1
Disable-ADAccount -Identity Guest -ErrorAction SilentlyContinue
Write-Host "Guest account has been disabled."

# Stop LAN Manager hash values being stored on next password changes
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "NoLMHash" -Type Dword -Value 1
Write-Host "LAN Manager hash storage has been disabled."

# Monitor changes to GPO settings using Group Policy Logging and Auditing
Set-GPRegistryValue -Name $GPOName -Key $GPOAuditPath -ValueName "GPOAuditEnabled" -Type Dword -Value 1
Write-Host "GPO Auditing has been enabled to monitor changes."

# Enable Advanced Audit Policy for GPO changes
Invoke-Expression '$auditCommand'
Write-Host "Advanced Audit Policy enabled for 'Audit Policy Change'"

# Disable Microsoft Edge First Run and Startup Screens
Set-GPRegistryValue -Name $GPOName -Key $EdgeKey -ValueName "HideFirstRunExperience" -Type Dword -Value 1
Set-GPRegistryValue -Name $GPOName -Key $EdgeKey -ValueName "ImportStartupSettings" -Type Dword -Value 0
Write-Host "Microsoft Edge First Run experience and startup screens have been disabled."

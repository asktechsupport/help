# Import the GroupPolicy module
Import-Module GroupPolicy

# Define variables
$GPOName = "recommended-windows-gpoSettings"
  $AppLockerPath = "HKLM\SOFTWARE\Policies\Microsoft\Windows\SrpV2"
  $ApplockerExecutableKey = "$AppLockerPath\ExecutableRules"
  $GPOAuditPath = "HKLM\SOFTWARE\Policies\Microsoft\Windows\System"
  $auditCategory = "Audit Policy Change"
  $auditSubcategory = "Audit Audit Policy Change"
  $auditCommand = "auditpol /set /subcategory:`"$auditSubcategory`" /success:enable /failure:enable"
$domain = (Get-ADDomain).DNSRoot

# Create a new GPO if it doesn't already exist
if (-not (Get-GPO -Name $GPOName -ErrorAction SilentlyContinue)) {
    $GPO = New-GPO -Name $GPOName -Domain $domain
    Write-Host "GPO Created: $($GPO.DisplayName)"
} else {
    $GPO = Get-GPO -Name $GPOName
    Write-Host "GPO '$GPOName' already exists."
}

# Apply setting to disable Control Panel
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoControlPanel" -Type Dword -Value 1
Write-Host "Control Panel has been disabled."

# Apply setting to disable Command Prompt
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Policies\Microsoft\Windows\System" -ValueName "DisableCMD" -Type Dword -Value 2
Write-Host "Command prompt has been disabled for domain users."

# Apply setting to deny access to removable storage
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices" -ValueName "Deny_All" -Type Dword -Value 1
Write-Host "Removable storage access is denied."

# AppLocker to Prevent Unwanted Software Installation
Set-GPRegistryValue -Name $GPOName -Key $AppLockerPath -ValueName "EnforcementMode" -Type Dword -Value 1
Set-GPRegistryValue -Name $GPOName -Key $ApplockerExecutableKey -ValueName "Allow_Microsoft_Signed_Apps" -Type Dword -Value 1
Set-GPRegistryValue -Name $GPOName -Key $ApplockerExecutableKey -ValueName "Deny_Untrusted_Apps" -Type Dword -Value 0
Write-Host "AppLocker has been configured."

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

# Define variables
Import-Module GroupPolicy
$GPOName = "CIS_Level2_Hardening_GPO"
$domain = (Get-ADDomain).DNSRoot

# Create a new GPO for CIS Level 2 Hardening
$GPO = New-GPO -Name $GPOName -Domain $domain
Write-Host -ForegroundColor Green -ForegroundColor Green "GPO Created: $($GPO.DisplayName)"

# -------------------------------
# CIS Level 2 Hardening Settings
# -------------------------------

# Computer Configuration: Require Smart Card for Interactive Logon
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "ScForceOption" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Require Smart Card for interactive logon"

# Computer Configuration: Set Maximum Password Age to 60 days
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -ValueName "MaximumPasswordAge" -Type Dword -Value 60
Write-Host -ForegroundColor Green "Set maximum password age to 60 days"

# Computer Configuration: Enable Audit Logon Events
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security" -ValueName "AuditLogonEvents" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Enabled audit logon events"

# Computer Configuration: Enable Audit Account Logon Events
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security" -ValueName "AuditAccountLogon" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Enabled audit account logon events"

# Computer Configuration: Disable LAN Manager Hash Storage
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "NoLMHash" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Disabled LAN Manager hash storage"

# Computer Configuration: Enable NTLM Block Policy (Deny All)
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -ValueName "NTLMMinServerSec" -Type Dword -Value 536870912
Write-Host -ForegroundColor Green "Enabled NTLM Block Policy (Deny All)"

# Computer Configuration: Enable "Audit Other Logon/Logoff Events"
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security" -ValueName "AuditOtherLogonEvents" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Enabled auditing of other logon/logoff events"

# Computer Configuration: Enable User Account Control (UAC)
# Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "EnableLUA" -Type Dword -Value 1
# Write-Host -ForegroundColor Green "Enabled User Account Control (UAC)"
Write-Host -ForegroundColor Yellow  "Skipped setting UAC settings as this causes issues in enterprise environments"

# Computer Configuration: Disable Anonymous Access to Named Pipes and Shares
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -ValueName "RestrictNullSessAccess" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Disabled anonymous access to named pipes and shares"

# Computer Configuration: Disable IPv6 (if not needed in the environment)
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters" -ValueName "DisabledComponents" -Type Dword -Value 255
Write-Host -ForegroundColor Green "Disabled IPv6"

# Computer Configuration: Set Screen Lock Timeout to 15 minutes
# Set-GPRegistryValue -Name $GPOName -Key "HKCU\Control Panel\Desktop" -ValueName "ScreenSaveTimeOut" -Type String -Value "900"
# Write-Host -ForegroundColor Green "Set screen lock timeout to 15 minutes"
Write-Host -ForegroundColor Yellow  "Skipped setting screen lockout settings as this causes issues in enterprise environments"

# Computer Configuration: Ensure Only Administrators Have Remote Access to the Registry
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" -ValueName "RestrictRemoteAccess" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Restricted remote access to the registry for non-administrators"

# Computer Configuration: Disable Automatic Administrative Share Creation
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -ValueName "AutoShareWks" -Type Dword -Value 0
Write-Host -ForegroundColor Green "Disabled automatic administrative share creation"

# User Configuration: Disable Windows Store Access
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoUseStoreOpenWith" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Disabled access to Windows Store"

# Computer Configuration: Enable Full Auditing for File and Object Access
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security" -ValueName "AuditObjectAccess" -Type Dword -Value 1
Write-Host -ForegroundColor Green "Enabled full auditing for file and object access"

# -------------------------------
# End of CIS Level 2 Hardening Settings
# -------------------------------

Write-Host -ForegroundColor Green "CIS Level 2 Hardening GPO Configuration Complete!"

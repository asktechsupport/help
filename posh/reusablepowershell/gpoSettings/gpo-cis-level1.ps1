# Define variables
Import-Module GroupPolicy
$GPOName = "CIS_Level1_Hardening_GPO"
$domain = (Get-ADDomain).DNSRoot

# Create a new GPO for CIS Level 1 Hardening
$GPO = New-GPO -Name $GPOName -Domain $domain
Write-Host -ForegroundColor Green "GPO Created: $($GPO.DisplayName)"

# -------------------------------
# CIS Level 1 Hardening Settings
# -------------------------------

# Computer Configuration: Disable Guest Account
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -ValueName "AutoAdminLogon" -Type Dword -Value 0
Write-Host "Disabled Guest Account"

# Computer Configuration: Account Lockout - Lockout Threshold (5 Invalid Attempts)
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Policies\System" -ValueName "LockoutThreshold" -Type Dword -Value 5
Write-Host "Set account lockout threshold to 5 invalid attempts"

# Computer Configuration: Password Policy - Minimum Password Length (14 characters)
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -ValueName "MinimumPasswordLength" -Type Dword -Value 14
Write-Host "Set minimum password length to 14 characters"

# Computer Configuration: Enable Windows Defender Antivirus
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" -ValueName "DisableAntiSpyware" -Type Dword -Value 0
Write-Host "Enabled Windows Defender Antivirus"

# Computer Configuration: Disable SMBv1 (SMB version 1 is insecure)
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -ValueName "SMB1" -Type Dword -Value 0
Write-Host "Disabled SMBv1"

# User Configuration: Disable Control Panel and Settings Access
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoControlPanel" -Type Dword -Value 1
Write-Host "Disabled Control Panel and Settings access for users"

# User Configuration: Prevent Access to Command Prompt
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Policies\Microsoft\Windows\System" -ValueName "DisableCMD" -Type Dword -Value 2
Write-Host "Disabled access to command prompt for users"

# Computer Configuration: Enable Account Lockout Duration (30 minutes)
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Policies\System" -ValueName "LockoutDuration" -Type Dword -Value 30
Write-Host "Set account lockout duration to 30 minutes"

# Computer Configuration: Set Password Complexity Requirements
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -ValueName "PasswordComplexity" -Type Dword -Value 1
Write-Host "Enabled password complexity requirements"

# Computer Configuration: Disable Anonymous Enumeration of SAM Accounts and Shares
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "RestrictAnonymousSAM" -Type Dword -Value 1
Write-Host "Disabled anonymous enumeration of SAM accounts and shares"

# Computer Configuration: Enable Windows Firewall
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -ValueName "EnableFirewall" -Type Dword -Value 1
Write-Host "Enabled Windows Firewall for domain profile"

# -------------------------------
# End of CIS Level 1 Hardening Settings
# -------------------------------

Write-Host "CIS Level 1 Hardening GPO Configuration Complete!"

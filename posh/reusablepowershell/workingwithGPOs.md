### GPOs

```powershell
# Start
Import-Module GroupPolicy
Import-Module ActiveDirectory
$domain = Get-ADDomain | select -ExpandProperty DNSRoot    # Example: Contoso.com
$GPOName = "CommonWindowsSettingsGPO"
$ouName = Get-ADDomain | select -ExpandProperty DNSRoot # Example: OU=IT,DC=Contoso,DC=com
$ouPath = Get-ADDomain | select DistinguishedName  # Base path of the domain

# Full DN of the new OU (e.g., OU=Contoso.com,DC=Contoso,DC=com)
$ouFullPath = "OU=$ouName,$ouPath"

# Create a new OU
New-ADOrganizationalUnit -Name $ouName -Path $ouPath
Write-Host -ForegroundColor Green "Organizational Unit '$ouName' has been created at '$ouPath'"

# Create a new GPO
$GPO = New-GPO -Name $GPOName -Domain $domain
Write-Host -ForegroundColor Green "GPO Created: $($GPO.DisplayName)"

# Link the GPO to the newly created OU
New-GPLink -Name $GPOName -Target $ouFullPath
Write-Host -ForegroundColor Green "GPO '$GPOName' Linked to OU '$ouFullPath'"

# Set common Windows settings using GPO

# Example: Disable Control Panel access (User Configuration)
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoControlPanel" -Type Dword -Value 1
Write-Host "Disabled Control Panel Access"

# Example: Disable Task Manager (User Configuration)
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "DisableTaskMgr" -Type Dword -Value 1
Write-Host "Disabled Task Manager"

# Example: Set screensaver timeout (User Configuration)
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Control Panel\Desktop" -ValueName "ScreenSaveTimeOut" -Type String -Value "600"
Write-Host "Set screensaver timeout to 10 minutes"

# Example: Force password complexity (Computer Configuration)
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "MinimumPasswordLength" -Type Dword -Value 8
Write-Host "Set password complexity to require a minimum of 8 characters"

# Example: Disable guest account (Computer Configuration)
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -ValueName "AutoAdminLogon" -Type Dword -Value 0
Write-Host "Disabled Guest Account"

Write-Host "GPO Configuration Complete!"
```

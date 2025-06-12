Increasing Windows server connections to more than the default 2

Install the Session Host feature

```powershell
Install-WindowsFeature -Name RDS-RD-Server
```
⚠️Reboot

> NOTE - if your domain already has a group policy for RDS licensing, apply that to the OU that the server is in
> 
> if not, you can create a new GPO using the script below.

```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Get the domain distinguished name
     $domain = (Get-ADDomain).DistinguishedName
     Write-Output "Domain: $domain"

# Define variables
$GPOName = "SpecifyRDSLicensingServer"
$LicenseServer = "YourLicenseServer"
$LicensingMode = 4  # 2 for Per Device, 4 for Per User

New-GPO -Name $GPOName

# Set the licensing server
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -ValueName "LicenseServers" -Type String -Value $LicenseServer
# Set the licensing mode
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -ValueName "LicensingMode" -Type DWORD -Value $LicensingMode

# Force Group Policy update
gpupdate /force
#
```
Now you can apply the GPO to the OU for the servers you need to RDP to. 

Ensure your group policies are setup to select the assigned Remote Desktop Licenses server for your domain

⚠️
It is recommended you do not apply across the entire domain unless you know your access figures very accurately.


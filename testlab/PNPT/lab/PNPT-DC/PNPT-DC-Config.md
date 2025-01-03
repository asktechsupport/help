> [!WARNING]
> Run the scripts in order, errors occur when you run as a single script without reboots.
## Run Script 001: Configure IP and rename machine
Configure a static IP, install DNS, disable ipv6 & rename the machine
```powershell
#Create the PNPT lab with powershell
#Run on your new Domain Controller. This script has been tested successfully in the author's lab environment.

#VARS
$folder = "Directory"
$netAdapterName = "pnpt.local"
$dcHostname = "PNPT-DC"

#SCRIPT INPUT
New-Item -Path 'C:\Temp' -ItemType $folder
New-Item -Path 'C:\Apps' -ItemType $folder

Rename-NetAdapter -Name “Ethernet0" -NewName $netAdapterName
New-NetIPAddress 10.0.0.1 -InterfaceAlias $netAdapterName -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias $netAdapterName -ServerAddresses 127.0.0.1
Disable-NetAdapterBinding -Name $netAdapterName -ComponentID ms_tcpip6

Install-WindowsFeature -Name Telnet-Client
Rename-Computer $dcHostname
Restart-Computer # ⚠️Reboot Required⚠️
#
```
> [!WARNING]
> The script will reboot the machine for you.
## Run Script 002: Create the domain "pnpt.local"
Create the domain "pnpt.local"
```powershell

#Install DNS
Install-WindowsFeature -Name DNS -IncludeManagementTools

#Install DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
  netsh dhcp add securitygroups #This adds DHCP Administrators and DHCP Users
  Restart-Service dhcpserver

#Install Active Directory
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName pnpt.local

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "pnpt.local" `
-DomainNetbiosName "pnpt" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

#Check that admin password is not stored in the XML files (Sysvol mining exploit)
#\\pnpt\SYSVOL\basicvlab\Policies\

#findstr /S /I cpassword \\basicvlab.local\sysvol\basicvlab.local\policies\*.xml
# ⚠️Reboot Required⚠️
```
> [!WARNING]
> The script will reboot the machine for you.
## Run Script 003: Join the domain
Join the domain
```powershell
Add-Computer -DomainName pnpt.local
# when prompted for creds enter
# Administrator
# Password456!
# Restart-Computer -Force ⚠️Reboot Required⚠️
#
```
> [!WARNING]
> The script will reboot the machine for you.
## Run Script 004: Install the Certificate Authority Server Role
Install the Certificate Authority Server Role
```powershell
Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -Force
#
```
*Reboot not required to install the Certificate Authority (AC DS) Role


[Find useful AD variables here](https://github.com/asktechsupport/help/blob/main/posh/reusablepowershell/usefulVariables.md)

- [x] Tested and working in the authors lab environment.
> [!WARNING]
> Run the scripts in order, errors occur when you run as a single script without reboots.

## Run Script 001: Configure IP and rename machine(s)
Configure a static IP, install DNS, disable ipv6 & rename the machine
> [!NOTE]
> You may need to pay attention to the hostname variable and IP address variable and change the script accordingly.
```powershell
#Create the PNPT lab with powershell
#Run on your new Domain Controller. This script has been tested successfully in the author's lab environment.

#VARS
$folder = "Directory"
$netAdapterName = "pnpt.local"
$renameHost = "PNPT-USER-PC01"

#SCRIPT INPUT
New-Item -Path 'C:\Temp' -ItemType $folder
New-Item -Path 'C:\Apps' -ItemType $folder

Rename-NetAdapter -Name “Ethernet0" -NewName $netAdapterName
New-NetIPAddress 10.0.0.2 -InterfaceAlias $netAdapterName -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias $netAdapterName -ServerAddresses 10.0.0.1
Disable-NetAdapterBinding -Name $netAdapterName -ComponentID ms_tcpip6

Install-WindowsFeature -Name Telnet-Client
Rename-Computer $renameHost
Restart-Computer -Force # ⚠️Reboot Required⚠️
#
```
> [!WARNING]
> The script will reboot the machine for you.

## Run script to join the domain
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

## Create local user accounts
> [!NOTE]
> You need to pay attention to the $newUser variable and change the script accordingly.
```powershell
# Step 1: Create the local user
$newUser = "PC-Local-Admin01"
New-LocalUser -Name $newUser -Password (ConvertTo-SecureString "Password456!" -AsPlainText -Force) -FullName $newUser -Description "Description of the user"

# Step 2: Add the user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $newUser
```



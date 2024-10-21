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


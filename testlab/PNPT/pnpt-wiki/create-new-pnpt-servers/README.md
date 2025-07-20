### Steps
1️⃣ Change the network adapter in vmware to pnpt.local

2️⃣ Power **ON**

3️⃣ Run script
```powershell
#Disable ipv6
Get-NetAdapterBinding –ComponentID ms_tcpip6 | disable-NetAdapterBinding -ComponentID ms_tcpip6 -PassThru
$getinterfaceindex = Get-NetIPConfiguration | select -ExpandProperty InterfaceIndex

Set-NetIPInterface -InterfaceAlias Ethernet0 #set to match the default interface alias value
Get-NetIPConfiguration
$ip = Read-Host "Enter the IP address"
New-NetIPAddress -IPAddress $ip -PrefixLength 24 -DefaultGateway "10.0.0.1" -InterfaceIndex $getinterfaceindex 
Set-DnsClientServerAddress -InterfaceIndex $getinterfaceindex -ServerAddresses ("10.0.0.1")

#Set Suffixes - credit https://eddiejackson.net/lab/2022/03/08/powershell-add-dns-suffix-to-ethernet-connections/
Set-DnsClientGlobalSetting -SuffixSearchList @("pnpt.local")

#Rename and join domain - credit https://stackoverflow.com/a/13492388
# get the credential 
$cred = get-credential

# Add and rename the computer with a prompt
Add-Computer -DomainName "pnpt.local" -Credential $cred -NewName (Read-Host -Prompt "Input the new PC name")
Get-NetIPConfiguration

#refresh dns

ipconfig /registerdns
```

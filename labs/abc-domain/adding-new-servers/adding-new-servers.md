### Steps
1️⃣ Change the network adapter in vmware to abc.local
<img width="367" height="58" alt="image" src="https://github.com/user-attachments/assets/8950eda5-7f57-4441-8d27-19eee7fdb0cd" />


2️⃣ Power **ON**

3️⃣ **Confirm the Network adapter is connected + connected at power on**

4️⃣ Run script
```powershell
$adapter = "Ethernet0"
$gateway = "10.0.0.1"
$dns = "10.0.0.1"

$ip = Read-Host "Enter the IP address"

$ifIndex = (Get-NetAdapter -Name $adapter).ifIndex

# Disable DHCP in both stores
Set-NetIPInterface -InterfaceIndex $ifIndex -AddressFamily IPv4 -Dhcp Disabled -PolicyStore ActiveStore
Set-NetIPInterface -InterfaceIndex $ifIndex -AddressFamily IPv4 -Dhcp Disabled -PolicyStore PersistentStore

Start-Sleep -Seconds 3

# Confirm DHCP is disabled
Get-NetIPInterface -InterfaceIndex $ifIndex -AddressFamily IPv4 |
    Format-Table InterfaceAlias,InterfaceIndex,Dhcp,PolicyStore

# Remove existing default route
Get-NetRoute -InterfaceIndex $ifIndex -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue |
    Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue

# Remove existing IPv4 addresses
Get-NetIPAddress -InterfaceIndex $ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object { $_.IPAddress -notlike "169.254*" } |
    Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

Start-Sleep -Seconds 3

# Add new static IP explicitly to ActiveStore
New-NetIPAddress `
    -InterfaceIndex $ifIndex `
    -IPAddress $ip `
    -PrefixLength 24 `
    -DefaultGateway $gateway `
    -PolicyStore ActiveStore

# Add DNS
Set-DnsClientServerAddress `
    -InterfaceIndex $ifIndex `
    -ServerAddresses $dns

Write-Host "Done. You may need to reboot for persistence." -ForegroundColor Green

#Set Suffixes - credit https://eddiejackson.net/lab/2022/03/08/powershell-add-dns-suffix-to-ethernet-connections/
Set-DnsClientGlobalSetting -SuffixSearchList @("abc.local")

#Rename and join domain - credit https://stackoverflow.com/a/13492388
# get the credential 
$cred = get-credential

# Add and rename the computer with a prompt
Add-Computer -DomainName "abc.local" -Credential $cred -NewName (Read-Host -Prompt "Input the new PC name")
Get-NetIPConfiguration

#refresh dns

ipconfig /registerdns
```

#Create 'basicvlab' with powershell
#Run on your new Domain Controller. This script has been tested successfully in the author's lab environment.
#working  12/2023 

$NewIPAddress = "10.0.0.1" #Define IP address
Rename-NetAdapter -Name “Ethernet0" -NewName “testlab" #Rename the network adapter
New-NetIPAddress $NewIPAddress -InterfaceAlias "testlab" -PrefixLength 24 #Set IP address
Set-DnsClientServerAddress -InterfaceAlias "testlab" -ServerAddresses 127.0.0.1 #Set DNS 
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 #turn off IPv6
ipconfig
Set-NetFirewallProfile -Enabled False #disable firewall (use with caution)
#
#
Install-WindowsFeature -Name DNS -IncludeManagementTools #Install DNS
Install-WindowsFeature DHCP -IncludeManagementTools #Install DHCP
  netsh dhcp add securitygroups #This adds DHCP Administrators and DHCP Users
  Restart-Service dhcpserver

#Install AD Forest "basicvlab.local"
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName basicvlab.local

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "basicvlab.local" `
-DomainNetbiosName "basicvlab" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

#Check that admin password is not stored in the XML files (Sysvol mining exploit)
#\\basicvlab\SYSVOL\basicvlab\Policies\

#findstr /S /I cpassword \\basicvlab.local\sysvol\basicvlab.local\policies\*.xml

#Create a clean with powershell
#Run on your new Domain Controller. This script has been tested successfully in the author's lab environment.

 
#Install DNS
Install-WindowsFeature -Name DNS -IncludeManagementTools

#Install DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
  netsh dhcp add securitygroups #This adds DHCP Administrators and DHCP Users
  netsh dhcp add "Domain Admins"
  Restart-Service dhcpserver

#Install AD Forest "domain.local"
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName domain.local

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "domain.local" `
-DomainNetbiosName "domain" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

#################################################################################
# Security best practices
#################################################################################
#Check that admin password is not stored in the XML files (Sysvol mining exploit)
#\\domain\SYSVOL\domain\Policies\

#findstr /S /I cpassword \\domain.local\sysvol\domain.local\policies\*.xml


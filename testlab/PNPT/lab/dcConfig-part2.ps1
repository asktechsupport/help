
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
#\\basicvlab\SYSVOL\basicvlab\Policies\

#findstr /S /I cpassword \\basicvlab.local\sysvol\basicvlab.local\policies\*.xml

# Import the GroupPolicy module
Import-Module GroupPolicy
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null #Loads the WSUS API Assembly


# Define variables
$domain = Get-ADDomain | select DNSRoot
$connectToWsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer("wsus", $False, 8531) # Connect to your wsus server
$GPOName = "Production WSUS Settings"
$WUServer = "https://WSUS.$domain:8531"
  # Create the initial target groups
  $newWsusTargetGroups = @("wsusTargetGroup_OWS", "wsusTargetGroup_QRM") | ForEach-Object { New-ADGroup -Name $_ -GroupScope Global -GroupCategory Security -Path Get-ADOrganizationalUnit -Filter 'Name -like "Security Groups*"'
 } 
    $wsusTargetGroups = Get-ADGroup -Filter 'Name -like "wsusTargetGroup*"'
    $existingGroup = $connectToWsus.GetComputerTargetGroups() | Where-Object { $_.Name -eq $wsusTargetGroups }  
      if ($existingGroup) {
          Write-Host "The group '$wsusTargetGroups' already exists." -ForegroundColor Red
      } else {
          $wsus.CreateComputerTargetGroup($groupName)
          Write-Host "The group '$newWsusTargetGroup' has been created." -ForegroundColor Green
      }
      $connectToWsus.CreateComputerTargetGroup($newWsusTargetGroup)
    

  


# Set the intranet update service location
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" -ValueName "WUServer" -Type String -Value $WUServer
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" -ValueName "WUStatusServer" -Type String -Value $WUServer

# Enable client-side targeting
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" -ValueName "TargetGroupEnabled" -Type DWord -Value 1
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" -ValueName "TargetGroup" -Type String -Value $wsusTargetGroups

# Configure automatic updates
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "NoAutoUpdate" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "AUOptions" -Type DWord -Value 4
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "ScheduledInstallDay" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "ScheduledInstallTime" -Type DWord -Value 3

# Allow automatic updates immediate installation
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "AutoInstallMinorUpdates" -Type DWord -Value 1

# Enable non-administrators to receive update notifications
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" -ValueName "ElevateNonAdmins" -Type DWord -Value 1

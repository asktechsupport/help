#Add the Defender Antivirus Feature (Add Roles and Feature wizard)
Install-WindowsFeature -Name Windows-Defender
write-host "Windows Defender Antivirus features has been installed" -ForegroundColor Green

#Copy onboarding script to Shared location/drive – to access from server 
copy-item -path "\\prod.int.aldermore.co.uk\SYSVOL\prod.int.aldermore.co.uk\scripts\WindowsDefenderATPLocalOnboardingScript2022.cmd" -Destination c:\temp
write-host "copied onboarding script from NETLOGON to c:\temp" -ForegroundColor Green

#Run Onboarding Script (May take up to 90 minutes to register in portal) 
Start-Process -FilePath "C:\temp\WindowsDefenderATPLocalOnboardingScript2022.cmd"

#Reboot the Server 
write-host "THE SERVER WILL REBOOT IN 5 SECONDS" -ForegroundColor red
#shutdown /r /t 5

#Run get-mpcomputerstatus command to check if feature is installed/AV status is enabled
get-mpcomputerstatus

  

       

      

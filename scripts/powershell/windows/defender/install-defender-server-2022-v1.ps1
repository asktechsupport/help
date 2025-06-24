Import-Module ActiveDirectory
#vars
$domain = (Get-ADDomain).DNSRoot
$scriptPath = "\\$domain\SYSVOL\$domain\scripts\WindowsDefenderATPLocalOnboardingScript2022.cmd"

# Add the Defender Antivirus Feature (Add Roles and Feature wizard)
Install-WindowsFeature -Name Windows-Defender
Write-Host "Windows Defender Antivirus features has been installed" -ForegroundColor Green

# Copy onboarding script to Shared location/drive – to access from server 

# Copy to destination
Copy-Item -Path $scriptPath -Destination "C:\temp"

Write-Host "Copied onboarding script from NETLOGON to C:\temp" -ForegroundColor Green

# Run Onboarding Script (May take up to 90 minutes to register in portal) 
Start-Process -FilePath "cmd.exe" -ArgumentList "/c C:\temp\WindowsDefenderATPLocalOnboardingScript2022.cmd" -Verb RunAs

# Run get-mpcomputerstatus command to check if feature is installed/AV status is enabled
Get-MpComputerStatus

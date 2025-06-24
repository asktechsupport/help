# Check for Admin Rights
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "⚠️  Please run PowerShell ISE as Administrator!"
    Pause
    exit
}

# Vars
$domain = "yourdomain.com"  # Replace with your actual domain
$ScriptName = "WindowsDefenderATPLocalOnboardingScript2022.cmd"
$OnboardingScriptPath = "\\$domain\SYSVOL\$domain\scripts\$ScriptName"
$destination = "C:\temp"
$DestinationScriptPath = Join-Path $destination $ScriptName

# Ensure destination directory exists
if (-not (Test-Path $destination)) {
    New-Item -ItemType Directory -Path $destination | Out-Null
}

# Add the Defender Antivirus Feature
Install-WindowsFeature -Name Windows-Defender
Write-Host "✅ Windows Defender Antivirus feature has been installed." -ForegroundColor Green

# Copy script from SYSVOL
Copy-Item -Path $OnboardingScriptPath -Destination $DestinationScriptPath -Force
Write-Host "✅ Copied onboarding script from SYSVOL to $DestinationScriptPath" -ForegroundColor Green

# Run Onboarding Script as Admin
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$DestinationScriptPath`"" -Verb RunAs

# Check Defender AV status
Get-MpComputerStatus

# Ensure the registry path exists
$regPath = "HKLM:\SOFTWARE\Policies\BaseImageScriptFramework\AntiVirus"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the policy to disabled (0)
Set-ItemProperty -Path $regPath -Name "RunAntiVirusScan" -Value 0 -Type DWord

Write-Host "BIS-F 'Run Antivirus Scan' policy has been disabled."

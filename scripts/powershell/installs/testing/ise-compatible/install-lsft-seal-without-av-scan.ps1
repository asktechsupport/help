# Run as Administrator to modify HKLM
$regPath = "HKLM:\SOFTWARE\Policies\BaseImageScriptFramework\AntiVirus"
$propertyName = "RunAntiVirusScan"
$desiredValue = 0

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    try {
        New-Item -Path $regPath -Force | Out-Null
        Write-Host "Created registry path: $regPath"
    } catch {
        Write-Host "Failed to create registry path. Run PowerShell ISE as Administrator." -ForegroundColor Red
        return
    }
}

# Set the policy value
try {
    Set-ItemProperty -Path $regPath -Name $propertyName -Value $desiredValue -Type DWord
    Write-Host "'Run Antivirus Scan' policy has been disabled in BIS-F." -ForegroundColor Green

    # Validate the value
    $currentValue = (Get-ItemProperty -Path $regPath -Name $propertyName).$propertyName
    if ($currentValue -eq $desiredValue) {
        Write-Host "Validation successful: '$propertyName' is set to $currentValue." -ForegroundColor Cyan
    } else {
        Write-Host "Validation failed: '$propertyName' is set to $currentValue instead of $desiredValue." -ForegroundColor Yellow
    }

} catch {
    Write-Host "Failed to set or validate registry value. Ensure you have administrative privileges." -ForegroundColor Red
}


# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    exit
}

# Define package ID
$packageId = "9NKSQGP7F2NH"

# Start installation in a separate process
Write-Output "Starting WhatsApp installation..."
$installProcess = Start-Process -FilePath "winget" `
    -ArgumentList "install --id $packageId --silent --accept-source-agreements --accept-package-agreements" `
    -NoNewWindow -PassThru

# Show a progress bar while the process runs
$progress = 0
while (!$installProcess.HasExited) {
    # Simulate progress bar (increment over time)
    Write-Progress -Activity "Installing WhatsApp" -Status "In progress..." -PercentComplete $progress
    Start-Sleep -Milliseconds 500
    $progress = ($progress + 2) % 100  # Cycle progress bar from 0 to 99
}

# Clear progress bar and check result
Write-Progress -Activity "Installing WhatsApp" -Completed
if ($installProcess.ExitCode -eq 0) {
    Write-Output "WhatsApp has been installed successfully."
} else {
    Write-Error "WhatsApp installation failed. Exit code: $($installProcess.ExitCode)"
}

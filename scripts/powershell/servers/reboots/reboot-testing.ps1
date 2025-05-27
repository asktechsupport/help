# Set the target reboot time (24-hour format)
$targetTime = [datetime]::ParseExact("10:45", "HH:mm", $null)
$targetDateTime = Get-Date -Hour $targetTime.Hour -Minute $targetTime.Minute -Second 0

Write-Output "Waiting until $targetDateTime to reboot this machine..."

# Wait until the target time
while ((Get-Date) -lt $targetDateTime) {
    Start-Sleep -Seconds 30
}

# Reboot the local machine
try {
    Write-Output "Rebooting local machine at $(Get-Date)..."
    Restart-Computer -Force -Confirm:$false
} catch {
    Write-Output "Failed to reboot the machine: $_"
}

### Reboot at a specified time
```powershell
# Target reboot time (24-hour format)
$targetTime = [datetime]::ParseExact("23:30", "HH:mm", $null)

# Optional: Add today's date to the time
$targetDateTime = Get-Date -Hour $targetTime.Hour -Minute $targetTime.Minute -Second 0

# Wait until the target time
while ((Get-Date) -lt $targetDateTime) {
    Start-Sleep -Seconds 30
}

# List of servers to reboot
$servers = @("Server1", "Server2")

foreach ($server in $servers) {
    try {
        Write-Output "Rebooting $server at $(Get-Date)..."
        Restart-Computer -ComputerName $server -Force -Confirm:$false -ErrorAction Stop
        Write-Output "$server reboot initiated."
    } catch {
        Write-Output "Failed to reboot $server: $_"
    }
}
```



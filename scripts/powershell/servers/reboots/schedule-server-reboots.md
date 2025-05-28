### Reboot at a specified time
```powershell
# Define reboot schedules
$schedules = @(
    @{ Time = "16:00"; Servers = @("ServerA", "ServerB") },
    @{ Time = "18:00"; Servers = @("ServerC", "ServerD") }
)

foreach ($schedule in $schedules) {
    $targetTime = [datetime]::ParseExact($schedule.Time, "HH:mm", $null)
    $targetDateTime = Get-Date -Hour $targetTime.Hour -Minute $targetTime.Minute -Second 0

    # If the target time has already passed today, schedule for tomorrow
    if ($targetDateTime -lt (Get-Date)) {
        $targetDateTime = $targetDateTime.AddDays(1)
    }

    Write-Output "Waiting until $($targetDateTime) to reboot servers: $($schedule.Servers -join ', ')"

    while ((Get-Date) -lt $targetDateTime) {
        Start-Sleep -Seconds 30
    }

    foreach ($server in $schedule.Servers) {
        try {
            Write-Output "Rebooting $server at $(Get-Date)..."
            Restart-Computer -ComputerName $server -Force -Confirm:$false -ErrorAction Stop
            Write-Output "$server reboot initiated."
        } catch {
            Write-Output "Failed to reboot $server: $_"
        }
    }
}

```



```powershell
# Get the current session ID for your user
$currentSessionId = (quser | Where-Object { $_ -match "$env:USERNAME" }) -replace '\s{2,}', ',' | ForEach-Object {
    $fields = $_ -split ','
    if ($fields[0] -eq $env:USERNAME -and $fields[3] -eq 'Active') { $fields[2] }
}

# Get all sessions for your user account
$sessions = quser | ForEach-Object {
    $line = ($_ -replace '\s{2,}', ',').Split(',')
    [PSCustomObject]@{
        Username = $line[0]
        SessionName = $line[1]
        ID = $line[2]
        State = $line[3]
    }
} | Where-Object { $_.Username -eq $env:USERNAME }

# Log off all sessions except the current one
foreach ($session in $sessions) {
    if ($session.ID -ne $currentSessionId) {
        Write-Host "Logging off session ID $($session.ID) for user $($session.Username)"
        logoff $session.ID
    }
}

# Re-check sessions for your user
Start-Sleep -Seconds 2  # Give the system a moment to update session list

$remainingSessions = quser | ForEach-Object {
    $line = ($_ -replace '\s{2,}', ',').Split(',')
    [PSCustomObject]@{
        Username = $line[0]
        SessionName = $line[1]
        ID = $line[2]
        State = $line[3]
    }
} | Where-Object { $_.Username -eq $env:USERNAME }

Write-Host "`nRemaining sessions for user $env:USERNAME: $($remainingSessions.Count)"
$remainingSessions | Format-Table -AutoSize

```

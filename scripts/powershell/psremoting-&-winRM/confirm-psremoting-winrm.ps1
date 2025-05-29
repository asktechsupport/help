# Import AD module
Import-Module ActiveDirectory

# Get all DNS hostnames from AD
$allHosts = Get-ADComputer -Filter * -Property DNSHostName | Where-Object { $_.DNSHostName } | Select-Object -ExpandProperty DNSHostName

$total = $allHosts.Count
$counter = 0

Write-Output "=== Checking WinRM and PSRemoting status on all discovered servers ==="

foreach ($serverName in $allHosts) {
    $counter++
    Write-Output "`n[$counter/$total] Checking: $serverName"

    try {
        # Check if WinRM responds (suppress output)
        $null = Test-WsMan -ComputerName $serverName -ErrorAction Stop
        Write-Output "  ✅ WinRM: Available"

        # Check if PSRemoting is enabled
        $psRemotingEnabled = Invoke-Command -ComputerName $serverName -ScriptBlock {
            (Get-Item -Path WSMan:\localhost\Service\Auth\Basic).Value
        } -ErrorAction Stop

        Write-Output "  ✅ PSRemoting (Basic Auth): $psRemotingEnabled"
    } catch {
        Write-Output "  ❌ Error: $_"
    }
}

Write-Output "`n=== Scan complete ==="

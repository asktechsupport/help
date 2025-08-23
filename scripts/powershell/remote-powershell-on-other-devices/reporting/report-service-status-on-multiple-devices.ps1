# Define anonymised hostnames
$hostnames = @(
    "ServerA",
    "ServerB",
    "ServerC",
    "ServerD",
    "ServerE",
    "ServerF",
    "ServerG",
    "ServerH"
)

# Define anonymised domain
$domain = "example.domain"

# Build FQDNs from hostnames
$fqdns = $hostnames | ForEach-Object { "$_.${domain}" }

# Check services and color output
foreach ($computer in $fqdns) {
    $services = Get-WmiObject -Class Win32_Service -ComputerName $computer |
        Where-Object { $_.Description -like "*SQL*" }

    foreach ($service in $services) {
        $statusColor = if ($service.State -eq "Running") { "Green" } else { "Red" }
        Write-Host "$($computer) - $($service.Name) - $($service.State)" -ForegroundColor $statusColor
    }
}

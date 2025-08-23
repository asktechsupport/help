# Define hostnames
$hostnames = @(
    "Server01",
    "Server02",
    "Server03",
    "Server04",
    "Server05",
    "Server06",
    "Server07",
    "Server08"
)

# Define domain
$domain = "your.domain.local"

# Build FQDNs from hostnames
$fqdns = $hostnames | ForEach-Object { "$_.${domain}" }

# Use FQDNs in your service check
foreach ($computer in $fqdns) {
    Get-WmiObject -Class Win32_Service -ComputerName $computer |
        Where-Object { $_.Description -like "*SQL*" } |
        Select-Object @{Name="ComputerName";Expression={$computer}}, Name, State
}

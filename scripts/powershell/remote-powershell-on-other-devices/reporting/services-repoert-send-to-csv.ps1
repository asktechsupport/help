# Create output directory if it doesn't exist
$path = "C:\temp\Services"
if (-not (Test-Path $path)) {
    New-Item -Path $path -ItemType Directory
}

# Define hostnames and domain
$hostnames = @(
    "HH3PIVDWHSSRS02",
    "HH3PIVDWHSSRS01",
    "HH3PIVDWHSSIS02",
    "HH3PIVDWHSSIS01",
    "HH3PIVDWHSOLP02",
    "HH3PIVDWHSOLP01",
    "HH3PICDWHSSQL02",
    "HH3PICDWHSSQL01"
)
$domain = "aldermore.int"
$fqdns = $hostnames | ForEach-Object { "$_.${domain}" }

# Collect service data
$results = @()
foreach ($computer in $fqdns) {
    try {
        $services = Get-WmiObject -Class Win32_Service -ComputerName $computer |
            Where-Object { $_.Description -like "*SQL*" }

        foreach ($service in $services) {
            $results += [PSCustomObject]@{
                ComputerName = $computer
                ServiceName  = $service.Name
                State        = $service.State
            }
        }
    } catch {
        Write-Warning "Failed to query ${computer}: $_"
    }
}

# Generate timestamp for filename
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvPath = Join-Path $path "SQL_Service_Status_$timestamp.csv"

# Export to CSV
$results | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "✅ CSV file saved to: $csvPath"

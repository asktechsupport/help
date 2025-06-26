$allFiles = @()

foreach ($drive in Get-PSDrive -PSProvider FileSystem) {
    try {
        Write-Host "Scanning $($drive.Root)..."
        $files = Get-ChildItem -Path $drive.Root -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
            [PSCustomObject]@{
                'Path'         = $_.FullName
                'Size (Auto)'  = Switch (
                    { $_.Length -ge 1TB } { '{0:N2} TB' -f ($_.Length / 1TB); break }
                    { $_.Length -ge 1GB } { '{0:N2} GB' -f ($_.Length / 1GB); break }
                    { $_.Length -ge 1MB } { '{0:N2} MB' -f ($_.Length / 1MB); break }
                    { $_.Length -ge 1KB } { '{0:N2} KB' -f ($_.Length / 1KB); break }
                    Default             { '{0:N2} B'  -f ($_.Length) }
                }
                'Size (Bytes)' = $_.Length
                'Modified'     = $_.LastWriteTime
            }
        }
        $allFiles += $files
    } catch {
        Write-Warning "Failed to scan $($drive.Root): $_"
    }
}

$top100 = $allFiles | Sort-Object 'Size (Bytes)' -Descending | Select-Object -First 100

$top100 | Out-GridView -Title "Top 100 Largest Files"

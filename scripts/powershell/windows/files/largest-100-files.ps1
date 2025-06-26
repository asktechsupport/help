$allFiles = @()

foreach ($drive in Get-PSDrive -PSProvider FileSystem) {
    try {
        Write-Host "Scanning $($drive.Root)..."
        $files = Get-ChildItem -Path $drive.Root -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
            $size = $_.Length
            $sizeAuto = if ($size -ge 1TB) {
                '{0:N2} TB' -f ($size / 1TB)
            } elseif ($size -ge 1GB) {
                '{0:N2} GB' -f ($size / 1GB)
            } elseif ($size -ge 1MB) {
                '{0:N2} MB' -f ($size / 1MB)
            } elseif ($size -ge 1KB) {
                '{0:N2} KB' -f ($size / 1KB)
            } else {
                '{0:N2} B' -f $size
            }

            [PSCustomObject]@{
                'Path'         = $_.FullName
                'Size (Auto)'  = $sizeAuto
                'Size (Bytes)' = $size
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

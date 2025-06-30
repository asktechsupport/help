function Run-PrepareBaseImageWithTiming {
    param (
        [string]$ScriptPath
    )

    $startTime = Get-Date
    Write-Host "Starting PrepareBaseImage.cmd at $startTime"

    # Launch the script elevated
    $process = Start-Process -FilePath $ScriptPath -Verb RunAs -PassThru

    # Wait for the process to exit
    $process.WaitForExit()

    $endTime = Get-Date
    Write-Host "PrepareBaseImage.cmd completed at $endTime"

    $duration = $endTime - $startTime
    Write-Host "Total execution time: $($duration.ToString())"
}

# Define source and destination paths
$source = "C:\Path\To\Source"
$destination = "C:\Path\To\Destination"

# Ensure destination exists
if (-not (Test-Path -Path $destination)) {
    New-Item -ItemType Directory -Path $destination -Force
}

# Copy all child files (not folders), overwriting without prompt
Get-ChildItem -Path $source -File -Recurse | ForEach-Object {
    $targetPath = Join-Path -Path $destination -ChildPath $_.Name
    Copy-Item -Path $_.FullName -Destination $targetPath -Force
}

# Search for the BIS-F PrepareBaseImage.cmd script
$bisfCmd = Get-ChildItem -Path "C:\Program Files (x86)" -Recurse -ErrorAction SilentlyContinue |
    Where-Object {
        -not $_.PSIsContainer -and $_.Name -like "*PrepareBaseImage*.cmd"
    } |
    Select-Object -ExpandProperty FullName -First 1

if ($bisfCmd) {
    Write-Host "Found BIS-F script at: $bisfCmd"
    Run-PrepareBaseImageWithTiming -ScriptPath $bisfCmd
} else {
    Write-Host "PrepareBaseImage.cmd not found in Program Files (x86)." -ForegroundColor Red
}

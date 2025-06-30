function Run-PrepareBaseImageWithTiming {
    param (
        [string]$ScriptPath
    )

    $logPath = "C:\Program Files (x86)\Base Image Script Framework (BIS-F)\customLogs\bis-f-script-time-elapsed.csv"

    # Ensure log directory exists
    $logDir = Split-Path $logPath
    if (-not (Test-Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force | Out-Null
    }

    $startTime = Get-Date
    Write-Host "Starting PrepareBaseImage.cmd at $startTime"

    # Launch the script elevated
    $process = Start-Process -FilePath $ScriptPath -Verb RunAs -PassThru
    $process.WaitForExit()

    $endTime = Get-Date
    $duration = $endTime - $startTime
    $computerName = $env:COMPUTERNAME
    $username = $env:USERNAME

    # Prepare CSV line
    $logLine = "$startTime,$endTime,$duration,$computerName,$username"

    # Add header if file doesn't exist
    if (-not (Test-Path $logPath)) {
        Add-Content -Path $logPath -Value "Start Time,End Time,Duration,Computer Name,Username"
    }

    # Check if a separator is needed (new day)
    $lastDate = (Get-Content $logPath | Select-Object -Last 2 | Select-String -Pattern '^\d{4}-\d{2}-\d{2}' | ForEach-Object {
        ($_ -split ',')[0]
    }) | Select-Object -Last 1

    if ($lastDate) {
        $lastDateParsed = [datetime]::Parse($lastDate).Date
        if ($lastDateParsed -ne $startTime.Date) {
            Add-Content -Path $logPath -Value "--------------------,--------------------,--------------------,--------------------,--------------------"
        }
    }

    # Append log entry
    Add-Content -Path $logPath -Value $logLine

    Write-Host "PrepareBaseImage.cmd completed at $endTime"
    Write-Host "Total execution time: $($duration.ToString())"
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

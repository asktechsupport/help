# Run as Administrator to modify HKLM
$regPath = "HKLM:\SOFTWARE\Policies\BaseImageScriptFramework\AntiVirus"
$propertyName = "RunAntiVirusScan"
$desiredValue = 0

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    try {
        New-Item -Path $regPath -Force | Out-Null
        Write-Host "Created registry path: $regPath"
    } catch {
        Write-Host "Failed to create registry path. Run PowerShell ISE as Administrator." -ForegroundColor Red
        return
    }
}

# Set the policy value
try {
    Set-ItemProperty -Path $regPath -Name $propertyName -Value $desiredValue -Type DWord
    Write-Host "'Run Antivirus Scan' policy has been disabled in BIS-F." -ForegroundColor Green

    # Validate the value
    $currentValue = (Get-ItemProperty -Path $regPath -Name $propertyName).$propertyName
    if ($currentValue -eq $desiredValue) {
        Write-Host "Validation successful: '$propertyName' is set to $currentValue." -ForegroundColor Cyan
    } else {
        Write-Host "Validation failed: '$propertyName' is set to $currentValue instead of $desiredValue." -ForegroundColor Yellow
    }

} catch {
    Write-Host "Failed to set or validate registry value. Ensure you have administrative privileges." -ForegroundColor Red
}
        #NEXT OPERATION STARTING
        Write-Host "NEXT OPERATION STARTING: Defining the PrepareBaseImage function..." -ForegroundColor Yellow

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

        #OPERATION FINISHED
        Write-Host "OPERATION FINISHED: PrepareBaseImage function defined..." -ForegroundColor Green
        
        #NEXT OPERATION STARTING
        Write-Host "NEXT OPERATION STARTING: Copying deployment files..." -ForegroundColor Yellow
        
# Define source and destination paths
$source = "C:\Temp\copyfilestest"
$destination = "C:\Temp\copydestinationtest"

# Ensure destination exists
if (-not (Test-Path -Path $destination)) {
    New-Item -ItemType Directory -Path $destination -Force
}

# Copy all child files (not folders), overwriting without prompt
Get-ChildItem -Path $source -File -Recurse | ForEach-Object {
    $targetPath = Join-Path -Path $destination -ChildPath $_.Name
    Copy-Item -Path $_.FullName -Destination $targetPath -Force
}

start $destination


        #OPERATION FINISHED
        Write-Host "OPERATION FINISHED: Copied deployment files successfully" -ForegroundColor Green

        #VALIDATION
        Write-Host "VALIDATION: Manually check the destination, the folder has opened for you" -ForegroundColor Cyan
        
        #NEXT OPERATION STARTING
        Write-Host "NEXT OPERATION STARTING: Sealing the image without AV scan" -ForegroundColor Yellow

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

        #SCRIPT FINISH
        Write-Host "NEXT OPERATION STARTING: POWERING OFF IMAGE" -ForegroundColor Red

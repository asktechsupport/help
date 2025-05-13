# Define variables
$apacheServiceName = "Apache2.4"
$apacheInstallDir = "C:\Apache24"
$backupDir = "C:\ApacheBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$tempDownloadDir = "$env:TEMP\ApacheUpdate"
$apacheDownloadUrl = "https://www.apachelounge.com/download/VC17/binaries/httpd-2.4.59-win64-VS17.zip"  # Update this URL as needed

# Create backup
Write-Output "Creating backup of Apache directory..."
Copy-Item -Path $apacheInstallDir -Destination $backupDir -Recurse

# Stop Apache service
Write-Output "Stopping Apache service..."
Stop-Service -Name $apacheServiceName -Force

# Download and extract new Apache version
Write-Output "Downloading latest Apache version..."
New-Item -ItemType Directory -Path $tempDownloadDir -Force | Out-Null
$zipPath = "$tempDownloadDir\apache.zip"
Invoke-WebRequest -Uri $apacheDownloadUrl -OutFile $zipPath

Write-Output "Extracting Apache files..."
Expand-Archive -Path $zipPath -DestinationPath $tempDownloadDir -Force

# Replace binaries (excluding conf and htdocs)
Write-Output "Updating Apache binaries..."
$extractedDir = Get-ChildItem -Path $tempDownloadDir | Where-Object { $_.PSIsContainer } | Select-Object -First 1
Copy-Item -Path "$($extractedDir.FullName)\*" -Destination $apacheInstallDir -Recurse -Force -Exclude "conf", "htdocs"

# Start Apache service
Write-Output "Starting Apache service..."
Start-Service -Name $apacheServiceName

Write-Output "Apache update complete."

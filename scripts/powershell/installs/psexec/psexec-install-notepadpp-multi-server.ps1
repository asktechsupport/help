$domainFQDN = $env:USERDNSDOMAIN
$installerFileName = "npp.8.8.2.Installer.x64.exe"
$installerShareRoot = "\\$domainFQDN\SYSVOL\$domainFQDN\scripts\automatedInstalls"
$installerShare = "$installerShareRoot\$installerFileName"
$psexecPath = "C:\Tools\PsTools\psexec.exe"

# Ensure installer share folder exists
if (-not (Test-Path $installerShareRoot)) {
    Write-Host "Installer share folder not found: $installerShareRoot"
    Write-Host "Creating folder..."
    New-Item -Path $installerShareRoot -ItemType Directory -Force | Out-Null
    Write-Host "Folder created."
} else {
    Write-Host "Installer share folder exists: $installerShareRoot"
}

# Generate server names: server01 to server33
$servers = 1..33 | ForEach-Object { "server{0:D2}.$domainFQDN" -f $_ }

# Detect installer type
$installerExtension = [System.IO.Path]::GetExtension($installerFileName).ToLower()
switch ($installerExtension) {
    ".exe" { $installArgs = "/S" }
    ".msi" { $installArgs = "/qn" }
    default { throw "Unsupported installer type: $installerExtension" }
}

foreach ($server in $servers) {
    $localTempUNC = "\\$server\C$\Temp\$installerFileName"
    $localExecutePath = "C:\Temp\$installerFileName"

    Write-Host "--------------------------------------------------"
    Write-Host "Processing $server with $installerExtension installer..."

    try {
        Start-Process -FilePath $psexecPath -ArgumentList "\\$server -s -n 10 -d cmd /c if not exist C:\Temp mkdir C:\Temp" -Wait

        Write-Host "Copying installer from $installerShare to $localTempUNC..."
        Copy-Item -Path $installerShare -Destination $localTempUNC -Force -ErrorAction Stop
        Write-Host "Copy completed on $server."

        $psexecArgs = "\\$server -s -n 10 -d `"$localExecutePath`" $installArgs"
        Write-Host "Launching installer on $server..."
        Start-Process -FilePath $psexecPath -ArgumentList $psexecArgs -Wait

    } catch {
        Write-Host "❌ Error processing ${server}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "--------------------------------------------------"
Write-Host "Deployment complete. Check PsExec logs for details."

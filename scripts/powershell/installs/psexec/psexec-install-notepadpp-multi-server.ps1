$domainFQDN = $env:USERDNSDOMAIN
$installerFileName = "npp.8.8.2.Installer.x64.exe"
$installerShare = "\\$domainFQDN\SYSVOL\$domainFQDN\scripts\automatedInstalls\$installerFileName"
$psexecPath = "C:\Tools\PsTools\psexec.exe"

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
        # Ensure C:\Temp exists
        Start-Process -FilePath $psexecPath -ArgumentList "\\$server -s -n 10 -d cmd /c if not exist C:\Temp mkdir C:\Temp" -Wait

        # Copy installer
        Write-Host "Copying installer from $installerShare to $localTempUNC..."
        Copy-Item -Path $installerShare -Destination $localTempUNC -Force -ErrorAction Stop
        Write-Host "Copy completed on $server."

        # Execute installer with appropriate arguments
        $psexecArgs = "\\$server -s -n 10 -d `"$localExecutePath`" $installArgs"
        Write-Host "Launching installer on $server..."
        Start-Process -FilePath $psexecPath -ArgumentList $psexecArgs -Wait

    } catch {
        Write-Host "❌ Error processing ${server}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "--------------------------------------------------"
Write-Host "Deployment complete. Check PsExec logs for details."

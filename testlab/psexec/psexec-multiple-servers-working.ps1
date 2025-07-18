$servers = @("pnpt-test.pnpt.local", "pnpt-winrm.pnpt.local")
$installerShare = "\\$env:USERDNSDOMAIN\SYSVOL\$env:USERDNSDOMAIN\scripts\automatedInstalls\npp.8.8.2.Installer.x64.exe"
$psexecPath = "C:\Tools\PsTools\psexec.exe"

foreach ($server in $servers) {
    $localTempUNC = "\\$server\C$\Temp\npp.8.8.2.Installer.x64.exe"
    $localExecutePath = "C:\Temp\npp.8.8.2.Installer.x64.exe"

    Write-Host "--------------------------------------------------"
    Write-Host "Processing $server..."

    try {
        Start-Process -FilePath $psexecPath -ArgumentList "\\$server -s -n 10 -d cmd /c if not exist C:\Temp mkdir C:\Temp" -Wait
        Copy-Item -Path $installerShare -Destination $localTempUNC -Force -ErrorAction Stop
        Write-Host "Copied installer to $server."

        $psexecArgs = "\\$server -s -n 10 -d `"$localExecutePath`" /S"
        Write-Host "Launching Notepad++ installer on $server..."
        Start-Process -FilePath $psexecPath -ArgumentList $psexecArgs -Wait

    } catch {
        Write-Host "❌ Error processing ${server}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

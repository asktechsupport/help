$installerFiles = @("npp.8.8.2.Installer.x64.exe", "otherInstaller.msi")

$domainFQDN = $env:USERDNSDOMAIN
$installerShareRoot = "\\$domainFQDN\SYSVOL\$domainFQDN\scripts\automatedInstalls"
$psexecPath = "C:\Tools\PsTools\psexec.exe"
$servers = 1..33 | ForEach-Object { "server{0:D2}.$domainFQDN" -f $_ }

foreach ($server in $servers) {
    Write-Host "--------------------------------------------------"
    Write-Host "Processing $server..."

    # Ensure C:\Temp exists
    Start-Process -FilePath $psexecPath -ArgumentList "\\$server -s -n 10 -d cmd /c if not exist C:\Temp mkdir C:\Temp" -Wait

    $commandChain = ""

    foreach ($installer in $installerFiles) {
        $installerShare = "$installerShareRoot\$installer"
        $localTempUNC = "\\$server\C$\Temp\$installer"
        $localExecutePath = "C:\Temp\$installer"

        # Copy each installer
        Write-Host "Copying $installer to ${server}..."
        Copy-Item -Path $installerShare -Destination $localTempUNC -Force -ErrorAction Stop

        # Build command chain with correct arguments
        $extension = [System.IO.Path]::GetExtension($installer).ToLower()
        $args = switch ($extension) {
            ".exe" { "/S" }
            ".msi" { "/qn" }
            default { throw "Unsupported file type: $installer" }
        }

        $commandChain += "`"$localExecutePath`" $args && "
    }

    # Remove trailing && 
    $commandChain = $commandChain.TrimEnd(" && ")

    Write-Host "Running installers on ${server}..."
    $psexecArgs = "\\$server -s -n 10 -d cmd /c $commandChain"
    Start-Process -FilePath $psexecPath -ArgumentList $psexecArgs -Wait
}

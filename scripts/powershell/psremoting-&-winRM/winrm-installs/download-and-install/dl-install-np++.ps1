# Use TLS 1.2 for secure downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Target settings
$target = "10.0.0.254"
$remoteUNCPath = "\\$target\C$\temp"
$remoteLocalPath = "C:\temp"

# Allow IP for WinRM by trusting the host
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $target -Force
Write-Host "✔ Added $target to TrustedHosts" -ForegroundColor Yellow

# Step 1: Download latest Notepad++ x64 installer
$homeUrl = 'https://notepad-plus-plus.org'
$res = Invoke-WebRequest -UseBasicParsing $homeUrl
if ($res.StatusCode -ne 200) { throw "Initial site status code: $($res.StatusCode)" }

$tempUrl = ($res.Links | Where-Object { $_.outerHTML -like "*Current Version *" })[0].href
if ($tempUrl.StartsWith("/")) { $tempUrl = "$homeUrl$tempUrl" }

$res = Invoke-WebRequest -UseBasicParsing $tempUrl
if ($res.StatusCode -ne 200) { throw "Version page status code: $($res.StatusCode)" }

$dlUrl = ($res.Links | Where-Object { $_.href -like "*x64.exe" })[0].href
if ($dlUrl.StartsWith("/")) { $dlUrl = "$homeUrl$dlUrl" }

$installerPath = Join-Path $env:TEMP (Split-Path $dlUrl -Leaf)
Invoke-WebRequest $dlUrl -OutFile $installerPath
Write-Host "✔ Downloaded Notepad++ to $installerPath" -ForegroundColor Green

# Step 2: Prompt for credentials
$creds = Get-Credential -Message "Enter admin credentials for $target"

# Step 3: Ensure remote folder exists and copy installer
if (-not (Test-Path $remoteUNCPath)) {
    New-Item -Path $remoteUNCPath -ItemType Directory -Force | Out-Null
    Write-Host "✔ Created $remoteUNCPath" -ForegroundColor Cyan
}
Copy-Item -Path $installerPath -Destination $remoteUNCPath -Force
Write-Host "✔ Copied installer to $remoteUNCPath" -ForegroundColor Cyan

# Step 4: Remotely install all .msi and .exe installers in C:\temp
Invoke-Command -ComputerName $target -Credential $creds -Authentication Negotiate -ScriptBlock {
    $folder = "C:\temp"

    if (-not (Test-Path $folder)) {
        New-Item -Path $folder -ItemType Directory -Force | Out-Null
        Write-Host "Created folder: $folder"
    }

    # Install all MSI files
    $msiFiles = Get-ChildItem -Path $folder -Filter *.msi -Recurse -ErrorAction SilentlyContinue
    foreach ($msi in $msiFiles) {
        Write-Host "Installing MSI: $($msi.FullName)"
        $arguments = "/i `"$($msi.FullName)`" /qn /norestart"
        Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait
    }

    # Install all EXE files (assumes /S silent switch works)
    $exeFiles = Get-ChildItem -Path $folder -Filter *.exe -Recurse -ErrorAction SilentlyContinue
    foreach ($exe in $exeFiles) {
        Write-Host "Installing EXE: $($exe.FullName)"
        Start-Process -FilePath $exe.FullName -ArgumentList "/S" -Wait
    }
}

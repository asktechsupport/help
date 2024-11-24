# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator!" -ForegroundColor Red
    exit
}

Write-Host "Starting installation for Citrix Prerequisites..." -ForegroundColor Cyan
Install-WindowsFeature -Name RSAT-ADCS-Mgmt -IncludeManagementTools


# Install Edge WebView2 Runtime
Write-Host "Searching for Microsoft Edge WebView2 Runtime Installer..." -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path "$($_.Root)" -Recurse -Filter "*.exe" -ErrorAction SilentlyContinue
} | Where-Object { $_.Name -like "*MicrosoftEdgeWebView2RuntimeInstaller*" } | Select-Object -First 1 -ExpandProperty FullName | ForEach-Object {
    Write-Host "Installing Microsoft Edge WebView2 Runtime from: $_" -ForegroundColor Green
    Start-Process -FilePath $_ -ArgumentList "/silent /install" -Verb RunAs -Wait
    Write-Host "Installed WebView2 Runtime successfully." -ForegroundColor Green
}

# Install .NET Prerequisites (Windows Desktop Runtime or NDP)
Write-Host "Searching for .NET Prerequisites (Windows Desktop Runtime or NDP)..." -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path "$($_.Root)" -Recurse -Filter "*.exe" -ErrorAction SilentlyContinue
} | Where-Object { $_.Name -like "*windowsdesktop-runtime*" -or $_.Name -like "ndp*" } | Select-Object -First 1 -ExpandProperty FullName | ForEach-Object {
    Write-Host "Installing .NET Prerequisite from: $_" -ForegroundColor Green
    Start-Process -FilePath $_ -ArgumentList "/quiet /norestart" -Verb RunAs -Wait
    Write-Host "Installed .NET Prerequisite successfully." -ForegroundColor Cyan
}

# Install Citrix Workspace App
Write-Host "Searching for Citrix Workspace App Installer..." -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path "$($_.Root)" -Recurse -Filter "*.exe" -ErrorAction SilentlyContinue
} | Where-Object { $_.Name -like "*CitrixWorkspaceApp*" } | Select-Object -First 1 -ExpandProperty FullName | ForEach-Object {
    Write-Host "Installing Citrix Workspace App from: $_" -ForegroundColor Green
    Start-Process -FilePath $_ -ArgumentList "/silent /noreboot" -Verb RunAs -Wait
    Write-Host "Installed Citrix Workspace App successfully." -ForegroundColor Yellow
}

Write-Host "Installation process completed successfully." -ForegroundColor Cyan

> [!WARNING]
> This script is in progress

⚠️Run as Administrator

.SYNOPSIS
    Generic Application Installer Script

.DESCRIPTION
    Installs any application on one or more targets using a specified executable and arguments.

.PARAMETER AppName
    The name of the application executable (without extension).

.PARAMETER AppVersion
    Optional version label for logging or folder naming.

.PARAMETER Targets
    One or more target machines (for remote install).

.PARAMETER InstallArgs
    Arguments to pass to the installer executable.

.NOTES
    Author: asktechsupport (modified by Copilot)

```powershell
param (
    [string]$AppName = "MyApp",
    [string]$AppVersion = "Latest",
    [string[]]$Targets = @("localhost"),
    [string[]]$InstallArgs = @()
)

# Define installer location
$installerLocation = "C:\AutomatedInstalls\$AppName"

# Ensure installer location exists
if (-not (Test-Path -Path $installerLocation)) {
    New-Item -Path $installerLocation -ItemType Directory | Out-Null
    Write-Host "Created directory: $installerLocation"
} else {
    Write-Host "$installerLocation already exists" -ForegroundColor Yellow
}

# Build installer path
$installerPath = Join-Path -Path $installerLocation -ChildPath "$AppName.exe"

# Check if installer exists
if (-not (Test-Path -Path $installerPath)) {
    Write-Host "Installer not found at $installerPath" -ForegroundColor Red
    exit 1
}

# Local install
Start-Process -FilePath $installerPath -Wait -ArgumentList $InstallArgs -Verb runas -PassThru

# Notification
$NotificationTitle = "$AppName $AppVersion Installation"
$NotificationText = "$AppName $AppVersion installed successfully on $($Targets -join ', ')"

[reflection.assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
[reflection.assembly]::LoadWithPartialName('System.Drawing') | Out-Null
$notify = New-Object system.windows.forms.notifyicon
$notify.icon = [System.Drawing.SystemIcons]::Information
$notify.visible = $true
$notify.showballoontip(10, $NotificationTitle, $NotificationText, [system.windows.forms.tooltipicon]::None)

Write-Host $NotificationText -ForegroundColor Green

```powershell

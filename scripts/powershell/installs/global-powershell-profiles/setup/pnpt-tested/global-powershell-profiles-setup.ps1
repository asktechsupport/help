# Set global variables
$Domain = $env:USERDNSDOMAIN
$SysvolRoot = "\\$Domain\SYSVOL\$Domain\scripts"
$GlobalProfilePath = "C:\ProgramData\Microsoft\Windows\PowerShell\profile.ps1"

# Ensure required SYSVOL paths exist
$PathsToCreate = @(
    "$SysvolRoot\global-powershell-profiles",
    "$SysvolRoot\variables-software-updates",
    "$SysvolRoot\variables-citrix-updates"
)

foreach ($Path in $PathsToCreate) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force
        Write-Host "Created SYSVOL folder: $Path"
    }
}

# Write global-variables.ps1
Set-Content -Path "$SysvolRoot\global-powershell-profiles\global-variables.ps1" -Value @'
$UpdatePath = "\\$env:USERDNSDOMAIN\SYSVOL\$env:USERDNSDOMAIN\scripts\variables-software-updates"

$SoftwareList = @(
    "GoogleChromeStandaloneEnterprise64.msi",
    "FirefoxInstaller.exe",
    "NotepadPlusPlus.exe"
)
'@

# Write citrix-variables.ps1
Set-Content -Path "$SysvolRoot\global-powershell-profiles\citrix-variables.ps1" -Value @'
$UpdatePath = "\\$env:USERDNSDOMAIN\SYSVOL\$env:USERDNSDOMAIN\scripts\variables-citrix-updates"

$SoftwareList = @(
    "CitrixWorkspaceApp.exe",
    "VDAWorkstationSetup.exe",
    "CitrixStoreFront-x64.exe"
)
'@

# Configure Global PowerShell Profile locally (preview version before GPO deployment)
$globalProfileFolder = Split-Path $GlobalProfilePath

if (-not (Test-Path $globalProfileFolder)) {
    New-Item -ItemType Directory -Path $globalProfileFolder -Force
    Write-Host "Created folder: $globalProfileFolder"
}

Set-Content -Path $GlobalProfilePath -Value @"
# Auto-loaded global variables for software updates
. "\\$Domain\SYSVOL\$Domain\scripts\global-powershell-profiles\global-variables.ps1"
. "\\$Domain\SYSVOL\$Domain\scripts\global-powershell-profiles\citrix-variables.ps1"
"@

Write-Host "Global PowerShell profile written to $GlobalProfilePath"
Write-Host "Make sure to deploy it via GPO to enforce across machines."

# Optional: Open the profile in default editor
notepad $GlobalProfilePath

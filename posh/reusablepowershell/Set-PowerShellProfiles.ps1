#--------------POWERSHELL (POSH) PROFILE SETUP | VARIABLES
##  src: https://github.com/asktechsupport/help/tree/main/posh/reusablepowershell
$iseProfilePath = $PROFILE.CurrentUserCurrentHost  # ISE profile for the current user
$psProfilePath = $PROFILE.CurrentUserAllHosts  # Regular PowerShell profile for the current user
$psStartNotification = "PowerShell is starting. Please be sure you meant to open or run PowerShell on this device."

#--------------Prepare a safe execution policy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process # Set the execution policy

#--------------FEEDBACK TO THE USER
Write-Host "Your profile loaded successfully on $(Get-Date)" -ForegroundColor Green
Write-Host "Hey, you are running as user:$env:USERNAME" -ForegroundColor White
Write-Host "Vars are stored @ *$iseProfilePath*" -ForegroundColor White
Write-Host "🔔PowerShell is starting. Make sure you intended to use PowerShell or PowerShell ISE." -ForegroundColor Yellow

start $iseProfilePath

#--------------SYNC THE ISE AND POWERSHELL PROFILES
if (-not (Test-Path $psProfilePath)) {
    New-Item -Path $psProfilePath -ItemType File -Force
}

if (Test-Path $iseProfilePath) {
    Copy-Item -Path $iseProfilePath -Destination $psProfilePath -Force
    Write-Host "PowerShell profile at $psProfilePath has been overwritten with the content from $iseProfilePath." -ForegroundColor Green
} else {
    Write-Host "ISE profile at $iseProfilePath does not exist. No action taken." -ForegroundColor Red
}
#Get-Content $psProfilePath

#--------------src: https://github.com/asktechsupport/help/tree/main/posh/reusablepowershell

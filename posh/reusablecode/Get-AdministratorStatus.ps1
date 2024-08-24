#------------------------------------------------------------------------------------------------------------------------------------------------#
#### Function to check if running as administrator
#------------------------------------------------------------------------------------------------------------------------------------------------#
Unblock-File -Path "C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1"
function Test-IsAdmin {
   $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
   return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
$ErrorActionPreference = "SilentlyContinue"
# Check if running as administrator
if (-not (Test-IsAdmin)) {
   Write-Host "This script must be run as an administrator." -ForegroundColor Red
   Read-Host "Press Enter to close this PowerShell window"    # Wait for user input before closing
   # Close the PowerShell application
   Stop-Process -Id $PID -Force
}
$ErrorActionPreference = "Continue"
Write-Host "Running with administrative privileges." -ForegroundColor Green

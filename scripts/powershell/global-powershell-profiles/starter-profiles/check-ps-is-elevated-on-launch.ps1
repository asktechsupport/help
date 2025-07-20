# Set-GlobalPowerShellAdminCheck.ps1
$globalProfile = "C:\ProgramData\Microsoft\Windows\PowerShell\profile.ps1"

# Ensure the directory exists
$globalDir = Split-Path $globalProfile
if (!(Test-Path $globalDir)) {
    New-Item -ItemType Directory -Path $globalDir -Force
}

# Define the admin check
$adminCheck = @'
# --- Admin Rights Check (All Hosts, All Users) ---
if ($Host.Name -notmatch "ServerRemoteHost") {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "❌ PowerShell is NOT running as Administrator!"
    } else {
        Write-Host "✅ Running as Administrator" -ForegroundColor Green
    }
}
'@

# Write the profile script
Set-Content -Path $globalProfile -Value $adminCheck -Encoding UTF8 -Force
Write-Host "✅ Admin check added to global PowerShell profile:"
Write-Host $globalProfile -ForegroundColor Green

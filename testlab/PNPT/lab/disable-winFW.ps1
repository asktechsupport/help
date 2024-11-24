# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator!" -ForegroundColor Red
    exit
}

Write-Host "Disabling all Windows Firewall profiles..." -ForegroundColor Yellow
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False

Write-Host "Domain firewall profile disabled." -ForegroundColor Cyan
Write-Host "Private firewall profile disabled." -ForegroundColor Cyan
Write-Host "Public firewall profile disabled." -ForegroundColor Cyan

Write-Host "All firewall profiles have been disabled." -ForegroundColor Green

# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator!" -ForegroundColor Red
    exit
}

Write-Host "Disabling all Windows Firewall profiles..." -ForegroundColor Yellow

# Disable Domain Profile
Set-NetFirewallProfile -Profile Domain -Enabled False
Write-Host "Domain firewall profile disabled." -ForegroundColor Green

# Disable Private Profile
Set-NetFirewallProfile -Profile Private -Enabled False
Write-Host "Private firewall profile disabled." -ForegroundColor Green

# Disable Public Profile
Set-NetFirewallProfile -Profile Public -Enabled False
Write-Host "Public firewall profile disabled." -ForegroundColor Green

Write-Host "All firewall profiles have been disabled." -ForegroundColor Cyan

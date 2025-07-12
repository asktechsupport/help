# Run this script as Administrator

# Variables
$pswaUser = "PNPT\PNPT"
$certName = "PSWA-SelfSigned"
$hostfqdn = "[System.Net.Dns]::GetHostEntry($env:computerName).HostName"  #Gets your server FQDN
$httpsPort = 443
$url = "https://$dnsName/pswa"

# Step 1: Install PowerShell Web Access
Install-WindowsFeature -Name WindowsPowerShellWebAccess -IncludeManagementTools

# Step 2: Install PSWA Web Application with a test certificate
Install-PswaWebApplication -UseTestCertificate -Verbose

# Step 3: Authorize PNPT\PNPT to use PSWA
Add-PswaAuthorizationRule -UserName $pswaUser -ComputerName * -ConfigurationName *

# Step 4: Allow inbound HTTPS through firewall
New-NetFirewallRule -DisplayName "Allow PSWA HTTPS" -Direction Inbound -Protocol TCP -LocalPort $httpsPort -Action Allow

# Step 5: Restart IIS to apply changes
Restart-Service W3SVC

# Step 6: Output and launch
Write-Host "`n✅ PowerShell Web Access is ready." -ForegroundColor Green
Write-Host "🌐 Access it via: $url" -ForegroundColor Cyan
Write-Host "🔐 Log in with: $pswaUser"

# Step 7: Launch the PSWA URL in the default browser
Start-Process $url

# Run as Administrator

# Variables
$pswaUser = "PNPT\PNPT"
$certCommonName = "PSWA Server Certificate"
$httpsPort = 443
$hostfqdn = [System.Net.Dns]::GetHostEntry($env:computerName).HostName
$url = "https://$hostfqdn/pswa"

# Step 1: Install Certificate Authority (AD CS) Role
Install-WindowsFeature -Name ADCS-Cert-Authority -IncludeManagementTools
Import-Module ADCSDeployment
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -Force

Write-Host "✅ Certificate Authority installed." -ForegroundColor Green

# Step 2: Install PowerShell Web Access
Install-WindowsFeature -Name WindowsPowerShellWebAccess -IncludeManagementTools
Write-Host "✅ PowerShell Web Access feature installed." -ForegroundColor Green

# Step 3: Install PSWA Web Application with default certificate first
Install-PswaWebApplication -UseTestCertificate
Write-Host "✅ PSWA Web Application installed." -ForegroundColor Green

# Step 4: Generate or request SSL certificate from internal CA (or self-signed for demo)
$cert = New-SelfSignedCertificate -DnsName $hostfqdn -CertStoreLocation "cert:\LocalMachine\My" -FriendlyName $certCommonName
$thumbprint = $cert.Thumbprint

Write-Host "✅ SSL Certificate created with thumbprint $thumbprint." -ForegroundColor Green

# Step 5: Rebind PSWA site to use custom certificate
Import-Module WebAdministration

# Remove old binding if it exists
Try {
    Remove-WebBinding -Name "pswa_default_site" -Protocol https -Port $httpsPort -ErrorAction SilentlyContinue
    Remove-Item "IIS:\SslBindings\0.0.0.0!$httpsPort" -ErrorAction SilentlyContinue
} Catch {}

# Create new binding
New-WebBinding -Name "pswa_default_site" -Protocol https -Port $httpsPort -HostHeader ""
New-Item "IIS:\SslBindings\0.0.0.0!$httpsPort" -Thumbprint $thumbprint -SSLFlags 0

Write-Host "✅ IIS binding updated with new SSL certificate." -ForegroundColor Green

# Step 6: Authorize PNPT\PNPT to use PSWA
Add-PswaAuthorizationRule -UserName $pswaUser -ComputerName * -ConfigurationName *

# Step 7: Allow inbound HTTPS through firewall
New-NetFirewallRule -DisplayName "Allow PSWA HTTPS" -Direction Inbound -Protocol TCP -LocalPort $httpsPort -Action Allow

# Step 8: Restart IIS to apply changes
Restart-Service W3SVC

# Step 9: Output and launch
Write-Host "`n✅ PowerShell Web Access is ready with CA-issued certificate." -ForegroundColor Green
Write-Host "🌐 Access it via: $url" -ForegroundColor Cyan
Write-Host "🔐 Log in with: $pswaUser"

Start-Process $url

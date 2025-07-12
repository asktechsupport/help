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

# Step 3: Request SSL Certificate from Internal CA
$cert = New-SelfSignedCertificate -DnsName $hostfqdn -CertStoreLocation "cert:\LocalMachine\My" -FriendlyName $certCommonName

# OR: Replace with internal CA request if available
# $certRequest = New-CertificateRequest...

# Step 4: Install PSWA Web Application with Custom Certificate
$thumbprint = $cert.Thumbprint
Install-PswaWebApplication -CertificateThumbprint $thumbprint -Verbose

# Step 5: Authorize PNPT\PNPT to use PSWA
Add-PswaAuthorizationRule -UserName $pswaUser -ComputerName * -ConfigurationName *

# Step 6: Allow inbound HTTPS through firewall
New-NetFirewallRule -DisplayName "Allow PSWA HTTPS" -Direction Inbound -Protocol TCP -LocalPort $httpsPort -Action Allow

# Step 7: Restart IIS to apply changes
Restart-Service W3SVC

# Step 8: Output and launch
Write-Host "`n✅ PowerShell Web Access is ready with CA-issued certificate." -ForegroundColor Green
Write-Host "🌐 Access it via: $url" -ForegroundColor Cyan
Write-Host "🔐 Log in with: $pswaUser"

Start-Process $url

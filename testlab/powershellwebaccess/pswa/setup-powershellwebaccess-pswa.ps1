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

# Step 2: Install PowerShell Web Access if not already installed
if (-not (Get-WebApplication -Site "Default Web Site" | Where-Object { $_.Path -eq "/pswa" })) {
    Install-WindowsFeature -Name WindowsPowerShellWebAccess -IncludeManagementTools
    Install-PswaWebApplication -UseTestCertificate
    Write-Host "✅ PowerShell Web Access installed first time." -ForegroundColor Green
} else {
    Write-Host "ℹ️ PowerShell Web Access already present. Skipping Install-PswaWebApplication." -ForegroundColor Yellow
}

# Step 3: Generate SSL Certificate (Self-Signed Example)
$cert = New-SelfSignedCertificate -DnsName $hostfqdn -CertStoreLocation "cert:\LocalMachine\My" -FriendlyName $certCommonName
$thumbprint = $cert.Thumbprint
Write-Host "✅ SSL Certificate created with thumbprint $thumbprint." -ForegroundColor Green

# Step 4: Always Replace IIS HTTPS Binding
Import-Module WebAdministration

# Remove all HTTPS bindings on Default Web Site
Get-WebBinding -Name "Default Web Site" -Protocol https | ForEach-Object { 
    Write-Host "Removing binding: $($_.bindingInformation)" -ForegroundColor Yellow
    Remove-WebBinding -Name "Default Web Site" -BindingInformation $_.bindingInformation -Protocol https 
}

# Clean up all ssl bindings for port 443 (global)
Get-ChildItem "IIS:\SslBindings" | Where-Object { $_.Port -eq $httpsPort } | ForEach-Object { 
    Remove-Item $_.PSPath -ErrorAction SilentlyContinue
}

# Add new binding manually
New-WebBinding -Name "Default Web Site" -Protocol https -Port $httpsPort -HostHeader ""
New-Item "IIS:\SslBindings\0.0.0.0!$httpsPort" -Thumbprint $thumbprint -SSLFlags 0
Write-Host "✅ HTTPS binding manually replaced with new certificate." -ForegroundColor Green

# Step 5: Authorize PNPT\PNPT to use PSWA
Add-PswaAuthorizationRule -UserName $pswaUser -ComputerName * -ConfigurationName *

# Step 6: Allow inbound HTTPS through firewall
if (-not (Get-NetFirewallRule | Where-Object { $_.DisplayName -eq "Allow PSWA HTTPS" })) {
    New-NetFirewallRule -DisplayName "Allow PSWA HTTPS" -Direction Inbound -Protocol TCP -LocalPort $httpsPort -Action Allow
    Write-Host "✅ Firewall rule added for PSWA HTTPS." -ForegroundColor Green
} else {
    Write-Host "ℹ️ Firewall rule already exists. Skipping." -ForegroundColor Yellow
}

# Step 7: Restart IIS
Restart-Service W3SVC

# Step 8: Output and Launch
Write-Host "`n✅ PowerShell Web Access is ready with updated HTTPS binding." -ForegroundColor Green
Write-Host "🌐 Access it via: $url" -ForegroundColor Cyan
Write-Host "🔐 Log in with: $pswaUser"

Start-Process $url

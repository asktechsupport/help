# MUST RUN AS ADMIN

Write-Host "`n=== SINGLE SERVER RDS CERT FIX SCRIPT ===`n" -ForegroundColor Cyan

# STEP 1: Get FQDN
$FQDN = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName
Write-Host "Using FQDN: $FQDN" -ForegroundColor Yellow

# STEP 2: Create a self-signed cert for the FQDN
Write-Host "Creating self-signed certificate..." -ForegroundColor Cyan
$cert = New-SelfSignedCertificate -DnsName $FQDN -CertStoreLocation "Cert:\LocalMachine\My" -FriendlyName "RDS SSL Cert"
$thumbprint = $cert.Thumbprint

# STEP 3: Add cert to Trusted Root store (locally trusted)
Write-Host "Adding certificate to Trusted Root store..." -ForegroundColor Cyan
$rootStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root","LocalMachine")
$rootStore.Open("ReadWrite")
$rootStore.Add($cert)
$rootStore.Close()

# STEP 4: Rebind IIS HTTPS (port 443) using netsh
Write-Host "Rebinding HTTPS in IIS..." -ForegroundColor Cyan
Import-Module WebAdministration

# Ensure HTTPS binding exists
if (-not (Get-WebBinding -Name "Default Web Site" -Protocol "https")) {
    New-WebBinding -Name "Default Web Site" -Protocol "https" -Port 443 -IPAddress "*"
}

# Remove any existing SSL binding on 443
netsh http delete sslcert ipport=0.0.0.0:443 2>$null

# Add new SSL binding with our cert
$guid = [guid]::NewGuid().ToString()
netsh http add sslcert ipport=0.0.0.0:443 certhash=$thumbprint appid="{$guid}" certstorename=MY

# STEP 5: Apply certificate to RDS roles
Write-Host "Applying certificate to RDS roles..." -ForegroundColor Cyan
Set-RDCertificate -Role RDWebAccess -Thumbprint $thumbprint -Force
Set-RDCertificate -Role RDPublishing -Thumbprint $thumbprint -Force
Set-RDCertificate -Role RDConnectionBroker -Thumbprint $thumbprint -Force

# STEP 6: Restart RDS and IIS
Write-Host "Restarting Remote Desktop Services and IIS..." -ForegroundColor Cyan
Restart-Service TermService -Force
iisreset

# STEP 7: Launch RDWeb in browser
$rdwebUrl = "https://$FQDN/RDWeb"
Write-Host "`n🎯 Opening RDWeb at: $rdwebUrl`n" -ForegroundColor Green
Start-Process $rdwebUrl

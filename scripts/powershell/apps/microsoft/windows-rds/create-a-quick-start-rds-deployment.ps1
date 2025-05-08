# MUST RUN AS ADMIN

Write-Host "`n=== SINGLE SERVER RDS DEPLOYMENT + CERT FIX SCRIPT ===`n" -ForegroundColor Cyan

# STEP 1: Get FQDN
$FQDN = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName
Write-Host "Using FQDN: $FQDN" -ForegroundColor Yellow

# STEP 2: Install RDS roles (Session Host, Connection Broker, Web Access)
Write-Host "Installing RDS roles..." -ForegroundColor Cyan
Install-WindowsFeature -Name RDS-RD-Server, RDS-Connection-Broker, RDS-Web-Access -IncludeManagementTools -Restart

# After reboot, the script resumes here
Start-Sleep -Seconds 10
Import-Module RemoteDesktop
$connectionBroker = $env:COMPUTERNAME
$sessionHost = $env:COMPUTERNAME
$webAccess = $env:COMPUTERNAME

# STEP 3: Create the RDS deployment
Write-Host "Creating RDS deployment..." -ForegroundColor Cyan
New-RDSessionDeployment -ConnectionBroker $connectionBroker -SessionHost $sessionHost -WebAccessServer $webAccess

# STEP 4: Publish Notepad as RemoteApp
Write-Host "Publishing Notepad as RemoteApp..." -ForegroundColor Cyan
New-RDRemoteApp -CollectionName "QuickSessionCollection" -Alias "Notepad" -DisplayName "Notepad" -FilePath "C:\Windows\System32\notepad.exe"

# STEP 5: Create self-signed certificate
Write-Host "Creating self-signed certificate for $FQDN..." -ForegroundColor Cyan
$cert = New-SelfSignedCertificate -DnsName $FQDN -CertStoreLocation "Cert:\LocalMachine\My" -FriendlyName "RDS SSL Cert"
$thumbprint = $cert.Thumbprint

# STEP 6: Add cert to Trusted Root CA locally
Write-Host "Adding cert to Trusted Root store..." -ForegroundColor Cyan
$rootStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root","LocalMachine")
$rootStore.Open("ReadWrite")
$rootStore.Add($cert)
$rootStore.Close()

# STEP 7: Bind cert to HTTPS in IIS
Write-Host "Rebinding HTTPS in IIS..." -ForegroundColor Cyan
Import-Module WebAdministration

if (-not (Get-WebBinding -Name "Default Web Site" -Protocol "https")) {
    New-WebBinding -Name "Default Web Site" -Protocol "https" -Port 443 -IPAddress "*"
}

netsh http delete sslcert ipport=0.0.0.0:443 2>$null
$guid = [guid]::NewGuid().ToString()
netsh http add sslcert ipport=0.0.0.0:443 certhash=$thumbprint appid="{$guid}" certstorename=MY

# STEP 8: Apply cert to all RDS roles
Write-Host "Applying certificate to RDS roles..." -ForegroundColor Cyan
Set-RDCertificate -Role RDWebAccess -Thumbprint $thumbprint -Force
Set-RDCertificate -Role RDPublishing -Thumbprint $thumbprint -Force
Set-RDCertificate -Role RDConnectionBroker -Thumbprint $thumbprint -Force

# STEP 9: Restart RDS and IIS
Write-Host "Restarting Remote Desktop Services and IIS..." -ForegroundColor Cyan
Restart-Service TermService -Force
iisreset

# STEP 10: Launch RDWeb in browser
$rdwebUrl = "https://$FQDN/RDWeb"
Write-Host "`n🎯 Deployment complete. Launching RDWeb at: $rdwebUrl`n" -ForegroundColor Green
Start-Process $rdwebUrl

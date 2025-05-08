# === RDS SINGLE SERVER SETUP WITH SELF-RESUMING SCRIPT ===
# Phase 1: Run before reboot. It installs RDS roles and sets up Task Scheduler to resume setup after reboot.

# Constants
$scriptPath = "$env:SystemDrive\RDS-Finalize-Phase2.ps1"
$taskName = "RDS-Resume-Setup"

Write-Host "\n=== PHASE 1: Installing RDS roles and setting up resume task ===\n" -ForegroundColor Cyan

# STEP 1: Get FQDN
$FQDN = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName
Write-Host "Using FQDN: $FQDN" -ForegroundColor Yellow

# STEP 2: Install RDS roles (Session Host, Connection Broker, Web Access)
Write-Host "Installing RDS roles..." -ForegroundColor Cyan
Install-WindowsFeature -Name RDS-RD-Server, RDS-Connection-Broker, RDS-Web-Access -IncludeManagementTools

# STEP 3: Write Phase 2 script to disk
Write-Host "Creating Phase 2 script at $scriptPath..." -ForegroundColor Cyan

$phase2 = @'
# === PHASE 2: Finalize RDS Deployment ===

Start-Transcript -Path "$env:SystemDrive\RDS-Phase2-Log.txt" -Append

$FQDN = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName
$connectionBroker = $env:COMPUTERNAME
$sessionHost = $env:COMPUTERNAME
$webAccess = $env:COMPUTERNAME

Import-Module RemoteDesktop

# Create RDS deployment
New-RDSessionDeployment -ConnectionBroker $connectionBroker -SessionHost $sessionHost -WebAccessServer $webAccess

# Create session collection
New-RDSessionCollection -CollectionName "QuickSessionCollection" `
    -SessionHost @($sessionHost) `
    -ConnectionBroker $connectionBroker `
    -CollectionDescription "Default collection"

# Grant Domain Users access
Set-RDSessionCollectionConfiguration -CollectionName "QuickSessionCollection" -UserGroup "Domain Users"

# Publish Notepad
New-RDRemoteApp -CollectionName "QuickSessionCollection" -Alias "Notepad" -DisplayName "Notepad" -FilePath "C:\Windows\System32\notepad.exe"

# Create SSL cert
$cert = New-SelfSignedCertificate -DnsName $FQDN -CertStoreLocation "Cert:\\LocalMachine\\My" -FriendlyName "RDS SSL Cert"
$thumbprint = $cert.Thumbprint

# Trust locally
$rootStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root","LocalMachine")
$rootStore.Open("ReadWrite")
$rootStore.Add($cert)
$rootStore.Close()

# Bind cert to IIS
Import-Module WebAdministration
if (-not (Get-WebBinding -Name "Default Web Site" -Protocol "https")) {
    New-WebBinding -Name "Default Web Site" -Protocol "https" -Port 443 -IPAddress "*"
}

netsh http delete sslcert ipport=0.0.0.0:443 2>$null
$guid = [guid]::NewGuid().ToString()
netsh http add sslcert ipport=0.0.0.0:443 certhash=$thumbprint appid="{$guid}" certstorename=MY

# Assign cert to RDS roles
Set-RDCertificate -Role RDWebAccess -Thumbprint $thumbprint -Force
Set-RDCertificate -Role RDPublishing -Thumbprint $thumbprint -Force
Set-RDCertificate -Role RDConnectionBroker -Thumbprint $thumbprint -Force

# Set RDWeb URL as Edge homepage for all users via registry
$homepage = "https://$FQDN/RDWeb"
$edgePolicyPath = "HKLM:\Software\Policies\Microsoft\Edge"
New-Item -Path $edgePolicyPath -Force | Out-Null
Set-ItemProperty -Path $edgePolicyPath -Name "RestoreOnStartup" -Value 4 -Type DWord
Set-ItemProperty -Path $edgePolicyPath -Name "RestoreOnStartupURLs" -Value @($homepage)

# Notify user before opening RDWeb
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("RDS setup is complete. RDWeb will now open:", "RDS Setup", 'OK', 'Information') | Out-Null

# Restart services
Restart-Service TermService -Force
Start-Sleep -Seconds 5

# Remove scheduled task
Unregister-ScheduledTask -TaskName "RDS-Resume-Setup" -Confirm:$false

# Mark completion and open RDWeb
Stop-Transcript
"RDS setup completed at $(Get-Date)" | Out-File "$env:SystemDrive\RDS-Phase2-Complete.txt" -Encoding UTF8 -Force
Start-Process "https://$FQDN/RDWeb"
'@

Set-Content -Path $scriptPath -Value $phase2 -Force -Encoding UTF8

# STEP 4: Create scheduled task to run Phase 2 script at startup
Write-Host "Registering scheduled task to resume setup after reboot..." -ForegroundColor Cyan
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal

# STEP 5: Force reboot
Write-Host "\n✅ Phase 1 complete. Rebooting now to continue RDS setup..." -ForegroundColor Green
shutdown /r /t 5 /c "Rebooting to finalize RDS setup..." /f

<# 
RDS Single Server Setup - Self-Resuming (Resilient Certificate Assignment)

PHASE 1 (run manually): 
- Installs required RDS roles/features
- Creates a scheduled task to run PHASE 2 at startup (SYSTEM)
- Reboots

PHASE 2 (auto after reboot):
- Creates RDS deployment and session collection
- Publishes Notepad
- Creates a self-signed cert
- Assigns certs to available RDS roles (role-aware / resilient)
- Restarts services
- Removes scheduled task
- Opens RDWeb

Logs:
- C:\RDS-Phase2-Log.txt
- C:\RDS-Phase2-Complete.txt
#>

# =========================
# PHASE 1: Install + Schedule Phase 2 + Reboot
# =========================

# Constants
$scriptPath = "$env:SystemDrive\RDS-Finalize-Phase2.ps1"
$taskName   = "RDS-Resume-Setup"

Write-Host "`n=== PHASE 1: Installing RDS roles and setting up resume task ===`n" -ForegroundColor Cyan

# STEP 1: Get FQDN
$FQDN = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName
Write-Host "Using FQDN: $FQDN" -ForegroundColor Yellow

# STEP 2: Install RDS roles (Session Host, Connection Broker, Web Access)
Write-Host "Installing RDS roles..." -ForegroundColor Cyan
Install-WindowsFeature -Name RDS-RD-Server, RDS-Connection-Broker, RDS-Web-Access -IncludeManagementTools | Out-Null

# STEP 3: Write Phase 2 script to disk
Write-Host "Creating Phase 2 script at $scriptPath..." -ForegroundColor Cyan

$phase2 = @'
# =========================
# PHASE 2: Finalize RDS Deployment
# =========================

$ErrorActionPreference = "Stop"
Start-Transcript -Path "$env:SystemDrive\RDS-Phase2-Log.txt" -Append

function Write-Step($msg) {
    Write-Host "[$(Get-Date -Format 's')] $msg" -ForegroundColor Cyan
}

try {
    $FQDN            = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName
    $connectionBroker = $FQDN
    $sessionHost      = $FQDN
    $webAccess        = $FQDN

    Write-Step "Using FQDN: $FQDN"
    Write-Step "Importing RemoteDesktop module..."
    Import-Module RemoteDesktop

    # Create RDS deployment (skip if it already exists)
    Write-Step "Checking for existing RDS deployment..."
    $deploymentExists = $false
    try {
        $null = Get-RDDeployment -ConnectionBroker $connectionBroker -ErrorAction Stop
        $deploymentExists = $true
    } catch {
        $deploymentExists = $false
    }

    if (-not $deploymentExists) {
        Write-Step "Creating RDS deployment..."
        New-RDSessionDeployment -ConnectionBroker $connectionBroker -SessionHost $sessionHost -WebAccessServer $webAccess
        Write-Step "RDS deployment created."
    } else {
        Write-Step "RDS deployment already exists; skipping New-RDSessionDeployment."
    }

    # Create session collection (skip if exists)
    $collectionName = "QuickSessionCollection"
    Write-Step "Checking for existing session collection '$collectionName'..."
    $collectionExists = $false
    try {
        $existing = Get-RDSessionCollection -ConnectionBroker $connectionBroker -ErrorAction Stop |
                    Where-Object { $_.CollectionName -eq $collectionName }
        if ($existing) { $collectionExists = $true }
    } catch {
        $collectionExists = $false
    }

    if (-not $collectionExists) {
        Write-Step "Creating session collection '$collectionName'..."
        New-RDSessionCollection -CollectionName $collectionName `
            -SessionHost @($sessionHost) `
            -ConnectionBroker $connectionBroker `
            -CollectionDescription "Default collection"
        Write-Step "Session collection created."
    } else {
        Write-Step "Session collection already exists; skipping."
    }

    # Grant Domain Users access (may fail if not domain joined)
    Write-Step "Setting user access for '$collectionName'..."
    try {
        Set-RDSessionCollectionConfiguration -CollectionName $collectionName -UserGroup "Domain Users" -ConnectionBroker $connectionBroker
        Write-Step "Granted access to 'Domain Users'."
    } catch {
        Write-Warning "Failed to set 'Domain Users' access (likely not domain-joined). Error: $($_.Exception.Message)"
        Write-Warning "If needed, set a local group instead, e.g. '$env:COMPUTERNAME\Users'."
    }

    # Publish Notepad (ignore if already exists)
    Write-Step "Publishing Notepad RemoteApp..."
    try {
        New-RDRemoteApp -CollectionName $collectionName -Alias "Notepad" -DisplayName "Notepad" -FilePath "C:\Windows\System32\notepad.exe" -ConnectionBroker $connectionBroker
        Write-Step "Notepad published."
    } catch {
        Write-Warning "Notepad publish skipped/failed (may already exist): $($_.Exception.Message)"
    }

    # Create SSL cert
    Write-Step "Creating self-signed certificate for $FQDN..."
    $cert = New-SelfSignedCertificate -DnsName $FQDN -CertStoreLocation "Cert:\LocalMachine\My" -FriendlyName "RDS SSL Cert"
    $thumbprint = $cert.Thumbprint
    Write-Step "Certificate created. Thumbprint: $thumbprint"

    # Trust locally
    Write-Step "Adding certificate to LocalMachine Root store (trust locally)..."
    $rootStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root","LocalMachine")
    $rootStore.Open("ReadWrite")
    $rootStore.Add($cert)
    $rootStore.Close()

    # Bind cert to IIS / HTTP.SYS (optional but commonly helpful for RDWeb)
    Write-Step "Binding certificate to IIS/HTTPS (Default Web Site) and HTTP.SYS..."
    Import-Module WebAdministration

    if (-not (Get-WebBinding -Name "Default Web Site" -Protocol "https" -ErrorAction SilentlyContinue)) {
        New-WebBinding -Name "Default Web Site" -Protocol "https" -Port 443 -IPAddress "*"
    }

    netsh http delete sslcert ipport=0.0.0.0:443 2>$null | Out-Null
    $guid = [guid]::NewGuid().ToString()
    netsh http add sslcert ipport=0.0.0.0:443 certhash=$thumbprint appid="{$guid}" certstorename=MY | Out-Null

    # =========================
    # RESILIENT RDS CERTIFICATE ASSIGNMENT (REPLACEMENT)
    # =========================
    Write-Step "Assigning certificate to available RDS roles (resilient)..."
    $validRoles = [enum]::GetNames([Microsoft.RemoteDesktopServices.Management.RDCertificateRole])
    $rolesToSet = @("RDWebAccess","RDPublishing","RDRedirector") | Where-Object { $_ -in $validRoles }

    foreach ($r in $rolesToSet) {
        Write-Step "Setting RDS certificate role: $r"
        Set-RDCertificate -Role $r -Thumbprint $thumbprint -ConnectionBroker $connectionBroker -Force
    }

    if ("RDGateway" -in $validRoles) {
        Write-Step "RDGateway role exists on this OS. Not setting it (Gateway not installed in this build)."
    }
    # =========================

    # Set RDWeb URL as Edge homepage for all users via registry
    Write-Step "Setting Edge homepage policy to RDWeb..."
    $homepage = "https://$FQDN/RDWeb"
    $edgePolicyPath = "HKLM:\Software\Policies\Microsoft\Edge"
    New-Item -Path $edgePolicyPath -Force | Out-Null
    Set-ItemProperty -Path $edgePolicyPath -Name "RestoreOnStartup" -Value 4 -Type DWord
    # RestoreOnStartupURLs expects a multi-string; ensure proper type
    New-ItemProperty -Path $edgePolicyPath -Name "RestoreOnStartupURLs" -PropertyType MultiString -Value @($homepage) -Force | Out-Null

    # Notify user (may fail under SYSTEM without interactive desktop; ignore)
    Write-Step "Displaying completion message (best-effort)..."
    try {
        Add-Type -AssemblyName PresentationFramework
        [System.Windows.MessageBox]::Show("RDS setup is complete. RDWeb will now open: $homepage", "RDS Setup", 'OK', 'Information') | Out-Null
    } catch {
        Write-Warning "UI notification skipped (non-interactive session)."
    }

    # Restart services
    Write-Step "Restarting services..."
    Restart-Service TermService -Force
    Start-Sleep -Seconds 5

    # Remove scheduled task
    Write-Step "Removing scheduled task..."
    Unregister-ScheduledTask -TaskName "RDS-Resume-Setup" -Confirm:$false -ErrorAction SilentlyContinue

    # Mark completion and open RDWeb
    Write-Step "Writing completion marker and opening RDWeb..."
    "RDS setup completed at $(Get-Date)" | Out-File "$env:SystemDrive\RDS-Phase2-Complete.txt" -Encoding UTF8 -Force

    try {
        Start-Process $homepage
    } catch {
        Write-Warning "Unable to open browser in this session."
    }

    Write-Step "Phase 2 complete."

} catch {
    Write-Error "Phase 2 failed: $($_.Exception.Message)"
    throw
} finally {
    Stop-Transcript
}
'@

Set-Content -Path $scriptPath -Value $phase2 -Force -Encoding UTF8

# STEP 4: Create scheduled task to run Phase 2 script at startup
Write-Host "Registering scheduled task to resume setup after reboot..." -ForegroundColor Cyan
$action    = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
$trigger   = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal | Out-Null

# STEP 5: Force reboot
Write-Host "`nPhase 1 complete. Rebooting now to continue RDS setup..." -ForegroundColor Green
shutdown /r /t 5 /c "Rebooting to finalize RDS setup..." /f

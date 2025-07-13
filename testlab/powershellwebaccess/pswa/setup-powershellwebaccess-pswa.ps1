# Run as Administrator

# ------------------------------
# Function: Set-IISHttpsBinding
# ------------------------------
function Set-IISHttpsBinding {
    param (
        [string]$SiteName = "Default Web Site",
        [string]$CertThumbprint,
        [int]$Port = 443
    )

    Write-Host "`n🔧 Replacing HTTPS binding on '$SiteName'..." -ForegroundColor Cyan

    if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
        Write-Host "❌ WebAdministration module is not available. Install IIS Management Tools." -ForegroundColor Red
        return
    }

    Import-Module WebAdministration

    Get-WebBinding -Name $SiteName -Protocol https | ForEach-Object {
        Remove-WebBinding -Name $SiteName -BindingInformation $_.bindingInformation -Protocol https
    }

    Remove-Item "IIS:\SslBindings\0.0.0.0!$Port" -ErrorAction SilentlyContinue

    New-WebBinding -Name $SiteName -Protocol https -Port $Port
    New-Item "IIS:\SslBindings\0.0.0.0!$Port" -Thumbprint $CertThumbprint -SSLFlags 0

    Write-Host "✅ HTTPS binding updated with certificate thumbprint $CertThumbprint" -ForegroundColor Green
}

# ------------------------------
# Function: Set-PSWAAuthorizationRule
# ------------------------------
function Set-PSWAAuthorizationRule {
    param (
        [string]$UserName,
        [string]$ComputerName = "*",
        [string]$ConfigurationName = "*"
    )

    $existingRule = Get-PswaAuthorizationRule | Where-Object { $_.UserName -eq $UserName }

    if ($existingRule) {
        Write-Host "ℹ️ PSWA authorization rule for $UserName already exists. Removing and re-adding it..." -ForegroundColor Yellow
        $existingRule | Remove-PswaAuthorizationRule
    }

    Add-PswaAuthorizationRule -UserName $UserName -ComputerName $ComputerName -ConfigurationName $ConfigurationName
    Write-Host "✅ PSWA authorization rule set for $UserName." -ForegroundColor Green
}

# ------------------------------
# Script Starts Here
# ------------------------------

$pswaUser = "PNPT\PNPT"
$certCommonName = "PSWA Server Certificate"
$httpsPort = 443
$hostfqdn = [System.Net.Dns]::GetHostEntry($env:computerName).HostName
$url = "https://$hostfqdn/pswa"

Install-WindowsFeature -Name ADCS-Cert-Authority -IncludeManagementTools
Import-Module ADCSDeployment
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -Force
Write-Host "✅ Certificate Authority installed." -ForegroundColor Green

if (-not (Get-WebApplication -Site "Default Web Site" | Where-Object { $_.Path -eq "/pswa" })) {
    Install-WindowsFeature -Name WindowsPowerShellWebAccess -IncludeManagementTools
    Install-PswaWebApplication
    Write-Host "✅ PowerShell Web Access installed." -ForegroundColor Green
} else {
    Write-Host "ℹ️ PSWA already installed. Skipping install." -ForegroundColor Yellow
}

$cert = New-SelfSignedCertificate -DnsName $hostfqdn -CertStoreLocation "cert:\LocalMachine\My" -FriendlyName $certCommonName
$thumbprint = $cert.Thumbprint
Write-Host "✅ SSL Certificate created with thumbprint $thumbprint" -ForegroundColor Green

Write-Host "`n🔧 Opening IIS Manager... Please remove any existing HTTPS bindings for 'Default Web Site' manually." -ForegroundColor Cyan
Start-Process inetmgr
Read-Host "⏸️ Press ENTER to continue after removing the bindings"

Import-Module WebAdministration
$httpsBindings = Get-WebBinding -Name "Default Web Site" -Protocol https

while ($httpsBindings) {
    Write-Host "⚠️ HTTPS bindings still detected. Please remove them in IIS Manager!" -ForegroundColor Yellow
    $httpsBindings | Format-Table BindingInformation
    Read-Host "⏸️ Press ENTER again once bindings have been removed"
    $httpsBindings = Get-WebBinding -Name "Default Web Site" -Protocol https
}

Write-Host "✅ No HTTPS bindings found. Continuing..." -ForegroundColor Green

Set-IISHttpsBinding -CertThumbprint $thumbprint -Port $httpsPort

Set-PSWAAuthorizationRule -UserName $pswaUser

if (-not (Get-NetFirewallRule | Where-Object { $_.DisplayName -eq "Allow PSWA HTTPS" })) {
    New-NetFirewallRule -DisplayName "Allow PSWA HTTPS" -Direction Inbound -Protocol TCP -LocalPort $httpsPort -Action Allow
    Write-Host "✅ Firewall rule created for PSWA HTTPS." -ForegroundColor Green
} else {
    Write-Host "ℹ️ Firewall rule already exists." -ForegroundColor Yellow
}

Restart-Service W3SVC

Write-Host "`n✅ PowerShell Web Access is ready." -ForegroundColor Green
Write-Host "🌐 Access it via: $url" -ForegroundColor Cyan
Write-Host "🔐 Log in with: $pswaUser"

Start-Process $url

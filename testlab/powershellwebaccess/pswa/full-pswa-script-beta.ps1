# Run as Administrator

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Please run this script as Administrator." -ForegroundColor Red
    exit
}

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
# Function: Update-WindowsAuthenticationInConfig
# ------------------------------
function Update-WindowsAuthenticationInConfig {
    $configPath = "C:\Windows\System32\inetsrv\config\applicationHost.config"
    [xml]$config = Get-Content $configPath
    $section = $config.configuration.'configSections'.section | Where-Object { $_.name -eq 'system.webServer/security/authentication/windowsAuthentication' }
    if ($section -ne $null) {
        $section.overrideModeDefault = "Allow"
        $config.Save($configPath)
        Write-Host "✅ windowsAuthentication overrideModeDefault updated to Allow in applicationHost.config." -ForegroundColor Green
    } else {
        Write-Host "❌ windowsAuthentication section not found in applicationHost.config." -ForegroundColor Red
    }
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

Install-WindowsFeature Web-Mgmt-Console
Install-WindowsFeature Web-Mgmt-Service

# Ensure Windows Authentication feature is installed
Dism /Online /Enable-Feature /FeatureName:IIS-WindowsAuthentication /All

$cert = New-SelfSignedCertificate -DnsName $hostfqdn -CertStoreLocation "cert:\LocalMachine\My" -FriendlyName $certCommonName
$thumbprint = $cert.Thumbprint
Write-Host "✅ SSL Certificate created with thumbprint $thumbprint" -ForegroundColor Green

Set-IISHttpsBinding -CertThumbprint $thumbprint -Port $httpsPort

Set-PSWAAuthorizationRule -UserName $pswaUser

if (-not (Get-NetFirewallRule | Where-Object { $_.DisplayName -eq "Allow PSWA HTTPS" })) {
    New-NetFirewallRule -DisplayName "Allow PSWA HTTPS" -Direction Inbound -Protocol TCP -LocalPort $httpsPort -Action Allow
    Write-Host "✅ Firewall rule created for PSWA HTTPS." -ForegroundColor Green
} else {
    Write-Host "ℹ️ Firewall rule already exists." -ForegroundColor Yellow
}

# Enable all authentication methods for PSWA
Write-Host "`n🔧 Enabling all IIS authentication methods for PSWA..." -ForegroundColor Cyan
Set-WebConfigurationProperty -Filter "system.webServer/security/authentication/windowsAuthentication" -PSPath "MACHINE/WEBROOT/APPHOST/Default Web Site/pswa" -Name enabled -Value True
Set-WebConfigurationProperty -Filter "system.webServer/security/authentication/formsAuthentication" -PSPath "MACHINE/WEBROOT/APPHOST/Default Web Site/pswa" -Name enabled -Value True
Set-WebConfigurationProperty -Filter "system.webServer/security/authentication/anonymousAuthentication" -PSPath "MACHINE/WEBROOT/APPHOST/Default Web Site/pswa" -Name enabled -Value True

Update-WindowsAuthenticationInConfig

Restart-Service W3SVC

Write-Host "`n✅ PowerShell Web Access is ready." -ForegroundColor Green
Write-Host "🌐 Access it via: $url" -ForegroundColor Cyan
Write-Host "🔐 Log in with: $pswaUser"

Start-Process $url

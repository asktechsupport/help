# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run as Administrator." -ForegroundColor Red
    exit
}

# Variables
$dnsNames = @($env:COMPUTERNAME, "$env:COMPUTERNAME.$env:USERDNSDOMAIN")
$certFriendlyName = "WinRM HTTPS PSRemoting"

# Create SSL Certificate with NetBIOS and FQDN
$cert = New-SelfSignedCertificate `
    -DnsName $dnsNames `
    -CertStoreLocation "cert:\LocalMachine\My" `
    -FriendlyName $certFriendlyName `
    -KeyUsage DigitalSignature, KeyEncipherment `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1")  # Server Authentication EKU

$thumbprint = $cert.Thumbprint
Write-Host "✅ Created certificate with thumbprint: $thumbprint" -ForegroundColor Green

# Remove existing HTTPS listeners
Get-ChildItem WSMan:\localhost\Listener | Where-Object { $_.Keys -match 'Transport=HTTPS' } | Remove-Item -Force

# Create new WinRM HTTPS listener
$command = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=`"$hostname`"; CertificateThumbprint=`"$thumbprint`"}"
cmd /c $command

Write-Host "✅ WinRM HTTPS listener configured for $env:COMPUTERNAME." -ForegroundColor Green


# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run as Administrator." -ForegroundColor Red
    exit
}

# Variables
$hostname = $env:COMPUTERNAME
$fqdn = "$hostname.$env:USERDNSDOMAIN"
$dnsNames = @($hostname, $fqdn)
$template = "WebServer"

Write-Host "Requesting certificate from CA for: $dnsNames" -ForegroundColor Cyan

try {
    $certRequest = Get-Certificate -Template $template -DnsName $dnsNames -CertStoreLocation "cert:\LocalMachine\My" -ErrorAction Stop
    $thumbprint = $certRequest.Certificate.Thumbprint
    Write-Host "✅ Issued certificate with thumbprint: $thumbprint" -ForegroundColor Green
} catch {
    Write-Host "❌ Certificate request failed. Check if the CA is reachable and the template is correct." -ForegroundColor Red
    exit
}

# Remove existing HTTPS listeners
Write-Host "Cleaning up existing WinRM HTTPS listeners..." -ForegroundColor Cyan
Get-ChildItem WSMan:\localhost\Listener | Where-Object { $_.Keys -match 'Transport=HTTPS' } | Remove-Item -Force

# Create new WinRM HTTPS listener
$listenerCommand = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=`"$fqdn`"; CertificateThumbprint=`"$thumbprint`"}"
cmd /c $listenerCommand

Write-Host "✅ WinRM HTTPS listener configured using CA-issued certificate for $fqdn" -ForegroundColor Green

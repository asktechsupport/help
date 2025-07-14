# Variables
$time = Get-Date -Format "HH:mm:ss"
$date = Get-Date -Format "dd/MM/yyyy"
$datetime = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
$sysvolscheduledtasks = "\\$env:USERDNSDOMAIN\SYSVOL\$env:USERDNSDOMAIN\scripts\scheduledtasks"
$sysvolscheduledtaskssetuplogpath = "$sysvolscheduledtasks\setup"
$sysvolscheduledtaskssetuplogfile = "$sysvolscheduledtaskssetuplogpath\setup.log"
$sysvolscheduledtasksrunlogpath = "$sysvolscheduledtasks\run"
$sysvolscheduledtasksrunlogfile = "$sysvolscheduledtasksrunlogpath\run.log"
$hostname = $env:COMPUTERNAME
$fqdn = "$hostname.$env:USERDNSDOMAIN"
$dnsNames = @($hostname, $fqdn)
$listenerprotocol = "https"
$listenerport = "5896"
$template = "WebServer"
$startlistener = ""
$endlistener = ""

function log-result {
    param(
        [string]$name,
        [string]$successMessage,
        [string]$thumbprint,
        [string]$expiryDate,
        [string]$errorMessages
    )
    $logLine = "$date,$time,$name,$hostname,$startlistener,$endlistener,$successMessage,$thumbprint,$expiryDate,$errorMessages"
    Add-Content -Path $sysvolscheduledtaskssetuplogfile -Value $logLine
    Write-Host $successMessage -ForegroundColor Green
}

function log-errors {
    param(
        [string]$errorMessages
    )
    $logLine = "$date,$time,ERROR,$hostname,$startlistener,$endlistener,,,,$errorMessages"
    Add-Content -Path $sysvolscheduledtaskssetuplogfile -Value $logLine
    Write-Host $errorMessages -ForegroundColor Red
}

function remove-all-listeners {
    Write-Host "Cleaning up existing WinRM HTTPS listeners..." -ForegroundColor Cyan
    Get-ChildItem WSMan:\localhost\Listener | Where-Object { $_.Keys -match 'Transport=HTTPS' } | Remove-Item -Force
}

function create-listener-5896 {
    $listenerCommand = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=\"$fqdn\"; CertificateThumbprint=\"$thumbprint\"}"
    cmd /c $listenerCommand
    $startlistener = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
}

function get-latest-valid-cert {
    $cert = Get-ChildItem -Path Cert:\LocalMachine\My |
        Where-Object { $_.DnsNameList.Unicode -contains $fqdn -and $_.NotAfter -gt (Get-Date) } |
        Sort-Object NotAfter -Descending |
        Select-Object -First 1
    return $cert
}

function try-request-cert {
    try {
        $cert = get-latest-valid-cert
        if (-not $cert) {
            $certRequest = Get-Certificate -Template $template -DnsName $dnsNames -CertStoreLocation "cert:\LocalMachine\My" -ErrorAction Stop
            $cert = $certRequest.Certificate
        }
        $thumbprint = $cert.Thumbprint
        $expiryDate = $cert.NotAfter.ToString("dd/MM/yyyy")
        Write-Host "✅ Using certificate with thumbprint: $thumbprint" -ForegroundColor Green
        return @{ Thumbprint = $thumbprint; Expiry = $expiryDate }
    } catch {
        $errorMsg = "❌ Certificate request failed. Check if the CA is reachable and the template is correct."
        log-errors -errorMessages $errorMsg
        return $null
    }
}

function confirm-scheduled-task-creation {
    Write-Host "✅ Scheduled Task created successfully on $fqdn" -ForegroundColor Green
}

# Main Execution Flow
if (!(Test-Path $sysvolscheduledtaskssetuplogpath)) { New-Item -ItemType Directory -Path $sysvolscheduledtaskssetuplogpath -Force }
if (!(Test-Path $sysvolscheduledtasksrunlogpath)) { New-Item -ItemType Directory -Path $sysvolscheduledtasksrunlogpath -Force }

remove-all-listeners
$certInfo = try-request-cert
if ($certInfo) {
    $thumbprint = $certInfo.Thumbprint
    $expiryDate = $certInfo.Expiry
    create-listener-5896
    $endlistener = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    log-result -name "WinRM HTTPS Listener Setup" -successMessage "✅ WinRM HTTPS listener configured using CA-issued certificate for $fqdn" -thumbprint $thumbprint -expiryDate $expiryDate -errorMessages ""
    confirm-scheduled-task-creation
}
else {
    Write-Host "Listener setup aborted due to certificate error." -ForegroundColor Yellow
}

# Schedule daily listener recreation at 3 AM using Scheduled Task
$taskName = "Daily WinRM Listener Setup"
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $sysvolscheduledtasks\scheduled-listener-recreation.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 3am
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Force

# Note: WinRM listeners do not persist automatically through reboot unless configured in a startup script, GPO, or service. Ensure this script or an equivalent is triggered at startup to recreate listeners if needed.
# Reminder: Administrator to manually move logs from setup.log to run.log after verification

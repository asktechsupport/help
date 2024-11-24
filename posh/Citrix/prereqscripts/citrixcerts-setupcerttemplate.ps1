# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator!" -ForegroundColor Red
    exit
}

Write-Host "Starting certificate request process..." -ForegroundColor Cyan

# Step 1: Retrieve CA Configuration
function RetrieveCAConfig {
    Write-Host "Retrieving Certificate Authority configuration..." -ForegroundColor Yellow
    $global:caConfig = certutil.exe -dump | Select-String -Pattern "Config" | ForEach-Object {
        ($_ -split "Config:")[1].Trim().Trim('"')
    }

    if (-not $caConfig) {
        Write-Host "Failed to retrieve CA configuration. Ensure certutil is accessible and CA is operational." -ForegroundColor Red
        exit
    }
    Write-Host "CA Configuration Retrieved: $caConfig" -ForegroundColor Green
}

# Step 2: Create Certificate Request File
function CreateCertRequest {
    Write-Host "Creating certificate request file..." -ForegroundColor Yellow

    $certReq = @"
[Version]
Signature = "$Windows NT$"

[NewRequest]
Subject = "CN=$($env:COMPUTERNAME).$((Get-WmiObject Win32_ComputerSystem).Domain)"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
MachineKeySet = TRUE
RequestType = Cert
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ProviderType = 12
HashAlgorithm = sha256

[RequestAttributes]
CertificateTemplate = StoreFrontTemplate
"@
    $global:requestFilePath = "$env:Temp\StoreFrontCert.req"
    Set-Content -Path $requestFilePath -Value $certReq
    Write-Host "Certificate request file created at: $requestFilePath" -ForegroundColor Green
}

# Step 3: Validate the Certificate Request File
function Validate-CertRequestFile {
    param (
        [string]$FilePath
    )

    Write-Host "Validating the certificate request file at: $FilePath" -ForegroundColor Yellow

    # Check if the file exists
    if (-not (Test-Path -Path $FilePath)) {
        Write-Host "The certificate request file does not exist: $FilePath" -ForegroundColor Red
        exit
    }

    # Display the contents of the file
    Write-Host "Contents of the certificate request file:" -ForegroundColor Cyan
    Get-Content -Path $FilePath | ForEach-Object { Write-Host $_ }

    # Perform basic validation checks
    $fileContent = Get-Content -Path $FilePath
    if (-not ($fileContent -match "Signature =")) {
        Write-Host "Validation failed: Missing 'Signature' field in the certificate request file." -ForegroundColor Red
        exit
    }
    if (-not ($fileContent -match "CertificateTemplate = StoreFrontTemplate")) {
        Write-Host "Validation failed: Missing or incorrect 'CertificateTemplate' in the certificate request file." -ForegroundColor Red
        exit
    }

    Write-Host "Certificate request file validation passed." -ForegroundColor Green
}

# Step 4: Submit Certificate Request
function SubmitCertRequest {
    Write-Host "Submitting certificate request to CA: $caConfig..." -ForegroundColor Yellow
    $global:responseFilePath = "$env:Temp\StoreFrontCert.cer"
    $submitCommand = "certreq.exe -submit -config `"$caConfig`" `"$requestFilePath`" `"$responseFilePath`""
    Write-Host "Executing: $submitCommand" -ForegroundColor Yellow
    Invoke-Expression $submitCommand

    if (-not (Test-Path $responseFilePath)) {
        Write-Host "Certificate response not received. Check CA logs and configuration." -ForegroundColor Red
        exit
    }
    Write-Host "Certificate response received: $responseFilePath" -ForegroundColor Green
}

# Step 5: Accept and Install the Certificate
function AcceptAndInstallCert {
    Write-Host "Accepting and installing the certificate..." -ForegroundColor Yellow
    $acceptCommand = "certreq.exe -accept -machine `"$responseFilePath`""
    Invoke-Expression $acceptCommand
    Write-Host "Certificate successfully installed." -ForegroundColor Green
}

# Main Script Execution
RetrieveCAConfig
CreateCertRequest
Validate-CertRequestFile -FilePath $requestFilePath
SubmitCertRequest
AcceptAndInstallCert

Write-Host "Certificate request process completed successfully!" -ForegroundColor Cyan

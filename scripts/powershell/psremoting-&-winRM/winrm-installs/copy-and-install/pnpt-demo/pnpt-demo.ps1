# CONFIG: Local directory containing all installers
$localInstallerDir = "C:\temp\winrm"

# CONFIG: List of target hostnames or IPs
$targets = @(
    "10.0.0.254",
    "10.0.0.1"
)

# Ensure local installer directory exists
if (-not (Test-Path $localInstallerDir)) {
    Write-Host "⚠ $localInstallerDir does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -Path $localInstallerDir -ItemType Directory -Force | Out-Null
    Write-Host "✅ Created $localInstallerDir. Please place installers in this folder and re-run the script." -ForegroundColor Green
    exit
}

# Prompt for credentials once
$creds = Get-Credential -Message "Enter credentials for remote install"

$total = $targets.Count
$count = 0

foreach ($target in $targets) {
    $count++
    Write-Host "`n[$count of $total] ➜ Processing $target..." -ForegroundColor Cyan

    try {
        # Trust IP-based target if needed
        if ($target -match '^\d{1,3}(\.\d{1,3}){3}$') {
            Set-Item WSMan:\localhost\Client\TrustedHosts -Value $target -Force
        }

        $remoteUNCPath = "\\$target\C$\temp"
        $remoteLocalPath = "C:\temp"

        # Ensure remote folder exists
        if (-not (Test-Path $remoteUNCPath)) {
            New-Item -Path $remoteUNCPath -ItemType Directory -Force | Out-Null
            Write-Host "  ✔ Created remote folder $remoteUNCPath"
        }

        # Copy all installer files
        Get-ChildItem -Path $localInstallerDir -File | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $remoteUNCPath -Force
            Write-Host "  ✔ Copied $($_.Name) to $remoteUNCPath"
        }

        # Run installer block remotely
        Invoke-Command -ComputerName $target -Credential $creds -Authentication Negotiate -ScriptBlock {
            $folder = "C:\temp"

            if (-not (Test-Path $folder)) {
                New-Item -Path $folder -ItemType Directory -Force | Out-Null
                Write-Host "Created $folder"
            }

            # Install MSI files
            $msiFiles = Get-ChildItem -Path $folder -Filter *.msi -Recurse -ErrorAction SilentlyContinue
            foreach ($msi in $msiFiles) {
                Write-Host "  ⏳ Installing MSI: $($msi.Name)"
                $args = "/i `"$($msi.FullName)`" /qn /norestart"
                $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList $args -Wait -PassThru
                if ($proc.ExitCode -eq 0) {
                    Write-Host "  ✅ MSI installed successfully"
                } else {
                    Write-Host "  ⚠ MSI failed with exit code $($proc.ExitCode)" -ForegroundColor Yellow
                }
            }

            # Install EXE files
            $exeFiles = Get-ChildItem -Path $folder -Filter *.exe -Recurse -ErrorAction SilentlyContinue
            foreach ($exe in $exeFiles) {
                Write-Host "  ⏳ Installing EXE: $($exe.Name)"
                $args = "/S"
                $proc = Start-Process -FilePath $exe.FullName -ArgumentList $args -Wait -PassThru
                if ($proc.ExitCode -eq 0) {
                    Write-Host "  ✅ EXE installed successfully"
                } else {
                    Write-Host "  ⚠ EXE failed with exit code $($proc.ExitCode)" -ForegroundColor Yellow
                }
            }
        }
    }
    catch {
        Write-Host "  ❌ Error on ${target}: $_" -ForegroundColor Red
    }
}

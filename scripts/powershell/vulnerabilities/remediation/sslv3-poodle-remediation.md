<details>
<summary>SSLv3 Poodle Remediation</summary>

> **Tip:** Run from a server that has Active Directory installed 

```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Get all AD servers
$adServers = Get-ADComputer -Filter {OperatingSystem -like "*Server*"} -Property Name

# Initialize progress bar
$progress = 0
$totalServers = $adServers.Count

# Function to disable SSLv3 and SSLv2, and enable TLS 1.2 and 1.3 remotely
function ConfigureSSLAndTLS {
    param (
        [string]$computerName
    )
    Invoke-Command -ComputerName $computerName -ScriptBlock {
        # Define the registry paths for SSLv3, SSLv2, TLS 1.2, and TLS 1.3
        $ssl3RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
        $ssl2RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
        $tls12RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
        $tls13RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server"

        # Create the registry keys if they don't exist
        if (-not (Test-Path $ssl3RegistryPath)) {
            New-Item -Path $ssl3RegistryPath -ItemType Directory
        }
        if (-not (Test-Path $ssl2RegistryPath)) {
            New-Item -Path $ssl2RegistryPath -ItemType Directory
        }
        if (-not (Test-Path $tls12RegistryPath)) {
            New-Item -Path $tls12RegistryPath -ItemType Directory
        }
        if (-not (Test-Path $tls13RegistryPath)) {
            New-Item -Path $tls13RegistryPath -ItemType Directory
        }

        # Set the Enabled values to 0 to disable SSLv3 and SSLv2
        Set-ItemProperty -Path $ssl3RegistryPath -Name "Enabled" -Value 0
        Set-ItemProperty -Path $ssl2RegistryPath -Name "Enabled" -Value 0

        # Set the Enabled values to 1 to enable TLS 1.2 and TLS 1.3
        Set-ItemProperty -Path $tls12RegistryPath -Name "Enabled" -Value 1
        Set-ItemProperty -Path $tls13RegistryPath -Name "Enabled" -Value 1
    }
}

# Iterate through each server and apply the fix
foreach ($server in $adServers) {
    $computerName = $server.Name
    ConfigureSSLAndTLS -computerName $computerName
    
    # Update progress bar
    $progress++
    Write-Progress -Activity "Configuring SSL and TLS on AD Servers" -Status "Processing $computerName" -PercentComplete (($progress / $totalServers) * 100)
}

Write-Output "SSLv3 and SSLv2 have been disabled, and TLS 1.2 and TLS 1.3 have been enabled on all AD servers."
```


</details>


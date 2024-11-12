### Run on a single server
- [X] Tested
```powershell
# Disable Export Cipher Suites
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" -Name "Enabled" -Value 0 -PropertyType DWORD -Force

# Enforce Stronger Cipher Suites
$protocols = @("TLS 1.2", "TLS 1.3")
foreach ($protocol in $protocols) {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Client" -Force
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Client" -Name "Enabled" -Value 1 -PropertyType DWORD -Force
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server" -Force
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server" -Name "Enabled" -Value 1 -PropertyType DWORD -Force
}

# Increase Diffie-Hellman Key Size
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\Diffie-Hellman" -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\Diffie-Hellman" -Name "ServerMinKeyBitLength" -Value 2048 -PropertyType DWORD -Force

Write-Output "Registry keys updated to mitigate Logjam vulnerability."
```

### Run on any 2012 servers in your environment
- [X] Tested

```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Get a list of Windows Server 2012 R2 servers from Active Directory
$servers = Get-ADComputer -Filter {OperatingSystem -like "*Windows Server 2012 R2*"} | Select-Object -ExpandProperty Name

# Define the script block to apply the registry changes
$scriptBlock = {
    # Disable Export Cipher Suites
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" -Force
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" -Name "Enabled" -Value 0 -PropertyType DWORD -Force

    # Enforce Stronger Cipher Suites
    $protocols = @("TLS 1.2", "TLS 1.3")
    foreach ($protocol in $protocols) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Client" -Force
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Client" -Name "Enabled" -Value 1 -PropertyType DWORD -Force
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server" -Force
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server" -Name "Enabled" -Value 1 -PropertyType DWORD -Force
    }

    # Increase Diffie-Hellman Key Size
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\Diffie-Hellman" -Force
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\Diffie-Hellman" -Name "ServerMinKeyBitLength" -Value 2048 -PropertyType DWORD -Force

    Write-Output "Registry keys updated to mitigate Logjam vulnerability."
}

# Apply the script block to each server
foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock
    }
```

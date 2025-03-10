<h1> Active Directory Vulnerability Remediation </h1>

<details>
<summary>Logjam Remediation</summary>

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

</details>

<details>
<summary>LLMNR Poisoning Remediation</summary>

> **Tip:** You can either manually link the new GPO, or modify the 3rd line "New-GPLink" to link it to the correct OU

```powershell
# Create a new GPO
New-GPO -Name "Disable LLMNR"

# Configure the GPO to disable LLMNR
Set-GPRegistryValue -Name "Disable LLMNR" -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -ValueName "EnableMulticast" -Type DWord -Value 0

# Link GPO to a specific Organizational Unit (OU)
New-GPLink -Name "Disable LLMNR" -Target <e.g.>"OU=<<<Computers>>>,DC=<<<YourDomain>>>,DC=co,DC=uk"
```

</details>
</details>

<details>
<summary>SSLv3 Poodle Remediation</summary>

> **Tip:** Run from a server that has Active Directory installed 

```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Get all computer objects in the domain
$computers = Get-ADComputer -Filter *

# Get credentials once
$credential = Get-Credential

# Loop through each computer and disable SSLv3
foreach ($computer in $computers) {
    $computerName = $computer.Name

    # Invoke a command on the remote computer to disable SSLv3
    Invoke-Command -ComputerName $computerName -ScriptBlock {
        # Disable SSLv3 in the registry
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0" -Force
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -Force
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" -Name "Enabled" -Value 0 -Type DWord
    } -Credential $credential
}

Write-Host "SSLv3 has been disabled on all servers."
```

</details>


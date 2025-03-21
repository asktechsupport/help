Testing:


Apply to all across the domaian

```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Get all server devices
$servers = Get-ADComputer -Filter {OperatingSystem -like "*Server*"} | Select-Object -ExpandProperty Name

# Define the script block to disable RC4 cipher suites
$scriptBlock = {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"

    # Disable RC4 128/128
    New-Item -Path "$regPath\RC4 128/128" -Force
    Set-ItemProperty -Path "$regPath\RC4 128/128" -Name "Enabled" -Value 0

    # Disable RC4 40/128
    New-Item -Path "$regPath\RC4 40/128" -Force
    Set-ItemProperty -Path "$regPath\RC4 40/128" -Name "Enabled" -Value 0

    # Disable RC4 56/128
    New-Item -Path "$regPath\RC4 56/128" -Force
    Set-ItemProperty -Path "$regPath\RC4 56/128" -Name "Enabled" -Value 0

    # Restart the server to apply changes
    Restart-Computer -Force
}

# Loop through each server and apply the fix
foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock
}

Write-Host "RC4 cipher suites have been disabled on all servers and they have been restarted."
```

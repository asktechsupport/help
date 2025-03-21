


```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Get all server devices
$servers = Get-ADComputer -Filter {OperatingSystem -like "*Server*"} | Select-Object -ExpandProperty Name

# Define the script block to disable SMBv1
$scriptBlock = {
    # Disable SMBv1
    Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

    # Remove SMBv1 feature
    Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

    # Restart the server to apply changes
    Restart-Computer -Force
}

# Loop through each server and apply the fix
foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock
}

Write-Host "SMBv1 has been disabled on all servers and they have been restarted."
```

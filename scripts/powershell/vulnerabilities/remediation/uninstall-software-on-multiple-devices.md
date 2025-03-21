```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Get all AD servers
$adServers = Get-ADComputer -Filter {OperatingSystem -like "*Server*"} -Property Name

# Initialize progress bar
$progress = 0
$totalServers = $adServers.Count

# Function to check if Firefox is installed
function IsFirefoxInstalled {
    param (
        [string]$computerName
    )
    $firefoxPath = "\\$computerName\C$\Program Files\Mozilla Firefox\firefox.exe"
    Test-Path $firefoxPath
}

# Function to remove Firefox
function RemoveFirefox {
    param (
        [string]$computerName
    )
    Invoke-Command -ComputerName $computerName -ScriptBlock {
        $firefoxUninstallPath = "C:\Program Files\Mozilla Firefox\uninstall\helper.exe"
        if (Test-Path $firefoxUninstallPath) {
            Start-Process -FilePath $firefoxUninstallPath -ArgumentList "/S" -Wait
        }
    }
}

# Iterate through each server and remove Firefox if installed
foreach ($server in $adServers) {
    $computerName = $server.Name
    if (IsFirefoxInstalled -computerName $computerName) {
        RemoveFirefox -computerName $computerName
    }
    
    # Update progress bar
    $progress++
    Write-Progress -Activity "Removing Firefox from AD Servers" -Status "Processing $computerName" -PercentComplete (($progress / $totalServers) * 100)
}

Write-Output "Firefox removal process completed."
```

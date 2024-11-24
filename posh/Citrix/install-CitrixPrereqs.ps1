### FUNCTIONS

    function Add-SendKeys {
        # Ensure the required assemblies are loaded for SendKeys support
        if (-not ([System.Windows.Forms.SendKeys] -as [type])) {
            try {
                Add-Type -AssemblyName Microsoft.VisualBasic
                Add-Type -AssemblyName System.Windows.Forms
                Write-Output "SendKeys support added successfully."
            } catch {
                Write-Error "Failed to add SendKeys support: $_"
                exit
            }
        } else {
            Write-Output "SendKeys support is already loaded."
        }
    }

# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator!" -ForegroundColor Red
    exit
}

Write-Host "Starting installation for Citrix Prerequisites..." -ForegroundColor Cyan
Install-WindowsFeature -Name RSAT-ADCS-Mgmt -IncludeManagementTools


# Install Edge WebView2 Runtime
Write-Host "Searching for Microsoft Edge WebView2 Runtime Installer..." -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path "$($_.Root)" -Recurse -Filter "*.exe" -ErrorAction SilentlyContinue
} | Where-Object { $_.Name -like "*MicrosoftEdgeWebView2RuntimeInstaller*" } | Select-Object -First 1 -ExpandProperty FullName | ForEach-Object {
    Write-Host "Installing Microsoft Edge WebView2 Runtime from: $_" -ForegroundColor Green
    Start-Process -FilePath $_ -ArgumentList "/silent /install" -Verb RunAs -Wait
    Write-Host "Installed WebView2 Runtime successfully." -ForegroundColor Green
}

# Install .NET Prerequisites (Windows Desktop Runtime or NDP)
Write-Host "Searching for .NET Prerequisites (Windows Desktop Runtime or NDP)..." -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path "$($_.Root)" -Recurse -Filter "*.exe" -ErrorAction SilentlyContinue
} | Where-Object { $_.Name -like "*windowsdesktop-runtime*" -or $_.Name -like "ndp*" } | Select-Object -First 1 -ExpandProperty FullName | ForEach-Object {
    Write-Host "Installing .NET Prerequisite from: $_" -ForegroundColor Green
    Start-Process -FilePath $_ -ArgumentList "/quiet /norestart" -Verb RunAs -Wait
    Write-Host "Installed .NET Prerequisite successfully." -ForegroundColor Cyan
}

# Install Citrix Workspace App
Write-Host "Searching for Citrix Workspace App Installer..." -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path "$($_.Root)" -Recurse -Filter "*.exe" -ErrorAction SilentlyContinue
} | Where-Object { $_.Name -like "*CitrixWorkspaceApp*" } | Select-Object -First 1 -ExpandProperty FullName | ForEach-Object {
    Write-Host "Installing Citrix Workspace App from: $_" -ForegroundColor Green
    Start-Process -FilePath $_ -ArgumentList "/silent /noreboot" -Verb RunAs -Wait
    Write-Host "Installed Citrix Workspace App successfully." -ForegroundColor Yellow
}

# Setup Certificates



# Load SendKeys
Add-SendKeys

# Open the Certificate Templates MMC
Write-Output "Opening Certificate Templates MMC..."
Start-Process "certtmpl.msc"
Start-Sleep -Seconds 5 # Wait for MMC to fully load

# Navigate and duplicate the Web Server template
Write-Output "Navigating and duplicating the Web Server template..."
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")        # Navigate to the template name field
[System.Windows.Forms.SendKeys]::SendWait("{W}")          # Navigate to the first template (e.g., Web Server)
Start-Sleep -Seconds 1
[System.Windows.Forms.SendKeys]::SendWait("+{F10}")       # Open context menu (Shift + F10)
Start-Sleep -Seconds 1
[System.Windows.Forms.SendKeys]::SendWait("{DOWN}")       # Hover "Duplicate Template"
Start-Sleep -Seconds 3
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")      # Select "Duplicate Template"
Start-Sleep -Seconds 3                                    # Wait for the Duplicate Template dialog

# Rename the new template
Write-Output "Renaming the new template to 'StoreFrontTemplate'..."
# Press TAB 5 times to navigate to the General tab
for ($i = 1; $i -le 5; $i++) {
    [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
    Start-Sleep -Milliseconds 500
}

    [System.Windows.Forms.SendKeys]::SendWait("{RIGHT}") # Press RIGHT ARROW key once
    Start-Sleep -Milliseconds 500

# Rename the template in the general tab...
    [System.Windows.Forms.SendKeys]::SendWait("{TAB}") # Press TAB key once
    Start-Sleep -Milliseconds 500
    [System.Windows.Forms.SendKeys]::SendWait("^a")           # Select all text (Ctrl + A)
    Start-Sleep -Milliseconds 500
    [System.Windows.Forms.SendKeys]::SendWait("StoreFrontTemplate") # Type the new template name
    Start-Sleep -Milliseconds 500

    [System.Windows.Forms.SendKeys]::SendWait("{TAB}") # Press TAB key once
    Start-Sleep -Milliseconds 500
    [System.Windows.Forms.SendKeys]::SendWait("^a")           # Select all text (Ctrl + A)
    Start-Sleep -Milliseconds 500
    [System.Windows.Forms.SendKeys]::SendWait("StoreFrontTemplate") # Type the new template name
    Start-Sleep -Milliseconds 500
# Skip the validity period, leaving it at 2 years. Press TAB 4 times
    for ($i = 1; $i -le 4; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
        Start-Sleep -Milliseconds 500
    }
# Renewal period = maximum allowed, 547 days
[System.Windows.Forms.SendKeys]::SendWait("{UP}") # Set "days" as the metric
    Start-Sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait("+{TAB}")       # Open context menu (Shift + TAB)
    Start-Sleep -Seconds 1
[System.Windows.Forms.SendKeys]::SendWait("547") # Set this to 547 days
    Start-Sleep -Milliseconds 500

    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")      # Save the template
    Start-Sleep -Seconds 3

Write-Output "Template duplication completed successfully. Verify in the Certification Authority MMC."


Write-Host "Installation process completed successfully." -ForegroundColor Cyan

Start-Process "ms-settings:windowsupdate"
Start-Sleep -Seconds 5  # Wait for the window to open

# Add the .NET assembly for SendKeys
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

# Bring the Settings window to the foreground
$windowTitle = "Windows Update"  # Replace with exact title if localized
(Get-Process | Where-Object { $_.MainWindowTitle -like "*$windowTitle*" }).MainWindowHandle |
    ForEach-Object {
        [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")  # Alt + Tab (optional, to focus on window)
        Start-Sleep -Seconds 1
    }

# Simulate pressing Tab to navigate the menu
[System.Windows.Forms.SendKeys]::SendWait("{TAB}") 
Start-Sleep -Seconds 1

# Bring the Settings window to the foreground
$windowTitle = "Windows Update"  # Replace with exact title if localized
(Get-Process | Where-Object { $_.MainWindowTitle -like "*$windowTitle*" }).MainWindowHandle |
    ForEach-Object {
        [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")  # Alt + Tab (optional, to focus on window)
        Start-Sleep -Seconds 1
    }


# Simulate pressing Tab to navigate the menu
[System.Windows.Forms.SendKeys]::SendWait("{TAB}") 
Start-Sleep -Seconds 1

# Bring the Settings window to the foreground
$windowTitle = "Windows Update"  # Replace with exact title if localized
(Get-Process | Where-Object { $_.MainWindowTitle -like "*$windowTitle*" }).MainWindowHandle |
    ForEach-Object {
        [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")  # Alt + Tab (optional, to focus on window)
        Start-Sleep -Seconds 1
    }

# Simulate pressing Enter to select "Check for updates"
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}") 
Start-Sleep -Seconds 10  # Wait for updates to be checked

# Bring the Settings window to the foreground
$windowTitle = "Windows Update"  # Replace with exact title if localized
(Get-Process | Where-Object { $_.MainWindowTitle -like "*$windowTitle*" }).MainWindowHandle |
    ForEach-Object {
        [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")  # Alt + Tab (optional, to focus on window)
        Start-Sleep -Seconds 1
    }


# Simulate pressing Space or Enter to install updates
[System.Windows.Forms.SendKeys]::SendWait(" ")
Start-Sleep -Seconds 10



### FUNCTIONS

function Add-SendKeys {
    # Check if the required types are already loaded
    if (-not ([System.Windows.Forms.SendKeys] -as [type])) {
        try {
            Add-Type -AssemblyName Microsoft.VisualBasic
            Add-Type -AssemblyName System.Windows.Forms
            Write-Output "SendKeys support added successfully."
        } catch {
            Write-Error "Failed to add SendKeys support: $_"
        }
    } else {
        Write-Output "SendKeys support is already loaded."
    }
}


function FocusWindow {
    param([string]$title)
    (Get-Process | Where-Object { $_.MainWindowTitle -like "*$title*" }).MainWindowHandle |
        ForEach-Object {
            [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")
            Start-Sleep -Seconds 1
        }
}

# Example Usage:
# FocusWindow "Windows Update"

function Press-Tab {
    param(
        [int]$Count = 1,  # Number of times to press Tab
        [int]$DelaySeconds = 1  # Delay in seconds between each Tab press
    )

    for ($i = 1; $i -le $Count; $i++) {
        # Simulate pressing the Tab key
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
        Start-Sleep -Seconds $DelaySeconds
    }
}


    Start-Process "ms-settings:windowsupdate"
        

    Add-SendKeys


    # Press Tab 4 times to navigate to a specific menu
    Press-Tab -Count 4 -DelaySeconds 1

    # Simulate pressing Enter to select the focused item
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep -Seconds 2



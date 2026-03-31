## Description

## Examples
Complete Windows OS Patching
```powershell
### FUNCTIONS

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
        

    # Add the .NET assembly for SendKeys
    Add-Type -AssemblyName Microsoft.VisualBasic
    Add-Type -AssemblyName System.Windows.Forms


    # Press Tab 3 times to navigate to a specific menu
    Press-Tab -Count 4 -DelaySeconds 1

    # Simulate pressing Enter to select the focused item
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep -Seconds 2

```
![image](https://github.com/user-attachments/assets/19c1cb22-a792-4be0-9841-7cd8f192fb80)

Write 'hi' in Notepad
```powershell
# Function to add SendKeys support
function Add-SendKeysSupport {
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

# Main Script
# Step 1: Add SendKeys support
Add-SendKeysSupport

# Step 2: Open Notepad
Start-Process "notepad"
Start-Sleep -Seconds 2  # Wait for Notepad to open

# Step 3: Open the On-Screen Keyboard
Start-Process "osk"
Start-Sleep -Seconds 2  # Wait for the On-Screen Keyboard to open

# Step 4: Type 'hi' in Notepad using SendKeys
[System.Windows.Forms.SendKeys]::SendWait("hi")

```
![image](https://github.com/user-attachments/assets/4f4295b8-b172-4630-a35e-fbecd226a914)

## Notes
> [!NOTE]
> You usually need to bring the window back to the foreground after every click. Building a function for this code
 is ideal
```powershell
# Bring the Settings window to the foreground
$windowTitle = "Windows Update"  # Replace with exact title if localized
(Get-Process | Where-Object { $_.MainWindowTitle -like "*$windowTitle*" }).MainWindowHandle |
    ForEach-Object {
        [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")  # Alt + Tab (optional, to focus on window)
        Start-Sleep -Seconds 1
    }
```

>>>
```powershell
### FUNCTIONS

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
```


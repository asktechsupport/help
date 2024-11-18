#### focusWindow
```powershell
function focusWindow {
    param([string]$title)
    (Get-Process | Where-Object { $_.MainWindowTitle -like "*$title*" }).MainWindowHandle |
        ForEach-Object {
            [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")
            Start-Sleep -Seconds 1
        }
}

# Example Usage:
# focusWindow "Windows Update"
```

#### typeMsg
```powershell
function typeMsg {
    param(
        [string]$Message,
        [int]$DelaySeconds = 1
    )

    # Ensure the required assemblies for SendKeys are loaded
    if (-not ([System.Windows.Forms.SendKeys] -as [type])) {
        try {
            Add-Type -AssemblyName Microsoft.VisualBasic
            Add-Type -AssemblyName System.Windows.Forms
        } catch {
            Write-Error "Failed to add SendKeys support: $_"
            return
        }
    }

    # Send the message or key sequence
    try {
        [System.Windows.Forms.SendKeys]::SendWait($Message)
        Start-Sleep -Seconds $DelaySeconds
        Write-Output "Message or keys '$Message' typed successfully."
    } catch {
        Write-Error "Failed to send message: $_"
    }
}
# Example Usage:
# Open Notepad
Start-Process "notepad"
Start-Sleep -Seconds 1  # Wait for Notepad to open

# Type "Hello" and press Enter
typeMsg -Message "Hello"
typeMsg -Message "{ENTER}"
```
#### pressKeys
```powershell
function pressKeys {
    param(
        [string]$key,
        [int]$DelaySeconds = 1
    )

    # Ensure the required assemblies for SendKeys are loaded
    if (-not ([System.Windows.Forms.SendKeys] -as [type])) {
        try {
            Add-Type -AssemblyName Microsoft.VisualBasic
            Add-Type -AssemblyName System.Windows.Forms
        } catch {
            Write-Error "Failed to add SendKeys support: $_"
            return
        }
    }

    # Send the message or key sequence
    try {
        [System.Windows.Forms.SendKeys]::SendWait($key)
        Start-Sleep -Seconds $DelaySeconds
        Write-Output "Message or keys '$Message' typed successfully."
    } catch {
        Write-Error "Failed to send message: $_"
    }
}
# Example Usage:
# Open Notepad
Start-Process "notepad"
Start-Sleep -Seconds 1  # Wait for Notepad to open
pressKeys "{ENTER}"

#### Navigate with tab

```powershell
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
```

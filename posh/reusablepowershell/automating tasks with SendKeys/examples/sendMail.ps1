# Function to send keystrokes
function typeMsg {
    param(
        [string]$Message,  # The message or key sequence to send
        [int]$DelaySeconds = 1  # Optional delay after sending the message
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
        Write-Output "Message '$Message' sent successfully."
    } catch {
        Write-Error "Failed to send message: $_"
    }
}
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
        Write-Output "Message or keys '$key' typed successfully."
    } catch {
        Write-Error "Failed to send message: $_"
    }
}
function focusWindow {
    param([string]$title)
    (Get-Process | Where-Object { $_.MainWindowTitle -like "*$title*" }).MainWindowHandle |
        ForEach-Object {
            [System.Windows.Forms.SendKeys]::SendWait("%{TAB}")
            Start-Sleep -Seconds 1
        }
}
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

# Example Usage:

# Main Script

# Step 1: Open the Default Email Client
Start-Process "mailto:" # Opens the default email client
  Start-Sleep -Seconds 1  # Wait for the email client to open
    typeMsg -Message "email@email.com"
    typeMsg -Message "{ENTER}"
# Press Tab 2 times to enter the email body
    Press-Tab -Count 2 -DelaySeconds 1

# Step 2: Type the Email Body
typeMsg -Message "Hello"  # Type "Hello" into the email body

typeMsg -Message "{ENTER}"  
typeMsg -Message "{ENTER}"

typeMsg -Message "Many thanks"  # Type "Many thanks" into the email body

typeMsg -Message "^{ENTER}"  # Send CTRL+ENTER
typeMsg -Message "{ENTER}"



    

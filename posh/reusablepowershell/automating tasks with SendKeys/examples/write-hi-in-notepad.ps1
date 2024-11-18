# Function to add SendKeys support
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

# Main Script
# Step 1: Add SendKeys support
Add-SendKeys

# Step 2: Open Notepad
Start-Process "notepad"
Start-Sleep -Seconds 1  # Wait for Notepad to open

# Step 4: Type 'hi' in Notepad using SendKeys
[System.Windows.Forms.SendKeys]::SendWait("hi")

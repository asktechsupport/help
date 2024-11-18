# Add TypeMsg function
function TypeMsg {
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

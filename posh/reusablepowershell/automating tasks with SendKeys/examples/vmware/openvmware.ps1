function Add-SendKeys {
    if (-not ([System.Windows.Forms.SendKeys] -as [type])) { # Check if SendKeys is already loaded
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

function focusWindow {
    param (
        [string]$PartialTitle # A partial string to search for in window titles
    )
    try {
        Add-Type -AssemblyName Microsoft.VisualBasic # Load VisualBasic namespace
        $processes = Get-Process | Where-Object {
            $_.MainWindowTitle -like "*$PartialTitle*" -and $_.MainWindowTitle
        }
        if ($processes.Count -gt 0) {
            [Microsoft.VisualBasic.Interaction]::AppActivate($processes[0].MainWindowTitle) # Focus the first matching window
            Write-Output "Window containing '$PartialTitle' in its title is now focused."
            Start-Sleep -Seconds 1 # Allow time for the window to gain focus
            return $true
        } else {
            Write-Warning "No window found containing '$PartialTitle' in its title."
            return $false
        }
    } catch {
        Write-Error "Failed to activate the window: $_"
        return $false
    }
}

Add-SendKeys # Ensure SendKeys support is available

$start = Get-Date # Record the start time
Start-Process -FilePath "vmware.exe" # Open VMware Workstation

do {
    Start-Sleep -Milliseconds 500 # Check every 500ms
    $vmwareProcess = Get-Process -Name "vmware" -ErrorAction SilentlyContinue
} while (-not $vmwareProcess) # Wait until the VMware process is detected

$end = Get-Date # Record the end time
$duration = ($end - $start).TotalSeconds # Calculate the elapsed time
Write-Host "VMware Workstation opened in $duration seconds."

if (-not (focusWindow -PartialTitle "VMware Workstation")) { # Focus the VMware Workstation window
    Write-Error "Failed to focus VMware Workstation. Stopping script execution."
    return # Stop the script gracefully while staying in the ISE
}



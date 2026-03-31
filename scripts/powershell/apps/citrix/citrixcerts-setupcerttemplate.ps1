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

# Load SendKeys
Add-SendKeys

# Open the Certificate Templates MMC
Write-Output "Opening Certificate Templates MMC..."
Start-Process "certtmpl.msc"
Start-Sleep -Seconds 1 # Wait for MMC to fully load

# Navigate and duplicate the Web Server template
Write-Output "Navigating and duplicating the Web Server template..."
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")        # Navigate to the template name field
[System.Windows.Forms.SendKeys]::SendWait("{W}")          # Navigate to the first template (e.g., Web Server)
Start-Sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait("+{F10}")       # Open context menu (Shift + F10)
Start-Sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait("{DOWN}")       # Hover "Duplicate Template"
Start-Sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")      # Select "Duplicate Template"
Start-Sleep -Milliseconds 500                             # Wait for the Duplicate Template dialog

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
# Now tab to the Subject Name tab. Press TAB a number of times
    for ($i = 1; $i -le 7; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
        Start-Sleep -Milliseconds 500
    }
    # Now RIGHT ARROW 4x
    for ($i = 1; $i -le 4; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{RIGHT}")
        Start-Sleep -Milliseconds 500
    }
        # Now TAB 1 x
        for ($i = 1; $i -le 1; $i++) {
            [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
            Start-Sleep -Milliseconds 500
        }
            # Now down 1 x
            for ($i = 1; $i -le 1; $i++) {
                [System.Windows.Forms.SendKeys]::SendWait("{DOWN}")
                Start-Sleep -Milliseconds 500
            }
                # Now TAB 1 x
                for ($i = 1; $i -le 1; $i++) {
                    [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
                    Start-Sleep -Milliseconds 500
                }
                    # Now UP 2 x. Sets format as DNS Name
                    for ($i = 1; $i -le 2; $i++) {
                        [System.Windows.Forms.SendKeys]::SendWait("{UP}")
                        Start-Sleep -Milliseconds 500
                    }
                        # Now TAB 3 x and space
                        for ($i = 1; $i -le 3; $i++) {
                            [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
                            Start-Sleep -Milliseconds 500
                        }
                            #Now space
                            [System.Windows.Forms.SendKeys]::SendWait(" ")
                            Start-Sleep -Milliseconds 500
                # Now TAB 6 x
                for ($i = 1; $i -le 6; $i++) {
                    [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
                    Start-Sleep -Milliseconds 500
                }
                    # Enter to Apply
                    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")      # Select "Duplicate Template"
                    Start-Sleep -Milliseconds 500                             
                        # Shift-tab back to ok
                            for ($i = 1; $i -le 4; $i++) {
                            [System.Windows.Forms.SendKeys]::SendWait("+{TAB}")
                            Start-Sleep -Milliseconds 500
                        }
                    # Enter to Finish creating the template
                    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")      # Select "Duplicate Template"
                        Start-Sleep -Milliseconds 500 

#Write-Output "Template duplication completed successfully. Verify in the Certification Authority MMC."

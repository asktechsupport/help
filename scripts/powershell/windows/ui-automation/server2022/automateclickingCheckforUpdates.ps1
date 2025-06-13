Add-Type -AssemblyName UIAutomationClient

function Get-ElementByName {
    param (
        [System.Windows.Automation.AutomationElement]$root,
        [string]$name
    )

    if (-not $name) {
        Write-Error "Element name is null or empty."
        return $null
    }

    $condition = New-Object System.Windows.Automation.PropertyCondition `
        ([System.Windows.Automation.AutomationElement]::NameProperty, $name)

    return $root.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $condition)
}

# Launch Windows Update Settings
Start-Process "ms-settings:windowsupdate"
Start-Sleep -Seconds 5

# Get the desktop root element
$desktop = [System.Windows.Automation.AutomationElement]::RootElement

# List all top-level windows to help identify the correct title
$windows = $desktop.FindAll([System.Windows.Automation.TreeScope]::Children, [System.Windows.Automation.Condition]::TrueCondition)
Write-Output "Top-level windows found:"
foreach ($win in $windows) {
    $name = $win.Current.Name
    if ($name) {
        Write-Output " - $name"
    }
}

# Try to find the Settings window (adjust this name based on the output above)
$settingsWindow = Get-ElementByName -root $desktop -name "Settings"
if (-not $settingsWindow) {
    Write-Error "Settings window not found."
    exit
}

# Try to find the "Check for updates" button
$checkButton = Get-ElementByName -root $settingsWindow -name "Check for updates"
if (-not $checkButton) {
    Write-Error "'Check for updates' button not found."
    exit
}

# Invoke the button
$invokePattern = $checkButton.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
$invokePattern.Invoke()

Write-Output "Check for updates button clicked."

Add-Type -AssemblyName UIAutomationClient

function Get-ElementByName {
    param (
        [System.Windows.Automation.AutomationElement]$root,
        [string]$name
    )

    $condition = New-Object System.Windows.Automation.PropertyCondition `
        ([System.Windows.Automation.AutomationElement]::NameProperty, $name)

    return $root.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $condition)
}

function Get-ButtonsByPartialName {
    param (
        [System.Windows.Automation.AutomationElement]$root,
        [string]$partialName
    )

    $buttonCondition = New-Object System.Windows.Automation.PropertyCondition `
        ([System.Windows.Automation.AutomationElement]::ControlTypeProperty, `
         [System.Windows.Automation.ControlType]::Button)

    $buttons = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants, $buttonCondition)

    $matchingButtons = @()
    foreach ($button in $buttons) {
        $name = $button.Current.Name
        if ($name -and $name -like "*$partialName*") {
            $matchingButtons += $button
        }
    }

    return $matchingButtons
}

# Step 1: Launch Windows Update Settings
Start-Process "ms-settings:windowsupdate"
Start-Sleep -Seconds 5

# Step 2: Get the desktop root element
$desktop = [System.Windows.Automation.AutomationElement]::RootElement

# Step 3: Find the Settings window
$settingsWindow = $desktop.FindFirst(
    [System.Windows.Automation.TreeScope]::Children,
    (New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::NameProperty, "Settings"))
)

if (-not $settingsWindow) {
    Write-Error "Settings window not found."
    exit
}

# Step 4: Click the "Check for updates" button
$checkButton = Get-ElementByName -root $settingsWindow -name "Check for updates"
if ($checkButton) {
    $invokePattern = $checkButton.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
    $invokePattern.Invoke()
    Write-Output "Clicked 'Check for updates' button."
    Start-Sleep -Seconds 10  # Wait for updates to be detected
} else {
    Write-Output "'Check for updates' button not found."
}

# Step 5: Click any "Install" buttons if available
$installButtons = Get-ButtonsByPartialName -root $settingsWindow -partialName "Install"
if ($installButtons.Count -eq 0) {
    Write-Output "No 'Install' buttons found."
} else {
    foreach ($btn in $installButtons) {
        Write-Output "Clicking button: $($btn.Current.Name)"
        $invokePattern = $btn.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
        $invokePattern.Invoke()
        Start-Sleep -Seconds 2
    }
}

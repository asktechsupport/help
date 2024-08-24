### Setting up a PowerShell profiles
#### w/ Write-Log function
```powershell
# Function to output a message with the current line number
function Write-Log {
    param (
        [string]$Message,
        [ConsoleColor]$Color = "Cyan"
    )
    $lineNumber = $MyInvocation.ScriptLineNumber
    Write-Host "[$lineNumber] $Message" -ForegroundColor $Color
}

# Function to get the total number of lines in the script
function Get-TotalLineCount {
    $scriptPath = $MyInvocation.PSCommandPath
    if ($scriptPath) {
        (Get-Content $scriptPath).Length
    } else {
        $MyInvocation.ScriptLineNumber
    }
}

#--------------POWERSHELL (POSH) PROFILE SETUP | VARIABLES
##  src: https://github.com/asktechsupport/help/tree/main/posh/reusablepowershell

Write-Log "Setting up profile variables..."
$iseProfilePath = $PROFILE.CurrentUserCurrentHost  # ISE profile for the current user
$psProfilePath = $PROFILE.CurrentUserAllHosts  # Regular PowerShell profile for the current user
$psStartNotification = "PowerShell is starting. Please be sure you meant to open or run PowerShell on this device."

#--------------Prepare a safe execution policy

Write-Log "Setting execution policy for the current process..."
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process # Set the execution policy

#--------------FEEDBACK TO THE USER

Write-Log "Providing feedback to the user..."
Write-Log "Your profile loaded successfully on $(Get-Date)" -Color Green
Write-Log "Hey, you are running as user:$env:USERNAME"
Write-Log "Vars are stored @ *$iseProfilePath*"
Write-Log "🔔PowerShell is starting. Make sure you intended to use PowerShell or PowerShell ISE." -Color Yellow

Write-Log "Opening ISE profile for editing..."
start $iseProfilePath

#--------------SYNC THE ISE AND POWERSHELL PROFILES

Write-Log "Checking if PowerShell profile exists..."
if (-not (Test-Path $psProfilePath)) {
    Write-Log "PowerShell profile does not exist. Creating new profile..."
    New-Item -Path $psProfilePath -ItemType File -Force
} else {
    Write-Log "PowerShell profile already exists."
}

Write-Log "Checking if ISE profile exists..."
if (Test-Path $iseProfilePath) {
    Write-Log "ISE profile exists. Copying content to PowerShell profile..."
    Copy-Item -Path $iseProfilePath -Destination $psProfilePath -Force
    Write-Log "PowerShell profile at $psProfilePath has been overwritten with the content from $iseProfilePath." -Color Green
} else {
    Write-Log "ISE profile at $iseProfilePath does not exist. No action taken." -Color Red
}

#--------------Log the total number of lines in the script
$totalLines = Get-TotalLineCount
Write-Log "Total number of lines in this script: $totalLines" -Color Cyan

#--------------src: https://github.com/asktechsupport/help/tree/main/posh/reusablepowershell
```

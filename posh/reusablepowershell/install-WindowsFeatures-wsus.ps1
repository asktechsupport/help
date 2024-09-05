# Ensure WSUS is installed with the necessary components
Install-WindowsFeature -Name UpdateServices, UpdateServices-UI, UpdateServices-Services -IncludeManagementTools
    takeown /f "C:\Program Files\Update Services\Database\VersionCheck.sql" /A
    icacls "C:\Program Files\Update Services\Database\VersionCheck.sql" /grant administrators:F


# Specify the content directory for WSUS
$wsusContentDir = "C:\WSUS"
if (-not (Test-Path $wsusContentDir)) {
    New-Item -Path $wsusContentDir -ItemType Directory
    Write-Host "Created WSUS content directory: $wsusContentDir"
}

# Manually set up WSUS post-installation (replace this with your DB or WID settings if necessary)
& "C:\Program Files\Update Services\Tools\WsusUtil.exe" PostInstall CONTENT_DIR="$wsusContentDir"


# Wait for WSUS service to start
Start-Service WSUSService

# Import WSUS PowerShell module
Import-Module UpdateServices

# Store WSUS server instance in variable
$WSUS = Get-WsusServer -Name "localhost" -PortNumber 8530

# Set WSUS to sync from Microsoft Update
Set-WsusServerSynchronization -SyncFromMU

# Disable all classifications initially
Get-WsusClassification | Set-WsusClassification -Disable

# Enable only specific classifications: Critical Updates, Security Updates, Updates
$Classifications = @(
    "Critical Updates",
    "Security Updates"
)

Get-WsusClassification | Where-Object {$_.Classification.Title -In $Classifications} | Set-WsusClassification -Enable

# Set products to sync: Example list includes Active Directory, SQL Server, Office, and Windows Server
$Products = @(
    "Active Directory Rights Management Services Client 2.0",
    "Active Directory",
    "Microsoft Edge",
    "Windows Server 2022"
)

$WSUS | Get-WsusProduct | Where-Object { $_.Product.Title -In $Products } | Set-WsusProduct -Enable

# Perform initial synchronization
$WSUS.GetSubscription().StartSynchronization()
Write-Host "Synchronization started. This may take a while depending on the size of updates."

# Wait for the synchronization to complete (polling)
do {
    $syncStatus = $WSUS.GetSubscription().GetSynchronizationStatus()
    Write-Host "Current synchronization state: $($syncStatus.State)"
    Start-Sleep -Seconds 30  # Wait for 30 seconds before checking again
} while ($syncStatus.State -ne "Idle")

Write-Host "Synchronization completed."

# Decline 32-bit and ARM64 Windows 10 updates
($WSUS.SearchUpdates("x86-based Systems")).Decline()
($WSUS.SearchUpdates("ARM64-based Systems")).Decline()

# Decline old versions of Windows 10 updates
$OldWin10Versions = @(
    'Windows 10 Version 1507',
    'Windows 10 Version 1511',
    'Windows 10 Version 1607',
    'Windows 10 Version 1703',
    'Windows 10 Version 1709'
)

foreach ($version in $OldWin10Versions) {
    Write-Host "Declining updates for $version"
    ($WSUS.SearchUpdates($version)).Decline()
}

# Put unapproved updates in a variable
$Unapproved = Get-WsusUpdate -Approval Unapproved
Write-Host "$($Unapproved.Count) unapproved updates found."

# Show unapproved updates
$Unapproved

# Approve the remaining unapproved updates for "All Computers" group
$Unapproved | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
Write-Host "Approved unapproved updates for 'All Computers'."

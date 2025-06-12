# Install WSUS Management Console and RSAT tools
Add-WindowsFeature -Name UpdateServices-UI, UpdateServices-RSAT

# Define the WSUS server to connect to
$WsusServer = "WSUS-SERVER-NAME"  # Replace with your actual server name or FQDN
$WsusPort = 8531  # Default WSUS port (HTTP). Use 8531 for HTTPS.

# Load the WSUS assembly
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")

# Connect to the WSUS server
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($WsusServer, $False, $WsusPort)

# Confirm connection
Write-Host "Connected to WSUS server: $($Wsus.Name)"


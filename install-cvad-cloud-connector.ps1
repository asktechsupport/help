# Specify your Citrix Cloud credentials
$cloudUsername = "YourCloudUsername"
$cloudPassword = "YourCloudPassword"

# Specify the download URL for the Citrix Cloud Connector setup executable
$cloudConnectorUrl = "https://download.cloud.com/Citrix/CloudConnector/CitrixCloudConnector.exe"

# Specify the installation parameters
$installParams = @{
    ExePath     = "C:\Temp\CitrixCloudConnector.exe"  # Adjust the path where you want to download the executable
    Destination = "C:\Citrix\CloudConnector"           # Adjust the installation directory
    ServiceType = "Interactive"                        # Use "Interactive" for a user-interactive installation
    CloudAdmin  = "$cloudUsername"
    CloudPassword = $cloudPassword | ConvertTo-SecureString -AsPlainText -Force
}

# Download Citrix Cloud Connector setup executable
Invoke-WebRequest -Uri $cloudConnectorUrl -OutFile $installParams.ExePath

# Run the Citrix Cloud Connector setup
Start-Process -FilePath $installParams.ExePath -ArgumentList "/quiet" -Wait

# Install the Citrix Cloud Connector
Install-CitrixCloudConnector @installParams

Write-Host "Citrix Cloud Connector installed successfully."

$store = "StoreFront" # Store Name
$baseUrl = "https://yourstorefront/" # StoreFront URL
$localhostUrl = "https://127.0.0.1/" # Local StoreFront URL for testing

Install-WindowsFeature -Name Web-Server -IncludeManagementTools
Add-WindowsFeature NET-Framework-Core
Install-WindowsFeature -Name Web-WebServer -IncludeManagementTools
Install-WindowsFeature -Name Web-Mgmt-Console
Start-Process -Wait -FilePath "C:\Citrix\CitrixStoreFront-64.exe" -ArgumentList "/quiet"
Import-Module "C:\Program Files\Citrix\Receiver StoreFront\Scripts\ImportModules.ps1"

# Create a new Store
New-STFStore -Name $store -Url "$baseUrl/Citrix/$store"

# Set Receiver for Web site
Set-STFWebReceiver -StoreServiceUrl "$baseUrl/Citrix/$store" -WebReceiverUrl "$baseUrl"

# Optionally, configure additional settings as needed

# Restart IIS
Restart-Service -Name W3SVC

# Restart server
Restart-Computer -Force

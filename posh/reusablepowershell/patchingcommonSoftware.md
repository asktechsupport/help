### Azure Data Studio

```powershell
$url = "https://go.microsoft.com/fwlink/?linkid=2282377" # Define the URL for the latest version
$installerPath = "$env:TEMP\azuredatastudio.exe" # Define the path where the installer will be downloaded

Invoke-WebRequest -Uri $url -OutFile $installerPath # Download the installer
Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT" -Wait # Install Azure Data Studio without prompts
```

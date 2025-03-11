:warning: **Script not tested**

```powershell
# Define the Azure Arc service endpoints
$endpoints = @(
    "https://management.azure.com",
    "https://login.microsoftonline.com",
    "https://global.azure-devices-provisioning.net",
    "https://global.azure-devices-provisioning.net"
)

# Function to test connectivity
function Test-Connectivity {
    param (
        [string]$url
    )
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "Connection to $url successful."
        } else {
            Write-Host "Connection to $url failed with status code $($response.StatusCode)."
        }
    } catch {
        Write-Host "Connection to $url failed. Error: $_"
    }
}

# Test connectivity to each endpoint
foreach ($endpoint in $endpoints) {
    Test-Connectivity -url $endpoint
}
```

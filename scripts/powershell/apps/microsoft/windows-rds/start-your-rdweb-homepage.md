```powershell
# Open RDWeb (standalone: builds FQDN and launches URL)
$FQDN = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME).HostName
$homepage = "https://$FQDN/RDWeb"
Start-Process "explorer.exe" $homepage
```

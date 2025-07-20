- [ ] Update VMware Tools each month* - Requires a reboot
- [ ] Turn on viewing file extensions and view hidden files and folders
- [ ] Patch OS each month* - Requires a reboot
> [!NOTE]
> Turn the template back on → Check for updates
- [ ] Configure
  - [ ] Turn off Firewall
  - [ ] Disable ipv6
  - [ ] Create C:\Tools  
```powershell
Set-NetFirewallProfile -Enabled False
#Disable ipv6
Get-NetAdapterBinding –ComponentID ms_tcpip6 | disable-NetAdapterBinding -ComponentID ms_tcpip6 -PassThru
#Create C:\Tools
$toolsPath = "C:\Tools"

if (-not (Test-Path $toolsPath)) {
    Write-Host "Creating folder: $toolsPath"
    New-Item -Path $toolsPath -ItemType Directory -Force | Out-Null
    Write-Host "✅ Folder created."
} else {
    Write-Host "✅ Folder already exists: $toolsPath"
}

```
- [ ] Sysprep → Generalize / Reboot
```cmd
cd \Windows\System32\Sysprep
.\Sysprep.exe
#
```
- [ ] Sysprep → Generalize / shut down
```cmd
cd \Windows\System32\Sysprep
.\Sysprep.exe
#
```
- [ ] Enable your template for cloning in Workstation → **Advanced**
> [!TIP]
> 
>  Template is ready for cloning




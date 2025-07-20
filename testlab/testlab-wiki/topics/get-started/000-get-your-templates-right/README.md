- [ ] Update VMware Tools each month* - Requires a reboot
- [ ] Turn on viewing file extensions and view hidden files and folders
- [ ] Patch OS each month* - Requires a reboot
> [!NOTE]
> Turn the template back on → Check for updates → Sysprep → Generalize / Reboot
```cmd
cd \Windows\System32\Sysprep
.\Sysprep.exe
#
```
- [ ] Turn off firewall and disable ipv6
```powershell
Set-NetFirewallProfile -Enabled False
#Disable ipv6
Get-NetAdapterBinding –ComponentID ms_tcpip6 | disable-NetAdapterBinding -ComponentID ms_tcpip6 -PassThru
```
- [ ] Sysprep → Generalize / shut down
```cmd
cd \Windows\System32\Sysprep
.\Sysprep.exe
#
```




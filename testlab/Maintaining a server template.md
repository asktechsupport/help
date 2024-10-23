○ Update VMware Tools each month* - Requires a reboot

○ Patch OS each month* - Requires a reboot

○ Turn on viewing file extensions and view hidden files and folders

○ Turn off firewall
Set-NetFirewallProfile -Enabled False

○ Turn the template back on and then
```cmd
cd \Windows\System32\Sysprep
.\Sysprep.exe
#
```
Generalize / Reboot
Run again:
```cmd
cd \Windows\System32\Sysprep
.\Sysprep.exe
#
```
Generalize / shut down


○ Turn off firewall again for the next time
Set-NetFirewallProfile -Enabled False![image](https://github.com/user-attachments/assets/b2e2a74b-f14f-493d-adba-da174894b2fd)

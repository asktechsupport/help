- [ ] Turn on viewing file extensions and view hidden files and folders
- [ ] Patch OS each month* and vmware Tools* - Requires a reboot
> [!NOTE]
> Turn the template back on → Check for updates
- [ ] Configure
  - [ ] Turn off Firewall
  - [ ] Disable ipv6
  - [ ] Create C:\Tools  
```powershell
#LINE02→14 ⚙Setup⚙ ✓Firewall✓disable ipv6✓create "C:\Tools"
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
#
#LINE24→68 ⚙Setup⚙ ✓File Extensions✓view hidden files and folders
  # Registry values to apply
	$regPath = "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	$values = @{
		Hidden         = 1  # Show hidden files
		HideFileExt    = 0  # Show file extensions
		ShowSuperHidden = 1 # Show protected OS files
	}

	# Function to apply settings to a registry path
	function Set-ExplorerSettings($hiveRoot) {
		foreach ($key in $values.Keys) {
			Set-ItemProperty -Path "$hiveRoot\$regPath" -Name $key -Value $values[$key] -Force -ErrorAction SilentlyContinue
		}
	}

	Write-Host "🔧 Applying settings to Current User..."
	Set-ExplorerSettings -hiveRoot "HKCU:"

	# Apply to Default User (future accounts)
	$defaultHive = "C:\Users\Default\NTUSER.DAT"
	$tempKey = "TempDefault"

	if (Test-Path $defaultHive) {
		Write-Host "🔧 Applying settings to Default User profile..."
		reg load "HKU\$tempKey" "$defaultHive" | Out-Null
		try {
			Set-ExplorerSettings -hiveRoot "HKU:\$tempKey"
		} finally {
			reg unload "HKU\$tempKey" | Out-Null
		}
	}

	# Apply to all existing user profiles
	$users = Get-ChildItem 'C:\Users' | Where-Object {
		$_.PSIsContainer -and $_.Name -notin @('Default', 'Public', 'All Users', 'desktop.ini')
	}

	foreach ($user in $users) {
		$ntuserPath = "$($user.FullName)\NTUSER.DAT"
		if (Test-Path $ntuserPath) {
			$sid = (Get-LocalUser -Name $user.Name -ErrorAction SilentlyContinue)?.SID
			$keyName = "Temp_$($user.Name)"
			Write-Host "🔧 Applying settings to $($user.Name)..."
			reg load "HKU\$keyName" "$ntuserPath" | Out-Null
			try {
				Set-ExplorerSettings -hiveRoot "HKU:\$keyName"
			} finally {
				reg unload "HKU\$keyName" | Out-Null
			}
		}
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




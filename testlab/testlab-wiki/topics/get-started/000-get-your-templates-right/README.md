- [ ] Turn on viewing file extensions and view hidden files and folders
- [ ] Patch OS each month* and vmware Tools* - Requires a reboot
> [!NOTE]
> Turn the template back on → Check for updates
- [ ] Configure
  - [ ] Turn off Firewall
  - [ ] Disable ipv6
  - [ ] Create C:\Tools  
```powershell
# ⚙ LINE02→14 ⚙ Setup ✓ Firewall ✓ Disable IPv6 ✓ Create C:\Tools

# Disable all firewall profiles
Set-NetFirewallProfile -Enabled False

# Disable IPv6 on all adapters
Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding -ComponentID ms_tcpip6 -PassThru

# Create C:\Tools if it doesn't exist
$toolsPath = "C:\Tools"
if (-not (Test-Path $toolsPath)) {
    Write-Host "Creating folder: $toolsPath"
    New-Item -Path $toolsPath -ItemType Directory -Force | Out-Null
    Write-Host "✅ Folder created."
} else {
    Write-Host "✅ Folder already exists: $toolsPath"
}

# ⚙ LINE24→68 ⚙ Setup ✓ File Extensions ✓ View Hidden Files and Folders

# Registry values to apply
$regPath = "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$values = @{
    Hidden          = 1  # Show hidden files
    HideFileExt     = 0  # Show file extensions
    ShowSuperHidden = 1  # Show protected OS files
}

# Function to apply settings to a given registry root
function Set-ExplorerSettings($hiveRoot) {
    foreach ($key in $values.Keys) {
        Set-ItemProperty -Path "$hiveRoot\$regPath" -Name $key -Value $values[$key] -Force -ErrorAction SilentlyContinue
    }
}

# Apply settings to the current user
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

# Apply to all existing user profiles — only if NTUSER.DAT is not locked
$users = Get-ChildItem 'C:\Users' | Where-Object {
    $_.PSIsContainer -and $_.Name -notin @('Default', 'Public', 'All Users', 'desktop.ini')
}

foreach ($user in $users) {
    $ntuserPath = "$($user.FullName)\NTUSER.DAT"
    if (Test-Path $ntuserPath) {
        # Try to open file to see if it's locked
        try {
            $stream = [System.IO.File]::Open($ntuserPath, 'Open', 'Read', 'None')
            $stream.Close()
        } catch {
            Write-Warning "⚠️ Skipping $($user.Name) — NTUSER.DAT is locked by another process."
            continue
        }

        $keyName = "Temp_$($user.Name)"
        Write-Host "🔧 Applying settings to $($user.Name)..."

        try {
            reg load "HKU\$keyName" "$ntuserPath" | Out-Null
            Set-ExplorerSettings -hiveRoot "HKU:\$keyName"
        } catch {
            Write-Warning "⚠️ Failed to load hive for $($user.Name): $_"
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




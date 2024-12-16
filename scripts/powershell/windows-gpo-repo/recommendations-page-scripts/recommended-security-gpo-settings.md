- [ ] Tested ❌

```powershell
# Ensure the GroupPolicy module is loaded
Import-Module GroupPolicy

# Function to create and configure a GPO
function Create-GPO {
    param (
        [string]$GPOName,
        [string]$GPOSettingPath,
        [string]$SettingName,
        [string]$Value,
        [string]$Type = "DWORD" # Default to DWORD
    )

    Write-Host "Creating or modifying GPO: $GPOName..." -ForegroundColor Green

    # Create the GPO if it doesn't already exist
    $GPO = Get-GPO -Name $GPOName -ErrorAction SilentlyContinue
    if (-not $GPO) {
        $GPO = New-GPO -Name $GPOName
        Write-Host "Created new GPO: $GPOName" -ForegroundColor Yellow
    } else {
        Write-Host "GPO already exists: $GPOName" -ForegroundColor Cyan
    }

    # Link the GPO to the domain root (customize as needed)
    New-GPLink -Name $GPOName -Target "DC=domain,DC=com" -LinkEnabled Yes -ErrorAction SilentlyContinue

    # Set GPO Settings
    Write-Host "Configuring settings for $GPOName..." -ForegroundColor Green
    Set-GPRegistryValue -Name $GPOName -Key $GPOSettingPath -ValueName $SettingName -Type $Type -Value $Value
}

# Create and configure all 10 common GPOs
Write-Host "Starting GPO configuration..." -ForegroundColor Green

# 1. Disable USB Drives
Create-GPO -GPOName "Disable USB Drives" `
           -GPOSettingPath "HKLM\Software\Policies\Microsoft\Windows\RemovableStorageAccess" `
           -SettingName "Deny_All" `
           -Value "1"

# 2. Set Desktop Wallpaper
Create-GPO -GPOName "Set Desktop Wallpaper" `
           -GPOSettingPath "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" `
           -SettingName "Wallpaper" `
           -Value "C:\Path\To\Your\Wallpaper.jpg" `
           -Type "String"

# 3. Prevent Software Installation
Create-GPO -GPOName "Prevent Software Installation" `
           -GPOSettingPath "HKLM\Software\Policies\Microsoft\Windows\Installer" `
           -SettingName "DisableUserInstalls" `
           -Value "1"

# 4. Enforce Password Complexity
Create-GPO -GPOName "Enforce Password Complexity" `
           -GPOSettingPath "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
           -SettingName "PasswordComplexity" `
           -Value "1"

# 5. Set Minimum Password Length
Create-GPO -GPOName "Set Minimum Password Length" `
           -GPOSettingPath "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
           -SettingName "MinimumPasswordLength" `
           -Value "8"

# 6. Disable Control Panel Access
Create-GPO -GPOName "Disable Control Panel" `
           -GPOSettingPath "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
           -SettingName "NoControlPanel" `
           -Value "1"

# 7. Enable Windows Defender Antivirus
Create-GPO -GPOName "Enable Windows Defender Antivirus" `
           -GPOSettingPath "HKLM\Software\Policies\Microsoft\Windows Defender" `
           -SettingName "DisableAntiSpyware" `
           -Value "0"

# 8. Disable Command Prompt
Create-GPO -GPOName "Disable Command Prompt" `
           -GPOSettingPath "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
           -SettingName "DisableCMD" `
           -Value "1"

# 9. Disable Task Manager
Create-GPO -GPOName "Disable Task Manager" `
           -GPOSettingPath "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
           -SettingName "DisableTaskMgr" `
           -Value "1"

# 10. Set Lock Screen Image
Create-GPO -GPOName "Set Lock Screen Image" `
           -GPOSettingPath "HKLM\Software\Policies\Microsoft\Windows\Personalization" `
           -SettingName "LockScreenImage" `
           -Value "C:\Path\To\Your\LockScreen.jpg" `
           -Type "String"

Write-Host "GPO configuration complete!" -ForegroundColor Green
```

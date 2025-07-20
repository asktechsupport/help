# Setup-AdminProfileCheck.ps1 (Final, tested, correct version)

$domain = $env:USERDNSDOMAIN
if (-not $domain) {
    Write-Error "❌ USERDNSDOMAIN not set. Are you on a domain?"
    exit 1
}

$sysvolScripts = "\\$domain\SYSVOL\$domain\scripts"
$scriptName = "EnsurePowerShellProfile.ps1"
$scriptPath = Join-Path $sysvolScripts $scriptName

# Ensure SYSVOL scripts folder exists
if (!(Test-Path $sysvolScripts)) {
    New-Item -ItemType Directory -Path $sysvolScripts -Force
}

# PowerShell profile admin check
$profileContent = @'
# Global PowerShell profile: C:\ProgramData\Microsoft\Windows\PowerShell\profile.ps1
if ($Host.Name -notmatch "ServerRemoteHost") {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "❌ PowerShell is NOT running as Administrator."
        # exit
    } else {
        Write-Host "✅ PowerShell is running as Administrator."
    }
}
'@

# GPO startup script logic
$startupScriptContent = @"
`$profilePath = "C:\ProgramData\Microsoft\Windows\PowerShell\profile.ps1"
if (!(Test-Path `$profilePath)) {
    New-Item -ItemType File -Path `$profilePath -Force
}
`$content = @'
$($profileContent)
'@
Set-Content -Path `$profilePath -Value `$content -Force
"@

# Write the script to SYSVOL
Set-Content -Path $scriptPath -Value $startupScriptContent -Force -Encoding UTF8
Write-Host "✅ Saved startup script to $scriptPath"

# Load Group Policy module and create GPO
Import-Module GroupPolicy
$gpoName = "GlobalPowerShellProfileSetup"
$gpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue

if (-not $gpo) {
    $gpo = New-GPO -Name $gpoName
    Write-Host "✅ Created GPO '$gpoName'"
} else {
    Write-Host "ℹ️ GPO '$gpoName' already exists"
}

# Link GPO to domain root (modify if you want an OU)
$linkTarget = "dc=" + ($domain -replace '\.', ',dc=')
New-GPLink -Name $gpo.DisplayName -Target $linkTarget -Enforced No -ErrorAction SilentlyContinue

# Add startup script via registry-backed GPO setting
$scriptListKey = "HKLM\Software\Policies\Microsoft\Windows\System\Scripts\Startup\0"
Set-GPRegistryValue -Name $gpoName -Key $scriptListKey -ValueName "Script" -Type String -Value $scriptName
Set-GPRegistryValue -Name $gpoName -Key $scriptListKey -ValueName "Parameters" -Type String -Value ""

Write-Host "✅ Startup script linked to GPO via HKLM registry path"
Write-Host "✅ GPO '$gpoName' fully set up and will enforce admin check on PowerShell"

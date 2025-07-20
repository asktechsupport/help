# Disable-UAC-GPO.ps1
# Creates and configures a GPO to disable UAC across domain-joined machines

$domain = $env:USERDNSDOMAIN
if (-not $domain) {
    Write-Error "❌ USERDNSDOMAIN not set. Are you on a domain?"
    exit 1
}

Import-Module GroupPolicy

$gpoName = "Disable UAC Settings"

# Create or retrieve the GPO
$gpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $gpoName
    Write-Host "✅ GPO '$gpoName' created"
} else {
    Write-Host "ℹ️ GPO '$gpoName' already exists"
}

# Link GPO to domain root (modify to an OU if needed)
$linkTarget = "dc=" + ($domain -replace '\.', ',dc=')
New-GPLink -Name $gpoName -Target $linkTarget -Enforced No -ErrorAction SilentlyContinue

# Registry keys to disable UAC
$regPath = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

$settings = @(
    @{Name="EnableLUA";                  Value=0},  # Main UAC switch (0 = disabled)
    @{Name="ConsentPromptBehaviorAdmin"; Value=0},  # No prompt for admins
    @{Name="PromptOnSecureDesktop";      Value=0}   # No secure desktop
)

foreach ($setting in $settings) {
    Set-GPRegistryValue -Name $gpoName -Key $regPath -ValueName $setting.Name -Type DWord -Value $setting.Value
    Write-Host "✔️ Set $($setting.Name) = $($setting.Value)"
}

Write-Host "✅ UAC has been disabled in GPO '$gpoName'"
Write-Host "💡 A reboot is required for changes to take full effect"

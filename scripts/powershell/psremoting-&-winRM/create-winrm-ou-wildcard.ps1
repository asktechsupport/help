Import-Module ActiveDirectory
Import-Module GroupPolicy

# === CONFIG ===
$ouName = "WinRM"
$gpoName = "Enable WinRM (Insecure Wildcard)"

# === Step 1: Create OU ===
$domainDN = (Get-ADDomain).DistinguishedName
$ouDN = "OU=$ouName,$domainDN"

if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name $ouName -Path $domainDN -ProtectedFromAccidentalDeletion $false
    Write-Host "✔ Created OU: $ouName" -ForegroundColor Green
} else {
    Write-Host "ℹ OU already exists: $ouName" -ForegroundColor Yellow
}

# === Step 2: Block Inheritance ===
Set-GPInheritance -Target $ouDN -IsBlocked $true
Write-Host "✔ Blocked inheritance on OU: $ouName" -ForegroundColor Green

# === Step 3: Create GPO and link it ===
$gpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $gpoName
    Write-Host "✔ Created GPO: $gpoName" -ForegroundColor Green
}
New-GPLink -Name $gpoName -Target $ouDN -Enforced $false

# === Step 4: Configure WinRM Client (TrustedHosts = *) ===
Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" `
    -ValueName "TrustedHosts" -Type String -Value "*"

# === Step 5: Enable WinRM Service ===
Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" `
    -ValueName "AllowAutoConfig" -Type DWord -Value 1

Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" `
    -ValueName "IPv4Filter" -Type String -Value "*"

Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" `
    -ValueName "IPv6Filter" -Type String -Value "*"

# === Step 6: Disable UAC ===
Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "EnableLUA" -Type DWord -Value 0

Write-Host "✅ GPO configured and linked to $ouName OU" -ForegroundColor Cyan

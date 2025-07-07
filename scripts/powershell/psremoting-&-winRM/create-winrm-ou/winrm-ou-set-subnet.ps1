# Import required modules
Import-Module ActiveDirectory
Import-Module GroupPolicy

# === CONFIG ===
$ouName = "WinRM"
$gpoName = "Enable WinRM (Set Subnet)"
$domainDN = (Get-ADDomain).DistinguishedName
$ouDN = "OU=$ouName,$domainDN"

# === STEP 1: Create OU if not exists ===
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name $ouName -Path $domainDN -ProtectedFromAccidentalDeletion $false
    Write-Host "✔ Created OU: $ouName" -ForegroundColor Green
} else {
    Write-Host "ℹ OU already exists: $ouName" -ForegroundColor Yellow
}

# === STEP 2: Block Inheritance on OU ===
Set-GPInheritance -Target $ouDN -IsBlocked $true
Write-Host "✔ Blocked inheritance on OU: $ouName" -ForegroundColor Green

# === STEP 3: Create or reuse GPO ===
$gpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $gpoName
    Write-Host "✔ Created GPO: $gpoName" -ForegroundColor Green
} else {
    Write-Host "ℹ GPO already exists: $gpoName" -ForegroundColor Yellow
}

# === STEP 4: Link GPO to OU ===
New-GPLink -Name $gpoName -Target $ouDN -Enforced $false
Write-Host "✔ Linked GPO to OU: $ouName" -ForegroundColor Green

# === STEP 5: Dynamically get local subnet for IPv4Filter ===
$localIPv4 = (Get-NetIPAddress -AddressFamily IPv4 `
    | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.*" } `
    | Sort-Object -Property PrefixLength -Descending `
    | Select-Object -First 1).IPAddress

if (-not $localIPv4) {
    Write-Error "❌ Could not determine a valid local IPv4 address"
    exit 1
}

# Get the subnet prefix — assume /24 (first 3 octets)
$ipv4Filter = ($localIPv4 -split '\.')[0..2] -join '.' + '.*'
Write-Host "✔ Dynamically detected IPv4Filter: $ipv4Filter" -ForegroundColor Cyan

# === STEP 6: Set GPO Registry Values ===

# Disable UAC
Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "EnableLUA" -Type DWord -Value 0

# Enable WinRM service
Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" `
    -ValueName "AllowAutoConfig" -Type DWord -Value 1

# Use dynamic subnet in IPv4Filter
Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" `
    -ValueName "IPv4Filter" -Type String -Value $ipv4Filter

# IPv6Filter = *
Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" `
    -ValueName "IPv6Filter" -Type String -Value "*"

# TrustedHosts = *
Set-GPRegistryValue -Name $gpoName `
    -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" `
    -ValueName "TrustedHosts" -Type String -Value "*"

Write-Host "`n✅ GPO fully configured and applied to OU '$ouName'" -ForegroundColor Cyan

Import-Module GroupPolicy -ErrorAction Stop

# ===== CONFIG =====
$DomainFqdn = "pnpt.local"
$GpoName    = "Lab - RDP Convenience"
$OuDn       = "OU=Testing,OU=Servers,OU=Resources,OU=pnpt.local,DC=pnpt,DC=local"

# ---- Auto Logon (LAB ONLY) ----
$AutoLogonUser   = "Administrator"
$AutoLogonDomain = "PNPT"
$AutoLogonPass   = "ChangeThisToYourLabPassword"

# ===== CREATE OR GET GPO =====
$gpo = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $GpoName
    Write-Host "Created GPO."
} else {
    Write-Host "Using existing GPO."
}

# ===== LINK GPO =====
try {
    New-GPLink -Name $GpoName -Target $OuDn -LinkEnabled Yes -Enforced:$false -ErrorAction Stop | Out-Null
    Write-Host "Linked GPO."
} catch {
    Write-Host "Link already exists or failed."
}

function Set-GpoReg {
    param($Key,$Name,$Type,$Value)
    Set-GPRegistryValue -Name $GpoName -Key $Key -ValueName $Name -Type $Type -Value $Value
}

# ==========================================================
# 1) Credential Delegation (TERMSRV/*)
# ==========================================================
$credKey = "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"

Set-GpoReg $credKey "AllowSavedCredentials"  DWord 1
Set-GpoReg $credKey "AllowSavedCredentialsWhenNTLMOnly" DWord 1
Set-GpoReg $credKey "AllowDefaultCredentials" DWord 1
Set-GpoReg $credKey "AllowDefaultCredentialsWhenNTLMOnly" DWord 1

Set-GpoReg "$credKey\AllowSavedCredentials" "1" String "TERMSRV/*"
Set-GpoReg "$credKey\AllowSavedCredentialsWhenNTLMOnly" "1" String "TERMSRV/*"
Set-GpoReg "$credKey\AllowDefaultCredentials" "1" String "TERMSRV/*"
Set-GpoReg "$credKey\AllowDefaultCredentialsWhenNTLMOnly" "1" String "TERMSRV/*"

# ==========================================================
# 2) RDP Security Settings (No prompts / No NLA)
# ==========================================================
$tsKey = "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

Set-GpoReg $tsKey "fPromptForPassword" DWord 0
Set-GpoReg $tsKey "UserAuthentication" DWord 0

# ==========================================================
# 3) Always Wait For Network
# ==========================================================
$sysKey = "HKLM\SOFTWARE\Policies\Microsoft\Windows\System"
Set-GpoReg $sysKey "SyncForegroundPolicy" DWord 1

# ==========================================================
# 4) AutoAdminLogon (LAB ONLY – plaintext password)
# ==========================================================
$winlogon = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

Set-GpoReg $winlogon "AutoAdminLogon" String "1"
Set-GpoReg $winlogon "DefaultUserName" String $AutoLogonUser
Set-GpoReg $winlogon "DefaultDomainName" String $AutoLogonDomain
Set-GpoReg $winlogon "DefaultPassword" String $AutoLogonPass

# ==========================================================
# 5) Force GPUpdate at Startup
# ==========================================================
$runKey = "HKLM\Software\Microsoft\Windows\CurrentVersion\Run"
Set-GpoReg $runKey "ForceGPUpdate" String "cmd.exe /c gpupdate /force"

Write-Host ""
Write-Host "Done."
Write-Host "Run gpupdate /force on a target machine or reboot it."

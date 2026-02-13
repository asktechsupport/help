Import-Module GroupPolicy

$GpoName = "Launch-Calc-Visible"
$OuDn    = "OU=Testing,OU=Servers,OU=Resources,OU=pnpt.local,DC=pnpt,DC=local"

$gpo = New-GPO -Name $GpoName

New-GPLink -Name $GpoName -Target $OuDn -LinkEnabled Yes

# Enable Loopback Replace
Set-GPRegistryValue -Name $GpoName `
  -Key "HKLM\Software\Policies\Microsoft\Windows\System" `
  -ValueName "UserPolicyMode" `
  -Type DWord `
  -Value 1

# Create HKCU Run key (THIS is the important part)
Set-GPPrefRegistryValue -Name $GpoName `
  -Context User `
  -Action Create `
  -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" `
  -ValueName "LaunchCalc" `
  -Type String `
  -Value "calc.exe"

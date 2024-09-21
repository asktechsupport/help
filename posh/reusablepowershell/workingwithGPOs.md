### GPOs

```powershell
# Start
Import-Module GroupPolicy
Import-Module ActiveDirectory
  Write-Host -ForegroundColor Green "Modules imported..."
$domain = Get-ADDomain | select -ExpandProperty DNSRoot    # Example: Contoso.com
$GPOName = "CommonWindowsSettingsGPO"
$ouName = Get-ADDomain | select -ExpandProperty DNSRoot # Example: OU=IT,DC=Contoso,DC=com
$ouPath = Get-ADDomain | select DistinguishedName  # Base path of the domain
  Write-Host -ForegroundColor Green "Variables set..."
$baseOU = New-ADOrganizationalUnit -Name (Get-ADDomain | Select-Object -ExpandProperty DNSRoot) -Path (Get-ADDomain | Select-Object -ExpandProperty DistinguishedName) -ProtectedFromAccidentalDeletion $true
  Write-Host -ForegroundColor Green "Organizational Unit '$baseOU' has been successfully created in domain '$domain'"
```

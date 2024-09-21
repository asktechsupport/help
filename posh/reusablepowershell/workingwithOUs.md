
```powershell
New-ADOrganizationalUnit -Name (Get-ADDomain | Select-Object -ExpandProperty DNSRoot) -Path (Get-ADDomain | Select-Object -ExpandProperty DistinguishedName) -ProtectedFromAccidentalDeletion $true
Write-Host -ForegroundColor Green "Organizational Unit has been successfully created in domain '$domain'"
```

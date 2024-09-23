
```powershell
New-ADOrganizationalUnit -Name (Get-ADDomain | Select-Object -ExpandProperty DNSRoot) -Path (Get-ADDomain | Select-Object -ExpandProperty DistinguishedName) -ProtectedFromAccidentalDeletion $true
Write-Host -ForegroundColor Green "Organizational Unit has been successfully created in domain '$domain'"
```
### Create child OUs

```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Define variables
$domain = (Get-ADDomain).DNSRoot
$parentOU = "OU=Resources,$domain"
$childOUs = @("Controls", "UsersandGroups", "Servers", "ServiceAccounts")

# Create the Top-Level Parent OU (domain root)
$domainDN = (Get-ADDomain).DistinguishedName

# Create Sub-parent OU 'Resources'
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'Resources'" -SearchBase $domainDN -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "Resources" -Path $domainDN
    Write-Host "Sub-parent OU 'Resources' created."
} else {
    Write-Host "Sub-parent OU 'Resources' already exists."
}

# Create Children OUs under 'Resources'
foreach ($childOU in $childOUs) {
    $childOUPath = "OU=$childOU,$parentOU"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$childOU'" -SearchBase $parentOU -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $childOU -Path $parentOU
        Write-Host "Child OU '$childOU' created under 'Resources'."
    } else {
        Write-Host "Child OU '$childOU' already exists under 'Resources'."
    }
}

Write-Host "OU creation script completed."

```


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

# Create the Top-Level Parent OU (Resources) under the root domain
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'Resources'" -SearchBase $domain -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "Resources" -Path $domain
    Write-Host "Top-level OU 'Resources' created under domain root."
} else {
    Write-Host "Top-level OU 'Resources' already exists under domain root."
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

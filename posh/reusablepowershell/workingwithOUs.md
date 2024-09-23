
```powershell
New-ADOrganizationalUnit -Name (Get-ADDomain | Select-Object -ExpandProperty DNSRoot) -Path (Get-ADDomain | Select-Object -ExpandProperty DistinguishedName) -ProtectedFromAccidentalDeletion $true
Write-Host -ForegroundColor Green "Organizational Unit has been successfully created in domain '$domain'"
```
### Create child OUs

```powershell
# Import the Active Directory module
Import-Module ActiveDirectory

# Define variables
$domain = (Get-ADDomain).DNSRoot  # The domain's DNSRoot value
$dnsRootOU = "OU=$domain,$((Get-ADDomain).DistinguishedName)"  # Top-level OU matching the DNSRoot
$parentOU = "OU=Resources,$dnsRootOU"  # Sub-parent OU (Resources) under the DNSRoot OU
$childOUs = @("Controls", "UsersandGroups", "Servers", "ServiceAccounts")  # List of child OUs

# Create the Top-Level OU matching DNSRoot if it doesn't exist
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$domain'" -SearchBase (Get-ADDomain).DistinguishedName -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name $domain -Path (Get-ADDomain).DistinguishedName
    Write-Host "Top-level OU '$domain' created under domain root."
} else {
    Write-Host "Top-level OU '$domain' already exists under domain root."
}

# Create the Resources OU under the Top-Level OU (DNSRoot)
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'Resources'" -SearchBase $dnsRootOU -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "Resources" -Path $dnsRootOU
    Write-Host "Sub-parent OU 'Resources' created under '$domain'."
} else {
    Write-Host "Sub-parent OU 'Resources' already exists under '$domain'."
}

# Create Child OUs under 'Resources'
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

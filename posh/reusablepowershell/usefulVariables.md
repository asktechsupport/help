### Useful ADComputer Variables
>[!NOTE]
> These variables should work in any AD environment

```powershell
$domain = Get-ADDomain | select DNSRoot
$defaultDomainPolicy = Get-GPO -Name "Default Domain Policy"
$rootOU = Get-ADDomain | select DistinguishedName
$svc_account1 = Get-ADUser -Filter { samAccountName -like '*-svc' } -Properties samAccountName | Select-Object samAccountName
    $svc_account2 = Get-ADUser -Filter { samAccountName -like '*-SQL' } -Properties samAccountName | Select-Object samAccountName
$allhosts = get-ADComputer -Filter * | select DNSHostName
    $currentHost = get-ADComputer $env:COMPUTERNAME | select -ExpandProperty DNSHostName
    $allsqlservers = get-ADComputer -Filter {Name -like "*SQL*"} | select DNSHostName
    $sqlserver1 = get-ADComputer -Filter {Name -like "*SQL01*"} | select DNSHostName
    $sqlserver2 = get-ADComputer -Filter {Name -like "*SQL02*"} | select DNSHostName
```
### Useful AD Setup Variables
```powershell
$wsusTargetGroups = Get-ADGroup -Filter 'Name -like "wsusTargetGroup*"'

```
### Useful Application Patching Variables
```powershell
$azuredatastudioPatching = "https://aka.ms/azuredatastudio-windows"

```

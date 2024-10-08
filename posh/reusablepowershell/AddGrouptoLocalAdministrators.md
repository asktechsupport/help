> [!CAUTION]
> change the group name

```powershell
# Define the group to be added
$groupName = "YourGroupName"

# Get all domain-joined computers
$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

# Loop through each computer and add the group to the local Administrators group
foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock {
        param ($groupName)
        $group = [ADSI]"WinNT://./Administrators,group"
        $group.Add("WinNT://YourDomain/$groupName,group")
    } -ArgumentList $groupName
}

Write-Host "Group $groupName added to Administrators group on all domain-joined machines."

```

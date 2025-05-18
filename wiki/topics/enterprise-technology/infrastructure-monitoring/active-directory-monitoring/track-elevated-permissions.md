## Setup
* 1 Enable logging in Group Policy
* 2 Save the PowerShell script on your Logic Monitor Collectors
* 3 View in Logic Monitor

---
### Modify Group Policy
<details>
<summary>Click to view PowerShell script to enable auditing for security group changes</summary>

```powershell
# PowerShell script to enable auditing for security group management in Group Policy

# Enable auditing for Security Group Management (Success events)
AuditPol /set /subcategory:"Security Group Management" /success:enable

# Apply the auditing policy to the Default Domain Controllers Policy
Import-Module GroupPolicy
Set-GPRegistryValue -Name "Default Domain Controllers Policy" `
    -Key "HKLM\System\CurrentControlSet\Services\EventLog\Security" `
    -ValueName "AuditSecurityGroupManagement" `
    -Type DWord -Value 1
```
</details>

example output
![{06375F3B-1BDC-4440-A065-469C31DC237E}](https://github.com/user-attachments/assets/85c6ccb3-0570-4fe4-ad60-551a4ba6b471)


### Script
<details>
<summary>Copy this PowerShell script</summary>

```powershell
# PowerShell script to track when users are added to security groups in Active Directory

# Define the event IDs for group membership changes
$eventIDs = @(4728, 4732)

# Get the events from the Security log
$events = Get-WinEvent -LogName Security | Where-Object { $eventIDs -contains $_.Id }

# Process each event and extract relevant information
$events | ForEach-Object {
    $eventData = @{
        TimeCreated = $_.TimeCreated
        UserAdded = $_.Properties[0].Value
        GroupModified = $_.Properties[1].Value
        AdminWhoMadeChange = $_.Properties[5].Value
        DomainController = $_.MachineName
    }
    [PSCustomObject]$eventData
} | Format-Table -AutoSize
```
</details>

[I track bitesize code in issues](https://github.com/asktechsupport/help/milestones) | [View my PowerShell code in issues](https://github.com/asktechsupport/help/milestones)

You're @ the asktechsupport github.

> Please note this documentation may contain all or some of these highlighting tools

> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

# PowerShell Best Practices
> [!TIP] 
> Best practices can be found here: [PowerShell Best Practices](https://github.com/PoshCode/PowerShellPracticeAndStyle)


# WinIaac | PowerShell Profiles


### ⭐ Special Mention - [Paolo Frigo's PowerShell Library](https://github.com/PaoloFrigo/scriptinglibrary/tree/master/Blog/PowerShell)

Note - I prefer to track my PowerShell code in issues and my documentation in discussions

#Run PowerShell scripts securely under only your user

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
```
## PowerShell cheatsheet

| **Category**            | **Description**                                                                                                                                   | **Example Cmdlets**                                                                                                                                                                  |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **System Information**  | Retrieve and manage system information and status, such as processes, services, and event logs.                                                   | `Get-Command`, `Get-Process`, `Get-Service`, `Start-Service`, `Stop-Service`, `Restart-Service`, `Get-EventLog`, `Clear-EventLog`, `Invoke-Command`                                |
| **File Management**     | Perform file and directory operations, including retrieving, creating, modifying, and deleting files and directories.                             | `Get-ChildItem`, `Get-Item`, `Set-Item`, `Remove-Item`, `Copy-Item`, `Move-Item`, `Rename-Item`, `New-Item`, `Test-Path`, `Get-Content`, `Set-Content`, `Add-Content`             |
| **Network Management**  | Configure and retrieve network settings and test network connectivity.                                                                           | `Get-NetIPAddress`, `New-NetIPAddress`, `Remove-NetIPAddress`, `Test-Connection`, `Get-NetAdapter`                                                                                  |
| **User and Security**   | Manage local user accounts and groups, including creating, modifying, and deleting accounts and managing group memberships.                       | `Get-LocalUser`, `New-LocalUser`, `Set-LocalUser`, `Remove-LocalUser`, `Get-LocalGroup`, `Add-LocalGroupMember`, `Remove-LocalGroupMember`                                          |
| **AD User Management**  | Manage Active Directory users, including creating, modifying, and deleting user accounts and unlocking or enabling accounts.                      | `Get-ADUser`, `New-ADUser`, `Set-ADUser`, `Remove-ADUser`, `Unlock-ADAccount`, `Enable-ADAccount`, `Disable-ADAccount`                                                             |
| **AD Group Management** | Manage Active Directory groups, including creating, modifying, and deleting groups and managing group memberships.                               | `Get-ADGroup`, `New-ADGroup`, `Set-ADGroup`, `Remove-ADGroup`, `Add-ADGroupMember`, `Remove-ADGroupMember`                                                                          |
| **AD Computer Mgmt**    | Manage Active Directory computer objects, including creating, modifying, and deleting computer accounts.                                         | `Get-ADComputer`, `New-ADComputer`, `Set-ADComputer`, `Remove-ADComputer`                                                                                                          |
| **AD OU Management**    | Manage Active Directory organizational units, including creating, modifying, and deleting OUs.                                                   | `Get-ADOrganizationalUnit`, `New-ADOrganizationalUnit`, `Set-ADOrganizationalUnit`, `Remove-ADOrganizationalUnit`                                                                   |
| **Group Policy**        | Manage Group Policy Objects (GPOs), including retrieving, creating, modifying, and deleting GPOs.                                                | `Get-GPO`, `New-GPO`, `Set-GPO`, `Remove-GPO`                                                                                                                                       |
| **Domain Management**   | Manage Active Directory domains and forests, including retrieving domain and forest information and managing domain controllers.                  | `Get-ADDomain`, `Get-ADForest`, `Set-ADForest`, `New-ADDomainController`                                                                                                            |
| **Scripting Basics**    | Basic scripting constructs used to automate tasks, including variables, loops, conditional statements, and functions.                            | `$variableName`, `if`, `else`, `elseif`, `for`, `foreach`, `while`, `do while`, `function FunctionName`                                                                             |





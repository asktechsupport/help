> [!NOTE]
>
> IN PROGRESS...

```
param( [Parameter(Mandatory=$true)] $JSONFile )

function CreateADGroup(){
  param( [Parameter(Mandatory=$true)] $groupObject )

  $name =$groupObject.name
  New-AdGroup -name $name -GroupScope Global
}

function RemoveADGroup (){
  param( [Parameter(Mandatory=$true)] $groupObject )

  $name =$groupObject.name
  Remove-AdGroup -Identity $name -Confirm:$false

}

function CreateADUser(){
  param( [Parameter(Mandatory=$true)] $userObject )

  # Pull out the name from the JSON Object
  $name = $userObject.name
  $password = $userObject.password


















function WeakenPasswordPolicy(){
  secedit /export /cfg C:\Windows\Tasks\secpol.cfg
  (Get-Content C:\Windows\Tasks\secpol.cfg.).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\Windows\Tasks\secpol.cfg
  secedit /configure /db c:\windows\security\local.sdb /cfg C:\Windows\Tasks\secpol.cfg /areas SECURITYPOLICY
  rm -force C:\Windows\Tasks\secpol.cfg -confirm:$false
}

  ```

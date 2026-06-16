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

  

  ```

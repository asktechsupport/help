Moving content to Gitbook: https://simplesec.gitbook.io/my-gitbook/
# Special Mention - [Paolo Frigo's PowerShell Library](https://github.com/PaoloFrigo/scriptinglibrary/tree/master/Blog/PowerShell)
[View my PowerShell code](https://github.com/users/simpletechgithub/projects/13)

#Run PowerShell scripts securely under only your user

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

## Create new security groups
```
New-ADGroup `
-Name "Security Group Name" `
-SamAccountName "SecurityGroupName" `
-GroupCategory Security `
 -GroupScope Global `
 -DisplayName "Security Group Name" `
-Path "CN=Groups,DC=Domain,DC=com" `
-Description "Brief description of what the security group is used for"
```
## New random password
```
# Paolo Frigo, 2018
# https://www.scriptinglibrary.com

Function New-RandomPassword{
    Param(
        [ValidateRange(8, 32)]
        [int] $Length = 16
    )
    $AsciiCharsList = @()
    foreach ($a in (33..126)){
        $AsciiCharsList += , [char][byte]$a
    }
    #RegEx for checking general AD Complex passwords
    $RegEx = "(?=^.{8,32}$)((?=.*\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*"

    do {
        $Password = ""
        $loops = 1..$Length
        Foreach ($loop in $loops) {
            $Password += $AsciiCharsList | Get-Random
        }
    }
    until ($Password -match $RegEx )
    return $Password
}

# Generate passwords similar to pwgen"
for ($i = 0; $i -lt (12); $i++) {
    $line = ""
    for ($j = 0; $j -lt (5); $j++) {
        $line += "$(New-RandomPassword(10)) "
    }
    Write-Output $line
}
# This example just print a random password
# Write-Output "Generate Random Password: $(New-RandomPassword(10))"

```
## 

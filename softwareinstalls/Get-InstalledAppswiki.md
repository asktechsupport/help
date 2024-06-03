<#
.SYNOPSIS
	Get-InstalledApps retrieves a list of installed software
.DESCRIPTION
	Get-InstalledApps opens up the specified (remote) registry and scours it for installed software. When found it returns a list of the software and it's version.
.PARAMETER ComputerName
	The computer from which you want to get a list of installed software. Defaults to the local host.
.EXAMPLE
	Get-InstalledApps DC1
	
	This will return a list of software from DC1. Like:
	Name			Version		Computer  UninstallCommand
	----			-------     --------  ----------------
	7-Zip 			9.20.00.0	DC1       MsiExec.exe /I{23170F69-40C1-2702-0920-000001000000}
	Google Chrome	65.119.95	DC1       MsiExec.exe /X{6B50D4E7-A873-3102-A1F9-CD5B17976208}
	Opera			12.16		DC1		  "C:\Program Files (x86)\Opera\Opera.exe" /uninstall
.EXAMPLE
	Import-Module ActiveDirectory
	Get-ADComputer -filter 'name -like "DC*"' | Get-InstalledApps
	
	This will get a list of installed software on every AD computer that matches the AD filter (So all computers with names starting with DC)
.INPUTS
	[string[]]Computername
.OUTPUTS
	PSObject with properties: Name,Version,Computer,UninstallCommand
.NOTES
	Author: Anthony Howell
	
	To add directories, add to the LMkeys (LocalMachine)
.LINK
	[Microsoft.Win32.RegistryHive]
	[Microsoft.Win32.RegistryKey]
#>
function Get-InstalledApps {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [string]$NameRegex = ''
    )
    
    foreach ($comp in $ComputerName) {
        $keys = '','\Wow6432Node'
        foreach ($key in $keys) {
            try {
                $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $comp)
                $apps = $reg.OpenSubKey("SOFTWARE$key\Microsoft\Windows\CurrentVersion\Uninstall").GetSubKeyNames()
            } catch {
                continue
            }

            foreach ($app in $apps) {
                $program = $reg.OpenSubKey("SOFTWARE$key\Microsoft\Windows\CurrentVersion\Uninstall\$app")
                $name = $program.GetValue('DisplayName')
                $installDate = $program.GetValue('InstallDate')
                if ($installDate -ne $null) {
                    try {
                        $installDate = [datetime]::ParseExact($installDate, "yyyyMMdd", $null).ToString("dd/MM/yyyy")
                    } catch {
                        $installDate = $null
                    }
                }
                if ($name -and $name -match $NameRegex) {
                    [pscustomobject]@{
                        ComputerName = $comp
                        DisplayName = $name
                        DisplayVersion = $program.GetValue('DisplayVersion')
                        Publisher = $program.GetValue('Publisher')
                        InstallDate = $installDate
                        UninstallString = $program.GetValue('UninstallString')
                        Bits = $(if ($key -eq '\Wow6432Node') {'64'} else {'32'})
                        Path = $program.Name
                    }
                }
            }
        }
    }
}

Get-InstalledApps | Out-GridView


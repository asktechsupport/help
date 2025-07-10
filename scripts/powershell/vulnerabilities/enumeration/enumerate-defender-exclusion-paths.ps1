#Powershell version
Get-MpPreference | Select-Object -ExpandProperty ExclusionPath


#cmd version
powershell -command "Get-MpPreference | Select -ExpandProperty ExclusionPath"



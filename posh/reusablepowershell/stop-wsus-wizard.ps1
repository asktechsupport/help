Install-WindowsFeature -Name UpdateServices, UpdateServices-Ui, UpdateServices-WidDB, UpdateServices-Services -IncludeManagementTools

	# SQL Patch
	Log-Message "Patching SQL Minor version bug"
	try {
		Start-Process takeown.exe -ArgumentList '/f "C:\Program Files\Update Services\Database\VersionCheck.sql"' -Wait 
		Start-Process icacls.exe -ArgumentList '"C:\Program Files\Update Services\Database\VersionCheck.sql" /grant "administrator:(F)"' -Wait 
		(Get-Content "C:\Program Files\Update Services\Database\VersionCheck.sql") -replace "(^DECLARE @scriptMinorVersion\s+ int = \(11\)$)","DECLARE @scriptMinorVersion int = (51)" | Set-Content "C:\Program Files\Update Services\Database\VersionCheck.sql"
		Log-Message "SQL Minor version bug patched successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to patch SQL Minor version bug: $_" -Level "ERROR"
		exit
	}

Invoke-WsusServerConfiguration -SkipInitialConfiguration

try {
	# Variables
	$WSUS_DIR = "C:/WSUS"
	$LogFile = "C:/WSUSSetupLog.txt"

	# Functions
	
	#to log messages
  # https://aws.amazon.com/powershell/

	function Log-Message {
		param (
			[string]$Message,
			[string]$Level = "INFO"
		)
		$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
		$logEntry = "$timestamp [$Level] $Message"
		Add-Content -Path $LogFile -Value $logEntry
		Write-Host $Message
		# TODO 
		# how to write host with colours based on error type
	}
Install-WindowsFeature -Name UpdateServices, UpdateServices-Ui, UpdateServices-WidDB, UpdateServices-Services -IncludeManagementTools
# Post Install
	Log-Message "Starting WSUS PostInstall"
	try {
		sl "C:\Program Files\Update Services\Tools\"
		.\wsusutil.exe postinstall CONTENT_DIR=$WSUS_DIR > $PostInstall
		Log-Message "WSUS PostInstall completed successfully. Output: $PostInstall" -Level "SUCCESS"
		Log-Message "WSUS Version: $(Get-WsusServer).Version" -Level "INFO" #TODO fix this output
	}
	catch {
		Log-Message "Failed to complete WSUS PostInstall: $_" -Level "ERROR"
		exit
	}
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

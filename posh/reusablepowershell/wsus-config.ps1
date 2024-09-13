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

	# TODO
	#Function to output progress of sync
	# Line 98
	# Line 181

	# Windows Features
	Log-Message "Installing Windows Features"
	try {
		Install-WindowsFeature -Name UpdateServices,UpdateServices-UI -IncludeManagementTools
		Log-Message "Windows Features installed successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to install Windows Features: $_" -Level "ERROR"
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

	# Set VARs
	Log-Message "Setting WSUS Environment Variables"
	try {
		$WSUS = Get-WsusServer
		$WSUS_CONFIG = $WSUS.GetConfiguration()
		$WSUS_SUBSCRIPTION = $WSUS.GetSubscription()
		Log-Message "WSUS Environment Variables set successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to set WSUS Environment Variables: $_" -Level "ERROR"
		exit
	}

	# Setting MS upstream
	Log-Message "Setting update upstream to Microsoft"
	try {
		Set-WsusServerSynchronization –SyncFromMU
		Log-Message "Update upstream set to Microsoft successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to set update upstream to Microsoft: $_" -Level "ERROR"
		exit
	}

	# Setting English
	Log-Message "Setting update Languages to English and saving configuration settings"
	try {
		$WSUS_CONFIG.AllUpdateLanguagesEnabled = $false
		$WSUS_CONFIG.SetEnabledUpdateLanguages("en")
		$WSUS_CONFIG.Save()
		Log-Message "Update Languages set to English and configuration saved successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to set update Languages to English and save configuration: $_" -Level "ERROR"
		exit
	}

	# Init Sync
	Log-Message "Performing initial synchronization to get latest categories"
	try {
		$WSUS_SUBSCRIPTION.StartSynchronizationForCategoryOnly()
		Log-Message "Initial synchronization started." -Level "INFO"
		Start-Sleep -Seconds 60
		# if ($WSUS_SUBSCRIPTION.GetSynchronizationStatus() -ne 'Running') {
		# 	Log-Message "Failed to perform initial synchronization: $_" -Level "ERROR"
		# 	exit	
		# }
		While (($WSUS_SUBSCRIPTION.GetSynchronizationStatus() -eq 'Running') -and ($WSUS_SUBSCRIPTION.GetSynchronizationProgress().TotalItems -ne 0)) {
			$progress = $WSUS_SUBSCRIPTION.GetSynchronizationProgress()
			$percentComplete = ($progress.ProcessedItems / $progress.TotalItems) * 100
			Log-Message "Synchronization progress: $($percentComplete.ToString("0.00"))%" -Level "INFO"
			Start-Sleep -Seconds 30
		}

	Log-Message "Initial synchronization completed." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to perform initial synchronization: $_" -Level "ERROR"
		exit
	}
#--------------------------------------------------------
	# Setting updates
	Log-Message "Configuring MS Products for updates"
	try {
		Get-WsusProduct | Where-Object {
			$_.Product.Title -in (
				"Microsoft Defender Antivirus",
				"Microsoft Defender for Endpoint",
				"Microsoft Edge",
				"Windows Server 2019",
				"Microsoft Server Operating System-21h2",
				"Microsoft Server Operating System-22h2",
				"Microsoft Server Operating System-23h2",
				"Microsoft Server Operating System-24h2",
				"Server 2022 Hotpatch Category",
				"Windows - Server, version 21H2 and later, Servicing Drivers",
				"Windows - Server, version 21H2 and later, Upgrade & Servicing Drivers",
				"Windows - Server, version 24H2 and later, Upgrade & Servicing Drivers",
				"Windows Server Manager - Windows Server Update Services")
		} | Set-WsusProduct
		Log-Message "MS Products configured for updates successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to configure MS Products for updates: $_" -Level "ERROR"
		exit
	}

	# Configure the Classifications
	Log-Message "Setting WSUS Classifications"
	try {
		Get-WsusClassification | Where-Object {
			$_.Classification.Title -in (
			'Critical Updates',
			'Security Updates')
		} | Set-WsusClassification
		Log-Message "WSUS Classifications set successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to set WSUS Classifications: $_" -Level "ERROR"
		exit
	}

	# Configure Synchronizations
	Log-Message "Configuring WSUS Automatic Synchronisation"
	try {
		$WSUS_SUBSCRIPTION.SynchronizeAutomatically = $true
		$WSUS_SUBSCRIPTION.SynchronizeAutomaticallyTimeOfDay = (New-TimeSpan -Hours 0)
		$WSUS_SUBSCRIPTION.NumberOfSynchronizationsPerDay = 1
		$WSUS_SUBSCRIPTION.Save()
		Log-Message "Enabled WSUS Automatic Synchronisation Configuration Successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to enable WSUS Automatic Synchronisation: $_" -Level "ERROR"
		exit
	}

  # start sync
	Log-Message "Performing WSUS Synchronisation"
	try {
		$WSUS_SUBSCRIPTION.StartSynchronization()
		Log-Message "WSUS Synchronisation Started." -Level "INFO"
		Start-Sleep -Seconds 60

		While (($WSUS_SUBSCRIPTION.GetSynchronizationStatus() -eq 'Running') -and ($WSUS_SUBSCRIPTION.GetSynchronizationProgress().TotalItems -ne 0)) {
			$progress = $WSUS_SUBSCRIPTION.GetSynchronizationProgress()
			$percentComplete = ($progress.ProcessedItems / $progress.TotalItems) * 100
			Log-Message "Synchronization progress: $($percentComplete.ToString("0.00"))%" -Level "INFO"
			Start-Sleep -Seconds 15
		}

    Log-Message "WSUS Synchronisation Finished." -Level "Success"
	}
	catch {
		Log-Message "Failed to enable WSUS Automatic Synchronisation: $_" -Level "ERROR"
		exit
	}

	# Default Approvals
	Log-Message "Setting up default approvals for critical and security updates"
	try {
		[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
		$rule = $WSUS.GetInstallApprovalRules() | Where {
			$_.Name -eq "Default Automatic Approval Rule"}
		$class = $WSUS.GetUpdateClassifications() | ? {$_.Title -In (
			'Critical Updates',
			'Security Updates')}
		$class_coll = New-Object Microsoft.UpdateServices.Administration.UpdateClassificationCollection
		$class_coll.AddRange($class)
		$rule.SetUpdateClassifications($class_coll)
		$rule.Enabled = $True
		$rule.Save()
		Log-Message "Default approvals for critical and security updates set successfully." -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to set default approvals: $_" -Level "ERROR"
		exit
	}

	# Run approvals and cleanup
	Log-Message "Running Default Approval Rule and cleaning up temporary files"
	try {
		try {
			$Apply = $rule.ApplyRule()
			Log-Message "Default Approval Rule applied successfully." -Level "SUCCESS"
		}
		catch {
			Log-Message "Failed to apply Default Approval Rule: $_" -Level "ERROR"
		}
		finally {
			if (Test-Path $TempDir\ReportViewer.exe) {
				Remove-Item $TempDir\ReportViewer.exe -Force
			}
			if (Test-Path $TempDir\SQLEXPRWT_x64_ENU.exe) {
				Remove-Item $TempDir\SQLEXPRWT_x64_ENU.exe -Force
			}
			if ($Tempfolder -eq "No") {
				Remove-Item $TempDir -Force
			}
			Log-Message "Temporary files cleaned up." -Level "INFO"
		}
	}
	catch {
		Log-Message "Failed to run Default Approval Rule and clean up temporary files: $_" -Level "ERROR"
		exit
	}

  # function WSUS_Update_Download_Progress {
  #   Param
  #     (
  #         [Parameter(Mandatory=$true, Position=0)]
  #         [object] $WSUS
  #     )
  #   $UpdatesToDownload=$WSUS.GetContentDownloadProgress().TotalBytesToDownload
  #   $UpdatesDownloaded=$WSUS.GetContentDownloadProgress().DownloadedBytes
  #   $percentComplete = ($UpdatesDownloaded / $UpdatesToDownload) * 100
  #   return $percentComplete
  # }

  # Download Update
  # verify something is happening successfully -
  # TODO 
  # WAIT x && Downloaded -eq 0
  # WAIT-JOB attempt

	try {
    $count=0
    while(($WSUS.GetContentDownloadProgress().TotalBytesToDownload -ne 0) -and ($count -ne 2)){
      $UpdatesToDownload=$WSUS.GetContentDownloadProgress().TotalBytesToDownload
      $UpdatesDownloaded=$WSUS.GetContentDownloadProgress().DownloadedBytes
      $percentComplete = ($UpdatesDownloaded / $UpdatesToDownload) * 100
      Log-Message "Download progress: $($percentComplete.ToString("0.00"))%" -Level "INFO"
      Start-Sleep 30
      $count++
    }
	}
	catch {
		Log-Message "Failed to GetContentDownloadProgress" -Level "ERROR"
		exit
	}

	# Complete clean up and prevent the WSUS wizard displaying again when launching WSUS
	Log-Message "Fixing WSUS wizard displaying" -Level "INFO"
	try {
		Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates
		Log-Message "Fixed WSUS wizard displaying" -Level "SUCCESS"
	}
	catch {
		Log-Message "Failed to stop wizard 🧙‍♂️: $_" -Level "ERROR"
		exit
	}
	
	## EOS
	Write-Host "WSUS succcessfully configured." -ForegroundColor Green
}
catch {
	Log-Message "An unexpected error occurred: $_" -Level "ERROR"
}

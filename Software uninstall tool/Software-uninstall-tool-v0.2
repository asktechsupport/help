#vars
$MsgIntro = @'
Software uninstaller - this tool allows you to remove multiple software packages from Windows simultaneously. 
'@
$msicounter = 1
$execounter = 1 

    write-host -ForegroundColor white "$MsgIntro"
    Write-host -ForegroundColor white "Please select the software you wish to uninstall..."
 

    $Software = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | select DisplayName, UninstallString, InstallLocation, InstallDate | ogv -Title "Software Uninstall Tool - Please select the software you wish to uninstall..." -PassThru
    write-host -ForegroundColor Yellow "The following software will be uninstalled:"

    foreach ($application in $Software) {
        Write-Progress -Activity "Removing software" -Status "$($application.DisplayName) removal in progress..." -PercentComplete (($counter / $application.Count) * 100) 

            if ($application.UninstallString -like "MsiExec*") {
              write-host "$Application"
              $uninstall = $Application.UnInstallString
              cmd /c $uninstall /quiet /norestart
            $msicounter++
            }

            else {
                $uninstall = $Application.UnInstallString
                & "$uninstall"
            $execounter++
            }

     }

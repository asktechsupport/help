#----------------------------------------------------------------------------#
# This script sets up some applications silently via PowerShell 
Set-ExecutionPolicy RemoteSigned
#----------------------------------------------------------------------------#

# CHROME
    #Create a temporary directory to store Google Chrome.
    md -Path $env:temp\chromeinstall -erroraction SilentlyContinue | Out-Null
    $Download = join-path $env:temp\chromeinstall chrome_installer.exe

    #Download the Google Chrome installer.
    $url = 'https://dl.google.com/chrome/install/latest/chrome_installer.exe'
    Invoke-WebRequest $url  -OutFile $Download

    #Perform a silent installation of Google Chrome.
    Invoke-Expression "$Download /silent /install"

    $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    $INSTALLED | ?{ $_.DisplayName -match 'chrome' } | sort-object -Property DisplayName -Unique | Format-Table -AutoSize

# FIREFOX
    #Create a temporary directory to store Mozilla Firefox.
    md -Path $env:temp\firefoxinstall -erroraction SilentlyContinue | Out-Null

    #Download the Mozilla Firefox installer.
    $Download = join-path $env:temp\firefoxinstall firefox_installer.exe
    Invoke-WebRequest 'https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US' -OutFile $Download

    #Perform a silent installation of Mozilla Firefox.
    Invoke-Expression "$Download /S"

    $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    $INSTALLED | ?{ $_.DisplayName -match 'firefox' } | sort-object -Property DisplayName -Unique | Format-Table -AutoSize

# WHATSAPP
    winget search WhatsApp --source=msstore --accept-source-agreements
    winget install -e -i --id=9NKSQGP7F2NH --source=msstore --accept-package-agreements

    start chrome.exe
    start firefox.exe

#Google Drive
    $Path = $env:TEMP; $Installer = "GoogleDriveSetup.exe"; Invoke-WebRequest "https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe" -OutFile $Path\$Installer; Start-Process -FilePath $Path\$Installer -ArgumentList "--silent" -PassThru -Verb RunAs -Wait; Remove-Item $Path\$Installer

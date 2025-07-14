# Variables
$GpoName = "Global PowerShell Profile Deployment"
$SourceProfilePath = "\\$env:USERDNSDOMAIN\SYSVOL\$env:USERDNSDOMAIN\scripts\global-powershell-profiles\profile.ps1"
$DestinationProfilePath = "C:\ProgramData\Microsoft\Windows\PowerShell\profile.ps1"

# Create GPO if it doesn't exist
if (-not (Get-GPO -Name $GpoName -ErrorAction SilentlyContinue)) {
    New-GPO -Name $GpoName
    Write-Host "Created GPO: $GpoName"
} else {
    Write-Host "GPO already exists: $GpoName"
}

# Create XML block for GPP file preference
$GppXml = @"
<?xml version="1.0" encoding="utf-8"?>
<Files clsid="{C631DF4C-088F-48E3-A7D8-0194ACEC0B7B}">
  <File clsid="{C631DF4C-088F-48E3-A7D8-0194ACEC0B7B}" name="profile.ps1" status="Update" image="2" uid="1">
    <Properties action="U" destination="$DestinationProfilePath" source="$SourceProfilePath" />
  </File>
</Files>
"@

# Save XML temporarily
$TempXmlPath = "$env:TEMP\global-profile-gpo.xml"
$GppXml | Set-Content -Path $TempXmlPath -Encoding UTF8

# Import into GPO (User Configuration by default)
$Gpo = Get-GPO -Name $GpoName
$GpoGuid = $Gpo.Id

# Create the GPP structure manually (doesn't use native cmdlets for this part—requires file manipulation)
$SysvolPath = "\\$env:USERDNSDOMAIN\SYSVOL\$env:USERDNSDOMAIN\Policies\{$GpoGuid}\User\Preferences\Files"
New-Item -ItemType Directory -Path $SysvolPath -Force
Copy-Item -Path $TempXmlPath -Destination "$SysvolPath\Files.xml" -Force

Write-Host "GPO configured. Link it to an OU as required."

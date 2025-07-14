Import-Module GroupPolicy

# Configuration
$GpoName = "Global PowerShell Profile Deployment (Computer Config)"
$SourcePath = "\\$env:USERDNSDOMAIN\SYSVOL\$env:USERDNSDOMAIN\scripts\global-powershell-profiles\profile.ps1"
$DestinationPath = "C:\ProgramData\Microsoft\Windows\PowerShell\profile.ps1"

# Create GPO if it doesn’t exist
$gpo = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
if (-not $gpo) {
    $gpo = New-GPO -Name $GpoName
    Write-Host "Created GPO: $GpoName"
} else {
    Write-Host "GPO already exists: $GpoName"
}

# Build the XML content for Computer Configuration
$GppXml = @"
<?xml version="1.0" encoding="utf-8"?>
<Files clsid="{C631DF4C-088F-48E3-A7D8-0194ACEC0B7B}">
  <File clsid="{C631DF4C-088F-48E3-A7D8-0194ACEC0B7B}" name="profile.ps1" status="Update" image="2" uid="1">
    <Properties action="U" 
                destination="$DestinationPath"
                source="$SourcePath"
                />
  </File>
</Files>
"@

# Path for Computer Configuration
$Domain = $env:USERDNSDOMAIN
$GpoGuid = $gpo.Id
$GppTargetPath = "\\$Domain\SYSVOL\$Domain\Policies\{$GpoGuid}\Machine\Preferences\Files"

# Ensure the folder exists
if (-not (Test-Path $GppTargetPath)) {
    New-Item -ItemType Directory -Path $GppTargetPath -Force
    Write-Host "Created GPP folder: $GppTargetPath"
}

# Write Files.xml
$GppXml | Set-Content -Path "$GppTargetPath\Files.xml" -Encoding UTF8
Write-Host "Files.xml written under Computer Configuration at $GppTargetPath"

Write-Host "✅ GPO setup complete. Link it to your target OU as needed using New-GPLink."

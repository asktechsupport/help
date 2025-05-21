# Ensure script runs with admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator."
    exit
}

# Define GPO name
$GpoName = "Medium Risk Remediation"

# Import the GroupPolicy module
Import-Module GroupPolicy

# Create the GPO if it doesn't exist
if (-not (Get-GPO -Name $GpoName -ErrorAction SilentlyContinue)) {
    New-GPO -Name $GpoName -Comment "GPO to apply recommended remediations for medium-risk vulnerabilities identified in the NCC Group report"
}

# 1. Disable insecure internet communication features
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoPublishingWizard" -Type DWord -Value 1
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoWebServices" -Type DWord -Value 1
Set-GPRegistryValue -Name $GpoName -Key "HKLM\Software\Policies\Microsoft\Messenger\Client" -ValueName "CEIP" -Type DWord -Value 2
Set-GPRegistryValue -Name $GpoName -Key "HKLM\Software\Policies\Microsoft\SearchCompanion" -ValueName "DisableContentFileUpdates" -Type DWord -Value 1
Set-GPRegistryValue -Name $GpoName -Key "HKLM\Software\Policies\Microsoft\SQMClient\Windows" -ValueName "CEIPEnable" -Type DWord -Value 0

# 2. Disable NetBIOS over TCP
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces\tcpip*" -ValueName "NetbiosOptions" -Type DWord -Value 2

# 3. Stop WPAD service
Set-Service -Name "WinHttpAutoProxySvc" -StartupType Disabled
Stop-Service -Name "WinHttpAutoProxySvc" -Force

# 4. Enable host-based firewall
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -ValueName "EnableFirewall" -Type DWord -Value 1
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -ValueName "EnableFirewall" -Type DWord -Value 1
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -ValueName "EnableFirewall" -Type DWord -Value 1

# 5. Disable RDP drive redirection
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -ValueName "fDisableCdm" -Type DWord -Value 1

Write-Host "GPO '$GpoName' created and configured successfully."

# Ensure script runs with admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator."
    exit
}

# Define GPO name
$GpoName = "Low Risk Remediation"

# Import the GroupPolicy module
Import-Module GroupPolicy

# Create the GPO if it doesn't exist
if (-not (Get-GPO -Name $GpoName -ErrorAction SilentlyContinue)) {
    New-GPO -Name $GpoName -Comment "GPO to apply recommended remediations for low-risk vulnerabilities identified in the NCC Group report"
}

# 1. Disable POSIX optional subsystems
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\SubSystems" -ValueName "Optional" -Type String -Value ""

# 2. Enable system-wide ASLR
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -ValueName "MoveImages" -Type DWord -Value 1

# 3. Disable storage of network authentication credentials
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "DisableDomainCreds" -Type DWord -Value 1

# 4. Disable NTFS 8.3 filename creation
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" -ValueName "NtfsDisable8dot3NameCreation" -Type DWord -Value 3

# 5. Enable Windows Defender Exploit Guard - Exploit Protection (basic)
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender ExploitGuard" -ValueName "ExploitProtection" -Type DWord -Value 1

# 6. Disable TLS 1.0 and 1.1
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -ValueName "Enabled" -Type DWord -Value 0
Set-GPRegistryValue -Name $GpoName -Key "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -ValueName "Enabled" -Type DWord -Value 0

Write-Host "GPO '$GpoName' created and configured successfully."

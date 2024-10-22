#.............................................................................
############################# CREATE LAB GPO ################################
#.............................................................................

# Import the GroupPolicy module
Import-Module GroupPolicy

# Define variables
$GPOName = "pnptLab-gpoSettings"
$AppLockerPath = "HKLM\SOFTWARE\Policies\Microsoft\Windows\SrpV2"
$ApplockerExecutableKey = "$AppLockerPath\ExecutableRules"
$GPOAuditPath = "HKLM\SOFTWARE\Policies\Microsoft\Windows\System"
$auditCategory = "Audit Policy Change"
$auditSubcategory = "Audit Audit Policy Change"
$auditCommand = "auditpol /set /subcategory:'$auditSubcategory' /success:enable /failure:enable"
$domain = (Get-ADDomain).DNSRoot
$rootOU = Get-ADDomain | select DistinguishedName
$EdgeKey = "HKLM\SOFTWARE\Policies\Microsoft\Edge"

# Create a new GPO if it doesn't already exist
if (-not (Get-GPO -Name $GPOName -ErrorAction SilentlyContinue)) {
    $GPO = New-GPO -Name $GPOName -Domain $domain
    Write-Host "GPO Created: $($GPO.DisplayName)"
} else {
    $GPO = Get-GPO -Name $GPOName
    Write-Host "GPO '$GPOName' already exists."
}

# Disable Windows Defender for lab purposes
Set-GPRegistryValue -Name "Disable Windows Defender" -Key "HKLM\Software\Policies\Microsoft\Windows Defender" -ValueName "DisableAntiSpyware" -Type Dword -Value 1


# Guest Account Status Reinforcement
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -ValueName "DisableGuestAccount" -Type Dword -Value 1
Disable-ADAccount -Identity Guest -ErrorAction SilentlyContinue
Write-Host "Guest account has been disabled."

# Stop LAN Manager hash values being stored on next password changes
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "NoLMHash" -Type Dword -Value 1
Write-Host "LAN Manager hash storage has been disabled."

# Monitor changes to GPO settings using Group Policy Logging and Auditing
Set-GPRegistryValue -Name $GPOName -Key $GPOAuditPath -ValueName "GPOAuditEnabled" -Type Dword -Value 1
Write-Host "GPO Auditing has been enabled to monitor changes."

# Enable Advanced Audit Policy for GPO changes
Invoke-Expression '$auditCommand'
Write-Host "Advanced Audit Policy enabled for 'Audit Policy Change'"

# Disable Microsoft Edge First Run and Startup Screens
Set-GPRegistryValue -Name $GPOName -Key $EdgeKey -ValueName "HideFirstRunExperience" -Type Dword -Value 1
Set-GPRegistryValue -Name $GPOName -Key $EdgeKey -ValueName "ImportStartupSettings" -Type Dword -Value 0
Write-Host "Microsoft Edge First Run experience and startup screens have been disabled."

#Link the GPO
New-GPLink -Name $GPOName -Target $rootOU


#.............................................................................
######################### CREATE LAB AD OBJECTS #############################
#.............................................................................
###### OUs ######
Import-Module ActiveDirectory
$domain = (Get-ADDomain).DNSRoot  # The domain's DNSRoot value
$dnsRootOU = "OU=$domain,$((Get-ADDomain).DistinguishedName)"  # Top-level OU matching the DNSRoot
$parentOU = "OU=Resources,$dnsRootOU"  # Sub-parent OU (Resources) under the DNSRoot OU
$serversOU = "OU=Servers,$parentOU"  # Servers OU path under Resources
$childOUs = @("Controls", "UsersandGroups", "Servers", "ServiceAccounts")  # List of child OUs under Resources
$serverChildOUs = @("ApplicationServers", "DatabaseServers", "CoreInfrastructure", "JumpStations", "Testing")  # List of OUs under Servers

# Create the Top-Level OU matching DNSRoot if it doesn't exist
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$domain'" -SearchBase (Get-ADDomain).DistinguishedName -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name $domain -Path (Get-ADDomain).DistinguishedName
    Write-Host "Top-level OU '$domain' created under domain root."
} else {
    Write-Host "Top-level OU '$domain' already exists under domain root."
}

# Create the Resources OU under the Top-Level OU (DNSRoot)
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'Resources'" -SearchBase $dnsRootOU -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "Resources" -Path $dnsRootOU
    Write-Host "Sub-parent OU 'Resources' created under '$domain'."
} else {
    Write-Host "Sub-parent OU 'Resources' already exists under '$domain'."
}

# Create Child OUs under 'Resources'
foreach ($childOU in $childOUs) {
    $childOUPath = "OU=$childOU,$parentOU"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$childOU'" -SearchBase $parentOU -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $childOU -Path $parentOU
        Write-Host "Child OU '$childOU' created under 'Resources'."
    } else {
        Write-Host "Child OU '$childOU' already exists under 'Resources'."
    }
}

# Create further Children OUs under 'Servers'
foreach ($serverChildOU in $serverChildOUs) {
    $serverChildOUPath = "OU=$serverChildOU,$serversOU"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$serverChildOU'" -SearchBase $serversOU -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $serverChildOU -Path $serversOU
        Write-Host "Server Child OU '$serverChildOU' created under 'Servers'."
    } else {
        Write-Host "Server Child OU '$serverChildOU' already exists under 'Servers'."
    }
}

Write-Host "OU creation script completed."
gpupdate /force
    Write-Host "Your Group Policy should have taken effect from gpupdate /force."

###### ➕USERS ######
# Add manually for now

###### ➕SERVICE ACCOUNTS ######
# Add manually for now

###### ➕SMB SHARES ######
# Define the paths
$parentDir = "C:\Shares"
$shareDir = "C:\Shares\hackme"

# Check if the parent directory (C:\Shares) exists, if not, create it
if (-Not (Test-Path -Path $parentDir)) {
    Write-Host "Directory C:\Shares does not exist. Creating it..."
    New-Item -Path $parentDir -ItemType Directory
} else {
    Write-Host "Directory C:\Shares already exists."
}

# Check if the share directory (C:\Shares\hackme) exists, if not, create it
if (-Not (Test-Path -Path $shareDir)) {
    Write-Host "Directory C:\Shares\hackme does not exist. Creating it..."
    New-Item -Path $shareDir -ItemType Directory
} else {
    Write-Host "Directory C:\Shares\hackme already exists."
}

# Create the SMB Share with default permissions (Full access to Administrators and read access to Everyone)
Write-Host "Creating SMB share 'hackme'..."
New-SmbShare -Name "hackme" -Path $shareDir -FullAccess "Administrators" -ReadAccess "Everyone"

# Verify the share creation
Write-Host "Verifying SMB share 'hackme'..."
$share = Get-SmbShare -Name "hackme"
if ($share) {
    Write-Host "SMB share 'hackme' created successfully!"
} else {
    Write-Host "Failed to create SMB share 'hackme'."
}
###### ➕SETSPN (SERVICE PRINCIPAL NAMES) ######
setspn -a pnpt/sql.pnpt.local:60111 PNPT\SQLService




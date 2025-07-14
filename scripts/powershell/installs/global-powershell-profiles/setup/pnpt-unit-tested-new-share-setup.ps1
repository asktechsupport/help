$sharePath = "\\PNPT-winrm.pnpt.local\I`$\software-repo-100gb"
$shareName = "software-repo-100gb"
$description = "Central software repository for automated installs"

# 1️⃣ Create folder if it doesn’t exist
if (-not (Test-Path $sharePath)) {
    New-Item -Path $sharePath -ItemType Directory -Force
    Write-Host "Created folder: $sharePath"
}

# 2️⃣ Ensure "Software Repo Admins" and "Server Admins" groups exist
$requiredGroups = @("Software Repo Admins", "Server Admins")

foreach ($groupName in $requiredGroups) {
    if (-not (Get-ADGroup -Filter { Name -eq $groupName } -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $groupName -GroupScope Global -Path "CN=Users,DC=$($env:USERDNSDOMAIN.Split('.')[0]),DC=$($env:USERDNSDOMAIN.Split('.')[1])"
        Write-Host "Created Active Directory group: $groupName"
    } else {
        Write-Host "Group already exists: $groupName"
    }
}


# 3️⃣ Create or update SMB share with full access for all required groups
$fullAccessGroups = @("Domain Admins", "Server Admins", $groupName)

if (-not (Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue)) {
    New-SmbShare -Name $shareName -Path $sharePath -Description $description -FullAccess $fullAccessGroups -ErrorAction SilentlyContinue
    Write-Host "Created share: $shareName with full access for $($fullAccessGroups -join ', ')"
} else {
    Set-SmbShare -Name $shareName -FullAccess $fullAccessGroups
    Write-Host "Updated share permissions for $shareName"
}

# 4️⃣ Set NTFS permissions with full control for all required groups
$fullAccessGroups = @("Domain Admins", "Server Admins", "Software Repo Admins")

foreach ($identity in $fullAccessGroups) {
    try {
        # Validate identity exists before using it
        $ntAccount = New-Object System.Security.Principal.NTAccount($identity)
        $sid = $ntAccount.Translate([System.Security.Principal.SecurityIdentifier])
        
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $identity, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
        )
        $acl.SetAccessRule($accessRule)

        Write-Host "Set access rule for: $identity"
    } catch {
        Write-Warning "Skipping invalid group: $identity ($_)" 
    }
}

Set-Acl -Path $sharePath -AclObject $acl

start $sharePath

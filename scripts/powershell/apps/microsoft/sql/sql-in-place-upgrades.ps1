# Define variables
$SQLSetupPath = "D:\SQLServer2019\setup.exe"  # Path to the SQL Server 2019 setup executable
$InstanceName = "MSSQLSERVER"                # Default instance or replace with your named instance
$BackupPath = "C:\SQLBackups"                # Path to store database backups
$LogPath = "C:\SQLUpgradeLogs"               # Path for upgrade logs
$SQLVersionQuery = "SELECT @@VERSION;"
$ServerInstance = "localhost"                # Replace with your server name if remote

# Create necessary directories
if (-not (Test-Path $BackupPath)) {
    New-Item -ItemType Directory -Path $BackupPath | Out-Null
}
if (-not (Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath | Out-Null
}

# Step 1: Backup all databases
Write-Host "Backing up all databases..."
Invoke-Sqlcmd -ServerInstance $ServerInstance -Query "
    EXEC sp_MSforeachdb 'IF DB_ID(''?'') > 4 BACKUP DATABASE [?] TO DISK = ''$BackupPath\?_Full.bak'' WITH INIT';
"

Write-Host "Databases backed up to $BackupPath."

# Step 2: Check SQL Server version (Pre-upgrade check)
Write-Host "Checking current SQL Server version..."
$currentVersion = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $SQLVersionQuery
Write-Host "Current SQL Server Version: $currentVersion"

# Step 3: Run SQL Server setup for upgrade
Write-Host "Starting SQL Server 2019 in-place upgrade..."
Start-Process -FilePath $SQLSetupPath -ArgumentList @(
    "/ACTION=Upgrade",
    "/INSTANCENAME=$InstanceName",
    "/IACCEPTSQLSERVERLICENSETERMS",
    "/QUIET",
    "/INDICATEPROGRESS",
    "/ERRORREPORTING=1",
    "/UPGRADELOGDIR=$LogPath"
) -Wait -NoNewWindow

Write-Host "SQL Server upgrade process completed."

# Step 4: Post-upgrade steps
Write-Host "Performing post-upgrade steps..."

# Update database compatibility levels to 150 for SQL Server 2019
Write-Host "Updating database compatibility levels..."
Invoke-Sqlcmd -ServerInstance $ServerInstance -Query "
    EXEC sp_MSforeachdb 'IF DB_ID(''?'') > 4 ALTER DATABASE [?] SET COMPATIBILITY_LEVEL = 150';
"

# Apply latest cumulative updates
Write-Host "Downloading and applying latest cumulative updates for SQL Server 2019..."
$CUInstallerPath = "C:\SQLUpdates\SQL2019CU.exe"  # Replace with the actual path to the CU installer
Start-Process -FilePath $CUInstallerPath -ArgumentList "/quiet /norestart" -Wait -NoNewWindow

# Step 5: Validate SQL Server version post-upgrade
Write-Host "Validating SQL Server version after upgrade..."
$postUpgradeVersion = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $SQLVersionQuery
Write-Host "SQL Server Version After Upgrade: $postUpgradeVersion"

Write-Host "Upgrade process completed successfully!"

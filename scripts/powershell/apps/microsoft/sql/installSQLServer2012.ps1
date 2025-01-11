# Define variables
$SQLSetupPath = "C:\SQLServer2012\setup.exe"   # Path to SQL Server 2012 setup executable
$SQLInstallDir = "C:\Program Files\Microsoft SQL Server"  # Installation directory
$SQLDataDir = "C:\SQLData"                    # Path for SQL Server data files
$SQLLogDir = "C:\SQLLogs"                     # Path for SQL Server log files
$SQLBackupDir = "C:\SQLBackups"               # Path for SQL Server backups
$SQLTempDBDir = "C:\SQLTempDB"                # Path for TempDB files
$SetupLogDir = "C:\SQLSetupLogs"              # Path for setup logs
$SQLSysAdminAccounts = "Administrator"        # Account to be added as SQL SysAdmin

# Create necessary directories
$Directories = @($SQLDataDir, $SQLLogDir, $SQLBackupDir, $SQLTempDBDir, $SetupLogDir)
foreach ($dir in $Directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

# Build argument list for SQL Server setup
$SetupArguments = @(
    "/ACTION=Install",                        # Perform a fresh installation
    "/QUIET",                                 # Run in silent mode
    "/IACCEPTSQLSERVERLICENSETERMS",          # Accept license terms
    "/FEATURES=SQLENGINE",                    # Install SQL Server Database Engine
    "/INSTANCENAME=MSSQLSERVER",              # Default instance name
    "/INSTALLOCATION=$SQLInstallDir",         # Installation location
    "/SQLUSERDBDIR=$SQLDataDir",              # User database directory
    "/SQLUSERDBLOGDIR=$SQLLogDir",            # User database log directory
    "/SQLBACKUPDIR=$SQLBackupDir",            # Backup directory
    "/SQLTEMPDBDIR=$SQLTempDBDir",            # TempDB files location
    "/ADDCURRENTUSERASSQLADMIN",              # Add the current user as SQL SysAdmin
    "/SQLSVCACCOUNT=NT AUTHORITY\NETWORK SERVICE", # SQL Server service account
    "/SQLSYSADMINACCOUNTS=$SQLSysAdminAccounts",   # SysAdmin accounts
    "/SECURITYMODE=SQL",                      # Enable mixed mode authentication
    "/SAPWD=StrongPassword123!"               # Password for the SA account (use a strong password)
)

# Start SQL Server installation
Write-Host "Starting SQL Server 2012 installation..."
Start-Process -FilePath $SQLSetupPath -ArgumentList $SetupArguments -Wait -NoNewWindow

# Check installation logs
Write-Host "Installation completed. Checking logs..."
$LogFile = Get-ChildItem -Path $SetupLogDir -Filter "*.txt" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Write-Host "Log file location: $($LogFile.FullName)"

Write-Host "SQL Server 2012 installation completed successfully!"

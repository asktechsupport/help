#------------------------------------------------------------------------------------------------------------------------------------------------#
#### Function to check if running as administrator
#------------------------------------------------------------------------------------------------------------------------------------------------#
# Function to check if running as administrator
Unblock-File -Path "C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1"
function Test-IsAdmin {
   $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
   return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
# Suppress any errors by redirecting error stream to $null
$ErrorActionPreference = "SilentlyContinue"
# Check if running as administrator
if (-not (Test-IsAdmin)) {
   Write-Host "This script must be run as an administrator." -ForegroundColor Red
   # Wait for user input before closing
   Read-Host "Press Enter to close this PowerShell window"
   # Close the PowerShell application
   Stop-Process -Id $PID -Force
}
# Restore default error action preference
$ErrorActionPreference = "Continue"
# Your script logic here
Write-Host "Running with administrative privileges." -ForegroundColor Green
#------------------------------------------------------------------------------------------------------------------------------------------------#
#### PROFILE SETUP
#------------------------------------------------------------------------------------------------------------------------------------------------#
    # Get the profile path for All Users, All Hosts
        $profilePath = $PROFILE.AllUsersAllHosts

    # Check if the profile path exists
    if (-not (Test-Path $profilePath)) {
        # If the path does not exist, create the profile file and its directory if needed
        New-Item -Path $profilePath -ItemType File -Force | Out-Null
        Write-Host "Profile path created: $profilePath" -ForegroundColor Green
    } else {
        Write-Host "Profile path already exists: $profilePath" -ForegroundColor Yellow
    }

    # Now $profilePath contains the path to the All Users, All Hosts profile
    Write-Host "Using profile path: $profilePath" -ForegroundColor Cyan

    # Replace $profilePath with the actual path of the profile
    $profilePath = $PROFILE.AllUsersAllHosts
    # Grant read and execute permissions to all users
    icacls $profilePath /grant "Administrators:F"
    icacls $profilePath /grant "Users:(RX)"

    $profilePathISE = $PROFILE.AllUsersCurrentHost
    # Ensure the profile file exists before modifying permissions
       if (-not (Test-Path $profilePathISE)) {
           New-Item -Path $profilePathISE -ItemType File -Force
       }
    # Grant full control to administrators
       icacls $profilePathISE /grant "Administrators:F"
    # Grant read and execute access to all users, but deny write access
       icacls $profilePathISE /grant "Users:(RX)"



# Check if the ISE profile exists
if (Test-Path $profilePathISE) {
   # Get the content of the ISE profile
   $content = Get-Content $profilePathISE
   $totalLines = $content.Count

   # Start the copying process with a progress bar
   for ($i = 0; $i -lt $totalLines; $i++) {
       # Write each line to the standard PowerShell profile
       Add-Content -Path $ProfilePath -Value $content[$i]

       # Update the progress bar
       $percentComplete = [math]::Round(($i / $totalLines) * 100)
       Write-Progress -Activity "Syncing ISE Profile" -Status "Copying line $($i+1) of $totalLines" -PercentComplete $percentComplete
   }

   Write-Host "PowerShell profile synced with ISE profile successfully." -ForegroundColor Green
} else {
   Write-Host "ISE profile does not exist. No action taken." -ForegroundColor Yellow
}

Write-Host "All-users profile loaded successfully on $(Get-Date)" -ForegroundColor Green
Write-Host "Hey, $env:USERNAME" -ForegroundColor White
Write-Host "Vars are stored @ *C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1*" -ForegroundColor White
#------------------------------------------------------------------------------------------------------------------------------------------------#
#### ENVIRONMENT VARS
#------------------------------------------------------------------------------------------------------------------------------------------------#
$env:USERNAME
#------------------------------------------------------------------------------------------------------------------------------------------------#
#### GLOBAL VARS
#------------------------------------------------------------------------------------------------------------------------------------------------#
    $domain = Get-ADDomain | select DNSRoot
    $rootOU = Get-ADDomain | select DistinguishedName
    $allhosts = get-ADComputer -Filter * | select DNSHostName
      $allsqlservers = get-ADComputer -Filter {Name -like "*SQL*"} | select DNSHostName
      $sqlserver1 = get-ADComputer -Filter {Name -like "*SQL01*"} | select DNSHostName
      $sqlserver2 = get-ADComputer -Filter {Name -like "*SQL02*"} | select DNSHostName
    

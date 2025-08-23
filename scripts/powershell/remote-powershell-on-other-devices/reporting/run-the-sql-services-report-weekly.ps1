$TaskName = "Weekly_SQL_Service_Report"
$TaskDescription = "Generates weekly SQL service status report every Sunday at 09:00"
$ScriptPath = "C:\temp\Services\Generate_SQL_Service_Report.ps1"

# Define the action to run the script
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

# Define the weekly trigger
$Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 9:00AM

# Define the principal (run as SYSTEM with highest privileges)
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Description $TaskDescription

Change the time and date  in line 9
$TaskName = "ScheduledReboot"
$TaskDescription = "Reboots the server at 15:00 on 24/08/2025"

# Define the action to reboot the server
$Action = New-ScheduledTaskAction -Execute "shutdown.exe" -Argument "/r /t 0"

# Define the one-time trigger
$TriggerTime = Get-Date "24/08/2025 15:00" #🕧provide time on this line
$Trigger = New-ScheduledTaskTrigger -Once -At $TriggerTime

# Define the principal (run as SYSTEM with highest privileges)
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Description $TaskDescription

#You can test this ⚠️warning - causes a reboot
#Start-ScheduledTask -TaskName "ScheduledReboot"

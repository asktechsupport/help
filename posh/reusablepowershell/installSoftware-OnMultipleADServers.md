### Copy Files to Windows 2012 Servers
>[!NOTE]
> Execute this as a Domain Admin user.

```powershell


Get-ADComputer -Filter {OperatingSystem -like '*Windows Server 2012*'} | ForEach-Object {Invoke-Command -ComputerName $_.DNSHostName -ScriptBlock {if (-Not (Test-Path -Path 'C:\Temp')) {New-Item -Path 'C:\Temp' -ItemType Directory}}; Copy-Item -Path "C:\Temp\AzureConnectedMachineAgent.msi" -Destination "\\$($_.DNSHostName)\C$\Temp\" -Force}
#Get-ADComputer -Filter {OperatingSystem -like '*Windows Server 2012*'} | ForEach-Object {Invoke-Command -ComputerName $_.DNSHostName -ScriptBlock {Start-Process msiexec.exe -ArgumentList '/I C:\Temp\AzureConnectedMachineAgent.msi /quiet /qn /norestart' -Wait}}

$servers = Get-ADComputer -Filter {OperatingSystem -like '*Windows Server 2012*'} | Select-Object -ExpandProperty DNSHostName
$totalServers = $servers.Count
$counter = 0
$servers | ForEach-Object {
   $counter++
   Write-Progress -Activity "Installing Azure Arc agent on servers" -Status "Processing server $counter of ${totalServers}: $_" -PercentComplete (($counter / $totalServers) * 100)
   Invoke-Command -ComputerName $_ -ScriptBlock {
       Write-Output "Installing Azure Arc agent on $_..."
       Start-Process msiexec.exe -ArgumentList '/I C:\Temp\AzureConnectedMachineAgent.msi /quiet /qn /norestart' -Wait
       Write-Output "Installation complete on $_."
   }
   Write-Output "Finished processing server $_ ($counter of $totalServers)."
}
Write-Output "Azure Arc agent installation process completed on all servers."
```

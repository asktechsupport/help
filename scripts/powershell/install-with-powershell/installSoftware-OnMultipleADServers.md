### Copy and run installers on Windows 2012 Servers
[Download | Azure Arc Agent](https://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwi8hJKs5qaIAxUoVkEAHQt6A2AQFnoECAoQAQ&url=https%3A%2F%2Faka.ms%2FAzureConnectedMachineAgent&usg=AOvVaw3e6kX3rlnWVZIPExAsulsI&opi=89978449)

>[!NOTE]
> Execute this as a Domain Admin user.

>[!TIP]
> In an internetless environment, move your installer to C:\Temp on the device you are running the PSRemote command from

### Enable PS Remoting if not already done
```powershell
Get-ADComputer -Filter {OperatingSystem -like '*Windows Server 2012*'} | ForEach-Object {Invoke-Command -ComputerName $_.Name -ScriptBlock {Enable-PSRemoting -Force -SkipNetworkProfileCheck}}

```

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

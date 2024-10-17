# Import the Active Directory module
Import-Module ActiveDirectory

# Get all servers in the domain
$servers = Get-ADComputer -Filter {OperatingSystem -Like "*Server*"} | Select-Object -ExpandProperty Name

# Command to find and renew the latest certificate in the Personal store
$renewCertCommand = {
    # Get the latest certificate from the LocalMachine\My store
    $certs = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.NotAfter -gt (Get-Date) }
    $latestCert = $certs | Sort-Object NotAfter -Descending | Select-Object -First 1

    if ($latestCert) {
        # Renew the certificate with the same key
        $renewedCert = $latestCert.Renew()
        if ($renewedCert) {
            Write-Output "Certificate renewed successfully on $env:COMPUTERNAME"
        } else {
            Write-Output "Failed to renew certificate on $env:COMPUTERNAME"
        }
    } else {
        Write-Output "No valid certificates found on $env:COMPUTERNAME"
    }
}

# Loop through each server and run the renew command
foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -ScriptBlock $renewCertCommand
}

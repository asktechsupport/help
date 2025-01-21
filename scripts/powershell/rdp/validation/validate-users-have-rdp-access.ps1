param (
    [string]$RemoteComputer,
    [string]$Username
)

function Test-RDPAccess {
    param (
        [string]$ComputerName,
        [string]$User
    )

    try {
        # Check if the user is a member of the Remote Desktop Users group
        $rdpGroup = ADSI
        $members = @($rdpGroup.psbase.Invoke("Members")) | ForEach-Object { $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) }

        if ($members -contains $User) {
            Write-Output "$User has RDP access on $ComputerName."
        } else {
            Write-Output "$User does not have RDP access on $ComputerName."
        }

        # Check if the user account is enabled
        $userAccount = ADSI
        $accountDisabled = $userAccount.AccountDisabled

        if ($accountDisabled) {
            Write-Output "However, the account $User is disabled."
        } else {
            Write-Output "The account $User is enabled."
        }
    } catch {
        Write-Output "Failed to validate RDP access for $User on $ComputerName. Error: $_"
    }
}

Test-RDPAccess -ComputerName $RemoteComputer -User $Username

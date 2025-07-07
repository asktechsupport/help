[Find useful AD variables here](https://github.com/asktechsupport/help/blob/main/posh/reusablepowershell/usefulVariables.md)

- [ ] Tested and working in the authors lab environment.
> [!WARNING]
> Run the scripts in order, errors occur when you run as a single script without reboots.

## Run Script 001: Configure IP and rename machine(s)
Configure a static IP, install DNS, disable ipv6 & rename the machine
> [!NOTE]
> You may need to pay attention to the hostname variable and IP address variable and change the script accordingly.
```powershell
#Create the PNPT lab with powershell
#Run on your new Domain Controller. This script has been tested successfully in the author's lab environment.

#FUNCTIONS
function Rename-Host {
    Add-Type -AssemblyName System.Windows.Forms

    # Create a form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Enter New Hostname"
    $form.TopMost = $true
    $form.Width = 300
    $form.Height = 150
    $form.StartPosition = "CenterScreen"

    # Create a label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Enter the new hostname:"
    $label.Top = 20
    $label.Left = 10
    $label.Width = 250
    $form.Controls.Add($label)

    # Create a text box
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Top = 50
    $textBox.Left = 10
    $textBox.Width = 250
    $form.Controls.Add($textBox)

    # Create an OK button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Top = 90
    $okButton.Left = 75
    $okButton.Width = 75
    $form.Controls.Add($okButton)
    $okButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })

    # Create a Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Top = 90
    $cancelButton.Left = 155
    $cancelButton.Width = 75
    $form.Controls.Add($cancelButton)
    $cancelButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })

    # Show the form
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK -and -not [string]::IsNullOrWhiteSpace($textBox.Text)) {
        return $textBox.Text
    } else {
        return $null
    }
}

function Set-IP {
    Add-Type -AssemblyName System.Windows.Forms

    # Create a form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Enter New IP Address"
    $form.TopMost = $true
    $form.Width = 300
    $form.Height = 150
    $form.StartPosition = "CenterScreen"

    # Create a label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Enter the new IP address:"
    $label.Top = 20
    $label.Left = 10
    $label.Width = 250
    $form.Controls.Add($label)

    # Create a text box
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Top = 50
    $textBox.Left = 10
    $textBox.Width = 250
    $form.Controls.Add($textBox)

    # Create an OK button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Top = 90
    $okButton.Left = 75
    $okButton.Width = 75
    $form.Controls.Add($okButton)
    $okButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })

    # Create a Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Top = 90
    $cancelButton.Left = 155
    $cancelButton.Width = 75
    $form.Controls.Add($cancelButton)
    $cancelButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })

    # Show the form
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK -and -not [string]::IsNullOrWhiteSpace($textBox.Text)) {
        return $textBox.Text
    } else {
        return $null
    }
}


#VARS
$folder = "Directory"
$netAdapterName = "pnpt.local"
# Call the Rename-Host function and store the result in $renameHost
$renameHost = Rename-Host

  if ($renameHost) {
      Rename-Computer -NewName $renameHost -Force
      $restart = [System.Windows.Forms.MessageBox]::Show("Do you want to restart now?", "Restart Confirmation", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
      if ($restart -eq [System.Windows.Forms.DialogResult]::Yes) {
          Restart-Computer
      } else {
          Write-Host "Please restart the computer for the changes to take effect."
      }
  } else {
      Write-Host "Operation cancelled or no hostname entered." -ForegroundColor Red
  }

#SCRIPT INPUT
New-Item -Path 'C:\Temp' -ItemType $folder
New-Item -Path 'C:\Apps' -ItemType $folder

Rename-NetAdapter -Name “Ethernet0" -NewName $netAdapterName
# Call the Set-IP function and store the result in $setIPAddress
$setIPAddress = Set-IP

    if ($setIPAddress) {
        Write-Host "The entered IP address is: $setIPAddress" -ForegroundColor Green
    } else {
        Write-Host "Operation cancelled or no IP address entered." -ForegroundColor Red
    }
New-NetIPAddress -IPAddress $setIPAddress -InterfaceAlias $netAdapterName -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias $netAdapterName -ServerAddresses 10.0.0.1
Disable-NetAdapterBinding -Name $netAdapterName -ComponentID ms_tcpip6
Rename-Computer $renameHost
#
```
> [!WARNING]
> The script will reboot the machine for you.

## Run script to join the domain
Join the domain
```powershell
Add-Computer -DomainName pnpt.local
# when prompted for creds enter
# Administrator
# Help8585
# Restart-Computer -Force ⚠️Reboot Required⚠️
#
```
> [!WARNING]
> The script will reboot the machine for you.

## Create local user accounts
> [!NOTE]
> You need to pay attention to the $newUser variable and change the script accordingly.
```powershell
# Step 1: Create the local user
$newUser = "PC-Local-Admin01"
New-LocalUser -Name $newUser -Password (ConvertTo-SecureString "Help8585" -AsPlainText -Force) -FullName $newUser -Description "Description of the user"

# Step 2: Add the user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $newUser
```

## Optional
```powershell
Install-WindowsFeature -Name Telnet-Client
```


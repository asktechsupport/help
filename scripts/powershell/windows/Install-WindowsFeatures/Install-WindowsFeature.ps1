# Windows Feature Installation Script with Dropdown Selection

Add-Type -AssemblyName System.Windows.Forms

# Get all available Windows Features
$features = Get-WindowsFeature | Where-Object { $_.InstallState -eq 'Available' }

# Create form and controls
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select Windows Feature to Install"
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = "CenterScreen"

$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(20,20)
$comboBox.Size = New-Object System.Drawing.Size(340,40)
$comboBox.DropDownStyle = 'DropDownList'

# Populate dropdown with feature names
$features.DisplayName | ForEach-Object { $comboBox.Items.Add($_) }

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(20,70)
$button.Size = New-Object System.Drawing.Size(340,40)
$button.Text = "Install Selected Feature"

$form.Controls.Add($comboBox)
$form.Controls.Add($button)

$button.Add_Click({
    $selectedFeatureDisplayName = $comboBox.SelectedItem
    $selectedFeature = $features | Where-Object { $_.DisplayName -eq $selectedFeatureDisplayName }
    if ($selectedFeature) {
        Install-WindowsFeature -Name $selectedFeature.Name
        [System.Windows.Forms.MessageBox]::Show("Feature $($selectedFeature.Name) installed.", "Success")
    } else {
        [System.Windows.Forms.MessageBox]::Show("No feature selected.", "Error")
    }
    $form.Close()
})

$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()

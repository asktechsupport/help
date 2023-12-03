#https://www.youtube.com/watch?v=s07r570yOW8
#⚠️⚠️⚠️ be cautious when removing a folder, ideal to watch the full tutorial first⚠️⚠️⚠️#

#region basic form
$basicForm = New-Object System.Windows.Forms.Form
#$basicForm.ShowDialog()
#endregion

#insert text box
$demoForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox

$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'

$demoForm.Controls.Add($pathTextBox)

$demoForm.ShowDialog()

#region insert button

#region reused code
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$demoForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'
$demoForm.Controls.Add($pathTextBox)
#endregion

$selectButton = New-Object System.Windows.Forms.Button

$selectButton.Text = 'Se;ect'
$selectButton.Location = '196,23'

$demoForm.Controls.Add($selectButton)

$demoForm.ShowDialog()

#region add folder browser

#regionreusedcode
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$demoForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$selectButton = New-Object System.Windows.Forms.Button
$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'
$selectButton.Text = 'Select'
$selectButton.Location = '196,23'
$demoForm.Controls.Add($pathTextBox)
$demoForm.Controls.Add($selectButton)
#endregion

$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

$selectButton.Add_Click({
  $folderBrowser.ShowDialog()
  $pathTextBox.Text = $folderBrowser.SelectedPath
  })
  $pathTextBox.ReadOnly = $true
  $demoForm.ShowDialog()
  #endregion

#region remove folder
  #regionreusedcode
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$demoForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$selectButton = New-Object System.Windows.Forms.Button
$okButton = New-Object System.Windows.Forms.Button
$cancelButton = New-Object System.Windows.Forms.Button
$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'
$selectButton.Text = 'Select'
$selectButton.Location = '196,23'
$demoForm.Controls.Add($pathTextBox)
$demoForm.Controls.Add($selectButton)
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$selectButton.Add_Click({
  $folderBrowser.ShowDialog()
  $pathTextBox.Text = $folderBrowser.SelectedPath
  })
  $pathTextBox.ReadOnly = $true
#endregion


$removeButton = New-Object System.Windows.Forms.Button
$removeButton.Location = '26,52'
$removeButton.Text = 'Remove'

$removeButton.Add_Click({
  If($folderBrowser.SelectedPath){
    If(Test-Path $folderBrowser.SelectedPath){
      Remove-Item $folderBrowser.SelectedPath
    }
  }
})
  #endregion

  $demoForm.Controls.Add($removeButton)
  $demoForm.ShowDialog()

#CODE FOR THE FULL FORM
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$demoForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$selectButton = New-Object System.Windows.Forms.Button
$removeButton = New-Object System.Windows.Forms.Button
$okButton = New-Object System.Windows.Forms.Button
$cancelButton = New-Object System.Windows.Forms.Button


$pathTextBox.Location = '23,23'
$pathTextBox.Size = '165,23'
$selectButton.Text = 'Select'
$selectButton.Location = '196,23'
$removeButton.Location = '26,55'
$removeButton.Text = '❌Remove'
$okButton.Location = '56,215'
$okButton.Text = 'OK'
$cancelButton.Location = '153,215'
$cancelButton.Text = 'Cancel'
$demoForm.AcceptButton = $okButton
$demoForm.CancelButton = $cancelButton

$demoForm.Controls.Add($pathTextBox) #text input
$demoForm.Controls.Add($selectButton) #📁 select folder button
$demoForm.Controls.Add($removeButton) #❌ remove button
$demoForm.Controls.Add($okButton) #👍 ok button
$demoForm.Controls.Add($cancelButton) #🚫 cancel button
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$selectButton.Add_Click({
  $folderBrowser.ShowDialog()
  $pathTextBox.Text = $folderBrowser.SelectedPath
  })
  $pathTextBox.ReadOnly = $true

  $demoForm.Text = '📁 Folder Form'
$removeButton.Add_Click({
  If($folderBrowser.SelectedPath){
    If(Test-Path $folderBrowser.SelectedPath){
      Remove-Item $folderBrowser.SelectedPath
    }
  }
})
$demoForm.ShowDialog()
#endregion

  





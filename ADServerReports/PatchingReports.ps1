#credit https://www.youtube.com/watch?v=XC1_dtTPxxQ&t=6s
#📁ADServerReporter Variables
    $defaultfont='Calibri,11'
    $servers = Get-ADComputer -filter * -Properties * | select Name #Server names
      $getsvc = Get-Service -Name $ServiceName | select DisplayName,Status #Services
      $showdomainname = Get-ADDomain | select DNSRoot -ExpandProperty DNSRoot
      $getlatestupdates =  gwmi win32_quickfixengineering |sort installedon -desc
      $ patchedservers = Get-ADComputer -Filter {(OperatingSystem-like "* windows * server *") -and (Enabled -eq "True")} -Properties OperatingSystem | Sort Name | select -Unique Name
          foreach ($ server in $ patchedservers) {
          write-host $ server.Name          
             Invoke-Command -ComputerName $ server.Name -ScriptBlock {
          (New-Object -com "Microsoft.Update.AutoUpdate"). Results}
          }
        $gethotfix = Get-HotFix -Description Security* -ComputerName $servers | select Source,Description,HotFixID,InstalledBy,InstalledOn | Sort-Object -Property InstalledOn


#🔧Report Features
    


#Creates Excel application
  $excel = New-Object -ComObject excel.application
        #Makes Excel Visible
          $excel.Application.Visible = $true
          $excel.DisplayAlerts = $false
        #Creates Excel workBook
          $book = $excel.Workbooks.Add()
        #Adds worksheets

#gets the work sheet and Names it
  $sheet = $book.Worksheets.Item(1)
        $sheet.name = 'ServerList'
  #Select a worksheet
$sheet.Activate() | Out-Null
#Create a row and set it to Row 1
  $row = 1
#Create a Column Variable and set it to column 1
  $column = 1
#Add the title and change the Font of the word
  $sheet.Cells.Item($row,$column) = "Server List - $showdomainname.DNSRoot"
  $sheet.Cells.Item($row,$column).Font.Name = "Arial"
  $sheet.Cells.Item($row,$column).Font.Size = 11
  $sheet.Cells.Item($row,$column).Font.ColorIndex = 16
  $sheet.Cells.Item($row,$column).Interior.ColorIndex = 2
  $sheet.Cells.Item($row,$column).HorizontalAlignment = -4108
  $sheet.Cells.Item($row,$column).Font.Bold = $true
#Merge the cells
  $range = $sheet.Range("A1:c1").Merge() | Out-Null
#Move to the next row
  $row++
#Create Intial row so you can add borders later
  $initalRow = $row

    #create Headers for your sheet
          $sheet.Cells.Item($row,$column) = "Hostname"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "FQDN"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "IP Address"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "Description"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "Operating System"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "Primary Application"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "Secondary Application"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "Project Manager"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "Project Name"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "HotFixID"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true
      $column++
          $sheet.Cells.Item($row,$column) = "Installed On"
          $sheet.Cells.Item($row,$column).Font.Size = 11
          $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
          $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
          $sheet.Cells.Item($row,$column).Font.Bold = $true


#Now that the headers are done we go down a row and back to column 1
  $row++
  $column = 1
#Get Server Properties
  foreach($i in $servers){
  $info = Get-ADComputer -Identity $($i.name) -Properties Name, DNSHostName, ipv4address, Description, OperatingSystem

    $sheet.Cells.Item($row,$column) = $info.Name
        $column++
            $sheet.Cells.Item($row,$column) = $info.DNSHostName
        $column++
            $sheet.Cells.Item($row,$column) = $info.ipv4address
        $column++
            $sheet.Cells.Item($row,$column) = $info.Description
        $column++
            $sheet.Cells.Item($row,$column) = $info.OperatingSystem
    $row++
    $column = 1
     foreach($i in $gethotfix){
      $info = Get-HotFix -Identity $($i.name) -Properties Source,Description,HotFixID,InstalledBy,InstalledOn
}
  $row--
  $dataRange = $sheet.Range(("A{0}" -f $initalRow),("m{0}"  -f $row))
  7..12 | ForEach {
      $dataRange.Borders.Item($_).LineStyle = 1
      $dataRange.Borders.Item($_).Weight = 2
}
#Fits cells to size
  $UsedRange = $sheet.UsedRange
  $UsedRange.EntireColumn.autofit() | Out-Null

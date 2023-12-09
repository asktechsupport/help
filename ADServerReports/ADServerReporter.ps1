#credit https://www.youtube.com/watch?v=XC1_dtTPxxQ&t=6s
#Tech Mate Variables
    $defaultfont='Arial,11'
    $servers = Get-ADComputer -filter * -Properties * | select Name #Server names
      $getsvc = Get-Service -Name $ServiceName | select DisplayName,Status #Services
    

#🔧Tech Mate Features
function svcDetails{
        $details=$getsvc
        $showsvcname.Text=$details.displayname
        $showsvcstatus.Text=$details.status

        if ($showsvcstatus.text -eq 'Running'){
            $showsvcstatus.ForeColor='green'
        }else{
            $showsvcstatus.ForeColor='red'
        }

}
    $svcdropdown.Add_SelectedIndexChanged({svcDetails})


#Creates Excel application
  $excel = New-Object -ComObject excel.application
#Makes Excel Visable
  $excel.Application.Visible = $true
  $excel.DisplayAlerts = $false
#Creates Excel workBook
  $book = $excel.Workbooks.Add()
#Adds worksheets

#gets the work sheet and Names it
  $sheet = $book.Worksheets.Item(1)
$sheet.name = 'Computer Information'
  #Select a worksheet
$sheet.Activate() | Out-Null
#Create a row and set it to Row 1
  $row = 1
#Create a Column Variable and set it to column 1
  $column = 1
#Add the title and change the Font of the word
  $sheet.Cells.Item($row,$column) = "Computer Information"
  $sheet.Cells.Item($row,$column).Font.Name = "Arial"
  $sheet.Cells.Item($row,$column).Font.Size = 18
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
  $sheet.Cells.Item($row,$column).Font.Size = 16
  $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
  $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
  $sheet.Cells.Item($row,$column).Font.Bold = $true
  $column++
  $sheet.Cells.Item($row,$column) = "FQDN"
  $sheet.Cells.Item($row,$column).Font.Size = 16
  $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
  $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
  $sheet.Cells.Item($row,$column).Font.Bold = $true
  $column++
  $sheet.Cells.Item($row,$column) = "IP Address"
  $sheet.Cells.Item($row,$column).Font.Size = 16
  $sheet.Cells.Item($row,$column).Font.ColorIndex = 1
  $sheet.Cells.Item($row,$column).Interior.ColorIndex = 48
  $sheet.Cells.Item($row,$column).Font.Bold = $true
#Now that the headers are done we go down a row and back to column 1
  $row++
  $column = 1
#Get Server Properties
  foreach($i in $servers){
  $info = Get-ADComputer -Identity $($i.name) -Properties Name, DNSHostName, ipv4address

    $sheet.Cells.Item($row,$column) = $info.Name
    $column++
    $sheet.Cells.Item($row,$column) = $info.DNSHostName
    $column++
    $sheet.Cells.Item($row,$column) = $info.ipv4address
    #$column++
       #Switch($info.Enabled){
        #True{$Enabled = "Enabled"; $sheet.Cells.Item($row,$column).Interior.ColorIndex = 4}
        #False{$Enabled = "Disabled"; $sheet.Cells.Item($row,$column).Interior.ColorIndex = 3}
    #}
    $sheet.Cells.Item($row,$column) = $Enabled
    $row++
    $column = 1
}
  $row--
  $dataRange = $sheet.Range(("A{0}" -f $initalRow),("c{0}"  -f $row))
  7..12 | ForEach {
      $dataRange.Borders.Item($_).LineStyle = 1
      $dataRange.Borders.Item($_).Weight = 2
}
#Fits cells to size
  $UsedRange = $sheet.UsedRange
  $UsedRange.EntireColumn.autofit() | Out-Null

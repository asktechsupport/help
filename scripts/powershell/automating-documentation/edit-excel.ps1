# Create Excel COM object
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $true  # Set to $true if you want to see Excel open

# Open existing workbook
$workbook = $excel.Workbooks.Open("C:\Users\Max.Haley\Downloads\excel.xlsx")
$sheet = $workbook.Sheets.Item(1)  # Use the first sheet

# Example: Add a new line of data at the next empty row
$row = $sheet.UsedRange.Rows.Count + 1
$sheet.Cells.Item($row, 1).Value2 = "New Value 1"
$sheet.Cells.Item($row, 2).Value2 = "New Value 2"
$sheet.Cells.Item($row, 3).Value2 = "New Value 3"

# Example: Edit an existing cell (e.g., row 2, column 1)
$sheet.Cells.Item(2, 1).Value2 = "Updated Value"

# Save and close
$workbook.Save()
$workbook.Close($false)

# Release COM objects
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet)
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook)
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
[GC]::Collect()
[GC]::WaitForPendingFinalizers()

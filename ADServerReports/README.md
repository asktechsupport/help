AD Server Reporting Tool

How to 
add additional columns
1) Find this line  #📁create Headers for your sheet
2) Copy from the Copy from the $column++ variable to the end of the .Font.Bold = $true variable
3) Rename the strings which are denoted in double quotes, e.g. "Hostname"

add additional server properties
1) Find this line #📁Get Server Properties to fill out the worksheet columns
2) Copy from the $column++ variable to the end of the $info.<property> variable
3) Check the new property you need to add using Get-ADComputer -Properties
4) Add to the $info variable after '-Properties', comma separated

    ($info = Get-ADComputer -Identity $($i.name) -Properties **<add properties here like Name, ipv4address etc>**

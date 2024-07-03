Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
 # Ensure the ImportExcel module is installed
if (-Not (Get-Module -ListAvailable -Name ImportExcel)) {
   Install-Module -Name ImportExcel -Scope CurrentUser -Force
}
 
# Define the vars you'll need
    $site = "https://asktechsupport.atlassian.net"
    $email = "help@asktechsupport.co.uk"
    $plainText = "${email}:${apiKey}" # Combine email and API key with a colon
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($plainText)) # Encode the combined string in base64
    # Set up headers
    $headers = @{
       Authorization = "Basic $base64AuthInfo"
       Accept = "application/json"
       ContentType = "application/json"
    }
    $groupnames = "$site/rest/api/3/groups/picker?expand=groups" | select name
    # Define the Jira API endpoint
    $getgroupmembersapi = "$site/rest/api/3/group/member?maxResults=250&groupname=group1&includeInactiveUsers=false" | select values | foreach { $_.values} | select -ExpandProperty emailAddress
    $getgroupmembers = $getgroupmembersapi
# Define the location of the spreadsheet
$jiragroupsxlsx = "C:\Users\$env:USERNAME\Downloads\temp\Jira Groups.xlsx"
$openspreadsheet = $jiragroupsxlsx
 
# Make the API request
$callgetgroupmembers = Invoke-RestMethod -Uri $getgroupmembersapi -Method Get -Headers $headers | select values | foreach { $_.values} | select -ExpandProperty emailAddress
 
# Check if the Excel file exists; create it if it does not
        if (-Not (Test-Path $jiragroupsxlsx)) {
           New-ExcelWorkbook -Path $jiragroupsxlsx
            }
 
$members = $callgetgroupmembers | foreach-object {
   [pscustomobject]@{GroupName = "$groupnames"; EmailAddress = $_}
}

$members | Export-Excel -Path $jiragroupsxlsx
 
 
# Output the response
Start $openspreadsheet

January 2025
- [x] **Tested** in an enterprise environment
```powershell
# Import the GroupPolicy module
Import-Module GroupPolicy

# Define the search string
$searchString = "Use the specified Remote Desktop license servers"

# Get all GPOs in the domain
$allGPOs = Get-GPO -All

# Search through each GPO's report for the setting
foreach ($gpo in $allGPOs) {
    $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml
    if ($report -match $searchString) {
        Write-Host "Match found in: $($gpo.DisplayName)" -ForegroundColor Green
    }
}
```

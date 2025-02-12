January 2025
- [x] **Tested** in an enterprise environment
```powershell
# Import the GroupPolicy module
Import-Module GroupPolicy

# Define the search strings
$searchStrings = @(
    "Set time limit for active but idle Remote Desktop Services sessions"
    "Set time limit for disconnected sessions"
    "End session when time limits are reached"
)

# Get all GPOs in the domain
$allGPOs = Get-GPO -All

# Search through each GPO's report for the settings
foreach ($gpo in $allGPOs) {
    $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml
    foreach ($searchString in $searchStrings) {
        if ($report -match $searchString) {
            Write-Host "Match found for '$searchString' in: $($gpo.DisplayName)" -ForegroundColor Green
        }
    }
}
```

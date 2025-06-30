# Define source and destination paths
$source = "C:\Path\To\Source"
$destination = "C:\Path\To\Destination"

# Ensure destination exists
if (-not (Test-Path -Path $destination)) {
    New-Item -ItemType Directory -Path $destination -Force
}

# Copy all child files (not folders), overwriting without prompt
Get-ChildItem -Path $source -File -Recurse | ForEach-Object {
    $targetPath = Join-Path -Path $destination -ChildPath $_.Name
    Copy-Item -Path $_.FullName -Destination $targetPath -Force
}

Get-ChildItem -Path "C:\Program Files (x86)" -Recurse -ErrorAction SilentlyContinue |
    Where-Object {
        $_.PSIsContainer -eq $false -and
        $_.Name -like "*PrepareBaseImage*"
    } |
    Select-Object -ExpandProperty FullName

    
    # Run the script as administrator
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$($bisfScript.FullName)`"" -Verb RunAs
} else {
    Write-Host "PrepareBaseImage.ps1 not found in BIS-F directory." -ForegroundColor Red
}

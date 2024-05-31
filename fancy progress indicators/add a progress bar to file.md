#v3 - silent installs, either MSI's or exe's, progress bar displayed for each file

```
cd C:\AutomatedInstalls
#📁vars

$msi = @(gci -Path C:\AutomatedInstalls | Where {$_.Name -like "*.msi"})

$exe = @(gci -Path C:\AutomatedInstalls | Where {$_.Name -like "*.exe"})

$msicounter = 1
$execounter = 1


#📢Script Instructions
    foreach ($file in $msi) {
        Write-Progress -Activity "Installing MSI files" -Status "$($file.Name) in progress..." -PercentComplete (($msicounter / $msi.Count) * 100)
        saps $file /quiet -Wait
        $msicounter++
        }
    foreach ($file in $exe) {
        Write-Progress -Activity "Installing .exe files" -Status "$($file.Name) in progress..." -PercentComplete (($execounter / $exe.Count) * 100)
        saps $file /S -Wait
        $execounter++
        }

#Explanation
#get each item in the folder (get-child item = gci) where the files end in .msi
#for each file in the array variable ($msi or $exe)
#saps (start-process) on each of the files.
#msi and exe counters allow for either msi's or exi's
#display a progress bar for each of the files
```


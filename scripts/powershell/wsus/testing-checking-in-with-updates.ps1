# Force the WSUS client to check in with the WSUS server
(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()

# Report the status to the WSUS server
Start-Process -FilePath "wuauclt.exe" -ArgumentList "/reportnow"

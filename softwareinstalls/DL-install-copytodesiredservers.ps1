[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$homeUrl = 'https://notepad-plus-plus.org'
$res = Invoke-WebRequest -UseBasicParsing $homeUrl
if ($res.StatusCode -ne 200) {throw ("status code to getDownloadUrl was not 200: "+$res.StatusCode)}
$tempUrl = ($res.Links | Where-Object {$_.outerHTML -like "*Current Version *"})[0].href
if ($tempUrl.StartsWith("/")) { $tempUrl = "$homeUrl$tempUrl" }
$res = Invoke-WebRequest -UseBasicParsing $tempUrl
if ($res.StatusCode -ne 200) {throw ("status code to getDownloadUrl was not 200: "+$res.StatusCode)}
$dlUrl = ($res.Links | Where-Object {$_.href -like "*x64.exe"})[0].href
if ($dlUrl.StartsWith("/")) { $dlUrl = "$homeUrl$dlUrl" }
$installerPath = Join-Path $env:TEMP (Split-Path $dlUrl -Leaf)
Invoke-WebRequest $dlUrl -OutFile $installerPath
Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
start $env:TEMP

Copy-Item -Path $installerPath -Destination \\hostname\C$\temp;

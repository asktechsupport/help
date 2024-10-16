# Notes - not tested
#StartScript
# Retrieve the certificate hash
$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*-ctrx-con*" }
$certHash = $cert.Thumbprint
Write-Host "Certificate Hash: $certHash"
# Retrieve the application ID
$appId = netsh http show sslcert ipport=0.0.0.0:443 | Select-String -Pattern "Application ID" | ForEach-Object { $_.Line.Split("{").Split("}") }
Write-Host "Application ID: $appId"
netsh http delete sslcert ipport=0.0.0.0:443
netsh http add sslcert ipport=0.0.0.0:443 certhash=‎$certHash appid={$appId} 
#EndScript

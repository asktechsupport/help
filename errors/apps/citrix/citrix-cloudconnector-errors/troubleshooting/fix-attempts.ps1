<# 
.SYNOPSIS
  Auto-remediates CTX223828 on a Citrix Cloud Connector:
  - Locates Citrix Cloud Connector executables/services
  - Reads Authenticode signer chain (no hard-coded CNs or URLs)
  - Follows AIA "CA Issuers" to fetch issuer/intermediate/root certs
  - Installs missing certs to LocalMachine\CA (Intermediates) and LocalMachine\Root
  - Verifies CRL Distribution Point reachability over HTTP
  - Writes a detailed report and exit code

.NOTES
  Run elevated on any Citrix Cloud Connector server.
#>

# region Helpers
$ErrorActionPreference = 'Stop'

function Write-Info($msg){ Write-Host "[INFO] $msg" }
function Write-Warn($msg){ Write-Warning $msg }
function Write-Err ($msg){ Write-Error $msg }

# Ensure modern TLS
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls13

# Start transcript (best-effort)
$logRoot = Join-Path $env:ProgramData 'Citrix\WorkspaceCloud\Logs'
if (-not (Test-Path $logRoot)) { New-Item -ItemType Directory -Force -Path $logRoot | Out-Null }
$stamp = (Get-Date).ToString('yyyyMMdd-HHmmss')
$logFile = Join-Path $logRoot "CTX223828-Fix-$stamp.log"
try { Start-Transcript -Path $logFile -ErrorAction Stop | Out-Null } catch {}

# Decode AIA (Authority Information Access) and CDP (CRL Distribution Points)
function Get-AiaUrls([System.Security.Cryptography.X509Certificates.X509Certificate2]$Cert){
  $oidAia = '1.3.6.1.5.5.7.1.1'
  $urls = @()
  foreach($ext in $Cert.Extensions){
    if($ext.Oid.Value -eq $oidAia){
      # Basic DER parse for "CA Issuers - URI"
      $raw = $ext.RawData
      # Use .NET AsnEncodedData formatter to get text and parse URIs
      $fmt = New-Object System.Security.Cryptography.AsnEncodedData $ext.Oid,$raw
      $urls += ([regex]::Matches($fmt.Format($true),'https?://\S+')).Value
    }
  }
  # Keep only CA Issuers URLs (usually .crt/.cer)
  $urls | Where-Object { $_ -match '/.+\.(crt|cer)(\?|$)' } | Select-Object -Unique
}

function Get-CdpUrls([System.Security.Cryptography.X509Certificates.X509Certificate2]$Cert){
  $oidCdp = '2.5.29.31'
  $urls = @()
  foreach($ext in $Cert.Extensions){
    if($ext.Oid.Value -eq $oidCdp){
      $fmt = New-Object System.Security.Cryptography.AsnEncodedData $ext.Oid,$ext.RawData
      $urls += ([regex]::Matches($fmt.Format($true),'http://\S+')).Value
    }
  }
  $urls | Select-Object -Unique
}

function Import-CertIfMissing([System.Security.Cryptography.X509Certificates.X509Certificate2]$Cert, [string]$StoreName){
  $store = New-Object System.Security.Cryptography.X509Certificates.X509Store($StoreName,'LocalMachine')
  $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
  try{
    $exists = $store.Certificates | Where-Object { $_.Thumbprint -eq $Cert.Thumbprint }
    if(-not $exists){
      Write-Info "Installing cert '$($Cert.Subject)' to LocalMachine\$StoreName"
      $store.Add($Cert)
      return $true
    } else {
      Write-Info "Cert already present in LocalMachine\${StoreName}: $($Cert.Subject)"
      return $false
    }
  } finally { $store.Close() }
}

function Download-CertFromUrl([string]$Url){
  Write-Info "Downloading certificate: $Url"
  $tmp = New-TemporaryFile
  Invoke-WebRequest -Uri $Url -OutFile $tmp.FullName -UseBasicParsing -MaximumRedirection 5
  # Some endpoints return DER/PEM; handle both
  $bytes = [System.IO.File]::ReadAllBytes($tmp.FullName)
  # If PEM, strip headers
  $text = [System.Text.Encoding]::ASCII.GetString($bytes)
  if($text -match '-----BEGIN CERTIFICATE-----'){
    $pem = ($text -replace '-----BEGIN CERTIFICATE-----','' -replace '-----END CERTIFICATE-----','').Trim()
    $bytes = [Convert]::FromBase64String(($pem -replace '\s',''))
  }
  $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($bytes)
  return $cert
}

function Build-And-FixChain([System.Security.Cryptography.X509Certificates.X509Certificate2]$Leaf){
  $added = 0
  $visited = @{}
  $current = $Leaf

  while($true){
    # If self-signed, we're at a (likely) root
    $selfSigned = $current.Subject -eq $current.Issuer

    # Ensure current is in an appropriate store
    if($selfSigned){
      $added += [int](Import-CertIfMissing -Cert $current -StoreName 'Root')
      break
    } else {
      # Intermediates belong to CA store
      $added += [int](Import-CertIfMissing -Cert $current -StoreName 'CA')
    }

    # Fetch issuer via AIA
    $aia = Get-AiaUrls $current
    if(-not $aia -or $aia.Count -eq 0){
      Write-Warn "No AIA 'CA Issuers' URL found for: $($current.Subject). Attempting to stop here."
      break
    }

    # Avoid loops and try each AIA until success
    $next = $null
    foreach($url in $aia){
      if($visited.ContainsKey($url)){ continue }
      $visited[$url] = $true
      try {
        $issuer = Download-CertFromUrl $url
        # If we already have this in store, fine, but still move up chain.
        $next = $issuer
        break
      } catch {
        Write-Warn "Failed to download issuer from $url : $($_.Exception.Message)"
      }
    }
    if(-not $next){ Write-Warn "Could not retrieve issuer certificate for $($current.Subject)"; break }

    $current = $next
  }

  return $added
}

function Test-CrlReachability([System.Security.Cryptography.X509Certificates.X509Certificate2]$Cert){
  $cdps = Get-CdpUrls $Cert
  $allOk = $true
  foreach($url in $cdps){
    try{
      $resp = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -TimeoutSec 20
      if($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 400){
        Write-Info "CRL reachable: $url ($($resp.StatusCode))"
      } else {
        Write-Warn "CRL returned non-success status: $url ($($resp.StatusCode))"
        $allOk = $false
      }
    } catch {
      Write-Warn "CRL unreachable: $url : $($_.Exception.Message)"
      $allOk = $false
    }
  }
  return $allOk
}
# endregion Helpers

# region Locate Citrix-signed binaries on this Cloud Connector
Write-Info "Locating Citrix Cloud Connector services and signed binaries..."
$citrixServices = Get-CimInstance Win32_Service | Where-Object {
  $_.Name -like 'Citrix Cloud *' -or $_.DisplayName -like 'Citrix Cloud *' -or $_.Name -like 'Citrix WEM Cloud*'
}

$exePaths = @()
foreach($svc in $citrixServices){
  if([string]::IsNullOrWhiteSpace($svc.PathName)){ continue }
  # Extract executable path even if quoted/with args
  $path = $svc.PathName
  if($path.StartsWith('"')){
    $path = $path.Split('"')[1]
  } else {
    $path = $path.Split(' ')[0]
  }
  if(Test-Path $path){ $exePaths += $path }
}

# Add a couple of known folders to broaden search (no hard-coded filenames)
$likelyRoots = @(
  'C:\Citrix',
  'C:\Program Files\Citrix',
  'C:\Program Files (x86)\Citrix',
  'C:\Program Files\Citrix\Broker\Service',
  'C:\Program Files\Citrix\CloudServices'
) | Where-Object { Test-Path $_ }

foreach($root in $likelyRoots){
  Get-ChildItem -Path $root -Recurse -Include *.exe -ErrorAction SilentlyContinue |
    ForEach-Object { $exePaths += $_.FullName }
}
$exePaths = $exePaths | Select-Object -Unique

if(-not $exePaths){ 
  Write-Err "Could not find any Citrix executables. Are you running on a Cloud Connector?"
  exit 2
}

# Filter to executables signed by Citrix (Authenticode)
$citrixSigned = @()
foreach($p in $exePaths){
  try{
    $sig = Get-AuthenticodeSignature -FilePath $p
    if($sig -and $sig.SignerCertificate -and $sig.Status -in 'Valid','NotSigned','Unknown'){
      # Keep only if signed and publisher contains 'Citrix' OR if file lives in Citrix path
      if($sig.SignerCertificate.Subject -match 'Citrix' -or $p -match '\\Citrix\\'){
        $citrixSigned += [pscustomobject]@{ Path=$p; Cert=$sig.SignerCertificate }
      }
    }
  } catch {}
}
$citrixSigned = $citrixSigned | Sort-Object Path -Unique
if(-not $citrixSigned){
  Write-Err "No Citrix-signed executables were discovered."
  exit 3
}

Write-Info ("Found {0} Citrix-signed executables" -f $citrixSigned.Count)
# endregion

# region Ensure full chain is in the machine stores
$addedCount = 0
$testedCrl  = $true

# Work against the *newest* signer we see (usually includes newest chain); still iterate all
foreach($item in $citrixSigned){
  $leaf = $item.Cert
  Write-Info "Processing signer for: $($item.Path)"
  $addedCount += (Build-And-FixChain -Leaf $leaf)

  # Validate CRL reachability for each element in the built chain (leaf + intermediates + root if available)
  $chain = New-Object System.Security.Cryptography.X509Certificates.X509Chain
  $chain.ChainPolicy.RevocationMode = [System.Security.Cryptography.X509Certificates.X509RevocationMode]::Online
  $chain.ChainPolicy.RevocationFlag = [System.Security.Cryptography.X509Certificates.X509RevocationFlag]::EntireChain
  $null = $chain.Build($leaf)
  foreach($elem in $chain.ChainElements){
    $ok = Test-CrlReachability $elem.Certificate
    if(-not $ok){ $testedCrl = $false }
  }
}

Write-Info "Certificates installed (this run): $addedCount"
if($testedCrl){
  Write-Info "All discovered CRL endpoints were reachable over HTTP."
} else {
  Write-Warn "One or more CRL endpoints were NOT reachable. Check proxy/firewall for outbound HTTP (port 80) as per CTX223828."
}

# endregion

# region Final chain validation summary
# Try to validate Authenticode chains now that stores are updated
$fail = $false
foreach($item in $citrixSigned){
  $sig = Get-AuthenticodeSignature -FilePath $item.Path
  if($sig.Status -ne 'Valid'){
    Write-Warn "Authenticode not fully valid yet for: $($item.Path) (Status: $($sig.Status))"
    $fail = $true
  } else {
    Write-Info "Authenticode valid: $($item.Path)"
  }
}

if($fail -or -not $testedCrl){
  Write-Warn "CTX223828 remediation partially completed. Review warnings above."
  try { Stop-Transcript | Out-Null } catch {}
  exit 1
} else {
  Write-Info "CTX223828 remediation completed successfully."
  try { Stop-Transcript | Out-Null } catch {}
  exit 0
}
# endregion

.\Fix-CTX223828.ps1 *>&1 | Tee-Object -FilePath "C:\Temp\ctx223828-run.log"


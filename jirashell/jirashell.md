# Interacting with Jira via PowerShell

## Get email addresses from a specified Group
```
# Define your email and API key
    $email = "first.last@email.com"
    $apiKey = ""
# Combine email and API key with a colon
    $plainText = "${email}:${apiKey}"
# Encode the combined string in base64
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($plainText))
# Set up headers
$headers = @{
   Authorization = "Basic $base64AuthInfo"
   Accept = "application/json"
   ContentType = "application/json"
}
# Define the Jira API endpoint
$url = "https://your-domain.atlassian.net/rest/api/3/group/member?groupname=MyGroup"
# Make the API request
$response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers | select values | foreach { $_.values} | select -ExpandProperty emailAddress
# Output the response
$response
```
Notes

* ⚠️site-admin is required
* set value "your-domain" to the name of your organisation or Jira instance
* set value "MyGroup" to the group name you want to check

# EG

```

```


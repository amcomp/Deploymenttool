#Authentication
$auth = Get-Content .\api.json | ConvertFrom-Json
$headers = @{
    "apikey"        = $auth.apikey
    "Authorization" = "Bearer $($auth.token)"
}

Write-Host "Fetching application manifest from cloud database..."
Invoke-RestMethod -Uri $auth.selectallURL -Headers $headers -Method Get
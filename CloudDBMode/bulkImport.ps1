# Load API credentials
$auth = Get-Content .\api.json | ConvertFrom-Json

$headers = @{
    "apikey"        = $auth.apikey
    "Authorization" = "Bearer $($auth.token)"
    "Content-Type"  = "application/json"
}

# Load local apps
$localApps = Get-Content .\database.json | ConvertFrom-Json

# Fetch remote apps from Supabase
$remoteApps = Invoke-RestMethod -Uri $auth.selectbyname -Headers $headers -Method Get

# Normalize remote names to lowercase for comparison
$remoteNames = $remoteApps.name | ForEach-Object { $_.ToLower() }

# Find apps in local that aren't in remote
$appsToUpload = $localApps | Where-Object {
    $localName = $_.DisplayName.ToLower()
    -not ($remoteNames -contains $localName)
}


# Upload the missing apps if any
if ($appsToUpload.count -eq 0) {
    Write-Host("JSON is Synced with Databse, nothing to upload")
} else {
    foreach ($app in $appsToUpload) {
        $applicationName = $app.DisplayName
        $method          = $app.Method
        $installLocation = $app.installLocation
        $installCommand  = $app.installCommand
    
    
        $body = @{
            "Name"            = $applicationName
            "Method"          = $method
            "installLocation" = $installLocation
            "installCommand"  = $installCommand
        } | ConvertTo-Json
        
        Invoke-RestMethod -Uri $auth.baseuri -Headers $headers -Method Post -Body $body -ContentType 'application/json'
        Write-Host "Uploaded $applicationName"
    }
}

$applicationName = Read-Host ("What is the name of the application you want to insert?")
$installLocation = Read-Host ("What is the install location of the application? (e.g., C:\Program Files\NewApp)")
$installCommand = Read-Host ("What is the install command for the application? (e.g., install newapp)")
$method = Read-Host ("What is the method of installation? (e.g., winget, chocolatey, etc.)")


#Authentication
$auth = Get-Content .\api.json | ConvertFrom-Json
$headers = @{
    "apikey"        = $auth.apikey
    "Authorization" = "Bearer $($auth.token)"
}

$body = @{
    "Name" = $applicationName
    "Method" = $method
    "installLocation" = $installLocation
    "installCommand" = $installCommand
} | ConvertTo-Json


$url = "https://mqnztceggwmcvymhzhaz.supabase.co/rest/v1/Applications"

Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Body $body


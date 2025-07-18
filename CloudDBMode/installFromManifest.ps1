#Authentication
$auth = Get-Content .\api.json | ConvertFrom-Json
$headers = @{
    "apikey"        = $auth.apikey
    "Authorization" = "Bearer $($auth.token)"
}

Write-Host "Fetching application manifest from cloud database..."
$Get = Invoke-RestMethod -Uri $auth.selectallURL -Headers $headers -Method Get

foreach ($path in $Get) {
    $Test = Test-Path ($path.installLocation)

    if ($Test -eq $false) {
       Start-Process winget $path.installCommand -NoNewWindow
    } else {
        Write-Host $($path.Name) "Already Exists"
    }
}

<# Validation function for installed applications 
This works a little differently than the installation process. It checks for the existece of applications first before trying to install them.
This is important for apps installed via winget, because if the app is already installed, winget will not try to update the app. 
If you want to update the app, you should run Install-Apps via .\main.ps1 -action Install.
#>
function Start-Validation {
    $apps = Get-Content '.\config\production.json' | ConvertFrom-Json
    foreach ($app in $apps) {
        $exist = Test-Path -Path $app.InstallLocation
    
        if (-not $exist) {
            Write-Host "Warning: $($app.DisplayName) is not installed."
            if ($app.Method -eq "winget") {
                Invoke-Expression "winget $($app.installCommand)"
            } elseif ($app.Method -eq "Executable") {
                Invoke-Expression "start-process -FilePath $($app.installCommand)"
            }
            
        } else {
            Write-Host "$($app.DisplayName) is installed."
        }
    }
}
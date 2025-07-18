
<#
.SYNOPSIS
    Installs or updates applications as specified in a configuration file.

.DESCRIPTION
    The Install-Apps function reads a JSON configuration file containing application details and installation methods.
    For each application, it determines the installation method (e.g., winget or executable) and executes the corresponding install command.
    If an unsupported installation method is specified, it notifies the user.

.PARAMETER None
    This function does not accept parameters. It reads application configuration from '.\config\production.json'.

.EXAMPLE
    Install-Apps
    Installs or updates all applications listed in the configuration file.

.NOTES
    The configuration file must be a JSON array of objects, each containing at least 'DisplayName', 'Method', and 'installCommand' properties.
#>
function Install-Apps {
    $apps = Get-Content '.\config\production.json' | ConvertFrom-Json

    foreach ($app in $apps) {
        Write-Host "Installing or Updating $($app.DisplayName)..."

        switch ($app.Method) {
            "winget" {
                Invoke-Expression "winget $($app.installCommand)"
            }
            "Executable" {
                Invoke-Expression start-process -FilePath $app.installCommand
            }
            Default {
                Write-Host "No valid installation method found for $($app.DisplayName)."
            }
        }
    }
}
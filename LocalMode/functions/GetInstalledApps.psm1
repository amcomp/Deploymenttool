<#
.SYNOPSIS
    Retrieves a list of installed applications on the local machine and exports it to a JSON file.

.DESCRIPTION
    The Get-InstalledApps function queries both 32-bit and 64-bit registry locations for installed applications.
    It selects the DisplayName property of each application, filters out entries without a DisplayName,
    and exports the resulting list to a JSON file named 'Manifest.json' in the '.\config' directory.

.OUTPUTS
    None. Outputs a JSON file containing the list of installed applications.

.EXAMPLE
    Get-InstalledApps

    This command retrieves the installed applications and writes them to '.\config\Manifest.json'.

.NOTES
    Requires appropriate permissions to read the registry and write to the output directory.
#>
function Get-InstalledApps {
    $installedApps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* ,
                                HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Select-Object DisplayName |
        Where-Object { $_.DisplayName } 
    
    $installedApps | ConvertTo-Json -Depth 3 | Out-File .\config\Manifest.json
}
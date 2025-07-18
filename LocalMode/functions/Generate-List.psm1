<#
.SYNOPSIS
    Compares entries between a database JSON file and a manifest JSON file, merges specific fields, and outputs the result.

.DESCRIPTION
    The Compare-DatabaseAndManifest function reads entries from 'database.json' and 'config\Manifest.json'.
    For each entry in the manifest, it searches for a matching entry in the database based on the DisplayName property (case-insensitive, trimmed).
    If a match is found, it merges the fields 'InstallLocation', 'installCommand', and 'Method' from the database entry into the manifest entry if they are missing or different.
    Only matched and merged entries are saved to 'config\production.json'.

.PARAMETER None
    This function does not take any parameters.

.INPUTS
    None. The function reads from files on disk.

.OUTPUTS
    None. The function writes the merged entries to 'config\production.json'.

.EXAMPLE
    Compare-DatabaseAndManifest

    This will compare the manifest and database, merge fields, and save the result to 'config\production.json'.
#>
function Compare-DatabaseAndManifest {
    $database = Get-Content '.\database.json' | ConvertFrom-Json
    $manifest = Get-Content '.\config\Manifest.json' | ConvertFrom-Json
    
    $fieldsToMerge = @("InstallLocation", "installCommand", "Method")
    $finalManifest = @()
    
    foreach ($entry in $manifest) {
        $key = $entry.DisplayName.Trim().ToLower()
        $dbEntry = $database | Where-Object { $_.DisplayName.Trim().ToLower() -eq $key }
    
        if ($dbEntry) {
            foreach ($field in $fieldsToMerge) {
                if (-not $entry.PSObject.Properties[$field]) {
                    $entry | Add-Member -MemberType NoteProperty -Name $field -Value $dbEntry.$field
                } elseif ($entry.$field -ne $dbEntry.$field) {
                    $entry.$field = $dbEntry.$field
                }
            }
            $finalManifest += $entry
        }
    }
    
    # Save only matched entries to production.json
    $finalManifest | ConvertTo-Json -Depth 10 | Set-Content '.\config\production.json'
}

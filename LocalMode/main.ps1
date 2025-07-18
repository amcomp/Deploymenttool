param (
    [string]$Action
)

# Loops the .\functions directory and imports all modules found there.
$imports = (Get-ChildItem -Path .\functions).Name
foreach ($module in $imports) {
    import-module .\functions\$module -Force
}

$configPath = Test-Path ".\config"
if (-not $configPath) {
    Write-Host "Error: Configuration folder not found at .\config"
    New-Item -ItemType Directory -Path .\config
}


switch ($Action) {
    "Extract" {
        Get-InstalledApps
        Compare-DatabaseAndManifest
    }
    "Install" {
        Install-Apps
    }
    Default {}
}



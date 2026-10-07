<#
.SYNOPSIS
    Syncs shared Valheim mods and configs from this repository into a Windows Valheim install.
.DESCRIPTION
    Copies mods\shared\plugins and mods\shared\config into the local BepInEx directory.
#>

[CmdletBinding()]
param (
    [string]$GamePath = ""
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot

if (-not $GamePath) {
    $DefaultPaths = @(
        "C:\Program Files (x86)\Steam\steamapps\common\Valheim",
        "D:\Steam\steamapps\common\Valheim",
        "E:\Steam\steamapps\common\Valheim",
        "C:\SteamLibrary\steamapps\common\Valheim",
        "D:\SteamLibrary\steamapps\common\Valheim",
        "E:\SteamLibrary\steamapps\common\Valheim"
    )

    foreach ($path in $DefaultPaths) {
        if (Test-Path "$path\BepInEx") {
            $GamePath = $path
            break
        }
    }
}

if (-not $GamePath -or -not (Test-Path "$GamePath\BepInEx")) {
    Write-Error "Could not locate Valheim BepInEx folder. Please provide the path:`n.\scripts\sync_client_windows.ps1 -GamePath 'C:\path\to\Valheim'"
    exit 1
}

$BepInExPlugins = Join-Path $GamePath "BepInEx\plugins"
$BepInExConfig  = Join-Path $GamePath "BepInEx\config"

Write-Host "=== Syncing Mods to Windows Valheim Client ===" -ForegroundColor Cyan
Write-Host "Target: $GamePath"

# Copy shared plugins
$SharedPlugins = Join-Path $RepoRoot "mods\shared\plugins"
if (Test-Path $SharedPlugins) {
    Write-Host "-> Copying shared plugins..."
    Copy-Item -Path "$SharedPlugins\*" -Destination $BepInExPlugins -Recurse -Force
}

# Copy shared config
$SharedConfig = Join-Path $RepoRoot "mods\shared\config"
if (Test-Path $SharedConfig) {
    Write-Host "-> Copying shared configs..."
    Copy-Item -Path "$SharedConfig\*" -Destination $BepInExConfig -Recurse -Force
}

Write-Host "`n Successfully synced mods to Windows Valheim!" -ForegroundColor Green
Write-Host "You can now start Valheim."

## get-panel-names.ps1
# This script retrieves the panel names for the current model.
# It's primarily used for testing and debugging purposes to quickly
# determine what panels are available for export.


# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Import common functions
$rootDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
Import-Module (Join-Path $rootDir "ps-modules/CommonFunctions.psm1") -Force

# Project paths
$modelFile = Join-Path $rootDir "model.scad"

# $openscadPath = 'C:\Program Files\OpenSCAD\openscad.exe'
$openscadPath = 'openscad'
$logFile = (Join-Path $rootDir "artifacts\openscad-console.log")

$panelNames = Get-PanelNames -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
Write-Output "Panel names found [$($panelNames.Count)]: $($panelNames -join ', ')"

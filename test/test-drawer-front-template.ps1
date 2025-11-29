# test-drawer-front-template.ps1
# This script tests the DrawerFrontTemplate panel export and verifies its hole metadata.

$ErrorActionPreference = "Stop"

$rootDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
Import-Module (Join-Path $rootDir "ps-modules/CommonFunctions.psm1") -Force

$modelFile = Join-Path $rootDir "model.scad"
$openscadPath = 'openscad'
$logFile = (Join-Path $rootDir "artifacts/openscad-console.log")
$modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
$exportDir = Join-Path $rootDir "export/$modelIdentifier"
$exportTypeDir = Join-Path $exportDir "dxf-raw"

$panelName = "DrawerFrontTemplate"
$exportType = "dxf"

$safePanelName = $panelName -replace '[\\/:"*?<>|]', '_'
$outputFile = Join-Path $exportTypeDir "$safePanelName.$exportType"
$csvFile = Join-Path $exportTypeDir "$safePanelName.csv"

Write-Output "Running test for $panelName ..."

# Execute export-panel.ps1
& powershell.exe -NoProfile -File (Join-Path $rootDir "test/export-panel.ps1") -panelName $panelName -exportType $exportType

# Verify DXF file exists
if (-not (Test-Path $outputFile)) {
    Write-Error "DXF file not found: $outputFile"
    exit 1
} else {
    Write-Output "DXF file found: $outputFile"
}

# Verify CSV file exists
if (-not (Test-Path $csvFile)) {
    Write-Error "CSV file not found: $csvFile"
    exit 1
} else {
    Write-Output "CSV file found: $csvFile"
}

# Verify handle hole entries in CSV
$csvContent = Get-Content $csvFile | ConvertFrom-Csv
$handleHoles = $csvContent | Where-Object { $_.HoleName -like "handle_*" }

if ($handleHoles.Count -eq 2) {
    Write-Output "Found 2 handle hole entries in CSV."
    # Further assertions can be added here if needed, e.g., checking coordinates or diameter
    # For now, just checking existence is sufficient.
} else {
    Write-Error "Expected 2 handle hole entries, but found $($handleHoles.Count)."
    exit 1
}

Write-Output "Test for $panelName passed."


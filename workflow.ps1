# workflow.ps1
#
# This script orchestrates the entire workflow for generating various outputs
# from the OpenSCAD model, including cut lists, DXF, STL, and SVG exports,
# and subsequent conversions to DWG and PDF formats.

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Project paths
$scriptDir = $PSScriptRoot
$modelFile = Join-Path $scriptDir "model.scad"
# Please set the path to your OpenSCAD executable here.
$openscadPath = "openscad"
$consoleLogPath = "artifacts\openscad-console.log"

function Get-ModelIdentifier {
    param(
        [string]$openscadPath,
        [string]$modelFile,
        [string]$logFile
    )

    & $openscadPath -o "artifacts/dummy.png" --imgsize="1,1" -D "generate_model_identifier=true" "$modelFile" 2>&1 | Out-File -FilePath $logFile -Encoding utf8

    # Read the console log file and process it
    $output = Get-Content $logFile
    $modelIdentifier = $output | Where-Object { $_.StartsWith("ECHO:") } | ForEach-Object { $_.Substring(6).Trim().Trim('"') }

    if ($modelIdentifier.Count -eq 0) {
        Write-Error "Error: Could not get model identifier from '$modelFile'."
        Write-Error "Please check the 'generate_model_identifier' functionality in the OpenSCAD script."
        exit 1
    }
    Write-Information "Model identifier: $modelIdentifier"
    return $modelIdentifier
}

$modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -consoleLogPath $consoleLogPath
$exportDir = Join-Path $scriptDir "export/$modelIdentifier"

.\generate-csv.ps1 -exportDir $exportDir
.\export-all.ps1 -exportDir $exportDir
.\run-split-layers.ps1 -exportDir $exportDir
.\convert-dxf-to-dwg.ps1 -exportDir $exportDir
.\convert-dxf-to-pdf.ps1 -exportDir $exportDir

# split-layers-dxf.ps1
#
# This script processes DXF files from the export/$modelIdentifier/dxf-raw directory
# using the split_layers.py script to separate geometry into CUT and DRILL layers.
# The processed files are saved in the export/$modelIdentifier/dxf directory.

param(
    [Parameter(Mandatory = $true)]
    [string]$exportDir = "export/default"
)

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Import common functions
$scriptDir = $PSScriptRoot
Import-Module (Join-Path $scriptDir "ps-modules/CommonFunctions.psm1")

# Validate parameters
Test-ExportDirectory -ExportDir $exportDir

# --- Configuration ---

# Set-PSDebug -Trace 1

$pythonPath = "python"

# --- Script ---

$inputDir = Join-Path $exportDir "dxf-raw"
$outputDir = Join-Path $exportDir "dxf"
$outputDirTemplate = Join-Path $exportDir "dxf-template"
$splitLayersScript = Join-Path $scriptDir "split_layers.py"

Write-Host "Input directory: $inputDir"
Write-Host "Output directory: $outputDir"
Write-Host "Output Template directory: $outputDirTemplate"
Write-Host "Python script: $splitLayersScript"

# Create output directory if it doesn't exist
Assert-DirectoryExists -Path $outputDir
Assert-DirectoryExists -Path $outputDirTemplate

# Get all DXF files from the input directory
$dxfFiles = Get-ChildItem -Path $inputDir -Filter *.dxf -Recurse

if ($dxfFiles.Count -eq 0) {
    Write-Output "No DXF files found in '$inputDir'."
    exit 0
}

Write-Output "Found $($dxfFiles.Count) DXF files to process."

# Loop through each DXF file and process it
foreach ($file in $dxfFiles) {
    $inputFile = $file.FullName
    $outputFile = Join-Path $outputDir $file.Name
    Write-Output "Processing '$($file.Name)' ... "

    # Execute the python script
    # Write-Output "$pythonPath $splitLayersScript $inputFile $outputFile 2>&1"
    & $pythonPath $splitLayersScript $inputFile $outputFile 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to process '$($file.Name)'. Please check the split_layers.py script."
        exit 1
    }

    # Create the template DXF file (no dimension, title, legend and no hole schedule)
    $outputFile = Join-Path $outputDirTemplate $file.Name
    # Execute the python script
    # Write-Output "$pythonPath $splitLayersScript $inputFile $outputFile 2>&1"
    & $pythonPath $splitLayersScript $inputFile $outputFile --template 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to process '$($file.Name)'. Please check the split_layers.py script."
        exit 1
    }
}

Write-Output "All DXF files processed successfully."

# Set-PSDebug -Trace 0

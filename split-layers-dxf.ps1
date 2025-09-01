# split-layers-dxf.ps1
#
# This script processes DXF files from the export/$modelIdentifier/dxf-raw directory
# using the split_layers.py script to separate geometry into CUT and DRILL layers.
# The processed files are saved in the export/$modelIdentifier/dxf directory.

param(
    [Parameter(Mandatory = $true)]
    [string]$exportDir = "export/default"
)

if ($exportDir -eq "export/default") {
    Write-Error "You have to specify an export directory with the -exportDir parameter."
    exit 1    
}

$scriptDir = $PSScriptRoot
$exportDir = Join-Path $scriptDir $exportDir

# --- Configuration ---

# Set-PSDebug -Trace 1

$pythonPath = "python"

# --- Script ---

$inputDir = Join-Path $exportDir "export/dxf-raw"
$outputDir = Join-Path $exportDir "export/dxf"
$splitLayersScript = Join-Path $scriptDir "split_layers.py"

# Create output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    Write-Output "Creating output directory at '$outputDir'"
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

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
    [System.Console]::Write("Processing '$($file.Name)' ... ")

    # Execute the python script
    & $pythonPath $splitLayersScript $inputFile $outputFile

    if ($LASTEXITCODE -eq 0) {
        Write-Output "OK"
    } else {
        Write-Output "FAILED"
        Write-Error "Failed to process '$($file.Name)'. Please check the split_layers.py script."
        exit 1
    }
}

Write-Output "All DXF files processed successfully."

# Set-PSDebug -Trace 0

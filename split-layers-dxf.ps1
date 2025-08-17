# split-layers-dxf.ps1
#
# This script processes DXF files from the artifacts/export/dxf directory
# using the split_layers.py script to separate geometry into CUT and DRILL layers.
# The processed files are saved in the artifacts/export/dxf-layered directory.

# --- Configuration ---

# Set-PSDebug -Trace 1

$pythonPath = "python"

# --- Script ---

$scriptDir = $PSScriptRoot
$inputDir = Join-Path $scriptDir "artifacts/export/dxf"
$outputDir = Join-Path $scriptDir "artifacts/export/dxf-layered"
$splitLayersScript = Join-Path $scriptDir "split_layers.py"

# Create output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    Write-Host "Creating output directory at '$outputDir'"
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Get all DXF files from the input directory
$dxfFiles = Get-ChildItem -Path $inputDir -Filter *.dxf -Recurse

if ($dxfFiles.Count -eq 0) {
    Write-Host "No DXF files found in '$inputDir'."
    exit 0
}

Write-Host "Found $($dxfFiles.Count) DXF files to process."

# Loop through each DXF file and process it
foreach ($file in $dxfFiles) {
    $inputFile = $file.FullName
    $outputFile = Join-Path $outputDir $file.Name
    Write-Host -NoNewline "Processing '$($file.Name)' ... "

    # Execute the python script
    & $pythonPath $splitLayersScript $inputFile $outputFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK"
    } else {
        Write-Host "FAILED" -ForegroundColor Red
        Write-Error "Failed to process '$($file.Name)'."
        exit 1
    }
}

Write-Host "All DXF files processed successfully."

# Set-PSDebug -Trace 0

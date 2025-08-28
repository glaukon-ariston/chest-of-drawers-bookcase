# convert-dxf-to-dwg.ps1
#
# This script converts DXF files to DWG format using the ODA File Converter.
# It expects the DXF files to be in a specific input directory and outputs
# the converted DWG files to a designated output directory.

# DXF to DWG Conversion
$scriptDir = $PSScriptRoot
$odaFileConverterPath = "D:\Program Files\ODA\ODAFileConverter26.7.0\ODAFileConverter.exe"
$dxfInputDir = Join-Path $scriptDir "artifacts/export/dxf"
$dwgOutputDir = Join-Path $scriptDir "artifacts/export/dwg"

# --- Batch Convert Layered DXF to DWG using ODA File Converter ---
if (-not (Test-Path $dwgOutputDir)) {
    Write-Output "Creating DWG output directory at '$dwgOutputDir'"
    New-Item -ItemType Directory -Path $dwgOutputDir | Out-Null
}

Write-Output "Starting batch conversion of DXF to DWG..."
$inputFileFilter = "*.dxf"
# Specific version codes:
# R12   = ACAD12
# R14   = ACAD14  
# R2000 = ACAD2000
# R2004 = ACAD2004
# R2007 = ACAD2007
$outputVersion = "ACAD2000" # Best for LibreCAD viewing
$recurseSubdirs = "0" # recurse subdirectories (0 = no, 1=yes)
$auditEachFile = "1" # audit each file (0 = no, 1=yes)
& $odaFileConverterPath $dxfInputDir $dwgOutputDir $outputVersion DWG $recurseSubdirs $auditEachFile $inputFileFilter

# Check the exit code of the last command
if ($LASTEXITCODE -eq 0) {
    Write-Output "Batch DXF to DWG conversion successful."
}
else {
    Write-Output "Batch DXF to DWG conversion FAILED with exit code $LASTEXITCODE."
    Write-Error "Failed to convert DXF files to DWG. Please check the ODA File Converter path, arguments, and ensure it's installed correctly."
    exit 1
}

Write-Output "All DXF files processed successfully."

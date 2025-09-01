# export-panels.ps1
#
# This script automates the export of all panels from the model.scad file
# to the export/$modelIdentifier directory.

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("dxf", "stl", "svg")]
    [string]$exportType = "dxf",
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

# Project paths
$modelFile = Join-Path $scriptDir "model.scad"
# Please set the path to your OpenSCAD executable here.
$openscadPath = "openscad"
$logFile = Join-Path $exportDir "log/openscad-console.log"
 
# --- Script ---

Initialize-LogFile -logFile $logFile

# Check if OpenSCAD executable exists
#if (-not (Test-Path $openscadPath)) {
#    Write-Output "Error: OpenSCAD executable not found at '$openscadPath'."
#    Write-Output "Please update the `$openscadPath variable in this script."
#    exit 1
#}

if ($exportType -eq "dxf") {
    $exportTypeDir = Join-Path $exportDir "dxf-raw"
} else {
    $exportTypeDir = Join-Path $exportDir $exportType
}

# Create export directory if it doesn't exist
Assert-DirectoryExists -Path $exportTypeDir

$panelNames = Get-PanelNames -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
Write-Output "Found $($panelNames.Count) panels to export."
Write-Output "Panel names found: $($panelNames -join ', ')"

# Loop through panel names and export DXF|STL files
foreach ($panelName in $panelNames) {
    $safePanelName = $panelName -replace '[\\/:"*?<>|]', '_' # Sanitize file name
    $outputFile = Join-Path $exportTypeDir "$safePanelName.$exportType"

    # Make the output path relative for cleaner logging
    $relativeOutputFile = Get-RelativePath -Base $exportDir -TargetPath $outputFile
    Write-Output "Exporting '$panelName' to '$relativeOutputFile' ... "
    
    # Execute OpenSCAD and capture any output (including errors from stderr)
    # "openscad" -o "artifacts\export\dummy-cmd.dxf" -D "export_panel_name=\"CorpusSideRight\"" model.scad
    # "openscad" -o "artifacts\export\dummy-ps.dxf" -D "export_panel_name=`"CorpusSideRight`"" model.scad
    # This parameter passing scheme took whole day to figure out. PowerShell quoting behaviour sucks!
    $export_panel_name = 'export_panel_name=\"' + $panelName + '\"'
    $export_type = 'export_type=\"' + $exportType + '\"'
    & $openscadPath -o "$outputFile" -D "$export_panel_name" -D "$export_type" "$modelFile" 2>&1 | Out-File -FilePath $logFile -Encoding utf8

    # Check the exit code of the last command
    if ($LASTEXITCODE -eq 0) {
        # --- Create Hole Metadata CSV ---
        $holeMetadata = Get-Content $logFile | Where-Object { $_.StartsWith('ECHO: "Hole,') } | ForEach-Object { $_.Substring(6).Trim('"') }
        if ($holeMetadata.Count -gt 0) {
            $csvFile = Join-Path $exportTypeDir "$safePanelName.csv"
            $csvContent = @("PanelName,HoleName,X,Y,Z,Diameter,Depth")
            $holeMetadata | ForEach-Object {
                $line = $_ -replace 'Hole,', ''
                $csvContent += $line
            }
            $relativeCsvFile = Get-RelativePath -Base $exportDir -TargetPath $csvFile
            $csvContent | Out-File -FilePath $csvFile -Encoding utf8
            Write-Output "  -> Created hole metadata file: $relativeCsvFile"
        }
    } else {
        Write-Output "FAILED with exit code $LASTEXITCODE"
        Write-Error "OpenSCAD failed to export '$panelName'."
        # Read the console log file and process it
        $openscadOutput = Get-Content $logFile
        $openscadOutput | ForEach-Object { Write-Error $_ }
        # Stop the script on the first error
        exit 1 # I've uncommented this to stop the script on the first failure.
    }
}

Write-Output "All panels exported successfully to '$exportTypeDir'"

# Set-PSDebug -Trace 0

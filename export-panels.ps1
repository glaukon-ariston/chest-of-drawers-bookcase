# export-panels.ps1
#
# This script automates the export of all panels from the model.scad file
# to the artifacts/export directory.

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("dxf", "stl", "svg")]
    [string]$exportType = "svg"
)

# --- Configuration ---

# Set-PSDebug -Trace 1

# Please set the path to your OpenSCAD executable here.
$openscadPath = "openscad"
$consoleLogPath = "artifacts\openscad-console.log"

# --- Script ---

# Check if OpenSCAD executable exists
#if (-not (Test-Path $openscadPath)) {
#    Write-Host "Error: OpenSCAD executable not found at '$openscadPath'."
#    Write-Host "Please update the `$openscadPath variable in this script."
#    exit 1
#}

# Project paths
$scriptDir = $PSScriptRoot
$modelFile = Join-Path $scriptDir "model.scad"
$exportDir = Join-Path $scriptDir "artifacts/export/$exportType"

# Create export directory if it doesn't exist
if (-not (Test-Path $exportDir)) {
    Write-Host "Creating export directory at '$exportDir'"
    New-Item -ItemType Directory -Path $exportDir | Out-Null
}

# Get panel names from model.scad
Write-Host "Getting panel names from '$modelFile' ..."
# "openscad" -o "artifacts\export\dummy.png" --imgsize="1,1" -D "generate_panel_names_list=true" model.scad
& $openscadPath -o "artifacts/dummy.png" --imgsize="1,1" -D "generate_panel_names_list=true" --debug=all "$modelFile" 2>&1 | Out-File -FilePath $consoleLogPath -Encoding utf8
# Read the console log file and process it
$output = Get-Content $consoleLogPath
$panelNames = $output | Where-Object { $_.StartsWith("ECHO:") } | ForEach-Object { $_.Substring(6).Trim().Trim('"') }

if ($panelNames.Count -eq 0) {
    Write-Host "Error: Could not get panel names from '$modelFile'."
    Write-Host "Please check the 'generate_panel_names_list' functionality in the OpenSCAD script."
    exit 1
}

Write-Host "Found $($panelNames.Count) panels to export."
Write-Host "Panel names found: $($panelNames -join ', ')"

# Loop through panel names and export DXF|STL files
foreach ($panelName in $panelNames) {
    $safePanelName = $panelName -replace '[\\/:"*?<>|]', '_' # Sanitize file name
    $outputFile = Join-Path $exportDir "$safePanelName.$exportType"
    Write-Host -NoNewline "Exporting '$panelName' to '$outputFile' ... "

    # Execute OpenSCAD and capture any output (including errors from stderr)
    # "openscad" -o "artifacts\export\dummy-cmd.dxf" -D "export_panel_name=\"CorpusSideRight\"" model.scad
    # "openscad" -o "artifacts\export\dummy-ps.dxf" -D "export_panel_name=`"CorpusSideRight`"" model.scad
    # This parameter passing scheme took whole day to figure out. PowerShell quoting behaviour sucks!
    $export_panel_name = 'export_panel_name=\"' + $panelName + '\"'
    $export_type = 'export_type=\"' + $exportType + '\"'
    & $openscadPath -o "$outputFile" -D "$export_panel_name" -D "$export_type" --debug=all "$modelFile" 2>&1 | Out-File -FilePath $consoleLogPath -Encoding utf8

    # Check the exit code of the last command
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK"

        # --- Create Hole Metadata CSV ---
        $holeMetadata = Get-Content $consoleLogPath | Where-Object { $_.StartsWith('ECHO: "Hole,') } | ForEach-Object { $_.Substring(6).Trim('"') }
        if ($holeMetadata.Count -gt 0) {
            $csvFile = Join-Path $exportDir "$safePanelName.csv"
            $csvContent = @("PanelName,HoleName,X,Y,Diameter,Depth")
            $holeMetadata | ForEach-Object {
                $line = $_ -replace 'Hole,', ''
                $csvContent += $line
            }
            $csvContent | Out-File -FilePath $csvFile -Encoding utf8
            Write-Host "  -> Created hole metadata file: $csvFile"
        }
    } else {
        Write-Host "FAILED" -ForegroundColor Red
        Write-Error "OpenSCAD failed to export '$panelName'."
        # Read the console log file and process it
        $openscadOutput = Get-Content $consoleLogPath
        $openscadOutput | ForEach-Object { Write-Error $_ }
        # Stop the script on the first error
        exit 1 # I've uncommented this to stop the script on the first failure.
    }
}

Write-Host "All panels exported successfully to '$exportDir'"

# Set-PSDebug -Trace 0

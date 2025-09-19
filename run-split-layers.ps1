# run-split-layers.ps1
#
# This script executes the split-layers-dxf.ps1 script and logs the output.
#
# e.g.
# .\run-split-layers.ps1 -exportDir export\H2300xW600xD230_Mm19_Ms12
# .\run-split-layers.ps1 -exportDir export\H2300xW600xD230_Mm18_Ms12

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

$scriptDir = $PSScriptRoot
$logFile = Join-Path $exportDir "log/split-layers-dxf.log"

Initialize-LogFile -LogFile $logFile

# Execute the script and tee the output to the log file
Write-Output "Executing split-layers-dxf.ps1 ..."
& (Join-Path $scriptDir "split-layers-dxf.ps1") -ExportDir $exportDir 2>&1 | Tee-Object -FilePath $logFile -Append

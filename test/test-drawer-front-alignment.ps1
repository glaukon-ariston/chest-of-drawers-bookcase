# test/test-drawer-front-alignment.ps1
$ErrorActionPreference = "Stop"
$rootDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
Import-Module (Join-Path $rootDir "ps-modules/CommonFunctions.psm1") -Force

$modelFile = Join-Path $rootDir "model.scad"
$openscadPath = 'openscad' 
$logFile = (Join-Path $rootDir "artifacts\openscad-console.log")

$modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
$exportDir = Join-Path $rootDir "export/$modelIdentifier"
$csvDir = Join-Path $exportDir "dxf-raw"

function Get-PanelHoles($panelName) {
    $exportScript = Join-Path $rootDir "test\export-panel.ps1"
    & $exportScript -panelName $panelName -exportType dxf | Out-Null
    $csvPath = Join-Path $csvDir "$panelName.csv"
    $csvData = Import-Csv $csvPath
    return $csvData
}

Write-Output "Testing Drawer Front X Alignment..."

# 1. Drawer Side Left
$frontHoles = Get-PanelHoles "DrawerFrontStandard"
$frontLeft1 = $frontHoles | Where-Object { $_.HoleName -eq "left_side_1" }
$frontRight1 = $frontHoles | Where-Object { $_.HoleName -eq "right_side_1" }

# Constants from model_info
$frontWidth = 597
$drawerWidth = 538
$thickness = 10

$expectedLeftX = ($frontWidth - $drawerWidth) / 2 + $thickness / 2
$expectedRightX = $frontWidth - $expectedLeftX
$expectedBottom1X = ($frontWidth - $drawerWidth) / 2 + $thickness + 50

Write-Output "  Expected Left X: $expectedLeftX"
Write-Output "  Actual Left X: $($frontLeft1.X)"
Write-Output "  Expected Right X: $expectedRightX"
Write-Output "  Actual Right X: $($frontRight1.X)"
Write-Output "  Expected Bottom 1 X: $expectedBottom1X"

$frontBottom1 = $frontHoles | Where-Object { $_.HoleName -eq "bottom_panel_1" }
Write-Output "  Actual Bottom 1 X: $($frontBottom1.X)"

if ([double]$frontLeft1.X -ne $expectedLeftX) { 
    Write-Error "Left side X mismatch: expected $expectedLeftX, got $($frontLeft1.X)" 
}
if ([double]$frontRight1.X -ne $expectedRightX) { 
    Write-Error "Right side X mismatch: expected $expectedRightX, got $($frontRight1.X)" 
}
if ([double]$frontBottom1.X -ne $expectedBottom1X) {
    Write-Error "Bottom panel 1 X mismatch: expected $expectedBottom1X, got $($frontBottom1.X)"
}

Write-Output "PASSED: X Alignment"

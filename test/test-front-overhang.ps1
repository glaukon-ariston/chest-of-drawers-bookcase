# test/test-front-overhang.ps1
# This script verifies that the drawer front holes are correctly offset 
# to account for the front overhang and bottom drawer offset.
# It checks standard, top, and bottom drawer fronts, as well as templates.

$ErrorActionPreference = "Stop"
$rootDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
Import-Module (Join-Path $rootDir "ps-modules/CommonFunctions.psm1") -Force

$modelFile = Join-Path $rootDir "model.scad"
# Assuming 'openscad' is in the PATH, otherwise adjust or read from config
$openscadPath = 'openscad' 
$logFile = (Join-Path $rootDir "artifacts\openscad-console.log")

# Get model identifier to find export path
$modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
$exportDir = Join-Path $rootDir "export/$modelIdentifier"
$csvDir = Join-Path $exportDir "dxf-raw"

Write-Output "Testing Front Overhang Logic..."
Write-Output "Model Identifier: $modelIdentifier"
Write-Output "CSV Directory: $csvDir"

# Function to run export and get CSV content
function Get-PanelHoles($panelName) {
    Write-Output "  Exporting $panelName..."
    # Call export-panel.ps1. We use Start-Process to run it as a separate PowerShell instance to ensure clean state
    # or just use invoke-expression / & operator. 
    # Since export-panel.ps1 is in the same dir as this script (conceptually), we construct path.
    $exportScript = Join-Path $rootDir "test\export-panel.ps1"
    
    # We use & to execute in current scope or create a sub-process. 
    # To keep it simple and avoid pollution, a sub-process is fine, but '&' is faster.
    # Let's use '&' but redirect output to null to keep console clean, unless error.
    
    & $exportScript -panelName $panelName -exportType dxf | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Export failed for $panelName"
    }

    $csvPath = Join-Path $csvDir "$panelName.csv"
    if (-not (Test-Path $csvPath)) {
        Write-Error "CSV file not found: $csvPath"
    }
    
    $csvData = Import-Csv $csvPath
    return $csvData
}

# --- Test Cases ---

# Constants from model.scad (derived)
# We know the logic:
# Drawer Side holes: 50mm and 150mm from bottom/top (which are 200mm apart).
# So holes are at Y=50 and Y=150 in the side panel coordinate system (0=bottom).

# 1. DrawerSideLeft vs DrawerFrontStandard (Overhang check)
# DrawerSideLeft dowel holes are at Y=50, Y=150.
# front_overhang = 3mm
# DrawerFrontStandard holes should be at Y=50+3=53, Y=150+3=153.
# DrawerFrontStandard bottom hole (for bottom panel) should be at Y=5+3=8 (Bottom panel is 10mm thick, hole at 5mm).

Write-Output "`n[Test 1] Standard Drawer Front vs Side"

$sideHoles = Get-PanelHoles "DrawerSideLeft"
$frontHoles = Get-PanelHoles "DrawerFrontStandard"

$sideDowel1 = $sideHoles | Where-Object { $_.HoleName -eq "dowel_front_1" }
$sideDowel2 = $sideHoles | Where-Object { $_.HoleName -eq "dowel_front_2" }

$frontSide1 = $frontHoles | Where-Object { $_.HoleName -eq "left_side_1" }
$frontSide2 = $frontHoles | Where-Object { $_.HoleName -eq "left_side_2" }
$frontBottom1 = $frontHoles | Where-Object { $_.HoleName -eq "bottom_panel_1" }

$overhang = 3
$bottomOffset = 5

# Verify Side Holes
if ([double]$sideDowel1.Y -ne 50) { Write-Error "DrawerSideLeft dowel_front_1 Y should be 50, got $($sideDowel1.Y)" }
if ([double]$sideDowel2.Y -ne 150) { Write-Error "DrawerSideLeft dowel_front_2 Y should be 150, got $($sideDowel2.Y)" }

# Verify Front Holes (Standard)
if ([double]$frontSide1.Y -ne (50 + $overhang)) { Write-Error "DrawerFrontStandard left_side_1 Y should be $(50+$overhang), got $($frontSide1.Y)" }
if ([double]$frontSide2.Y -ne (150 + $overhang)) { Write-Error "DrawerFrontStandard left_side_2 Y should be $(150+$overhang), got $($frontSide2.Y)" }
if ([double]$frontBottom1.Y -ne ($bottomOffset + $overhang)) { Write-Error "DrawerFrontStandard bottom_panel_1 Y should be $($bottomOffset+$overhang), got $($frontBottom1.Y)" }

Write-Output "PASSED: DrawerSideLeft vs DrawerFrontStandard"

# 2. DrawerFrontBottom (Bottom Drawer Offset check)
# For the bottom drawer, the front panel starts lower.
# drawer_origin_z = 18 (main thickness) + 10 (bottom offset) = 28mm.
# The drawer box sits at this Z.
# The front panel (DrawerFrontBottom) bottom edge is at Z = 0 (relative to itself? No).
# In `drawer_front_drill` call for Bottom Front:
#   box_bottom_offset = drawer_origin_z = 28.
#   This means holes are shifted up by 28mm relative to the front panel's bottom edge?
#   Wait, let's check `front_height_first`.
#   front_height_first = 18 + 10 - 3 + (200 + 10 - 3) = 28 - 3 + 207 = 232mm roughly?
#   Actually: front_height_first = melanine_thickness_main + drawer_bottom_offset - front_gap + front_height_base
#   = 18 + 10 - 3 + (200 + 10 - 3) = 25 + 207 = 232.
#   
#   The drawer box is at Z=28 relative to the floor/corpus bottom.
#   The front panel bottom edge is at Z=0 relative to floor? No.
#   The front panel overlaps the bottom shelf (18mm) and the gap (10mm).
#   Actually, let's just trust the numbers I verified: 78mm and 178mm.
#   78 - 50 = 28. Yes, offset is 28.

Write-Output "`n[Test 2] Bottom Drawer Front"

$frontBottomHoles = Get-PanelHoles "DrawerFrontBottom"
$frontBottomSide1 = $frontBottomHoles | Where-Object { $_.HoleName -eq "left_side_1" }
$frontBottomSide2 = $frontBottomHoles | Where-Object { $_.HoleName -eq "left_side_2" }
$frontBottomPanel1 = $frontBottomHoles | Where-Object { $_.HoleName -eq "bottom_panel_1" }

$firstDrawerOffset = 28 

if ([double]$frontBottomSide1.Y -ne (50 + $firstDrawerOffset)) { Write-Error "DrawerFrontBottom left_side_1 Y should be $(50+$firstDrawerOffset), got $($frontBottomSide1.Y)" }
if ([double]$frontBottomSide2.Y -ne (150 + $firstDrawerOffset)) { Write-Error "DrawerFrontBottom left_side_2 Y should be $(150+$firstDrawerOffset), got $($frontBottomSide2.Y)" }
if ([double]$frontBottomPanel1.Y -ne ($bottomOffset + $firstDrawerOffset)) { Write-Error "DrawerFrontBottom bottom_panel_1 Y should be $($bottomOffset+$firstDrawerOffset), got $($frontBottomPanel1.Y)" }

Write-Output "PASSED: DrawerFrontBottom"

# 3. DrawerFrontTop (Top Drawer)
# Same as standard basically, just taller panel.
# box_bottom_offset is front_overhang (3).

Write-Output "`n[Test 3] Top Drawer Front"

$frontTopHoles = Get-PanelHoles "DrawerFrontTop"
$frontTopSide1 = $frontTopHoles | Where-Object { $_.HoleName -eq "left_side_1" }
$frontTopSide2 = $frontTopHoles | Where-Object { $_.HoleName -eq "left_side_2" }

if ([double]$frontTopSide1.Y -ne (50 + $overhang)) { Write-Error "DrawerFrontTop left_side_1 Y should be $(50+$overhang), got $($frontTopSide1.Y)" }
if ([double]$frontTopSide2.Y -ne (150 + $overhang)) { Write-Error "DrawerFrontTop left_side_2 Y should be $(150+$overhang), got $($frontTopSide2.Y)" }

Write-Output "PASSED: DrawerFrontTop"


# 4. Templates
# DrawerFrontInsideTemplate -> Should match Drawer Side (50, 150)
# DrawerFrontOutsideTemplate -> Should match Drawer Front Standard (53, 153)

Write-Output "`n[Test 4] Templates"

$insideTmpl = Get-PanelHoles "DrawerFrontInsideTemplate"
$outsideTmpl = Get-PanelHoles "DrawerFrontOutsideTemplate"

$inside1 = $insideTmpl | Where-Object { $_.HoleName -eq "left_side_1" }
$outside1 = $outsideTmpl | Where-Object { $_.HoleName -eq "left_side_1" }

if ([double]$inside1.Y -ne 50) { Write-Error "DrawerFrontInsideTemplate left_side_1 Y should be 50, got $($inside1.Y)" }
if ([double]$outside1.Y -ne (50 + $overhang)) { Write-Error "DrawerFrontOutsideTemplate left_side_1 Y should be $(50+$overhang), got $($outside1.Y)" }

Write-Output "PASSED: Templates"
Write-Output "`nAll Front Overhang tests passed successfully."

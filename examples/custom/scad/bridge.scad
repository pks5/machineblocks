/**
* MachineBlocks
* https://machineblocks.com/examples/classic-bricks
*
* Slim Plate 2x1
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Include the library
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

/* [Size] */

brickSizeX = 8;
brick1SizeX = 2;
brick2SizeX = 2;

// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
brickHeight = 3; // [1:24]
bridgeHeight = 1;

tunnelType = "round"; // [square, round]

/* [Hidden] */
brickTotalSizeY = (brickSizeY * unitGrid[0] * unitMbu + 2 * baseSideAdjustment);

tunnelWidth = (brickSizeX - brick1SizeX - brick2SizeX) * unitGrid[0] * unitMbu;
tunnelHeight = (brickHeight - bridgeHeight) * unitGrid[1] * unitMbu;

// First Pillar
machineblock(
    size = [brick1SizeX, brickSizeY, brickHeight - bridgeHeight],
    
    
    
    studs = false,
    
    scale = scale,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    baseWallThicknessAdjustment = baseWallThicknessAdjustment,
    baseClampThickness = baseClampThickness,
    tubeXDiameterAdjustment = tubeXDiameterAdjustment,
    tubeYDiameterAdjustment = tubeYDiameterAdjustment,
    tubeZDiameterAdjustment = tubeZDiameterAdjustment,
    holeXDiameterAdjustment = holeXDiameterAdjustment,
    holeYDiameterAdjustment = holeYDiameterAdjustment,
    holeZDiameterAdjustment = holeZDiameterAdjustment,
    pinDiameterAdjustment = pinDiameterAdjustment,
    studDiameterAdjustment = studDiameterAdjustment,
    studCutoutAdjustment = studCutoutAdjustment,
    previewRender = previewRender,
    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    studRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution
){

    if(tunnelType != "square"){
        difference(){
            // Tunnel
            machineblock(
                size = [brickSizeX - brick1SizeX - brick2SizeX, brickSizeY, brickHeight - bridgeHeight],
                offset = [brick1SizeX,0,0],
                baseCutoutType = "none",
                
                studs = false,
                
                scale = scale,
                baseHeightAdjustment = baseHeightAdjustment,
                baseSideAdjustment = [-baseSideAdjustment, -baseSideAdjustment,baseSideAdjustment, baseSideAdjustment],
                baseWallThicknessAdjustment = baseWallThicknessAdjustment,
                baseClampThickness = baseClampThickness,
                tubeXDiameterAdjustment = tubeXDiameterAdjustment,
                tubeYDiameterAdjustment = tubeYDiameterAdjustment,
                tubeZDiameterAdjustment = tubeZDiameterAdjustment,
                holeXDiameterAdjustment = holeXDiameterAdjustment,
                holeYDiameterAdjustment = holeYDiameterAdjustment,
                holeZDiameterAdjustment = holeZDiameterAdjustment,
                pinDiameterAdjustment = pinDiameterAdjustment,
                studDiameterAdjustment = studDiameterAdjustment,
                studCutoutAdjustment = studCutoutAdjustment,
                previewRender = previewRender,
                previewQuality = previewQuality,
                baseRoundingResolution = roundingResolution,
                holeRoundingResolution = roundingResolution,
                studRoundingResolution = roundingResolution,
                pillarRoundingResolution = roundingResolution
            );
            
            if(tunnelType == "round"){
                translate([0.5*tunnelWidth + brick1SizeX * unitGrid[0] * unitMbu, 0.5*(brickTotalSizeY)- baseSideAdjustment, 0])
                rotate([90,0,0])
                    scale([1, 2* tunnelHeight / tunnelWidth, 1])
                        cylinder(h = 1.1*brickTotalSizeY, r = 0.5*tunnelWidth, center=true);
            }
        }
    }

    // Second Pillar
    machineblock(
        size = [brick2SizeX, brickSizeY, brickHeight - bridgeHeight],
        offset = [brickSizeX - brick2SizeX,0,0],
        
        
        studs = false,
        
        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        baseWallThicknessAdjustment = baseWallThicknessAdjustment,
        baseClampThickness = baseClampThickness,
        tubeXDiameterAdjustment = tubeXDiameterAdjustment,
        tubeYDiameterAdjustment = tubeYDiameterAdjustment,
        tubeZDiameterAdjustment = tubeZDiameterAdjustment,
        holeXDiameterAdjustment = holeXDiameterAdjustment,
        holeYDiameterAdjustment = holeYDiameterAdjustment,
        holeZDiameterAdjustment = holeZDiameterAdjustment,
        pinDiameterAdjustment = pinDiameterAdjustment,
        studDiameterAdjustment = studDiameterAdjustment,
        studCutoutAdjustment = studCutoutAdjustment,
        previewRender = previewRender,
        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        studRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution
    );

    // Bridge
    machineblock(
        size = [brickSizeX, brickSizeY, bridgeHeight],
        offset = [0,0,brickHeight - bridgeHeight],
        
        baseCutoutType = "none",
        
        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        baseWallThicknessAdjustment = baseWallThicknessAdjustment,
        baseClampThickness = baseClampThickness,
        tubeXDiameterAdjustment = tubeXDiameterAdjustment,
        tubeYDiameterAdjustment = tubeYDiameterAdjustment,
        tubeZDiameterAdjustment = tubeZDiameterAdjustment,
        holeXDiameterAdjustment = holeXDiameterAdjustment,
        holeYDiameterAdjustment = holeYDiameterAdjustment,
        holeZDiameterAdjustment = holeZDiameterAdjustment,
        pinDiameterAdjustment = pinDiameterAdjustment,
        studDiameterAdjustment = studDiameterAdjustment,
        studCutoutAdjustment = studCutoutAdjustment,
        previewRender = previewRender,
        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        studRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution
    );
}
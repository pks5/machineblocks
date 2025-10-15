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

// Imports
use <../../lib/block.scad>;
include <../../config/presets.scad>;


/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 8;
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
brickHeight = 3; // [1:24]

// Size of first pillar in X-direction specified as multiple of an 1x1 brick.
column1SizeX = 2;
// Size of second pillar in X-direction specified as multiple of an 1x1 brick.
column2SizeX = 2;
// Height of the deck as multiple of a plate
deckHeight = 1;

// Shape of the span between columns
spanShape = "round"; // [square, round]

/* [Base] */

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Override Config] */
    overrideConfig=false;
    overrideUnitMbu = 1.6;
    overrideUnitGrid = [5, 2];
    overrideScale = 1.0;
    overrideBaseHeightAdjustment = 0.0;
    overrideBaseSideAdjustment = -0.1;
    overrideBaseWallThicknessAdjustment = -0.1;
    overrideBaseClampThickness = 0.1;
    overrideTubeXDiameterAdjustment = -0.1;
    overrideTubeYDiameterAdjustment = -0.1;
    overrideTubeZDiameterAdjustment = -0.1;
    overrideHoleXDiameterAdjustment = 0.3;
    overrideHoleYDiameterAdjustment = 0.3;
    overrideHoleZDiameterAdjustment = 0.3;
    overridePinDiameterAdjustment = 0.0;
    overrideStudDiameterAdjustment = 0.2;
    overrideStudCutoutAdjustment = [0, 0.2];
    overridePreviewRender = true;
    overridePreviewQuality = 0.5;
    overrideRoundingResolution = 64;


/* [Hidden] */

tunnelWidth = (brickSizeX - column1SizeX - column2SizeX) * unitGrid[0] * unitMbu;
tunnelHeight = (brickHeight - deckHeight) * unitGrid[1] * unitMbu;

bSideAdjustment = overrideConfig ? overrideBaseSideAdjustment : baseSideAdjustment;

brickTotalSizeY = (brickSizeY * unitGrid[0] * unitMbu + 2 * bSideAdjustment);

// First Pillar
machineblock(
    size = [column1SizeX, brickSizeY, brickHeight - deckHeight],
    studs = false,

    baseColor = baseColor,
    
    baseSideAdjustment = bSideAdjustment,
    
    unitMbu=overrideConfig ? overrideUnitMbu : unitMbu,
    unitGrid=overrideConfig ? overrideUnitGrid : unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
){

    if(spanShape != "square"){
        difference(){
            // Tunnel
            machineblock(
                size = [brickSizeX - column1SizeX - column2SizeX, brickSizeY, brickHeight - deckHeight],
                offset = [column1SizeX,0,0],
                baseCutoutType = "none",
                studs = false,

                baseColor = baseColor,
                
                baseSideAdjustment = [-bSideAdjustment, -bSideAdjustment, bSideAdjustment, bSideAdjustment],
                
                unitMbu=overrideConfig ? overrideUnitMbu : unitMbu,
    unitGrid=overrideConfig ? overrideUnitGrid : unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
            );
            
            if(spanShape == "round"){
                translate([0.5*tunnelWidth + column1SizeX * unitGrid[0] * unitMbu, 0.5*(brickTotalSizeY) - bSideAdjustment, 0])
                rotate([90,0,0])
                    scale([1, 2* tunnelHeight / tunnelWidth, 1])
                        cylinder(h = 1.1*brickTotalSizeY, r = 0.5*tunnelWidth, center=true);
            }
        }
    }

    // Second Pillar
    machineblock(
        size = [column2SizeX, brickSizeY, brickHeight - deckHeight],
        offset = [brickSizeX - column2SizeX,0,0],
        studs = false,

        baseColor = baseColor,
        
        baseSideAdjustment = bSideAdjustment,
        
        unitMbu=overrideConfig ? overrideUnitMbu : unitMbu,
    unitGrid=overrideConfig ? overrideUnitGrid : unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
    );

    // Bridge
    machineblock(
        size = [brickSizeX, brickSizeY, deckHeight],
        offset = [0,0,brickHeight - deckHeight],
        baseCutoutType = "none",

        baseColor = baseColor,
        
        baseSideAdjustment = bSideAdjustment,
        
        unitMbu=overrideConfig ? overrideUnitMbu : unitMbu,
    unitGrid=overrideConfig ? overrideUnitGrid : unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
    );
}
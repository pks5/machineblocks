/**
* MachineBlocks
* https://machineblocks.com/examples/technic-liftarms
*
* Technic Liftarm Thick 1 x 1 (Spacer)
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
use <../../lib/block.scad>;
include <../../config/config.scad>;


/* [Size] */

// Whether lift arm should be thin
thin = false;

// Whether lift has axle in middle
leg1AxleHoleFirst = false;

// Whether lift has axle in middle
leg1AxleHoleLast = false;

// Size of first leg as multiple of an 1x1 brick.
leg1Size = 1;  // [1:32]

// Size of second leg as multiple of an 1x1 brick.
leg2Size = 0;  // [1:32]

// Rotation of second leg
leg2Rotation=0;

/* [Base] */

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Studs] */
//Whether to render the stud icon
studIcon = true;

/* [Override Config] */
    overrideConfig=false;
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

holeY = leg1AxleHoleLast ? [true, [0,0,0,0,"axle"], [leg1Size-1,0,leg1Size-1,0,"axle"]] : [true, [0,0,0,0,"axle"]];

bSideAdjustment = overrideConfig ? overrideBaseSideAdjustment : baseSideAdjustment;

machineblock(
    baseRoundingRadius = [1.25,0,0],
    baseCutoutRoundingRadius = 0,
    baseCutoutType = "none",
    baseColor = baseColor,
    holeY = holeY,
    holeYCentered = false,
    holeYGridOffsetZ = 2.5,
    size=[thin ? 0.5 : 1, leg1Size, 2.5], 
    studs = false,

    baseSideAdjustment = bSideAdjustment,
    
    unitMbu=unitMbu,
    unitGrid=unitGrid,
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
    if(leg2Size > 0){
        machineblock(
            rotation = [leg2Rotation,0,0],
            rotationOffset = [0, -0.5, -1.25],
            offset = [0, leg1Size-1, 0],
            baseRoundingRadius = [1.25,0,0],
            baseCutoutRoundingRadius = 0,
            baseCutoutType = "none",
            baseColor = baseColor,
            holeY = [true, [leg2Size-1,0,leg2Size-1,0,"axle"]],
            holeYCentered = false,
            holeYGridOffsetZ = 2.5,
            size=[thin ? 0.5 : 1, leg2Size, 2.5], 
            studs = false,

            baseSideAdjustment = bSideAdjustment,
            
            unitMbu=unitMbu,
    unitGrid=unitGrid,
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
}


/**
* MachineBlocks
* {URL}
*
* {BRICK_NAME}
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
/*{IMPORTS}*/

/* [Size] */

// Whether lift arm should be thin
thin = false;

// Whether lift has axle in middle
leg1AxleHoleFirst = false;

// Whether lift has axle in middle
leg1AxleHoleLast = false;

// Size of first leg as multiple of an 1x1 brick.
leg1Size=6;  // [1:32]

// Size of second leg as multiple of an 1x1 brick.
leg2Size=4;  // [1:32]

// Rotation of second leg
leg2Rotation=0;

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Hidden] */

holeY = leg1AxleHoleLast ? [true, [0,0,0,0,"axle"], [leg1Size-1,0,leg1Size-1,0,"axle"]] : [true, [0,0,0,0,"axle"]];

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
}


/**
* MachineBlocks
* https://machineblocks.com/examples/lift-arms
*
* Technic Liftarm Thin 1 x 2 - Axle Holes
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;


/* [Size] */

// Whether lift arm should be thin
thin = true;

// Whether lift has axle in middle
leg1AxleHoleFirst = false;

// Whether lift has axle in middle
leg1AxleHoleLast = true;

// Size of first leg as multiple of an 1x1 brick.
leg1Size = 2;  // [1:32]

// Size of second leg as multiple of an 1x1 brick.
leg2Size = 0;  // [1:32]

// Rotation of second leg
leg2Rotation=0;

/* [Base] */

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Hidden] */

holeY = leg1AxleHoleLast ? [true, [0,0,0,0,"axle"], [leg1Size-1,0,leg1Size-1,0,"axle"]] : [true, [0,0,0,0,"axle"]];

machineblock(
    baseRoundingRadius = [4,0,0],
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
            baseRoundingRadius = [4,0,0],
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


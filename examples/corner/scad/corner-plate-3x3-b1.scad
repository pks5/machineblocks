/**
* MachineBlocks
* https://machineblocks.com/examples/corner
*
* Corner Plate 3x3 B1
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

// Brick 1 Grid Size in X-direction as multiple of an 1x1 brick.
brick1SizeX = 3;  // [1:32]
// Brick 1 Grid Size in Y-direction as multiple of an 1x1 brick.
brick1SizeY = 1;  // [1:32]

// Brick 1 Offset in Y-direction as multiple of an 1x1 brick.
brick1OffsetY = 0; // [0:31]

// Brick 2 Grid Size in X-direction as multiple of an 1x1 brick.
brick2SizeX = 1;  // [1:32]
// Brick 2 Grid Size in Y-direction as multiple of an 1x1 brick.
brick2SizeY = 3;  // [1:32]

// Brick 2 Offset in X-direction as multiple of an 1x1 brick.
brick2OffsetX = 0; // [0:31]

//Number of layers
baseLayers = 1; // [1:48]

/* [Base] */

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Appearance] */

// Whether to draw knobs.
knobs = true;
// Type of the knobs
knobType = "classic"; // [classic, technic]

// Generate the block
union(){
    machineblock(
        size = [brick1SizeX, brick1SizeY,baseLayers],
        offset = [0, brick1OffsetY - 0.5*(brick2SizeY-brick1SizeY), 0],
        baseWallGapsX = [[brick2OffsetX, 2, brick2SizeX]],
        
        baseColor = baseColor,

        studs = knobs,
        studType = knobType,
        align="ccs",

        baseSideAdjustment = baseSideAdjustment,
        
        scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
    );

    machineblock(
        size = [brick2SizeX, brick2SizeY,baseLayers],
        offset = [brick2OffsetX - 0.5*(brick1SizeX-brick2SizeX), 0, 0],
        baseWallGapsY = [[brick1OffsetY, 2, brick1SizeY]],
        baseColor = baseColor,

        studs = knobs,
        studType = knobType,
        align="ccs",
        
        baseSideAdjustment = baseSideAdjustment,
    
        scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
    );    
}
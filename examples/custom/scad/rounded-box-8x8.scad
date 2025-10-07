/**
* Machine Blocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Rounded Box 8x8
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

/* [Appearance] */

//Grid Size X-direction
gridX = 8; 
//Grid Size Y-direction
gridY = 8; 
//Number of layers
baseLayers = 12;
//Text on lid
lidText = "Jewelry";
//Text Font
textFont = "RBNo3.1";

machineblock(
    size = [gridX, gridY, baseLayers - 1],
    studs = false,
    tongue = true,
    tongueHeight = 1.8,
    tongueClampThickness = 0,
    
    pit = true,
    baseCutoutType = "none",
    baseRoundingRadius = [0,0,4],
    
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

machineblock(
    size = [gridX, gridY,1],
    offset = [gridX + 1, 0, 0],
    baseCutoutType = "groove",
    tongueClampThickness = 0,
    
    //tongueThickness = 1.2,
    studs = false,
    textSide = 5,
    textSize = 10,
    textDepth = 0.8,
    text = lidText,
    textFont = textFont,
    baseRoundingRadius = [0,0,4],

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

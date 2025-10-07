/**
* Machine Blocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Breadboard Frame 12x8
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
gridX = 12; 
//Grid Size Y-direction
gridY = 8; 
//Number of layers
baseLayers = 4;

machineblock(
    size = [gridX, gridY, baseLayers],
    pit = true,
    pitWallThickness = [5.9/8, 4.6/8],
    pitDepth = 8.8,
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
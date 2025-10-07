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

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

machineblock(
    size = [gridX, gridY, baseLayers],
    pit = true,
    pitWallThickness = [5.9/8, 4.6/8],
    pitDepth = 8.8,
    studs = false,

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
    previewRender = previewRender
);
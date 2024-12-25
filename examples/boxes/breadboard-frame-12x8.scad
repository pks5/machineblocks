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
use <../../lib/block.scad>;

/* [Appearance] */

//Grid Size X-direction
gridX = 12; 
//Grid Size Y-direction
gridY = 8; 
//Number of layers
baseLayers = 4;

/* [Quality] */

// Preview Quality
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final render.
roundingResolution = 64; // [16:8:128]

/* [Calibration] */

//Adjustment of the height (mm)
baseHeightAdjustment = 0.0;
//Adjustment of each side (mm)
baseSideAdjustment = -0.1;
//Diameter of the knobs (mm)
knobSize = 5.0;
//Thickness of the walls (mm)
wallThickness = 1.5;
//Diameter of the Z-Tubes (mm)
tubeZSize = 6.4;

block(
    baseLayers = baseLayers,
    grid = [gridX, gridY],
    pit = true,
    pitWallThickness = [5.9/8, 4.6/8],
    pitDepth = 8.8,
    baseCutoutMaxDepth = 2.6,
    knobs = false,

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
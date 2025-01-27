/**
* MachineBlocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Box 6x6
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
use <../../lib/block.scad>;

/* [Size] */

// Box size in X-direction specified as multiple of an 1x1 brick.
boxSizeX = 6; // [1:32] 
// Box size in Y-direction specified as multiple of an 1x1 brick.
boxSizeY = 6; // [1:32] 
// Total box height specified as number of layers. Each layer has the height of one plate.
boxLayers = 3; // [1:24]

/* [Appearance] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]
// Whether the base should have knobs
baseKnobs = true;
// Type of the base knobs
baseKnobType = "classic"; // [classic, technic]
// Whether the pit should contain knobs
basePitKnobs = true;
// Pit wall thickness
basePitWallThickness = 1;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
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
tubeZSize = 6.3;

block(
    grid=[boxSizeX, boxSizeY],
    baseLayers = boxLayers,
    baseCutoutType = baseCutoutType,

    knobs = baseKnobs,
    knobType = baseKnobType,
    knobCentered = false,
    
    pit=true,
    pitWallGaps = [ [ 0, .333, .333 ] ],
    pitWallThickness = basePitWallThickness,
    pitKnobs = basePitKnobs,

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
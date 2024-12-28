/**
* Machine Blocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Box 2x2
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
use <../../lib/block.scad>;

/* [Size] */

//Grid Size X-direction
gridX = 2; 
//Grid Size Y-direction
gridY = 2; 
//Number of layers
baseLayers = 4;

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
tubeZSize = 6.4;

//Generate 2x2 Box
block(
    baseLayers = baseLayers - 1,
    grid = [gridX, gridY],
    
    pit = true,
    pitKnobs = false,
    
    tongue = true,
    tongueHeight=1.8,
    tongueClampThickness=0,
    tongueOuterAdjustment=-0.1,

    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);

//Generate 2x2 Lid
block(
    baseLayers = 1,
    grid = [gridX, gridY],
    gridOffset = [gridX + 1, 0, 0],

    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
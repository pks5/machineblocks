/**
* Machine Blocks
* https://machineblocks.com/examples/classic-bricks
*
* Base Plate 32x16
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../lib/block.scad>;

/* [Appearance] */

//Grid Size X-direction
gridX = 32; // [1:32]
//Grid Size Y-direction
gridY = 16; // [1:32] 
//Number of layers
baseLayers = 1; // [1:24]
//Base Cutout Type
baseCutoutType = "none"; // [none, classic]
//Draw Knobs
knobs = true;
//Knob Centered
knobCentered = false;
//Knob Type
knobType = "classic"; // [classic, technic]

/* [Calibration] */

//Diameter of the knobs (mm)
knobSize = 5.0; // .1
//Thickness of the walls (mm)
wallThickness = 1.5; // .1
//Diameter of the Z-Tubes (mm)
tubeZSize = 6.4; // .1
//Adjustment of the height (mm)
baseHeightAdjustment = 0.0; // .1
//Adjustment of each side (mm)
baseSideAdjustment = -0.1; // .1

//Generate the block
block(
    grid = [gridX, gridY],
    baseLayers = baseLayers,
    baseCutoutType = baseCutoutType,
    knobs = knobs,
    knobCentered = knobCentered,
    knobType = knobType,
    
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment
);
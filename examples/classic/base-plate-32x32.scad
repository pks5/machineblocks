/**
* Machine Blocks
* https://machineblocks.com/examples/classic-bricks
*
* Base Plate 32x32
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../lib/block.scad>;

//Grid Size X-direction
gridX = 32; // [1:64]
//Grid Size Y-direction
gridY = 32; // [1:64] 
//Number of layers
baseLayers = 1; // [1:64]
//Draw Knobs
knobs = true;
//Base Cutout Type
baseCutoutType = "none"; // [none, classic]

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
    knobs = knobs,
    baseCutoutType = baseCutoutType,
    
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment
);
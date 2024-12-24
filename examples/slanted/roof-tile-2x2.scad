/**
* Machine Blocks
* https://machineblocks.com/examples/slanted
*
* Roof Tile 2x2
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
gridX = 2; 
//Grid Size Y-direction
gridY = 2; 
//Number of layers
baseLayers = 3;
//Draw Knobs
knobs = true;

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

//Generate the block
block(
    grid = [gridX, gridY],
    baseLayers = baseLayers,
    knobs = knobs,
    slanting=[0,0,1,0], 
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
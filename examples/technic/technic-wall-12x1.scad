/**
* Machine Blocks
* https://machineblocks.com/examples/technic-bricks
*
* Technic Wall 12x1
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
gridX = 12; 
//Grid Size Y-direction
gridY = 1; 
//Number of layers
baseLayers = 12;
//KnobType
knobType = "technic";
//Technic Holes
holesX1 = 0;
holesZ1 = 0;
holesX2 = 2;
holesZ2 = 2;

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
    knobType = knobType,
    holesX = [[holesX1, holesZ1, holesX2, holesZ2]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
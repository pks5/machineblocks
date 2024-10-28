/**
* MachineBlocks Brick 4x2
* https://machineblocks.com 
*
* Copyright (c) 2022 Jan P. Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

//Include the MachineBlocks library
include <../../lib/block.scad>;

//Adjustment of the height in mm
baseHeightAdjustment = 0.0;
//Adjustment of each side in mm
baseSideAdjustment = -0.1;
//Diameter of the knobs in mm
knobSize = 5.0;
//Thickness of the walls in mm
wallThickness = 1.5;
//Diameter of the Z-Tubes in mm
tubeZSize = 6.4;

//Generate 3x2 Brick
block(
    baseLayers = 3,
    grid = [3,2],
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
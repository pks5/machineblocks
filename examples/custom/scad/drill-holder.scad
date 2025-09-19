/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Drill Holder
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../lib/block.scad>;
include <../../config/presets.scad>;

block(
    grid=[12,2],
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment=[baseSideAdjustment,0.1,baseSideAdjustment,baseSideAdjustment],
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
);

block(
    grid=[2,4],
    gridOffset=[7,0,0],
    holesZ=true,
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
);

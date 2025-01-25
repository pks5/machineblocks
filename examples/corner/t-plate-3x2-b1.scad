/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* T Plate 3x2 B1
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../lib/block.scad>;

/* [Appearance] */

//Brick 1 Grid Size X-direction
brick1SizeX = 3;  // [1:32]
//Brick 1 Grid Size Y-direction
brick1SizeY = 1;  // [1:32]

//Brick 1 Offset Y
brick1OffsetY = 1; // [0:31]

//Brick 2 Grid Size X-direction
brick2SizeX = 1;  // [1:32]
//Brick 2 Grid Size Y-direction
brick2SizeY = 2;  // [1:32]

//Brick 2 Offset X
brick2OffsetX = 1; // [0:31]

//Number of layers
baseLayers = 1; // [1:48]
//Draw Knobs
knobs = true;
//Knob Type
knobType = "classic"; // [classic, technic]

/* [Calibration] */

//Adjustment of the height (mm)
baseHeightAdjustment = 0.0; // .1
//Adjustment of each side (mm)
baseSideAdjustment = -0.1; // .1
//Diameter of the knobs (mm)
knobSize = 5.0; // .1
//Thickness of the walls (mm)
wallThickness = 1.5; // .1
//Diameter of the Z-Tubes (mm)
tubeZSize = 6.4; // .1

//Duo
union(){
    block(
        grid = [brick1SizeX, brick1SizeY],
        gridOffset = [0, brick1OffsetY - 0.5*(brick2SizeY-brick1SizeY), 0],
        wallGapsX = [[brick2OffsetX, 2, brick2SizeX]],
        baseLayers = baseLayers,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobs = knobs,
        knobType = knobType,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );

    block(
        grid = [brick2SizeX, brick2SizeY],
        gridOffset = [brick2OffsetX - 0.5*(brick1SizeX-brick2SizeX), 0, 0],
        wallGapsY = [[brick1OffsetY, 2, brick1SizeY]],
        baseLayers = baseLayers,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobs = knobs,
        knobType = knobType,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );    
}
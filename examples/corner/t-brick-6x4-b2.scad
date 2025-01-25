/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* T Brick 6x4 B2
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../lib/duo.scad>;

/* [Appearance] */

//Brick 1 Grid Size X-direction
brick1SizeX = 6;  // [1:32]
//Brick 1 Grid Size Y-direction
brick1SizeY = 2;  // [1:32]

//Brick 1 Offset Y
brick1OffsetY = 1; // [0:31]

//Brick 2 Grid Size X-direction
brick2SizeX = 2;  // [1:32]
//Brick 2 Grid Size Y-direction
brick2SizeY = 4;  // [1:32]

//Brick 2 Offset X
brick2OffsetX = 0; // [0:31]

//Number of layers
baseLayers = 3; // [1:48]
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

mb_duo(
    brick1GridX = brick1SizeX,
    brick1GridY = brick1SizeY,
    brick1OffsetY = brick1OffsetY,
    brick2GridX = brick2SizeX,
    brick2GridY = brick2SizeY,
    brick2OffsetX = brick2OffsetX,
    baseLayers = baseLayers,
    knobs = knobs,
    knobType = knobType,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
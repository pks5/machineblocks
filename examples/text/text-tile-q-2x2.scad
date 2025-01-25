/**
* Machine Blocks
* https://machineblocks.com/examples/text
*
* Text Tile Q 2x2
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../lib/block.scad>;

//Grid Size X-direction
brickSizeX = 2; 
//Grid Size Y-direction
brickSizeY = 2; 
//Number of layers
baseLayers = 1;
//Letter
text = "Q";
//Letter Depth
textDepth = 1.2;
// Font
textFont = "RBNo3.1 Black";

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
    grid = [brickSizeX, brickSizeY],
    baseLayers = baseLayers,
    knobs = false,

    textSide = 5,
    textSize = 9,
    text=text,
    textDepth=textDepth,
    textFont=textFont,

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
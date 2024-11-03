/**
* Machine Blocks
* https://machineblocks.com/examples/classic-bricks
*
* Text Plate 6x6
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
gridX = 6; 
//Grid Size Y-direction
gridY = 6; 
//Number of layers
baseLayers = 1;
//Text
text = "Love";

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
    knobs = [true, [0,2,5,3, true]],

    textFont="Liberation Sans",
    text=text,
    textSize=10,
    textSide=5,
    textDepth=0.6,

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
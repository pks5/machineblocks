/**
* Machine Blocks
* https://machineblocks.com/examples/text
*
* Symbol Tile Triangle Exclaimation 2x2
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../lib/block.scad>;

/* [Size] */

//Grid Size X-direction
brickSizeX = 2; // [1:32] 
//Grid Size Y-direction
brickSizeY = 2; // [1:32] 
//Number of layers
baseLayers = 1; // [1:48]

/* [Text] */

//Letter
text = "";
//Letter Depth
textDepth = 1.2; // [0.2:0.2:3.2]
// Font
textFont = "Font Awesome 6 Free Solid"; // [Creato Display, RBNo3.1 Black, Font Awesome 6 Free Regular, Font Awesome 6 Free Solid]
// Text Style
textStyle = "Regular"; // [Black, Black Italic, Bold, Bold Italic, Book, Book Italic, ExtraBold, ExtraBold Italic, Light, Light Italic, Medium, Medium Italic, Regular, Regular Italic, Thin, Thin Italic, Ultra, Ultra Italic]
//Text Size
textSize = 8; // [1:32]
//Text Side
textSide = 5; // [0:X0, 1:X1, 2:Y0, 3:Y1, 4:Z0, 5:Z1]

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
    grid = [brickSizeX, brickSizeY],
    baseLayers = baseLayers,
    knobs = false,

    textSide = textSide,
    textSize = textSize,
    text=text,
    textDepth=textDepth,
    textFont=str(textFont, (textStyle == "" ? "" : str(":style=", textStyle))),

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);
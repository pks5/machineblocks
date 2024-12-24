/**
* Machine Blocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Rounded Box 8x8
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

use <../../lib/block.scad>;

/* [Appearance] */

//Grid Size X-direction
gridX = 8; 
//Grid Size Y-direction
gridY = 8; 
//Number of layers
baseLayers = 12;
//Text on lid
lidText = "Jewelry";
//Text Font
textFont = "RBNo3.1";

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

block(
    grid = [gridX, gridY],
    baseLayers = baseLayers - 1,
    knobs = false,
    tongue = true,
    tongueHeight = 1.8,
    tongueClampThickness = 0,
    tongueRoundingRadius = 1,
    pit = true,
    baseCutoutType = "none",
    baseRoundingRadius = [0,0,4],

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);

block(
    grid = [gridX, gridY],
    gridOffset = [gridX + 1, 0, 0],
    baseCutoutType = "groove",
    tongueClampThickness = 0,
    tongueRoundingRadius = 1,
    tongueOuterAdjustment = 0.1,
    tongueThickness = 1.2,
    knobs = false,
    textSide = 5,
    textSize = 10,
    textDepth = 0.8,
    text = lidText,
    textFont = textFont,
    baseRoundingRadius = [0,0,4],

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);

/**
* Machine Blocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Box 6x6
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
use <../../lib/block.scad>;

//Grid Size X-direction
gridX = 6; 
//Grid Size Y-direction
gridY = 6; 
//Number of layers
baseLayers = 9;

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
    grid=[gridX, gridY],
    baseLayers = baseLayers - 1,
    
    tongue = true,
    tongueHeight = 1.8,
    tongueClampThickness = 0,
    tongueOuterAdjustment = -0.1,
    
    knobs=false,
    pit=true,
    
    textSize = 10,
    textFont = "OldSansBlack",
    textDepth = -0.8,
    text = "Jewelry",

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);

block(
    grid=[gridX, gridY],
    gridOffset = [gridX + 1, 0, 0],

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);   
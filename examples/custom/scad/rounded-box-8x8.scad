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

use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

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

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

block(
    grid = [gridX, gridY],
    baseLayers = baseLayers - 1,
    knobs = false,
    tongue = true,
    tongueHeight = 1.8,
    tongueClampThickness = 0,
    
    pit = true,
    baseCutoutType = "none",
    baseRoundingRadius = [0,0,4],

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
);

block(
    grid = [gridX, gridY],
    gridOffset = [gridX + 1, 0, 0],
    baseCutoutType = "groove",
    tongueClampThickness = 0,
    
    //tongueThickness = 1.2,
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
    tubeZSize = tubeZSize,
    pinSize = pinSize
);

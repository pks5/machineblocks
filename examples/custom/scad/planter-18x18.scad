/**
* Machine Blocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Breadboard Frame 12x8
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
gridX = 12; 
//Grid Size Y-direction
gridY = 12; 
//Number of layers
baseLayers = 24;
//Floor layers
floorLayers = 3;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

union(){
    block(
        baseLayers = floorLayers, 
        grid = [gridX, gridY], 
        knobs = false,

        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize,
        align = "ccs"
    );


    block(
        baseLayers = baseLayers - floorLayers, 
        grid = [gridX, 1], 
        baseCutoutType = "none",
        text="\ue5aa",
        textSide = 2,
        textSize = 40,
        textFont = "Font Awesome 6 Free Solid", 
        gridOffset = [0, -0.5 * (gridY - 1), floorLayers],

        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize,
        align = "ccs"
    ); 


    block(
        baseLayers = baseLayers - floorLayers, 
        grid = [gridX, 1], 
        baseCutoutType = "none", 
        gridOffset = [0, 0.5 * (gridY - 1), floorLayers],

        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize,
        align = "ccs"
    );


    block(
        baseLayers = baseLayers - floorLayers, 
        grid = [1, gridY-2], 
        baseCutoutType = "none", 
        gridOffset = [-0.5 * (gridX - 1), 0, floorLayers], 

        previewRender = previewRender,     
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = [-0.1, -0.1, 0.1, 0.1],
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize,
        align = "ccs"
    );


    block(
        baseLayers = baseLayers - floorLayers, 
        grid = [1, gridY-2], 
        baseCutoutType = "none", 
        gridOffset = [0.5 * (gridX - 1), 0, floorLayers], 

        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = [-0.1, -0.1, 0.1, 0.1],
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize,
        align = "ccs"
    ); 
}
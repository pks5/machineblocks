/**
* Machine Blocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Water Tank 8x12
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
gridY = 12; 
//Number of layers
baseLayers = 24;
//Floor layers
floorLayers = 3;

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

union(){
    block(
        baseLayers = floorLayers, 
        grid = [gridX, gridY], 
        knobs = false,

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );


    block(
        baseLayers = baseLayers - floorLayers, 
        grid = [gridX, 1], 
        baseCutoutType = "none",
        gridOffset = [0, -0.5 * (gridY - 1), floorLayers],

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    ); 


    block(
        baseLayers = baseLayers - floorLayers, 
        grid = [gridX, 1], 
        baseCutoutType = "none", 
        gridOffset = [0, 0.5 * (gridY - 1), floorLayers],

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );


    block(
        baseLayers = baseLayers - floorLayers, 
        grid = [1, gridY-2], 
        baseCutoutType = "none", 
        gridOffset = [-0.5 * (gridX - 1), 0, floorLayers], 
        
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = [-0.1, -0.1, 0.1, 0.1],
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );


    block(
        baseLayers = baseLayers - floorLayers, 
        grid = [1, gridY-2], 
        baseCutoutType = "none", 
        gridOffset = [0.5 * (gridX - 1), 0, floorLayers], 

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = [-0.1, -0.1, 0.1, 0.1],
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    ); 
}
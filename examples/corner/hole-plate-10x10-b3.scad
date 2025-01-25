/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Hole Plate 10x10 B3
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the MachineBlocks library
use <../../lib/block.scad>;

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 10; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 10; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 3; // [1:24]
// Border Size as multiple of an 1x1 brick.
borderSize = 3; // [1:8]

/* [Appearance] */

// Whether to draw knobs.
knobs = true;
// Type of the knobs
knobType = "classic"; // [classic, technic]

/* [Calibration] */

// Adjustment of the height (mm)
baseHeightAdjustment = 0.0; // .1
// Adjustment of each side (mm)
baseSideAdjustment = -0.1; // .1
// Diameter of the knobs (mm)
knobSize = 5.0; // .1
// Thickness of the walls (mm)
wallThickness = 1.5; // .1
// Diameter of the Z-Tubes (mm)
tubeZSize = 6.4; // .1

// Generate the block
union(){
    block(
        grid=[borderSize, brickSizeY], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        wallGapsY=[[0,1,borderSize], [brickSizeY-borderSize,1,borderSize]],
        gridOffset=[-0.5*(brickSizeX-borderSize),0,0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );  

    block(
        grid=[brickSizeX,borderSize],
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        wallGapsX=[[0,0,borderSize], [brickSizeX-borderSize,0,borderSize]],
        gridOffset=[0,0.5*(brickSizeY-borderSize),0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );

    block(
        grid=[borderSize, brickSizeY], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        wallGapsY=[[0,0,borderSize], [brickSizeY-borderSize,0,borderSize]],
        gridOffset=[0.5*(brickSizeX-borderSize),0,0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );    

    block(
        grid=[brickSizeX,borderSize], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        wallGapsX=[[0,1,borderSize], [brickSizeX-borderSize,1,borderSize]],
        gridOffset=[0,-0.5*(brickSizeY-borderSize),0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );
}
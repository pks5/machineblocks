/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Hole Plate 10x10 B1
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the MachineBlocks library
use <../../lib/block.scad>;

/* [Appearance] */

//Grid Size X-direction
brickSizeX = 10; // [1:32]
//Grid Size Y-direction
brickSizeY = 10; // [1:32]
//Border Size
borderSize = 1; // [1:8]
//Number of layers
baseLayers = 1; // [1:48]
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

//Plate with hole
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
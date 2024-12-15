/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Plate with Hole 4x4
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the MachineBlocks library
include <../../lib/block.scad>;

//Grid Size X-direction
gridX = 8; // [1:32]
//Grid Size Y-direction
gridY = 8; // [1:32]
//Border Size
borderSize = 2; // [1:8]
//Number of layers
baseLayers = 1; // [1:48]
//Draw Knobs
knobs = true;
//Knob Type
knobType = "classic"; // [classic, technic]

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
        grid=[borderSize, gridY], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        wallGapsY=[[0,1,borderSize], [gridY-borderSize,1,borderSize]],
        gridOffset=[-0.5*(gridX-borderSize),0,0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );  

    block(
        grid=[gridX,borderSize],
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        wallGapsX=[[0,0,borderSize], [gridX-borderSize,0,borderSize]],
        gridOffset=[0,0.5*(gridY-borderSize),0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );

    block(
        grid=[borderSize, gridY], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        wallGapsY=[[0,0,borderSize], [gridY-borderSize,0,borderSize]],
        gridOffset=[0.5*(gridX-borderSize),0,0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );    

    block(
        grid=[gridX,borderSize], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        wallGapsX=[[0,1,borderSize], [gridX-borderSize,1,borderSize]],
        gridOffset=[0,-0.5*(gridY-borderSize),0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );
}
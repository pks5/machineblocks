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
gridX = 4; 
//Grid Size Y-direction
gridY = 4; 
//Number of layers
baseLayers = 1;
//Draw Knobs
knobs = true;

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

//Plate with hole
union(){
    block(
        grid=[1, gridY], 
        knobs=knobs,
        baseLayers = baseLayers,
        wallGapsY=[[0,1], [gridY-1,1]],
        gridOffset=[-0.5*(gridX-1),0,0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );  

    block(
        grid=[gridX,1],
        knobs=knobs,
        baseLayers = baseLayers,
        wallGapsX=[[0,0], [gridX-1,0]],
        gridOffset=[0,0.5*(gridY-1),0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );

    block(
        grid=[1, gridY], 
        knobs=knobs,
        baseLayers = baseLayers,
        wallGapsY=[[0,0], [gridY-1,0]],
        gridOffset=[0.5*(gridX-1),0,0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );    

    block(
        grid=[gridX,1], 
        knobs=knobs,
        baseLayers = baseLayers,
        wallGapsX=[[0,1], [gridX-1,1]],
        gridOffset=[0,-0.5*(gridY-1),0],
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );
}
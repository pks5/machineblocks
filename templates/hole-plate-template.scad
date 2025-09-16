/**
* MachineBlocks
* {URL}
*
* {BRICK_NAME}
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the MachineBlocks library
use <../../lib/block.scad>;
include <../../config/presets.scad>;

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 4; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]
// Border Size as multiple of an 1x1 brick.
borderSize = 1; // [1:8]

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Knobs] */

// Whether to draw knobs.
knobs = true;
// Type of the knobs
knobType = "classic"; // [classic, technic]

/* [Render] */

/*{QUALITY_VARIABLES}*/

// Generate the block
union(){
    block(
        grid=[borderSize, brickSizeY], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        /*{BASE_PARAMETERS}*/

        wallGapsY=[[0,1,borderSize], [brickSizeY-borderSize,1,borderSize]],
        gridOffset=[-0.5*(brickSizeX-borderSize),0,0],
        
        /*{QUALITY_PARAMETERS}*/

        baseSideAdjustment = baseSideAdjustment,
        
        /*{PRESET_PARAMETERS}*/
    );  

    block(
        grid=[brickSizeX,borderSize],
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        /*{BASE_PARAMETERS}*/

        wallGapsX=[[0,0,borderSize], [brickSizeX-borderSize,0,borderSize]],
        gridOffset=[0,0.5*(brickSizeY-borderSize),0],
        
        /*{QUALITY_PARAMETERS}*/

        baseSideAdjustment = baseSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );

    block(
        grid=[borderSize, brickSizeY], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        /*{BASE_PARAMETERS}*/

        wallGapsY=[[0,0,borderSize], [brickSizeY-borderSize,0,borderSize]],
        gridOffset=[0.5*(brickSizeX-borderSize),0,0],
        
        /*{QUALITY_PARAMETERS}*/

        baseSideAdjustment = baseSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );    

    block(
        grid=[brickSizeX,borderSize], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        /*{BASE_PARAMETERS}*/

        wallGapsX=[[0,1,borderSize], [brickSizeX-borderSize,1,borderSize]],
        gridOffset=[0,-0.5*(brickSizeY-borderSize),0],
        
        /*{QUALITY_PARAMETERS}*/

        baseSideAdjustment = baseSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );
}
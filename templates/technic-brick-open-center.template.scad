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

// Imports
/*{IMPORTS}*/

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
knobType = "solid"; // [solid, hollow]

/*{STUD_VARIABLES}*/

/* [Pin Holes] */

pinHoles = false;
pinHolesCentered = true;

cornerRadius = 0.5;

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

// Generate the block
union(){
    machineblock(
        size=[borderSize, brickSizeY,baseLayers], 
        studs=knobs,
        studType=knobType,
        
        /*{STUD_PARAMETERS}*/

        /*{BASE_PARAMETERS}*/

        holeYCentered = pinHolesCentered,
        holeY = pinHoles ? [false, [0,0,brickSizeY - 1,0]] : false,
        offset=[-0.5*(brickSizeX-borderSize),0,0],
        align="ccs",
        
        baseSideAdjustment = bSideAdjustment,
        
        /*{PRESET_PARAMETERS}*/
    );  

    machineblock(
        size=[brickSizeX-2,borderSize,baseLayers],
        studs=knobs,
        studType=knobType,
        
        /*{STUD_PARAMETERS}*/

        baseRoundingRadius=[0,0,[cornerRadius,0,0,cornerRadius]],
        /*{BASE_PARAMETERS}*/

        holeXCentered = pinHolesCentered,
        holeX = pinHoles ? [false, [0,0,brickSizeX - 1,0]] : false,
        offset=[0,0.5*(brickSizeY-borderSize),0],
        align="ccs",

        baseSideAdjustment = [-bSideAdjustment,-bSideAdjustment,bSideAdjustment,bSideAdjustment],
    
        /*{PRESET_PARAMETERS}*/
    );

    machineblock(
        size=[borderSize, brickSizeY,baseLayers], 
        studs=knobs,
        studType=knobType,
        
        /*{STUD_PARAMETERS}*/

        /*{BASE_PARAMETERS}*/

        holeYCentered = pinHolesCentered,
        holeY = pinHoles ? [false, [0,0,brickSizeY - 1,0]] : false,
        offset=[0.5*(brickSizeX-borderSize),0,0],
        align="ccs",
        
        baseSideAdjustment = bSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );    

    machineblock(
        size=[brickSizeX-2,borderSize,baseLayers], 
        studs=knobs,
        studType=knobType,
        
        /*{STUD_PARAMETERS}*/

        baseRoundingRadius=[0,0,[0, cornerRadius,cornerRadius,0]],
        /*{BASE_PARAMETERS}*/

        holeXCentered = pinHolesCentered,
        holeX = pinHoles ? [false, [0,0,brickSizeX - 1,0]] : false,
        offset=[0,-0.5*(brickSizeY-borderSize),0],
        align="ccs",
        
        baseSideAdjustment = [-bSideAdjustment,-bSideAdjustment,bSideAdjustment,bSideAdjustment],
    
        /*{PRESET_PARAMETERS}*/
    );
}
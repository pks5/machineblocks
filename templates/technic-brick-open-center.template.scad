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

// Brick size
size = [4, 2, 1]; // [1:32]

// Border Size as multiple of an 1x1 brick.
borderSize = 1; // [1:8]

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Knobs] */

/*{STUD_VARIABLES}*/

/* [Pin Holes] */

pinHoles = false;
pinHolesCentered = true;

cornerRadius = 0.5;

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

// Generate the block
union(){
    machineblock(
        size=[borderSize, size[1],size[2]], 
        offset=[-0.5*(size[0]-borderSize), 0, 0],
        align="ccs",

        /*{STUD_PARAMETERS}*/

        /*{BASE_PARAMETERS}*/

        holeYCentered = pinHolesCentered,
        holeY = pinHoles ? [false, [0,0,size[1] - 1,0]] : false,
        

        /*{STYLE_PARAMETERS}*/
        
        baseSideAdjustment = bSideAdjustment,
        
        /*{PRESET_PARAMETERS}*/
    );  

    machineblock(
        size=[size[0]-2*borderSize,borderSize,size[2]],
        offset=[0,0.5*(size[1]-borderSize),0],
        align="ccs",

        /*{STUD_PARAMETERS}*/

        baseRoundingRadius=[0,0,[cornerRadius,0,0,cornerRadius]],
        /*{BASE_PARAMETERS}*/

        holeXCentered = pinHolesCentered,
        holeX = pinHoles ? [false, [0,0,size[0] - 1,0]] : false,
        

        /*{STYLE_PARAMETERS}*/

        baseSideAdjustment = [-bSideAdjustment,-bSideAdjustment,bSideAdjustment,bSideAdjustment],
    
        /*{PRESET_PARAMETERS}*/
    );

    machineblock(
        size=[borderSize, size[1],size[2]], 
        offset=[0.5*(size[0]-borderSize),0,0],
        align="ccs",

        /*{STUD_PARAMETERS}*/

        /*{BASE_PARAMETERS}*/

        holeYCentered = pinHolesCentered,
        holeY = pinHoles ? [false, [0,0,size[1] - 1,0]] : false,
        
        /*{STYLE_PARAMETERS}*/
        
        baseSideAdjustment = bSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );    

    machineblock(
        size=[size[0]-2*borderSize,borderSize,size[2]], 
        offset=[0,-0.5*(size[1]-borderSize),0],
        align="ccs",
        
        /*{STUD_PARAMETERS}*/

        baseRoundingRadius=[0,0,[0, cornerRadius,cornerRadius,0]],
        /*{BASE_PARAMETERS}*/

        holeXCentered = pinHolesCentered,
        holeX = pinHoles ? [false, [0,0,size[0] - 1,0]] : false,
        
        /*{STYLE_PARAMETERS}*/
        
        baseSideAdjustment = [-bSideAdjustment,-bSideAdjustment,bSideAdjustment,bSideAdjustment],
    
        /*{PRESET_PARAMETERS}*/
    );
}
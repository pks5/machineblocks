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

// Brick 1 Grid Size in X-direction as multiple of an 1x1 brick.
brick1SizeX=3;  // [1:32]
// Brick 1 Grid Size in Y-direction as multiple of an 1x1 brick.
brick1SizeY=1;  // [1:32]

// Brick 1 Offset in Y-direction as multiple of an 1x1 brick.
brick1OffsetY = 1; // [0:31]

// Brick 2 Grid Size in X-direction as multiple of an 1x1 brick.
brick2SizeX=1;  // [1:32]
// Brick 2 Grid Size in Y-direction as multiple of an 1x1 brick.
brick2SizeY=3;  // [1:32]

// Brick 2 Offset in X-direction as multiple of an 1x1 brick.
brick2OffsetX = 1; // [0:31]

//Number of layers
baseLayers = 1; // [1:48]

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Studs] */

/*{STUD_VARIABLES}*/

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

// Generate the block
union(){
    machineblock(
        size = [brick1SizeX, brick1SizeY,baseLayers],
        offset = [0, brick1OffsetY - 0.5*(brick2SizeY-brick1SizeY), 0],
        align="ccs",
        
        baseWallGapsX = [[brick2OffsetX, 2, brick2SizeX]],
        
        /*{BASE_PARAMETERS}*/

        /*{STUD_PARAMETERS}*/

        /*{STYLE_PARAMETERS}*/

        baseSideAdjustment = bSideAdjustment,
        
        /*{PRESET_PARAMETERS}*/
    );

    machineblock(
        size = [brick2SizeX, brick2SizeY,baseLayers],
        offset = [brick2OffsetX - 0.5*(brick1SizeX-brick2SizeX), 0, 0],
        align="ccs",

        baseWallGapsY = [[brick1OffsetY, 2, brick1SizeY]],
        /*{BASE_PARAMETERS}*/

        /*{STUD_PARAMETERS}*/

        /*{STYLE_PARAMETERS}*/
        
        baseSideAdjustment = bSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );    
}
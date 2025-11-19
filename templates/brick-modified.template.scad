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

// Brick 1 size (grid)
size = [2, 1, 3]; // [1:0.1:32]

// Brick 2 size (grid)
sizeY_2 = 1; // [1:0.1:32]

holeX = true;

/* [Studs] */

/*{STUD_VARIABLES_1}*/

/*{STUD_VARIABLES_2}*/

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

machineblock(
    size = size,
    holeX = holeX,
    
    /*{STUD_PARAMETERS_1}*/

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

machineblock(
    size = [size[0], sizeY_2, 1],
    offset = [0, size[1], 1],

    holeZ = holeX,
    holeZPartialY = "start",
    holeZDiameter = 3.75,
    tubeZDiameter = 0,
    /*{STUD_PARAMETERS_2}*/

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment = [bSideAdjustment,bSideAdjustment, -bSideAdjustment, bSideAdjustment],
    
    /*{PRESET_PARAMETERS}*/
    
);
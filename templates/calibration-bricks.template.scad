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

size_1 = [1, 1, 1];

size_2 = [3, 1, 1];

size_3 = [3, 3, 1];

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

machineblock(
    size = size_1, 
    
    /*{STYLE_PARAMETERS}*/
    
    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);

machineblock(
    size = size_2,
    offset = [size_1[0] + 0.5, 0, 0],
    
    /*{STYLE_PARAMETERS}*/
    
    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);

machineblock(
    size = size_3, 
    offset = [size_1[0] + 0.5 + size_2[0] + 0.5, 0, 0],
    
    /*{STYLE_PARAMETERS}*/
    
    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);


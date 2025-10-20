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

brick1Size = [1, 1, 1];

brick2Size = [3, 1, 1];

brick3Size = [3, 3, 1];

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Studs] */
//Whether to render the stud icon
studIcon = true;

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

machineblock(
    size=brick1Size, 
    studIcon = studIcon,
    
    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);

machineblock(
    size=brick2Size,
    offset = [brick1Size[0] + 0.5, 0, 0],
    studIcon = studIcon,
    
    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);

machineblock(
    size=brick3Size, 
    offset = [brick1Size[0] + 0.5 + brick2Size[0] + 0.5, 0, 0],
    studIcon = studIcon,
    
    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);


/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Drill Holder
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
/*{IMPORTS}*/

/* [Render] */
// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]

/* [Size] */

brick1SizeX = 4;
brick1HolesZ = true;
brick1KnobType = "classic"; // [classic, technic]

brick2SizeX = 4;
brick2HolesZ = true;
brick2KnobType = "classic"; // [classic, technic]

gridSizeY = 2;
middleSizeX = 1;
middleLayers = 2;

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Studs] */
//Whether to render the stud icon
studIcon = true;

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */
multipart = assemblyMode != "merged";
assembled = assemblyMode != "unassembled";

/*{HIDDEN_PARAMETERS}*/

machineblock(
    size=[brick1SizeX,gridSizeY,1],
    offset=[-0.5*(brick1SizeX-middleSizeX),0,0],
    holeZ=[brick1HolesZ,[brick1SizeX-middleSizeX-1,0,brick1SizeX-2,gridSizeY-2,true]],
    studType = brick1KnobType,
    studIcon = studIcon,
    align="ccs",

    /*{BASE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

machineblock(
    size=[middleSizeX,gridSizeY,middleLayers],
    offset=[0,0,1],
    studs = false,
    tongue = multipart,
    align="ccs",
    studIcon = studIcon,

    /*{BASE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

machineblock(
    size=[middleSizeX,gridSizeY,1],
    offset=[0, assembled ? 0 : -gridSizeY-0.5, assembled ? middleLayers+1 : 0],
    studType = brick2KnobType,
    baseCutoutType = multipart ? "groove" : "none",
    tongueThicknessAdjustment = 0.1,
    align="ccs",
    studIcon = studIcon,

    /*{BASE_PARAMETERS}*/

    baseSideAdjustment = [bSideAdjustment, -bSideAdjustment, bSideAdjustment, bSideAdjustment],
    
    /*{PRESET_PARAMETERS}*/
);


machineblock(
    size=[brick2SizeX-middleSizeX,gridSizeY,1],
    offset=[0.5*(brick2SizeX-middleSizeX+middleSizeX), assembled ? 0 : -gridSizeY-0.5, assembled ? middleLayers+1 : 0],
    holeZ=brick2HolesZ,
    studType = brick2KnobType,
    align="ccs",
    studIcon = studIcon,

    /*{BASE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

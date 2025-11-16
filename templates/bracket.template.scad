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

// Bracke Size
size = [7, 2, 4]; // [0:1:128]

middleWidth = 1;

//Whether first plate has pin holes
holeZ_1 = true;

//Whether second plate has pin holes
holeZ_2 = true;






/* [Base] */

/*{BASE_VARIABLES}*/

/* [Studs] */

/*{STUD_VARIABLES_1}*/

/*{STUD_VARIABLES_2}*/

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */
middleLayers = size[2] - 2;
brick1SizeX = 0.5 * (size[0] + middleWidth);
brick2SizeX = 0.5 * (size[0] + middleWidth);

gridSizeY = size[1];

multipart = assemblyMode != "merged";
assembled = assemblyMode != "unassembled";

/*{HIDDEN_PARAMETERS}*/

machineblock(
    size=[brick1SizeX,gridSizeY,1],
    offset=[-0.5*(brick1SizeX-middleWidth),0,0],
    align="ccs",
    
    holeZ=[holeZ_1,[brick1SizeX-middleWidth-1,0,brick1SizeX-2,gridSizeY-2,false]],
    
    /*{STUD_PARAMETERS_1}*/

    /*{BASE_PARAMETERS}*/

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

machineblock(
    size=[middleWidth,gridSizeY,middleLayers],
    offset=[0,0,1],
    align="ccs",
    
    studs = false,
    tongue = multipart,
    
    /*{BASE_PARAMETERS}*/

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

machineblock(
    size=[middleWidth,gridSizeY,1],
    offset=[0, assembled ? 0 : -gridSizeY-0.5, assembled ? middleLayers+1 : 0],
    align="ccs",
    
    baseCutoutType = multipart ? "groove" : "none",
    tongueThicknessAdjustment = 0.1,
    
    /*{STUD_PARAMETERS_2}*/

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment = [bSideAdjustment, -bSideAdjustment, bSideAdjustment, bSideAdjustment],
    
    /*{PRESET_PARAMETERS}*/
);


machineblock(
    size=[brick2SizeX-middleWidth,gridSizeY,1],
    offset=[0.5*(brick2SizeX-middleWidth+middleWidth), assembled ? 0 : -gridSizeY-0.5, assembled ? middleLayers+1 : 0],
    align="ccs",
    
    holeZ=holeZ_2,
    
    /*{BASE_PARAMETERS}*/

    /*{STUD_PARAMETERS_2}*/

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

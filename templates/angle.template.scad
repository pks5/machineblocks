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
size = [3, 2, 1]; // [1:32]

// Second brick's size in Y-direction specified as multiple of an 1x1 brick.
brick2SizeY = 2; // [1:32]

// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]

/* [Base] */

// Radius of the vertical brick
baseRoundingRadiusZ = [0, 0.5, 0.5, 0];

/*{BASE_VARIABLES}*/

/* [Studs] */

/*{STUD_VARIABLES_1}*/

/*{STUD_VARIABLES_2}*/

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

// Generate the block


machineblock(
    size = size,
    
    /*{BASE_PARAMETERS}*/

    /*{STUD_PARAMETERS_1}*/
    
    connectors = assemblyMode == "merged" ? false : [[ 2, 0 ] ],
    connectorSideTolerance = assemblyMode == "merged" ? 0 : 0.1,

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment =
        [ bSideAdjustment, bSideAdjustment, assemblyMode == "merged" ? 0 : bSideAdjustment, bSideAdjustment ],
    
    /*{PRESET_PARAMETERS}*/
){

  machineblock(
      size = [ size[0], brick2SizeY, 0.5 ],
      offset = [assemblyMode == "unassembled" ? 2.5 : 0, 0,0],
      rotation = [assemblyMode == "unassembled" ? 0 : 90,0,0],
      
      baseCutoutType = "none",
      baseRoundingRadius=[0,0,baseRoundingRadiusZ],

      /*{STUD_PARAMETERS_2}*/
      
      connectors = assemblyMode == "merged" ? false : [ [ 2, 2 ] ],
      connectorHeight = size[2] * unitGrid[1],
      
      /*{STYLE_PARAMETERS}*/

      baseSideAdjustment =
        [ bSideAdjustment, bSideAdjustment, 0, bSideAdjustment ],

      /*{PRESET_PARAMETERS}*/
  );
}




    
 
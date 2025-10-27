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

// Both bricks' size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 3; // [1:32]
// First brick's size in Y-direction specified as multiple of an 1x1 brick.
brick1SizeY = 2; // [1:32]
// Second brick's size in Y-direction specified as multiple of an 1x1 brick.
brick2SizeY = 2; // [1:32]
// First brick's height specified as number of layers. Each layer has the height of one plate.
brick1BaseLayers = 1; // [1:24]

// Second brick's base height in mm
//brick2BaseHeight = 1.8;

/* [Base] */

// Radius of the vertical brick
baseRoundingRadiusZ = [0, 0.5, 0.5, 0];

/*{BASE_VARIABLES}*/

/* [Knobs] */

// Whether first brick should have knobs.
brick1Knobs = true;
// Type of first brick's knobs
brick1KnobType = "solid"; // [solid, hollow]
// Whether second brick should have knobs.
brick2Knobs = true;
// Type of second brick's knobs
brick2KnobType = "hollow"; // [solid, hollow]

/*{STUD_VARIABLES}*/

/* [Render] */

// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

// Generate the block


machineblock(
      size = [ brickSizeX, brick1SizeY,brick1BaseLayers ],
      
      /*{BASE_PARAMETERS}*/

      studs = brick1Knobs,
      studType = brick1KnobType,
      
      /*{STUD_PARAMETERS}*/

      connectors = assemblyMode == "merged" ? false : [[ 2, 0 ] ],
      connectorSideTolerance = assemblyMode == "merged" ? 0 : 0.1,

      /*{STYLE_PARAMETERS}*/

      baseSideAdjustment =
          [ bSideAdjustment, bSideAdjustment, assemblyMode == "merged" ? 0 : bSideAdjustment, bSideAdjustment ],
      
      /*{PRESET_PARAMETERS}*/
){

  machineblock(
        size = [ brickSizeX, brick2SizeY, 0.5 ],
        offset = [assemblyMode == "unassembled" ? 2.5 : 0, 0,0],
        rotation = [assemblyMode == "unassembled" ? 0 : 90,0,0],
        
        baseCutoutType = "none",
        baseRoundingRadius=[0,0,baseRoundingRadiusZ],

        studs = brick2Knobs,
        studType = brick2KnobType,
        
        /*{STUD_PARAMETERS}*/

        connectors = assemblyMode == "merged" ? false : [ [ 2, 2 ] ],
        connectorHeight = brick1BaseLayers * unitGrid[1],
        
        /*{STYLE_PARAMETERS}*/

        baseSideAdjustment =
          [ bSideAdjustment, bSideAdjustment, 0, bSideAdjustment ],

        /*{PRESET_PARAMETERS}*/
  );
}




    
 
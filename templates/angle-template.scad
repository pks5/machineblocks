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
brick2BaseHeight = 1.8;

/* [Base] */

// Type of cut-out on the underside.
brick1BaseCutoutType = "classic"; // [none, classic]

/*{BASE_VARIABLES}*/

/* [Knobs] */

// Whether first brick should have knobs.
brick1Knobs = true;
// Type of first brick's knobs
brick1KnobType = "solid"; // [solid, ring]
// Whether second brick should have knobs.
brick2Knobs = true;
// Type of second brick's knobs
brick2KnobType = "ring"; // [solid, ring]

/* [Render] */

// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]

/* [Hidden] */

// Grid Size XY
gridSizeXY = 8.0;
// Grid Size Z
gridSizeZ = 3.2;

// Generate the block
union()
{
  machineblock(size = [ brickSizeX, brick1SizeY,brick1BaseLayers ],
        baseCutoutType = brick1BaseCutoutType,
        /*{BASE_PARAMETERS}*/

        connectors = assemblyMode == "merged" ? false : [[ 2, 0 ] ],
        connectorSideTolerance = assemblyMode == "merged" ? 0 : 0.1,
        studs = brick1Knobs,
        studType = brick1KnobType,

        baseSideAdjustment = baseSideAdjustment,
        
        /*{PRESET_PARAMETERS}*/
  );
}

translate(assemblyMode != "unassembled" ? [0, -0.5 * brick1SizeY * gridSizeXY, 0.5 * brick2SizeY * gridSizeXY] : [(brickSizeX + 0.5) * gridSizeXY, 0, 0]) 
  rotate(assemblyMode != "unassembled" ? [ 90, 0, 0 ] : [ 0, 0, 0 ])
  {

    machineblock(size = [ brickSizeX, brick2SizeY, 1 ],
          baseHeight = brick2BaseHeight,
          baseCutoutType = "none",
          /*{BASE_PARAMETERS}*/

          studs = brick2Knobs,
          studType = brick2KnobType,
          connectors = assemblyMode == "merged" ? false : [ [ 2, 2 ] ],
          connectorHeight = brick1BaseLayers * gridSizeZ,
          

          baseSideAdjustment =
            [ baseSideAdjustment, baseSideAdjustment, 0, baseSideAdjustment ],

          /*{PRESET_PARAMETERS}*/
    );
  }
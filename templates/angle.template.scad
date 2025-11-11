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
size = [3, 2, 1]; // [1:1:32]

// Brick 2 Size
size_2 = [3, 2]; // [1:1:32]

/* [Bracket] */

// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]

// Whether bracked should be inverted
inverted = false;

// Offset of brick 2
offset = 0; // [-32:1:32]

/* [Base] */

/*{BASE_VARIABLES}*/

// Radius of the brick 1 (grid)
roundingRadius_1 = [0.0, 0.0, 0.0, 0.0]; // [0:0.1:8]

// Radius of the brick 2 (grid)
roundingRadius_2 = [0.0, 0.5, 0.5, 0.0]; // [0:0.1:8]

/* [Studs] */

/*{STUD_VARIABLES_1}*/

/*{STUD_VARIABLES_2}*/

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/
connectorPaddingStart1 = max(0, offset);
connectorPaddingEnd1 = max(0, size[0] - size_2[0] - offset);

connectorPaddingStart2 = max(0, -offset);
connectorPaddingEnd2 = max(0, size_2[0] - size[0] + offset);

echo (connectorPaddingEnd1 = connectorPaddingEnd1, connectorPaddingEnd2 = connectorPaddingEnd2);

// Generate the block


machineblock(
    size = size,
    
    /*{BASE_PARAMETERS}*/

    baseRoundingRadius=[0,0,roundingRadius_1],

    /*{STUD_PARAMETERS_1}*/
    
    connectors = assemblyMode == "merged" ? false : [[ 2, 0 ] ],
    connectorSideTolerance = assemblyMode == "merged" ? 0 : 0.1,
    connectorPadding = [connectorPaddingStart1, connectorPaddingEnd1],

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment =
        [ bSideAdjustment, bSideAdjustment, assemblyMode == "merged" ? 0 : bSideAdjustment, bSideAdjustment ],
    
    /*{PRESET_PARAMETERS}*/
){

  machineblock(
      size = [ size_2[0], size_2[1], 0.5 ],

      offset = assemblyMode == "unassembled" ? [size[0] + 0.5, 0, 0] : (inverted ? [offset, 0, 0] : [offset, 0, size[2]]),
      
      rotation = assemblyMode == "unassembled" ? [0, 0, 0] : (inverted ? [90,0,0] : [-90,0,180]),
      
      rotationOffset = assemblyMode == "unassembled" ? [0, 0, 0] : (inverted ? [0,0,0] : [-0.5*size_2[0],0,0]),
      
      baseCutoutType = "none",
      baseRoundingRadius=[0,0,roundingRadius_2],

      /*{STUD_PARAMETERS_2}*/
      
      connectors = assemblyMode == "merged" ? false : [ [ 2, 2 ] ],
      connectorHeight = size[2] * unitGrid[1],
      connectorPadding = [connectorPaddingStart2, connectorPaddingEnd2],
      
      /*{STYLE_PARAMETERS}*/

      baseSideAdjustment =
        [ bSideAdjustment, bSideAdjustment, 0, bSideAdjustment ],

      /*{PRESET_PARAMETERS}*/
  );
}




    
 
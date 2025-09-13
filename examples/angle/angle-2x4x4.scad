/**
 * MachineBlocks
 * https://machineblocks.com/examples/angle
 *
 * Angle 2x4x4
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Include the library
use <../../lib/block.scad>;
include <../../config/presets.scad>;

/* [Render] */
// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]
// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

/* [Size] */

// Both bricks' size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 2; // [1:32]
// First brick's size in Y-direction specified as multiple of an 1x1 brick.
brick1SizeY = 4; // [1:32]
// Second brick's size in Y-direction specified as multiple of an 1x1 brick.
brick2SizeY = 4; // [1:32]
// First brick's height specified as number of layers. Each layer has the height of one plate.
brick1BaseLayers = 3; // [1:24]
// Second brick's base height in mm
brick2BaseHeight = 1.8;

/* [Base] */

// Type of cut-out on the underside.
brick1BaseCutoutType = "classic"; // [none, classic]

/* [Knobs] */

// Whether first brick should have knobs.
brick1Knobs = true;
// Type of first brick's knobs
brick1KnobType = "classic"; // [classic, technic]
// Whether second brick should have knobs.
brick2Knobs = true;
// Type of second brick's knobs
brick2KnobType = "technic"; // [classic, technic]

/* [Hidden] */

// Grid Size XY
gridSizeXY = 8.0;
// Grid Size Z
gridSizeZ = 3.2;

// Generate the block
union()
{
  block(grid = [ brickSizeX, brick1SizeY ],
        baseLayers = brick1BaseLayers,
        baseCutoutType = brick1BaseCutoutType,
        connectors = assemblyMode == "merged" ? false : [[ 2, 0 ] ],
        connectorSideTolerance = assemblyMode == "merged" ? 0 : 0.1,
        knobs = brick1Knobs,
        knobType = brick1KnobType,

        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        knobRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution,

        gridSizeXY = gridSizeXY,
        gridSizeZ = gridSizeZ,
        
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = assemblyMode == "merged" ? 
            [ baseSideAdjustment, baseSideAdjustment, 0, baseSideAdjustment ] : baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize
  );
}

translate(assemblyMode != "unassembled" ? [0, -0.5 * brick1SizeY * gridSizeXY, 0.5 * brick2SizeY * gridSizeXY] : [(brickSizeX + 0.5) * gridSizeXY, 0, 0]) 
  rotate(assemblyMode != "unassembled" ? [ 90, 0, 0 ] : [ 0, 0, 0 ])
  {

    block(grid = [ brickSizeX, brick2SizeY ],
          baseHeight = brick2BaseHeight,
          baseCutoutType = "none",
          knobs = brick2Knobs,
          knobType = brick2KnobType,
          connectors = assemblyMode == "merged" ? false : [ [ 2, 2 ] ],
          connectorHeight = brick1BaseLayers * gridSizeZ,
          

          previewQuality = previewQuality,
          baseRoundingResolution = roundingResolution,
          holeRoundingResolution = roundingResolution,
          knobRoundingResolution = roundingResolution,
          pillarRoundingResolution = roundingResolution,

          gridSizeXY = gridSizeXY,
          gridSizeZ = gridSizeZ,
          
          baseHeightAdjustment = baseHeightAdjustment,
          baseSideAdjustment =
            [ baseSideAdjustment, baseSideAdjustment, 0, baseSideAdjustment ],
          knobSize = knobSize,
          wallThickness = wallThickness,
          tubeZSize = tubeZSize,
          pinSize = pinSize
    );
  }
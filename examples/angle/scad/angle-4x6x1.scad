/**
 * MachineBlocks
 * https://machineblocks.com/examples/angle
 *
 * Angle 4x6x1
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Imports
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;


/* [Size] */

// Both bricks' size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 4; // [1:32]
// First brick's size in Y-direction specified as multiple of an 1x1 brick.
brick1SizeY = 6; // [1:32]
// Second brick's size in Y-direction specified as multiple of an 1x1 brick.
brick2SizeY = 1; // [1:32]
// First brick's height specified as number of layers. Each layer has the height of one plate.
brick1BaseLayers = 1; // [1:24]
// Second brick's base height in mm
brick2BaseHeight = 1.8;

/* [Base] */

// Type of cut-out on the underside.
brick1BaseCutoutType = "classic"; // [none, classic]

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Knobs] */

// Whether first brick should have knobs.
brick1Knobs = true;
// Type of first brick's knobs
brick1KnobType = "classic"; // [classic, technic]
// Whether second brick should have knobs.
brick2Knobs = true;
// Type of second brick's knobs
brick2KnobType = "technic"; // [classic, technic]

/* [Render] */

// Quality of the preview in relation to the final rendering.
    previewQuality = 0.5; // [0.1:0.1:1]
    // Number of drawn fragments for roundings in the final rendering.
    roundingResolution = 64; // [16:8:128]
    previewRender = true;
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
  block(grid = [ brickSizeX, brick1SizeY ],
        baseLayers = brick1BaseLayers,
        baseCutoutType = brick1BaseCutoutType,
        baseColor = baseColor,

        connectors = assemblyMode == "merged" ? false : [[ 2, 0 ] ],
        connectorSideTolerance = assemblyMode == "merged" ? 0 : 0.1,
        knobs = brick1Knobs,
        knobType = brick1KnobType,

        gridSizeXY = gridSizeXY,
        gridSizeZ = gridSizeZ,

        previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    previewRender = previewRender,

        baseSideAdjustment = baseSideAdjustment,
        
        baseHeightAdjustment = baseHeightAdjustment,
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
          baseColor = baseColor,

          knobs = brick2Knobs,
          knobType = brick2KnobType,
          connectors = assemblyMode == "merged" ? false : [ [ 2, 2 ] ],
          connectorHeight = brick1BaseLayers * gridSizeZ,
          

          gridSizeXY = gridSizeXY,
          gridSizeZ = gridSizeZ,
          
          previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    previewRender = previewRender,

          baseSideAdjustment =
            [ baseSideAdjustment, baseSideAdjustment, 0, baseSideAdjustment ],

          baseHeightAdjustment = baseHeightAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
    );
  }
/**
 * MachineBlocks
 * https://machineblocks.com/examples/angle
 *
 * Angle 2x1x1
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

/* [View] */
// How to view the brick in the editor
viewMode = "print"; // [print, assembled, cover]

/* [Size] */

// Both bricks' size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 2; // [1:32]
// First brick's size in Y-direction specified as multiple of an 1x1 brick.
brick1SizeY = 1; // [1:32]
// Second brick's size in Y-direction specified as multiple of an 1x1 brick.
brick2SizeY = 1; // [1:32]
// First brick's height specified as number of layers. Each layer has the height of one plate.
brick1BaseLayers = 1; // [1:24]
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

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

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
        connectors = [[ 2, 0 ] ],
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
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize
  );
}

translate(viewMode != "print" ? [0, -0.5 * brick1SizeY * gridSizeXY, 0.5 * brick2SizeY * gridSizeXY + (viewMode == "cover" ? (brick1BaseLayers + 2) * gridSizeZ : 0)] : [(brickSizeX + 0.5) * gridSizeXY, 0, 0]) 
  rotate(viewMode != "print" ? [ 90, 0, 0 ] : [ 0, 0, 0 ])
  {

    block(grid = [ brickSizeX, brick2SizeY ],
          baseHeight = brick2BaseHeight,
          baseCutoutType = "none",
          knobs = brick2Knobs,
          knobType = brick2KnobType,
          connectors = [ [ 2, 2 ] ],
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
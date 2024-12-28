/**
 * Machine Blocks
 * https://machineblocks.com/examples/text
 *
 * Very Cool Text Plates
 * Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Include the MachineBlocks library
use <../../lib/block.scad>;

/* [Size] */

// Brick 1 size in X-direction specified as multiple of an 1x1 brick.
brick1SizeX = 4; // [1:32]
// Brick 1 size in X-direction specified as multiple of an 1x1 brick.
brick2SizeX = 4; // [1:32]
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]

/* [Appearance] */

text1 = "VERY";
text2 = "COOL";
textSize = 7;
textDepth = 0.6;
textSpacing = 1.1;
textFont = "RBNo3.1 Black";

/* [Calibration] */

// Adjustment of the height (mm)
baseHeightAdjustment = 0.0;
// Adjustment of each side (mm)
baseSideAdjustment = -0.1;
// Diameter of the knobs (mm)
knobSize = 5.0;
// Thickness of the walls (mm)
wallThickness = 1.5;
// Diameter of the Z-Tubes (mm)
tubeZSize = 6.4;

// Generate the brick
block(grid = [ brick1SizeX, brickSizeY ],
      baseLayers = baseLayers,
      knobs = false,
      text = text1,
      textFont = textFont,
      textSide = 5,
      textSize = textSize,
      textDepth = textDepth,
      textSpacing = textSpacing,

      baseHeightAdjustment = baseHeightAdjustment,
      baseSideAdjustment = baseSideAdjustment,
      knobSize = knobSize,
      wallThickness = wallThickness,
      tubeZSize = tubeZSize);

translate([ 0, -20, 0 ]) block(grid = [ brick2SizeX, brickSizeY ],
                               baseLayers = baseLayers,
                               knobs = false,
                               text = text2,
                               textFont = textFont,
                               textSize = textSize,
                               textSide = 5,
                               textDepth = textDepth,
                               textSpacing = textSpacing,

                               baseHeightAdjustment = baseHeightAdjustment,
                               baseSideAdjustment = baseSideAdjustment,
                               knobSize = knobSize,
                               wallThickness = wallThickness,
                               tubeZSize = tubeZSize);
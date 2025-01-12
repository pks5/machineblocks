/**
 * MachineBlocks
 * https://machineblocks.com/examples/classic-bricks
 *
 * Centered Plate 4x4
 * Copyright (c) 2022 - 2024 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Include the library
use <../../lib/block.scad>;
use <../../lib/connectors.scad>;

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 3; // [1:32]
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeVerticalY = 2; // [1:32]

/* [Appearance] */

// Type of cut-out on the underside.
baseCutoutType = "none"; // [none, classic]
// Whether to draw knobs.
knobs = true;
// Type of the knobs
knobType = "technic"; // [classic, technic]

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

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

gridSizeXY = 8.0;
assembled = false;

union()
{
  block(grid = [ brickSizeX, brickSizeY ],

        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        knobRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution,
        connectors=[[2,0]],

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize);
  
}


translate([ assembled ? 0: (brickSizeX+0.5)*gridSizeXY, assembled ? -0.5*brickSizeY*gridSizeXY : 0, assembled ? 0.5*brickSizeVerticalY*gridSizeXY:0 ])
rotate(assembled ? [90,0,0]: [0,0,0])
difference()
{

  block(grid = [ brickSizeX, brickSizeVerticalY ],
        baseLayers = 1,
        baseCutoutType = baseCutoutType,
        knobs = knobs,
        knobType = knobType,

        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        knobRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution,
        connectors=[[2,1],[3,0]],

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment =
          [ baseSideAdjustment, baseSideAdjustment, 0, baseSideAdjustment ],
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize);

  
}
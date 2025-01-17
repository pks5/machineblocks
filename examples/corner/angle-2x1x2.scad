/**
 * MachineBlocks
 * https://machineblocks.com/examples/corner
 *
 * Angle 2x1x2
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Include the library
use <../../lib/block.scad>;
use <../../lib/connectors.scad>;

/* [Preview] */
// Whether assembly view should be active
assembled = false;

/* [Size] */

// Both bricks' size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 2; // [1:32]
// First brick's size in Y-direction specified as multiple of an 1x1 brick.
brick1SizeY = 1; // [1:32]
// Second brick's size in Y-direction specified as multiple of an 1x1 brick.
brick2SizeY = 2; // [1:32]

/* [Appearance] */

// Type of cut-out on the underside.
brick1BaseCutoutType = "classic"; // [none, classic]
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

/* [Hidden] */

// Grid Size XY
gridSizeXY = 8.0;

union()
{
  block(grid = [ brickSizeX, brick1SizeY ],
        baseCutoutType = brick1BaseCutoutType,
        connectors = [[ 2, 0 ] ],
        knobs = brick1Knobs,
        knobType = brick1KnobType,

        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        knobRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution,
        
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize);
}

translate([
  assembled ? 0 : (brickSizeX + 0.5) * gridSizeXY,
  assembled ? -0.5 * brick1SizeY* gridSizeXY : 0,
  assembled ? 0.5 * brick2SizeY* gridSizeXY : 0
]) rotate(assembled ? [ 90, 0, 0 ] : [ 0, 0, 0 ])
{

  block(grid = [ brickSizeX, brick2SizeY ],
        baseHeight = 1.8,
        baseCutoutType = "none",
        knobs = brick2Knobs,
        knobType = brick2KnobType,
        connectors = [ [ 2, 2 ] ],
        connectorHeight = 3.2,

        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        knobRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution,
        
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment =
          [ baseSideAdjustment, baseSideAdjustment, 0, baseSideAdjustment ],
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize);
}
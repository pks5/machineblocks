/**
 * Machine Blocks
 * https://machineblocks.com/examples/boxes-enclosures
 *
 * Cable Channel
 * Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */
use <../../lib/block.scad>;

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

block(baseLayers = 3,
      grid = [ 4, 2 ],
      pit = true,
      pitWallGaps = [ [ 0, 0, 0 ], [ 1, 0, 0 ] ],
      tongue = true,
      tongueClampThickness = 0,
      knobSize = 5.1,
      pitWallThickness = 2.55 / 8,

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

translate([ 0, 20, 0 ]) block(baseLayers = 1,
                              grid = [ 4, 2 ],
                              pitWallGaps = [ [ 0, 0, 0 ], [ 1, 0, 0 ] ],
                              tongueClampThickness = 0,
                              tongueOuterAdjustment = 0.1,
                              baseCutoutType = "groove",
                              knobSize = 5.1,
                              pitWallThickness = 2.55 / 8,

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
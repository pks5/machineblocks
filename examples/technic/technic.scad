/**
 * Machine Blocks
 * https://machineblocks.com/examples/technic-bricks
 *
 * Technic Set
 * Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

use <../../lib/block.scad>;
include <../../config/presets.scad>;

/* [Appearance] */

// Base Cutout Type
baseCutoutType = "classic"; // [none, classic]
// Draw Knobs
knobs = true;
// Whether to draw pillars.
pillars = true;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

translate([ -26, -20, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 2 ],
                                 center = false,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

translate([ -26, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 2 ],
                                 center = false,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

translate([ -26, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 2, 2 ],
                                 center = false,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

translate([ 32, 10, 0 ])
{

  translate([ 0, -20, 0 ]) block(grid = [ 2, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

  translate([ 0, -40, 0 ]) block(grid = [ 4, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

  translate([ 0, -60, 0 ]) block(grid = [ 6, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

  translate([ 0, -80, 0 ]) block(grid = [ 8, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);
}

translate([ 108, -110, 0 ]) rotate([ 0, 0, 180 ])
{
  translate([ 0, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 2, 1 ],
                                 center = false,
                                 holesX = true,
                                 knobType = "technic",
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

  translate([ 0, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 1 ],
                                 center = false,
                                 holesX = true,
                                 knobType = "technic",
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

  translate([ 0, -80, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 1 ],
                                 center = false,
                                 holesX = true,
                                 knobType = "technic",
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 previewQuality = previewQuality,
                                 baseRoundingResolution = roundingResolution,
                                 holeRoundingResolution = roundingResolution,
                                 knobRoundingResolution = roundingResolution,
                                 pillarRoundingResolution = roundingResolution,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize,
    pinSize = pinSize);

  translate([ 0, -100, 0 ]) block(baseLayers = 3,
                                  grid = [ 8, 1 ],
                                  center = false,
                                  holesX = true,
                                  knobType = "technic",
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  pillars = pillars,

                                  previewQuality = previewQuality,
                                  baseRoundingResolution = roundingResolution,
                                  holeRoundingResolution = roundingResolution,
                                  knobRoundingResolution = roundingResolution,
                                  pillarRoundingResolution = roundingResolution,

                                  baseHeightAdjustment = baseHeightAdjustment,
                                  baseSideAdjustment = baseSideAdjustment,
                                  knobSize = knobSize,
                                  wallThickness = wallThickness,
                                  tubeZSize = tubeZSize,
    pinSize = pinSize);

  translate([ 0, -120, 0 ]) block(baseLayers = 3,
                                  grid = [ 16, 1 ],
                                  center = false,
                                  holesX = true,
                                  knobType = "technic",
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  pillars = pillars,

                                  previewQuality = previewQuality,
                                  baseRoundingResolution = roundingResolution,
                                  holeRoundingResolution = roundingResolution,
                                  knobRoundingResolution = roundingResolution,
                                  pillarRoundingResolution = roundingResolution,

                                  baseHeightAdjustment = baseHeightAdjustment,
                                  baseSideAdjustment = baseSideAdjustment,
                                  knobSize = knobSize,
                                  wallThickness = wallThickness,
                                  tubeZSize = tubeZSize,
    pinSize = pinSize);
}
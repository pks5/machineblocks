/**
 * Machine Blocks
 * https://machineblocks.com/examples/classic-bricks
 *
 * Classic Bricks
 * Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Include the library
use <../../lib/block.scad>;
include <../../config/presets.scad>;

/* [Appearance] */

// Base Cutout Type
baseCutoutType = "classic"; // [none, classic]
// Draw Knobs
knobs = true;
// Knob Centered
knobCentered = false;
// Knob Type
knobType = "classic"; // [classic, technic]
// Whether to draw pillars.
pillars = true;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

translate([ -20, -20, 0 ]) block(baseLayers = 3,
                                 grid = [ 2, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

translate([ -20, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 3, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

translate([ -20, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

translate([ -20, -80, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

translate([ -44, -120, 0 ]) block(baseLayers = 3,
                                  grid = [ 2, 14 ],
                                  center = false,
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  knobCentered = knobCentered,
                                  knobType = knobType,
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

translate([ -20, -120, 0 ]) block(baseLayers = 3,
                                  grid = [ 4, 4 ],
                                  center = false,
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  knobCentered = knobCentered,
                                  knobType = knobType,
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

translate([ 50, -84, 0 ]) rotate([ 0, 0, 180 ])
{
  translate([ 0, -20, 0 ]) block(grid = [ 2, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

  translate([ 0, -40, 0 ]) block(grid = [ 3, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

  translate([ 0, -60, 0 ]) block(grid = [ 4, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

  translate([ 0, -80, 0 ]) block(grid = [ 6, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

translate([ 20, -120, 0 ]) block(grid = [ 12, 4 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

translate([ 116, -92, 0 ]) rotate([ 0, 0, 180 ])
{
  translate([ 0, -20, 0 ]) block(baseLayers = 3,
                                 grid = [ 1, 1 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

  translate([ 0, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 2, 1 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
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

translate([ 56, -20, 0 ]) block(grid = [ 1, 1 ],
                                center = false,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobCentered = knobCentered,
                                knobType = knobType,
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

translate([ 56, -40, 0 ]) block(grid = [ 2, 1 ],
                                center = false,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobCentered = knobCentered,
                                knobType = knobType,
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

translate([ 56, -60, 0 ]) block(grid = [ 4, 1 ],
                                center = false,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobCentered = knobCentered,
                                knobType = knobType,
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

translate([ 56, -80, 0 ]) block(grid = [ 6, 1 ],
                                center = false,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobCentered = knobCentered,
                                knobType = knobType,
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
/**
 * Machine Blocks
 * https://machineblocks.com/examples/technic-bricks
 *
 * Technic Long Bricks Set
 * Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Include the MachineBlocks library
use <../../lib/block.scad>;

/* [Appearance] */

// Base Cutout Type
baseCutoutType = "classic"; // [none, classic]
// Draw Knobs
knobs = true;
// Knob Type
knobType = "technic"; // [classic, technic]
// Whether to draw pillars.
pillars = true;

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

translate([ -80, 10, 0 ]) block(baseLayers = 3,
                                holesX = true,
                                grid = [ 20, 1 ],
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
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
                                tubeZSize = tubeZSize);

translate([ -80, 0, 0 ]) block(baseLayers = 3,
                               holesX = true,
                               grid = [ 16, 1 ],
                               baseCutoutType = baseCutoutType,
                               knobs = knobs,
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
                               tubeZSize = tubeZSize);

translate([ -80, -10, 0 ]) block(baseLayers = 3,
                                 holesX = true,
                                 grid = [ 12, 1 ],
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -20, 0 ]) block(baseLayers = 3,
                                 holesX = true,
                                 grid = [ 10, 1 ],
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -30, 0 ]) block(baseLayers = 3,
                                 grid = [ 9, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 8, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -50, 0 ]) block(baseLayers = 3,
                                 grid = [ 7, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -70, 0 ]) block(baseLayers = 3,
                                 grid = [ 5, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -80, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -90, 0 ]) block(baseLayers = 3,
                                 grid = [ 3, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
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
                                 tubeZSize = tubeZSize);

translate([ -80, -100, 0 ]) block(baseLayers = 3,
                                  grid = [ 2, 1 ],
                                  holesX = true,
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
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
                                  tubeZSize = tubeZSize);
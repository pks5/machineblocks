/**
 * Machine Blocks
 * https://machineblocks.com/examples/classic-bricks
 *
 * Long Tiles
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
knobs = false;
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

translate([ 10, -10, 0 ]) block(grid = [ 8, 2 ],
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
                                tubeZSize = tubeZSize);

translate([ 10, -30, 0 ]) block(grid = [ 10, 2 ],
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
                                tubeZSize = tubeZSize);

translate([ 10, -50, 0 ]) block(grid = [ 12, 2 ],
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
                                tubeZSize = tubeZSize);

translate([ 10, -70, 0 ]) block(grid = [ 16, 2 ],
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
                                tubeZSize = tubeZSize);

translate([ 10, -90, 0 ]) block(grid = [ 20, 2 ],
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
                                tubeZSize = tubeZSize);

translate([ 10, 10, 0 ]) block(grid = [ 8, 1 ],
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
                               tubeZSize = tubeZSize);

translate([ 10, 20, 0 ]) block(grid = [ 10, 1 ],
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
                               tubeZSize = tubeZSize);

translate([ 10, 30, 0 ]) block(grid = [ 12, 1 ],
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
                               tubeZSize = tubeZSize);

translate([ 10, 40, 0 ]) block(grid = [ 16, 1 ],
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
                               tubeZSize = tubeZSize);

translate([ 10, 50, 0 ]) block(grid = [ 20, 1 ],
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
                               tubeZSize = tubeZSize);
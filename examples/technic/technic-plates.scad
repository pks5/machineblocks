/**
 * Machine Blocks
 * https://machineblocks.com/examples/technic-bricks
 *
 * Technic Plates Set
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
// Whether to draw pillars.
pillars = true;

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

translate([ 10, -20, 0 ]) block(grid = [ 4, 2 ],
                                holesZ = true,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                pillars = pillars,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = baseSideAdjustment,
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);

translate([ 10, -40, 0 ]) block(grid = [ 6, 2 ],
                                holesZ = true,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                pillars = pillars,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = baseSideAdjustment,
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);

translate([ 10, -60, 0 ]) block(grid = [ 8, 2 ],
                                holesZ = true,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                pillars = pillars,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = baseSideAdjustment,
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);

translate([ 10, -80, 0 ]) block(grid = [ 10, 2 ],
                                holesZ = true,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                pillars = pillars,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = baseSideAdjustment,
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);

translate([ 10, -100, 0 ]) block(grid = [ 12, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ 10, -120, 0 ]) block(grid = [ 16, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ 10, -140, 0 ]) block(grid = [ 20, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);
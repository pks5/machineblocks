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

translate([ -20, -20, 0 ]) block(baseLayers = 3,
                                 grid = [ 2, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ -20, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 3, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ -20, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ -20, -80, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ -44, -120, 0 ]) block(baseLayers = 3,
                                  grid = [ 2, 14 ],
                                  center = false,
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  knobCentered = knobCentered,
                                  knobType = knobType,
                                  pillars = pillars,

                                  baseHeightAdjustment = baseHeightAdjustment,
                                  baseSideAdjustment = baseSideAdjustment,
                                  knobSize = knobSize,
                                  wallThickness = wallThickness,
                                  tubeZSize = tubeZSize);

translate([ -20, -120, 0 ]) block(baseLayers = 3,
                                  grid = [ 4, 4 ],
                                  center = false,
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  knobCentered = knobCentered,
                                  knobType = knobType,
                                  pillars = pillars,

                                  baseHeightAdjustment = baseHeightAdjustment,
                                  baseSideAdjustment = baseSideAdjustment,
                                  knobSize = knobSize,
                                  wallThickness = wallThickness,
                                  tubeZSize = tubeZSize);

translate([ 50, -84, 0 ]) rotate([ 0, 0, 180 ])
{
  translate([ 0, -20, 0 ]) block(grid = [ 2, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -40, 0 ]) block(grid = [ 3, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -60, 0 ]) block(grid = [ 4, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -80, 0 ]) block(grid = [ 6, 2 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);
}

translate([ 20, -120, 0 ]) block(grid = [ 12, 4 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

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

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 2, 1 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 1 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -80, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 1 ],
                                 center = false,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobCentered = knobCentered,
                                 knobType = knobType,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);
}

translate([ 56, -20, 0 ]) block(grid = [ 1, 1 ],
                                center = false,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobCentered = knobCentered,
                                knobType = knobType,
                                pillars = pillars,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = baseSideAdjustment,
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);

translate([ 56, -40, 0 ]) block(grid = [ 2, 1 ],
                                center = false,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobCentered = knobCentered,
                                knobType = knobType,
                                pillars = pillars,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = baseSideAdjustment,
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);

translate([ 56, -60, 0 ]) block(grid = [ 4, 1 ],
                                center = false,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobCentered = knobCentered,
                                knobType = knobType,
                                pillars = pillars,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = baseSideAdjustment,
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);

translate([ 56, -80, 0 ]) block(grid = [ 6, 1 ],
                                center = false,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobCentered = knobCentered,
                                knobType = knobType,
                                pillars = pillars,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = baseSideAdjustment,
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);
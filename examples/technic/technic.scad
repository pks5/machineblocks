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

translate([ -26, -20, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 2 ],
                                 center = false,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ -26, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 2 ],
                                 center = false,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ -26, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 2, 2 ],
                                 center = false,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

translate([ 32, 10, 0 ])
{

  translate([ 0, -20, 0 ]) block(grid = [ 2, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -40, 0 ]) block(grid = [ 4, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -60, 0 ]) block(grid = [ 6, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -80, 0 ]) block(grid = [ 8, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);
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

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 1 ],
                                 center = false,
                                 holesX = true,
                                 knobType = "technic",
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -80, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 1 ],
                                 center = false,
                                 holesX = true,
                                 knobType = "technic",
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,

                                 baseHeightAdjustment = baseHeightAdjustment,
                                 baseSideAdjustment = baseSideAdjustment,
                                 knobSize = knobSize,
                                 wallThickness = wallThickness,
                                 tubeZSize = tubeZSize);

  translate([ 0, -100, 0 ]) block(baseLayers = 3,
                                  grid = [ 8, 1 ],
                                  center = false,
                                  holesX = true,
                                  knobType = "technic",
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  pillars = pillars,

                                  baseHeightAdjustment = baseHeightAdjustment,
                                  baseSideAdjustment = baseSideAdjustment,
                                  knobSize = knobSize,
                                  wallThickness = wallThickness,
                                  tubeZSize = tubeZSize);

  translate([ 0, -120, 0 ]) block(baseLayers = 3,
                                  grid = [ 16, 1 ],
                                  center = false,
                                  holesX = true,
                                  knobType = "technic",
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  pillars = pillars,

                                  baseHeightAdjustment = baseHeightAdjustment,
                                  baseSideAdjustment = baseSideAdjustment,
                                  knobSize = knobSize,
                                  wallThickness = wallThickness,
                                  tubeZSize = tubeZSize);
}
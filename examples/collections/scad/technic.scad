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

use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

/* [Appearance] */

// Base Cutout Type
baseCutoutType = "classic"; // [none, classic]
// Draw Knobs
knobs = true;
// Whether to draw pillars.
pillars = true;
// Color of the brick
baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]


/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]


translate([ -26, -20, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 2 ],
                                 align="start",
                                 previewRender=previewRender,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
                                 align="start",
                                 previewRender=previewRender,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
                                 align="start",
                                 previewRender=previewRender,
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
                                align="ccs",
                                previewRender=previewRender,
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
                                    align="ccs",
                                    previewRender=previewRender,
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
  align="ccs",
  previewRender=previewRender,
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
  align="ccs",
  previewRender=previewRender,
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
                                 align="start",
                                 previewRender=previewRender,
                                 holesX = true,
                                 knobType = "technic",
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
                                 align="start",
                                 previewRender=previewRender,
                                 holesX = true,
                                 knobType = "technic",
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
                                 align="start",
                                 previewRender=previewRender,
                                 holesX = true,
                                 knobType = "technic",
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,

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
                                  align="start",
                                  previewRender=previewRender,
                                  holesX = true,
                                  knobType = "technic",
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  pillars = pillars,
                                baseColor = baseColor,

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
                                  align="start",
                                  previewRender=previewRender,
                                  holesX = true,
                                  knobType = "technic",
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  pillars = pillars,
                                baseColor = baseColor,

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
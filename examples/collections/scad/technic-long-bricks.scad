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
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

/* [Appearance] */

// Base Cutout Type
baseCutoutType = "classic"; // [none, classic]
// Draw Knobs
knobs = true;
// Knob Type
knobType = "technic"; // [classic, technic]
// Whether to draw pillars.
pillars = true;
// Color of the brick
baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]


/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]


translate([ -80, 10, 0 ]) block(baseLayers = 3,
                                holesX = true,
                                grid = [ 20, 1 ],
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobType = knobType,
                                pillars = pillars,
                                baseColor = baseColor,

                                previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, 0, 0 ]) block(baseLayers = 3,
                               holesX = true,
                               grid = [ 16, 1 ],
                               baseCutoutType = baseCutoutType,
                               knobs = knobs,
                               knobType = knobType,
                               pillars = pillars,
                                baseColor = baseColor,

                               previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -10, 0 ]) block(baseLayers = 3,
                                 holesX = true,
                                 grid = [ 12, 1 ],
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -20, 0 ]) block(baseLayers = 3,
                                 holesX = true,
                                 grid = [ 10, 1 ],
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -30, 0 ]) block(baseLayers = 3,
                                 grid = [ 9, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -40, 0 ]) block(baseLayers = 3,
                                 grid = [ 8, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -50, 0 ]) block(baseLayers = 3,
                                 grid = [ 7, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -60, 0 ]) block(baseLayers = 3,
                                 grid = [ 6, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -70, 0 ]) block(baseLayers = 3,
                                 grid = [ 5, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -80, 0 ]) block(baseLayers = 3,
                                 grid = [ 4, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -90, 0 ]) block(baseLayers = 3,
                                 grid = [ 3, 1 ],
                                 holesX = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 knobType = knobType,
                                 pillars = pillars,
                                baseColor = baseColor,

                                 previewQuality = previewQuality,
                                previewRender=previewRender,
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

translate([ -80, -100, 0 ]) block(baseLayers = 3,
                                  grid = [ 2, 1 ],
                                  holesX = true,
                                  baseCutoutType = baseCutoutType,
                                  knobs = knobs,
                                  knobType = knobType,
                                  pillars = pillars,
                                baseColor = baseColor,

                                  previewQuality = previewQuality,
                                previewRender=previewRender,
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
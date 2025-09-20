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

translate([ 10, -20, 0 ]) block(grid = [ 4, 2 ],
                                holesZ = true,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                pillars = pillars,
                                baseColor = baseColor,
                                previewRender=previewRender,

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

translate([ 10, -40, 0 ]) block(grid = [ 6, 2 ],
                                holesZ = true,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                pillars = pillars,
                                baseColor = baseColor,
                                previewRender=previewRender,

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

translate([ 10, -60, 0 ]) block(grid = [ 8, 2 ],
                                holesZ = true,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                pillars = pillars,
                                baseColor = baseColor,
                                previewRender=previewRender,

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

translate([ 10, -80, 0 ]) block(grid = [ 10, 2 ],
                                holesZ = true,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                pillars = pillars,
                                baseColor = baseColor,
                                previewRender=previewRender,

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

translate([ 10, -100, 0 ]) block(grid = [ 12, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,
                                previewRender=previewRender,

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

translate([ 10, -120, 0 ]) block(grid = [ 16, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,
                                previewRender=previewRender,

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

translate([ 10, -140, 0 ]) block(grid = [ 20, 2 ],
                                 holesZ = true,
                                 baseCutoutType = baseCutoutType,
                                 knobs = knobs,
                                 pillars = pillars,
                                baseColor = baseColor,
                                previewRender=previewRender,

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
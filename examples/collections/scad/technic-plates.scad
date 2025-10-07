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

translate([10, -20, 0]) machineblock(
    size=[4, 2,1],
    holeZ=true,
    baseCutoutType=baseCutoutType,
    studs=knobs,
    pillars=pillars,
    baseColor=baseColor,
    scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseSideAdjustment=baseSideAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
  );

translate([10, -40, 0]) machineblock(
    size=[6, 2,1],
    holeZ=true,
    baseCutoutType=baseCutoutType,
    studs=knobs,
    pillars=pillars,
    baseColor=baseColor,
    scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseSideAdjustment=baseSideAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
  );

translate([10, -60, 0]) machineblock(
    size=[8, 2,1],
    holeZ=true,
    baseCutoutType=baseCutoutType,
    studs=knobs,
    pillars=pillars,
    baseColor=baseColor,
    scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseSideAdjustment=baseSideAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
  );

translate([10, -80, 0]) machineblock(
    size=[10, 2,1],
    holeZ=true,
    baseCutoutType=baseCutoutType,
    studs=knobs,
    pillars=pillars,
    baseColor=baseColor,
    scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseSideAdjustment=baseSideAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
  );

translate([10, -100, 0]) machineblock(
    size=[12, 2,1],
    holeZ=true,
    baseCutoutType=baseCutoutType,
    studs=knobs,
    pillars=pillars,
    baseColor=baseColor,
    scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseSideAdjustment=baseSideAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
  );

translate([10, -120, 0]) machineblock(
    size=[16, 2,1],
    holeZ=true,
    baseCutoutType=baseCutoutType,
    studs=knobs,
    pillars=pillars,
    baseColor=baseColor,
    scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseSideAdjustment=baseSideAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
  );

translate([10, -140, 0]) machineblock(
    size=[20, 2,1],
    holeZ=true,
    baseCutoutType=baseCutoutType,
    studs=knobs,
    pillars=pillars,
    baseColor=baseColor,
    scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseSideAdjustment=baseSideAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
  );

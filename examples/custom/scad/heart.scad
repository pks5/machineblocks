use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

block(
    grid=[6,4],
    baseRoundingRadius=[0,0,[0,0,16,16]],
    wallGapsX=[[0,1,4]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment=[baseSideAdjustment,0.1,baseSideAdjustment,baseSideAdjustment],
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
){

  block(
    grid=[4,6],
    baseRoundingRadius=[0,0,[0,16,16,0]],
    wallGapsY=[[0,1,4]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment=[baseSideAdjustment,0.1,baseSideAdjustment,baseSideAdjustment],
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
);
}



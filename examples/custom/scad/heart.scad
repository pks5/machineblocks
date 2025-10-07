use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

machineblock(
    size=[6,4,1],
    baseRoundingRadius=[0,0,[0,0,16,16]],
    baseWallGapsX=[[0,1,4]],
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = [baseSideAdjustment,-baseSideAdjustment,baseSideAdjustment,baseSideAdjustment],
    baseWallThicknessAdjustment = baseWallThicknessAdjustment,
    baseClampThickness = baseClampThickness,
    tubeXDiameterAdjustment = tubeXDiameterAdjustment,
    tubeYDiameterAdjustment = tubeYDiameterAdjustment,
    tubeZDiameterAdjustment = tubeZDiameterAdjustment,
    holeXDiameterAdjustment = holeXDiameterAdjustment,
    holeYDiameterAdjustment = holeYDiameterAdjustment,
    holeZDiameterAdjustment = holeZDiameterAdjustment,
    pinDiameterAdjustment = pinDiameterAdjustment,
    studDiameterAdjustment = studDiameterAdjustment,
    studCutoutAdjustment = studCutoutAdjustment,
    previewRender = previewRender
){

  machineblock(
    size=[4,6,1],
    baseRoundingRadius=[0,0,[0,16,16,0]],
    baseWallGapsY=[[0,1,4]],
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = [baseSideAdjustment,-baseSideAdjustment,baseSideAdjustment,baseSideAdjustment],
    baseWallThicknessAdjustment = baseWallThicknessAdjustment,
    baseClampThickness = baseClampThickness,
    tubeXDiameterAdjustment = tubeXDiameterAdjustment,
    tubeYDiameterAdjustment = tubeYDiameterAdjustment,
    tubeZDiameterAdjustment = tubeZDiameterAdjustment,
    holeXDiameterAdjustment = holeXDiameterAdjustment,
    holeYDiameterAdjustment = holeYDiameterAdjustment,
    holeZDiameterAdjustment = holeZDiameterAdjustment,
    pinDiameterAdjustment = pinDiameterAdjustment,
    studDiameterAdjustment = studDiameterAdjustment,
    studCutoutAdjustment = studCutoutAdjustment,
    previewRender = previewRender
);
}



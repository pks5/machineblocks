/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Winner's Podium
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the MachineBlocks library
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;


machineblock(
    size=[6,2,3],
    
    scale = scale,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
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
    previewRender = previewRender,
    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    studRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution
){
    machineblock(
        size=[2,2,3],
        offset=[2,0,3],
        
        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
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
        previewRender = previewRender,
        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        studRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution
    );    
}
    
    

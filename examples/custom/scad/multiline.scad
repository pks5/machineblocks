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
    size=[9,9,1],
    studs=false,
    alignChildren=["center", "end", "start"],
    
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
        size=[9,2,1],
        base=false,
        offset=[0,0,0],
        studs=false,
        align=["center", "end", "start"],

        text="Information",
        textSide=5,
        textDepth=0.4,
        textSize=8,
    
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
    
    machineblock(
        size=[9,2,1],
        offset=[0,-2.5,0],
        base=false,
        
        studs=false,
        align=["center", "end", "start"],

        text="Now you can create",
        textSide=5,
        textDepth=0.4,
        textSize=5,
        
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
    
    machineblock(
        size=[9,2,1],
        offset=[0,-4,0],
        base=false,
        
        studs=false,
        align=["center", "end", "start"],

        text="fancy multiline",
        textSide=5,
        textDepth=0.4,
        textSize=6,
        
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
    
    machineblock(
        size=[9,2,1],
        offset=[0,-5.5,0],
        base=false,
        
        studs=false,
        align=["center", "end", "start"],

        text="bricks!",
        textSide=5,
        textDepth=0.4,
        textSize=8,
    
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
    
    

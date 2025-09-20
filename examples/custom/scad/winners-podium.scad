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


block(
    grid=[6,2],
    baseLayers=3,
    previewRender = previewRender,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
){
    block(
        grid=[2,2],
        baseLayers=3,
        gridOffset=[2,0,3],
        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize
    );    
}
    
    

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
    grid=[9,9],
    baseLayers=1,
    knobs=false,
    alignChildren=["center", "end", "start"],

    previewRender = previewRender,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
){
    block(
        grid=[9,2],
        base=false,
        baseLayers=1,
        gridOffset=[0,0,0],
        knobs=false,
        align=["center", "end", "start"],

        text="Information",
        textSide=5,
        textDepth=0.4,
        textSize=8,

        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize
    );    
    
    block(
        grid=[9,2],
        gridOffset=[0,-2.5,0],
        base=false,
        baseLayers=1,
        
        knobs=false,
        align=["center", "end", "start"],

        text="Now you can create",
        textSide=5,
        textDepth=0.4,
        textSize=5,

        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize
    );    
    
    block(
        grid=[9,2],
        gridOffset=[0,-4,0],
        base=false,
        baseLayers=1,
        
        knobs=false,
        align=["center", "end", "start"],

        text="fancy multiline",
        textSide=5,
        textDepth=0.4,
        textSize=6,

        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize
    );    
    
    block(
        grid=[9,2],
        gridOffset=[0,-5.5,0],
        base=false,
        baseLayers=1,
        
        knobs=false,
        align=["center", "end", "start"],

        text="bricks!",
        textSide=5,
        textDepth=0.4,
        textSize=8,

        previewRender = previewRender,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize,
        pinSize = pinSize
    );    
}
    
    

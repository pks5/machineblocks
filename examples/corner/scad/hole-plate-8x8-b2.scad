/**
* MachineBlocks
* https://machineblocks.com/examples/corner
*
* Hole Plate 8x8 B2
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;


/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 8; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 8; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]
// Border Size as multiple of an 1x1 brick.
borderSize = 2; // [1:8]

/* [Base] */

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Knobs] */

// Whether to draw knobs.
knobs = true;
// Type of the knobs
knobType = "classic"; // [classic, technic]

/* [Render] */

// Quality of the preview in relation to the final rendering.
    previewQuality = 0.5; // [0.1:0.1:1]
    // Number of drawn fragments for roundings in the final rendering.
    roundingResolution = 64; // [16:8:128]
    previewRender = true;

// Generate the block
union(){
    block(
        grid=[borderSize, brickSizeY], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        baseColor = baseColor,

        wallGapsY=[[0,1,borderSize], [brickSizeY-borderSize,1,borderSize]],
        gridOffset=[-0.5*(brickSizeX-borderSize),0,0],
        align="ccs",
        
        previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    previewRender = previewRender,

        baseSideAdjustment = baseSideAdjustment,
        
        baseHeightAdjustment = baseHeightAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
    );  

    block(
        grid=[brickSizeX,borderSize],
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        baseColor = baseColor,

        wallGapsX=[[0,0,borderSize], [brickSizeX-borderSize,0,borderSize]],
        gridOffset=[0,0.5*(brickSizeY-borderSize),0],
        align="ccs",

        previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    previewRender = previewRender,

        baseSideAdjustment = baseSideAdjustment,
    
        baseHeightAdjustment = baseHeightAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
    );

    block(
        grid=[borderSize, brickSizeY], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        baseColor = baseColor,

        wallGapsY=[[0,0,borderSize], [brickSizeY-borderSize,0,borderSize]],
        gridOffset=[0.5*(brickSizeX-borderSize),0,0],
        align="ccs",
        
        previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    previewRender = previewRender,

        baseSideAdjustment = baseSideAdjustment,
    
        baseHeightAdjustment = baseHeightAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
    );    

    block(
        grid=[brickSizeX,borderSize], 
        knobs=knobs,
        knobType=knobType,
        baseLayers = baseLayers,
        baseColor = baseColor,

        wallGapsX=[[0,1,borderSize], [brickSizeX-borderSize,1,borderSize]],
        gridOffset=[0,-0.5*(brickSizeY-borderSize),0],
        align="ccs",
        
        previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    previewRender = previewRender,

        baseSideAdjustment = baseSideAdjustment,
    
        baseHeightAdjustment = baseHeightAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
    );
}
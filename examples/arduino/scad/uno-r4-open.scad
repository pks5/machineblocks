/**
* MachineBlocks
* https://machineblocks.com/examples/classic-bricks
*
* Slim Plate 4x1
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Include the library
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

/* [Hidden] */
frameSizeX = 8;
frameSizeY = 7;
middleX=3;

//Shift of the frame (grid multiple)
shiftX = (0.5*frameSizeX-0.5) - middleX;
//Offset of the pcb in mm
pcbOffsetX = 7;

// Generate the block
block(
    grid = [1, frameSizeY],
    baseLayers = 1,
    
    knobs = false,
    wallGapsY=[[0,2,1], [frameSizeY-1,2,1]],

    pcb = true,
    pcbScrewSockets = [[0,0],[-26 + pcbOffsetX, -24],[-25 + pcbOffsetX, 24],[26 + pcbOffsetX, 9], [26 + pcbOffsetX, -19]],
    pcbMountingType = "screws",
    
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
    pinSize = pinSize,
    align="ccs"
);

block(
    grid = [frameSizeX, 1],
    gridOffset=[shiftX, -(0.5*frameSizeY-0.5),0],
    baseLayers = 1,
    
    knobs = false,

    wallGapsX=[[0,1,1], [middleX,1,1], [frameSizeX-1,1,1]],

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
    pinSize = pinSize,
    align="ccs"
);

block(
    grid = [1, frameSizeY],
    gridOffset=[shiftX-(0.5*frameSizeX-0.5), 0,0],
    baseLayers = 1,
    
    knobs = false,
    wallGapsY=[[0,1,1], [frameSizeY-1,1,1]],

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
    pinSize = pinSize,
    align="ccs"
);

block(
    grid = [frameSizeX, 1],
    gridOffset=[shiftX, (0.5*frameSizeY-0.5),0],
    baseLayers = 1,
    
    knobs = false,
    wallGapsX=[[0,0,1], [middleX,0,1], [frameSizeX-1,0,1]],

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
    pinSize = pinSize,
    align="ccs"
);

block(
    grid = [1, frameSizeY],
    gridOffset=[shiftX + (0.5*frameSizeX-0.5), 0,0],
    baseLayers = 1,
    
    knobs = false,
    wallGapsY=[[0,0,1], [frameSizeY-1,0,1]],

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
    pinSize = pinSize,
    align="ccs"
);
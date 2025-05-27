/**
* MachineBlocks
* https://machineblocks.com/examples/classic-bricks
*
* Tall Plate 16x8
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Include the library
use <../../lib/block.scad>;

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 22; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 17; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseHeight = 8; // [1:24]

/* [Appearance] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]
// Whether to draw knobs.
knobs = false;

// Whether to draw pillars.
pillars = false;

stabilizerGrid = true;

// Whether brick should have a pit
pit = false;
// Whether knobs should be drawn inside pit
pitKnobs = false;
// Pit wall thickness as multiple of one brick side length
pitWallThickness = 0.333;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

/* [Calibration] */

// Adjustment of the height (mm)
baseHeightAdjustment = 0.0;
// Adjustment of each side (mm)
baseSideAdjustment = -0.1;
// Diameter of the knobs (mm)
knobSize = 5.0;
// Thickness of the walls (mm)
wallThickness = 1.5;
// Diameter of the Z-Tubes (mm)
tubeZSize = 6.4;

// Generate the block
difference(){
block(
    grid = [brickSizeX, brickSizeY],
    baseHeight = baseHeight,
    baseCutoutType = baseCutoutType,
    
    knobs = knobs,
    
    pillars = pillars,
    stabilizerGrid = stabilizerGrid,
    
    pit = pit,
    pitKnobs = pitKnobs,
    pitWallThickness = pitWallThickness,
    
    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);

block(
    grid = [brickSizeX, brickSizeY],
    baseLayers=3,
    knobs=false,
    baseCutoutType = "none",
    baseSideAdjustment = [baseSideAdjustment-8,baseSideAdjustment-3,baseSideAdjustment-18,baseSideAdjustment-18]
    
);
}
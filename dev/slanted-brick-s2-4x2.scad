/**
* MachineBlocks
* https://machineblocks.com/examples/slanted
*
* Slanted Brick S2 4x2
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Include the library
use <../lib/block.scad>;

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 4; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 5; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 3; // [1:24]

/* [Appearance] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]
// Whether to draw knobs.
knobs = false;
// Whether knobs should be centered.
knobCentered = false;
// Type of the knobs
knobType = "classic"; // [classic, technic]

// Whether to draw pillars.
pillars = true;

tongue = true;
tongueClampThickness = 0;

// Whether brick should have Technic holes along X-axis.
holesX = false;
// Whether brick should have Technic holes along Y-axis.
holesY = false;
// Whether brick should have Technic holes along Z-axis.
holesZ = false;

// Whether brick should have a pit
pit = true;
// Whether knobs should be drawn inside pit
pitKnobs = true;
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

// Generate the block
machineblock(
    size = [brickSizeX, brickSizeY, baseLayers],
    baseCutoutType = baseCutoutType,
    
    studs = knobs,
    studCentered = knobCentered,
    studType = knobType,
    
    pillars = pillars,
    
    holeX = holesX,
    holeY = holesY,
    holeZ = holesZ,
    
    pit = pit,
    pitKnobs = pitKnobs,
    pitWallThickness = pitWallThickness,
    
    tongue = tongue,
    tongueClampThickness = tongueClampThickness,
    
    bevel = [[2,0],[-1,0],[0,0],[0,0]],
    
    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    studRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment
);

// Generate the block
machineblock(
    size = [brickSizeX, brickSizeY, 1],
    offset = [5,0,0],
    baseCutoutType = "groove",
    
    studs = true,
    studCentered = knobCentered,
    studType = knobType,
    
    pillars = pillars,
    
    holeX = holesX,
    holeY = holesY,
    holeZ = holesZ,
    
    bevel = [[2,0],[-1,0],[0,0],[0,0]],
    
    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    studRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,

    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment
);
/**
* MachineBlocks
* https://machineblocks.com/examples/technic-bricks
*
* Tile TZ 6x4
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
brickSizeX = 6; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 4; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]

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

// Whether brick should have Technic holes along X-axis.
holesX = false;
// Whether brick should have Technic holes along Y-axis.
holesY = false;
// Whether brick should have Technic holes along Z-axis.
holesZ = true;

// Whether brick should have a pit
pit = false;
// Whether knobs should be drawn inside pit
pitKnobs = false;
// Pit wall thickness as multiple of one brick side length
pitWallThickness = 0.333;

// Slanting size on X0 side specified as multiple of an 1x1 brick.
slantingX0 = 0;
// Slanting size on X1 side specified as multiple of an 1x1 brick.
slantingX1 = 0;
// Slanting size on Y0 side specified as multiple of an 1x1 brick.
slantingY0 = 0;
// Slanting size on Y1 side specified as multiple of an 1x1 brick.
slantingY1 = 0;

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
block(
    grid = [brickSizeX, brickSizeY],
    baseLayers = baseLayers,
    baseCutoutType = baseCutoutType,
    
    knobs = knobs,
    knobCentered = knobCentered,
    knobType = knobType,
    
    pillars = pillars,
    
    holesX = holesX,
    holesY = holesY,
    holesZ = holesZ,
    
    pit = pit,
    pitKnobs = pitKnobs,
    pitWallThickness = pitWallThickness,
    
    slanting = ((slantingX0 != 0) || (slantingX1 != 0) || (slantingY0 != 0) || (slantingY1 != 0)) ? [slantingX0, slantingX1, slantingY0, slantingY1] : false, 

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
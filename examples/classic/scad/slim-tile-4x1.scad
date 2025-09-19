/**
* MachineBlocks
* https://machineblocks.com/examples/classic-bricks
*
* Slim Tile 4x1
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Include the library
use <../../lib/block.scad>;
include <../../config/presets.scad>;

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 4; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 1; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]

/* [Base] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]
// Rounding Radius X
baseRoundingRadiusX = 0;
// Rounding Radius Y
baseRoundingRadiusY = 0;
// Rounding Radius Z
baseRoundingRadiusZ = 0;
// Cutout Rounding Radius
baseCutoutRoundingRadius = "auto";


// Whether to draw pillars.
pillars = true;
baseReliefCut = false;
baseReliefCutHeight = 0.4;
baseReliefCutThickness = 0.4;

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Knobs] */

// Whether to draw knobs.
knobs = false;
// Whether knobs should be centered.
knobCentered = false;
// Type of the knobs
knobType = "classic"; // [classic, technic]

/* [Bevel] */

// Bevel X and Y for the corner 0,0
bevel0 = [0, 0];
// Bevel X and Y for the corner 0,1
bevel1 = [0, 0];
// Bevel X and Y for the corner 1,1
bevel2 = [0, 0];
// Bevel X and Y for the corner 1,0
bevel3 = [0, 0];

/* [Holes] */

// Whether brick should have Technic holes along X-axis.
holesX = false;
// Type of X Holes.
holeXType = "technic";
// Whether X Holes should be centered
holeXCentered = true;
// Hole X Grid Offset Z
holeXGridOffsetZ = 1.75;
// Whether brick should have Technic holes along Y-axis.
holesY = false;
// Type of Y Holes.
holeYType = "technic";
// Whether Y Holes should be centered
holeYCentered = true;
// Hole Y Grid Offset Z
holeYGridOffsetZ = 1.75;
// Whether brick should have Technic holes along Z-axis.
holesZ = false;
// Type of Z Holes.
holeZType = "technic";

/* [Pit] */

// Whether brick should have a pit
pit = false;
// Whether knobs should be drawn inside pit
pitKnobs = false;
// Pit wall thickness as multiple of one brick side length
pitWallThickness = 0.333;

/* [Slanting] */

// Slanting size on X0 side specified as multiple of an 1x1 brick.
slantingX0 = 0;
// Slanting size on X1 side specified as multiple of an 1x1 brick.
slantingX1 = 0;
// Slanting size on Y0 side specified as multiple of an 1x1 brick.
slantingY0 = 0;
// Slanting size on Y1 side specified as multiple of an 1x1 brick.
slantingY1 = 0;

/* [Render] */

// Quality of the preview in relation to the final rendering.
    previewQuality = 0.5; // [0.1:0.1:1]
    // Number of drawn fragments for roundings in the final rendering.
    roundingResolution = 64; // [16:8:128]

/* [Hidden] */
slanting = ((slantingX0 != 0) || (slantingX1 != 0) || (slantingY0 != 0) || (slantingY1 != 0)) ? [slantingX0, slantingX1, slantingY0, slantingY1] : false;

// Generate the block
block(
    grid = [brickSizeX, brickSizeY],
    baseLayers = baseLayers,
    baseCutoutType = baseCutoutType,
    baseRoundingRadius=[baseRoundingRadiusX, baseRoundingRadiusY, baseRoundingRadiusZ],
    baseCutoutRoundingRadius = baseCutoutRoundingRadius,
    baseReliefCut = baseReliefCut,
    baseReliefCutHeight = baseReliefCutHeight,
    baseReliefCutThickness = baseReliefCutThickness,
    baseColor = baseColor,

    bevelHorizontal = [bevel0, bevel1, bevel2, bevel3],

    knobs = knobs,
    knobCentered = knobCentered,
    knobType = knobType,
    
    pillars = pillars,
    
    holesX = holesX,
    holeXType = holeXType,
    holeXCentered = holeXCentered,
    holeXGridOffsetZ = holeXGridOffsetZ,
    holesY = holesY,
    holeYType = holeYType,
    holeYCentered = holeYCentered,
    holeYGridOffsetZ = holeYGridOffsetZ,
    holesZ = holesZ,
    holeZType = holeZType,
    
    pit = pit,
    pitKnobs = pitKnobs,
    pitWallThickness = pitWallThickness,
    
    slanting = slanting, 

    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,

    baseSideAdjustment = baseSideAdjustment,
    
    baseHeightAdjustment = baseHeightAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
);
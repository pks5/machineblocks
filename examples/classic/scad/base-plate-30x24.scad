/**
* MachineBlocks
* https://machineblocks.com/examples/classic-bricks
*
* Base Plate 30x24
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
brickSizeX = 30; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 24; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]

/* [Base] */

// Type of cut-out on the underside.
baseCutoutType = "none"; // [none, classic]
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
knobs = true;
// Whether knobs should be centered.
knobCentered = false;
// Type of the knobs
knobType = "solid"; // [solid, ring]
// Knob Padding
knobPadding = 0.2;

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
holeXType = "pin";
// Whether X Holes should be centered
holeXCentered = true;
// Hole X Grid Offset Z
holeXGridOffsetZ = 3.5;
// Whether brick should have Technic holes along Y-axis.
holesY = false;
// Type of Y Holes.
holeYType = "pin";
// Whether Y Holes should be centered
holeYCentered = true;
// Hole Y Grid Offset Z
holeYGridOffsetZ = 3.5;
// Whether brick should have Technic holes along Z-axis.
holesZ = false;
// Type of Z Holes.
holeZType = "pin";
// Whether Z Holes should be centered on X direction
holeZCenteredX = true;
// Whether Z Holes should be centered on Y direction
holeZCenteredY = true;

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

/* [Hidden] */
slanting = ((slantingX0 != 0) || (slantingX1 != 0) || (slantingY0 != 0) || (slantingY1 != 0)) ? [slantingX0, slantingX1, slantingY0, slantingY1] : false;

// Generate the block
machineblock(
    size = [brickSizeX, brickSizeY,baseLayers],
    baseCutoutType = baseCutoutType,
    baseRoundingRadius=[baseRoundingRadiusX, baseRoundingRadiusY, baseRoundingRadiusZ],
    baseCutoutRoundingRadius = baseCutoutRoundingRadius,
    baseReliefCut = baseReliefCut,
    baseReliefCutHeight = baseReliefCutHeight,
    baseReliefCutThickness = baseReliefCutThickness,
    baseColor = baseColor,

    bevel = [bevel0, bevel1, bevel2, bevel3],

    studs = knobs,
    studCentered = knobCentered,
    studType = knobType,
    studPadding = knobPadding,
    
    pillars = pillars,
    
    holeX = holesX,
    holeXType = holeXType,
    holeXCentered = holeXCentered,
    holeXGridOffsetZ = holeXGridOffsetZ,
    holeY = holesY,
    holeYType = holeYType,
    holeYCentered = holeYCentered,
    holeYGridOffsetZ = holeYGridOffsetZ,
    holeZ = holesZ,
    holeZType = holeZType,
    holeZCenteredX = holeZCenteredX,
    holeZCenteredY = holeZCenteredY,
    
    pit = pit,
    pitKnobs = pitKnobs,
    pitWallThickness = pitWallThickness,
    
    slanting = slanting, 

    baseSideAdjustment = baseSideAdjustment,
    
    scale=scale,
    baseHeightAdjustment=baseHeightAdjustment,
    baseWallThicknessAdjustment=baseWallThicknessAdjustment,
    baseClampThickness=baseClampThickness,
    tubeXDiameterAdjustment=tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=tubeZDiameterAdjustment,
    holeXDiameterAdjustment=holeXDiameterAdjustment,
    holeYDiameterAdjustment=holeYDiameterAdjustment,
    holeZDiameterAdjustment=holeZDiameterAdjustment,
    pinDiameterAdjustment=pinDiameterAdjustment,
    studDiameterAdjustment=studDiameterAdjustment,
    studCutoutAdjustment=studCutoutAdjustment,
    previewRender=previewRender,
    previewQuality=previewQuality,
    baseRoundingResolution=roundingResolution,
    holeRoundingResolution=roundingResolution,
    studRoundingResolution=roundingResolution,
    pillarRoundingResolution=roundingResolution
);
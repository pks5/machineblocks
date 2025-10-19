/**
* MachineBlocks
* https://machineblocks.com/examples/classic-bricks
*
* Centered Plate 3x2
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
use <../../lib/block.scad>;
include <../../config/config.scad>;


/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 3; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
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
knobs = true;
// Whether knobs should be centered in X direction.
knobCenteredX = true;
// Whether knobs should be centered in Y direction.
knobCenteredY = true;
// Type of the knobs
knobType = "hollow"; // [solid, hollow]
// Knob Padding Side 0
knobPadding0 = 0.2;
// Knob Padding Side 1
knobPadding1 = 0.2;
// Knob Padding Side 2
knobPadding2 = 0.2;
// Knob Padding Side 3
knobPadding3 = 0.2;

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

/* [Slope] */

// Slope side 0
slope0 = 0;
// Slope side 1
slope1 = 0;
// Slope side 2
slope2 = 0;
// Slope side 3
slope3 = 0;

/* [Grille] */
// Grille in X direction
grilleX = false;
// Grille in Y direction
grilleY = false;

/* [Override Config] */
    overrideConfig=false;
    overrideUnitMbu = 1.6;
    overrideUnitGrid = [5, 2];
    overrideScale = 1.0;
    overrideBaseHeightAdjustment = 0.0;
    overrideBaseSideAdjustment = -0.1;
    overrideBaseWallThicknessAdjustment = -0.1;
    overrideBaseClampThickness = 0.1;
    overrideTubeXDiameterAdjustment = -0.1;
    overrideTubeYDiameterAdjustment = -0.1;
    overrideTubeZDiameterAdjustment = -0.1;
    overrideHoleXDiameterAdjustment = 0.3;
    overrideHoleYDiameterAdjustment = 0.3;
    overrideHoleZDiameterAdjustment = 0.3;
    overridePinDiameterAdjustment = 0.0;
    overrideStudDiameterAdjustment = 0.2;
    overrideStudCutoutAdjustment = [0, 0.2];
    overridePreviewRender = true;
    overridePreviewQuality = 0.5;
    overrideRoundingResolution = 64;



/* [Hidden] */
slope = ((slope0 != 0) || (slope1 != 0) || (slope2 != 0) || (slope3 != 0)) ? [slope0, slope1, slope2, slope3] : false;

bSideAdjustment = overrideConfig ? overrideBaseSideAdjustment : baseSideAdjustment;

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
    studCenteredX = knobCenteredX,
    studCenteredY = knobCenteredY,
    studType = knobType,
    studPadding = [knobPadding0, knobPadding1, knobPadding2, knobPadding3],
    
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
    
    slope = slope, 

    grilleX = grilleX,
    grilleY = grilleY,

    baseSideAdjustment = bSideAdjustment,
    
    unitMbu=overrideConfig ? overrideUnitMbu : unitMbu,
    unitGrid=overrideConfig ? overrideUnitGrid : unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
);
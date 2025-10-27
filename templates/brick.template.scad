/**
* MachineBlocks
* {URL}
*
* {BRICK_NAME}
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
/*{IMPORTS}*/

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 4; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 3; // [1:24]

/* [Base] */

// Rounding Radius X
baseRoundingRadiusX = 0; // [0:0.1:128]
// Rounding Radius Y
baseRoundingRadiusY = 0; // [0:0.1:128]
// Rounding Radius Z
baseRoundingRadiusZ = 0; // [0:0.1:128]
// Cutout Rounding Radius
baseCutoutRoundingRadius = "auto";

/*{BASE_VARIABLES}*/

/* [Knobs] */

// Whether to draw knobs.
knobs = true;
// Whether knobs should be centered in X direction.
knobCenteredX = false;
// Whether knobs should be centered in Y direction.
knobCenteredY = false;
// Type of the knobs
knobType = "solid"; // [solid, hollow]
// Stud Padding
studPadding = [0.2, 0.2, 0.2, 0.2]; // [0:0.1:128]

/*{STUD_VARIABLES}*/

/* [Bevel] */

// Bevel X and Y for the corner 0,0
bevel0 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner 0,1
bevel1 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner 1,1
bevel2 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner 1,0
bevel3 = [0, 0]; // [0:0.1:128]

/* [Holes] */

// Whether brick should have Technic holes along X-axis.
holesX = false;
// Type of X Holes.
holeXType = "pin"; // [pin, axle]
// Whether X Holes should be centered
holeXCentered = true;
// Hole X Grid Offset Z
holeXGridOffsetZ = 3.5; // [0:0.1:128]
// Whether brick should have Technic holes along Y-axis.
holesY = false;
// Type of Y Holes.
holeYType = "pin"; // [pin, axle]
// Whether Y Holes should be centered
holeYCentered = true;
// Hole Y Grid Offset Z
holeYGridOffsetZ = 3.5; // [0:0.1:128]
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
pitWallThickness = 0.333; // [0:0.001:128]

/* [Slope] */

slope = [0, 0, 0, 0]; // [-128:0.1:128]

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

// Generate the block
machineblock(
    size = [brickSizeX, brickSizeY,baseLayers],
    
    baseRoundingRadius=[baseRoundingRadiusX, baseRoundingRadiusY, baseRoundingRadiusZ],
    baseCutoutRoundingRadius = baseCutoutRoundingRadius,
    
    /*{BASE_PARAMETERS}*/

    bevel = [bevel0, bevel1, bevel2, bevel3],

    studs = knobs,
    studCenteredX = knobCenteredX,
    studCenteredY = knobCenteredY,
    studType = knobType,
    studPadding = studPadding,
    
    /*{STUD_PARAMETERS}*/
    
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

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);
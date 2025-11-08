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

// Brick size (grid)
size = [4, 2, 3]; // [1:0.1:32]

/* [Base] */

// Rounding Radius X (grid)
baseRoundingRadiusX = [0, 0, 0, 0]; // [0:0.1:128]
// Rounding Radius Y (grid)
baseRoundingRadiusY = [0, 0, 0, 0]; // [0:0.1:128]
// Rounding Radius Z (grid)
baseRoundingRadiusZ = [0, 0, 0, 0]; // [0:0.1:128]

/*{BASE_VARIABLES}*/

/* [Studs] */

/*{STUD_VARIABLES}*/

/* [Bevel] */

// Bevel X and Y for the corner [0,0] (grid)
bevel0 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner [0,1] (grid)
bevel1 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner [1,1] (grid)
bevel2 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner [1,0] (grid)
bevel3 = [0, 0]; // [0:0.1:128]

/* [Holes] */

// Whether brick should have Technic holes along X-axis.
holesX = false;
// Type of X Holes.
holeXType = "pin"; // [pin, axle]
// Whether X Holes should be centered
holeXShift = true;
// Hole X Grid Offset Z (mbu)
holeXGridOffsetZ = 3.5; // [0:0.1:128]
// Whether brick should have Technic holes along Y-axis.
holesY = false;
// Type of Y Holes.
holeYType = "pin"; // [pin, axle]
// Whether Y Holes should be centered
holeYShift = true;
// Hole Y Grid Offset Z (mbu)
holeYGridOffsetZ = 3.5; // [0:0.1:128]
// Whether brick should have Technic holes along Z-axis.
holeZ = false;
// Type of Z Holes.
holeZType = "pin"; // [pin, axle]
// Whether Z Holes should be shifted by a half brick.
holeZShift = "xy"; // [none:None, x:X-Direction, y:Y-Direction, xy:Both Directions]

/* [Recess] */

// Whether brick should have a pit
recess = false;
// Whether knobs should be drawn inside pit
recessStuds = false;
// Pit wall thickness as multiple of one brick side length (grid)
recessWallThickness = 0.333; // [0:0.001:128]

/* [Slope] */

slope = [0, 0, 0, 0]; // [-128:0.1:128]

/*{TEXT_VARIABLES}*/

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

// Generate the block
machineblock(
    size = size,
    
    baseRoundingRadius=[baseRoundingRadiusX, baseRoundingRadiusY, baseRoundingRadiusZ],
    
    /*{BASE_PARAMETERS}*/

    bevel = [bevel0, bevel1, bevel2, bevel3],

    /*{STUD_PARAMETERS}*/
    
    holeX = holesX,
    holeXType = holeXType,
    holeXShift = holeXShift,
    holeXGridOffsetZ = holeXGridOffsetZ,
    holeY = holesY,
    holeYType = holeYType,
    holeYShift = holeYShift,
    holeYGridOffsetZ = holeYGridOffsetZ,
    holeZ = holeZ,
    holeZType = holeZType,
    holeZShift = holeZShift,
    
    recess = recess,
    recessStuds = recessStuds,
    recessWallThickness = recessWallThickness,
    
    slope = slope, 

    /*{TEXT_PARAMETERS}*/

    /*{STYLE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);
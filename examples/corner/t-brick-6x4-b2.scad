/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* T Brick 6x4 B2
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../lib/block.scad>;

/* [Size] */

// Brick 1 Grid Size in X-direction as multiple of an 1x1 brick.
brick1SizeX = 6;  // [1:32]
// Brick 1 Grid Size in Y-direction as multiple of an 1x1 brick.
brick1SizeY = 2;  // [1:32]

// Brick 1 Offset in Y-direction as multiple of an 1x1 brick.
brick1OffsetY = 1; // [0:31]

// Brick 2 Grid Size in X-direction as multiple of an 1x1 brick.
brick2SizeX = 2;  // [1:32]
// Brick 2 Grid Size in Y-direction as multiple of an 1x1 brick.
brick2SizeY = 4;  // [1:32]

// Brick 2 Offset in X-direction as multiple of an 1x1 brick.
brick2OffsetX = 0; // [0:31]

//Number of layers
baseLayers = 3; // [1:48]

/* [Appearance] */

// Whether to draw knobs.
knobs = true;
// Type of the knobs
knobType = "classic"; // [classic, technic]

/* [Calibration] */

// Adjustment of the height (mm)
baseHeightAdjustment = 0.0; // .1
// Adjustment of each side (mm)
baseSideAdjustment = -0.1; // .1
// Diameter of the knobs (mm)
knobSize = 5.0; // .1
// Thickness of the walls (mm)
wallThickness = 1.5; // .1
// Diameter of the Z-Tubes (mm)
tubeZSize = 6.4; // .1

// Generate the block
union(){
    block(
        grid = [brick1SizeX, brick1SizeY],
        gridOffset = [0, brick1OffsetY - 0.5*(brick2SizeY-brick1SizeY), 0],
        wallGapsX = [[brick2OffsetX, 2, brick2SizeX]],
        baseLayers = baseLayers,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobs = knobs,
        knobType = knobType,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );

    block(
        grid = [brick2SizeX, brick2SizeY],
        gridOffset = [brick2OffsetX - 0.5*(brick1SizeX-brick2SizeX), 0, 0],
        wallGapsY = [[brick1OffsetY, 2, brick1SizeY]],
        baseLayers = baseLayers,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobs = knobs,
        knobType = knobType,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );    
}
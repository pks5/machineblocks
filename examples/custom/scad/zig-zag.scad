/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Zig Zag
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

//Include the library
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

/* [Appearance] */

//Number of layers
baseLayers = 3;
//Draw Knobs
knobs = true;

block(
    baseLayers=baseLayers, 
    knobs=knobs,
    grid=[2,1], 
    wallGapsX=[[0,0]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

block(
    baseLayers=baseLayers, 
    knobs=knobs,
    grid=[1, 2], 
    gridOffset=[-0.5, -0.5, 0], 
    wallGapsY=[[1,1], [0,0]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

block(
    baseLayers=baseLayers, 
    knobs=knobs,
    grid=[2,1], 
    gridOffset=[-1, -1, 0],
    wallGapsX=[[1,1], [0,0]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

block(
    baseLayers=baseLayers, 
    knobs=knobs,
    grid=[1, 2], 
    gridOffset=[-1.5, -1.5, 0], 
    wallGapsY=[[1,1], [0,0]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

block(
    baseLayers=baseLayers, 
    knobs=knobs,
    grid=[2,1], 
    gridOffset=[-2, -2, 0], 
    wallGapsX=[[1,1], [0,0]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

block(
    baseLayers=baseLayers, 
    knobs=knobs,
    grid=[1, 2], 
    gridOffset=[-2.5, -2.5, 0], 
    wallGapsY=[[1,1], [0,0]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

block(
    baseLayers=baseLayers, 
    knobs=knobs,
    grid=[2,1], 
    gridOffset=[-3, -3, 0], 
    wallGapsX=[[1,1]],
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);
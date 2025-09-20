/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Drill Holder
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

/* [Render] */
// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]
// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

/* [Size] */

brick1SizeX = 4;
brick1HolesZ = true;
brick1KnobType = "classic"; // [classic, technic]

brick2SizeX = 4;
brick2HolesZ = true;
brick2KnobType = "classic"; // [classic, technic]

gridSizeY = 2;
middleSizeX = 1;
middleLayers = 2;

/* [Hidden] */
multipart = assemblyMode != "merged";
assembled = assemblyMode != "unassembled";

block(
    grid=[brick1SizeX,gridSizeY],
    gridOffset=[-0.5*(brick1SizeX-middleSizeX),0,0],
    holesZ=[brick1HolesZ,[brick1SizeX-middleSizeX-1,0,brick1SizeX-2,gridSizeY-2,true]],
    knobType = brick1KnobType,

    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    
    //baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

block(
    grid=[middleSizeX,gridSizeY],
    gridOffset=[0,0,1],
    baseLayers = middleLayers,
    knobs = false,
    tongue = multipart,

    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    
    //baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment=baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

block(
    grid=[middleSizeX,gridSizeY],
    gridOffset=[0, assembled ? 0 : -gridSizeY-0.5, assembled ? middleLayers+1 : 0],
    baseLayers = 1,
    knobType = brick2KnobType,
    baseCutoutType = multipart ? "groove" : "none",

    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment=[baseSideAdjustment,-baseSideAdjustment,baseSideAdjustment,baseSideAdjustment],
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);


block(
    grid=[brick2SizeX-middleSizeX,gridSizeY],
    gridOffset=[0.5*(brick2SizeX-middleSizeX+middleSizeX), assembled ? 0 : -gridSizeY-0.5, assembled ? middleLayers+1 : 0],
    holesZ=brick2HolesZ,  //[brick2HolesZ,[0,0,middleSizeX-1,gridSizeY-2,true]],
    knobType = brick2KnobType,

    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize,
    align="ccs"
);

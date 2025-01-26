/**
* MachineBlocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Box with Lid 6x12
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
use <../../lib/block.scad>;

/* [Size] */

// Box size in X-direction specified as multiple of an 1x1 brick.
boxSizeX = 6; // [1:32] 
// Box size in Y-direction specified as multiple of an 1x1 brick.
boxSizeY = 12; // [1:32] 
// Total box height specified as number of layers. Each layer has the height of one plate.
boxLayers = 12; // [1:24]

/* [Appearance] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]
// Whether the base should have knobs
baseKnobs = true;
// Type of the base knobs
baseKnobType = "classic"; // [classic, technic]
// Whether the pit should contain knobs
basePitKnobs = false;
// Pit wall thickness
basePitWallThickness = 1;
// Whether the base should have a tongue
baseTongue = false;

// Whether the box should have a lid
lid = true;
// Lid height specified as number of layers. Each layer has the height of one plate.
lidLayers = 1; // [1:24]
// Whether the lid should have knobs
lidKnobs = true;
// Type of the lid knobs
lidKnobType = "classic"; // [classic, technic]
// Whether lid knobs should be centered.
lidKnobCentered = false;
// Whether lid should have pillars
lidPillars = true;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

/* [Calibration] */

//Adjustment of the height (mm)
baseHeightAdjustment = 0.0;
//Adjustment of each side (mm)
baseSideAdjustment = -0.1;
//Diameter of the knobs (mm)
knobSize = 5.0;
//Thickness of the walls (mm)
wallThickness = 1.5;
//Diameter of the Z-Tubes (mm)
tubeZSize = 6.4;

block(
    grid=[boxSizeX, boxSizeY],
    baseLayers = boxLayers - (lid ? lidLayers : 0),
    baseCutoutType = baseCutoutType,

    knobs = baseKnobs,
    knobType = baseKnobType,
    
    pit=true,
    pitWallThickness = basePitWallThickness,
    pitKnobs = basePitKnobs,

    tongue = baseTongue,
    tongueHeight = 1.8,
    tongueClampThickness = 0,
    tongueOuterAdjustment = -0.1,
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);

if(lid){
    block(
        grid=[boxSizeX, boxSizeY],
        gridOffset = [boxSizeX + 1, 0, 0],
        baseLayers = lidLayers,

        knobs = lidKnobs,
        knobType = lidKnobType,
        knobCentered = lidKnobCentered,

        pillars = lidPillars,

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize
    );
}

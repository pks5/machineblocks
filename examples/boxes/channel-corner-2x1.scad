/**
* MachineBlocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Channel Corner 2x1
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
use <../../lib/block.scad>;
include <../../config/presets.scad>;

/* [View] */
// How to view the brick in the editor
viewMode = "print"; // [print, assembled, cover]

/* [Size] */

// Box size in X-direction specified as multiple of an 1x1 brick.
boxSizeX = 2; // [1:32] 
// Box size in Y-direction specified as multiple of an 1x1 brick.
boxSizeY = 1; // [1:32] 
// Total box height specified as number of layers. Each layer has the height of one plate.
boxLayers = 5; // [1:24]

/* [Base] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]
// Whether the base should have a tongue
baseTongue = true;
// Whether the base should have knobs
baseKnobs = false;
// Type of the base knobs
baseKnobType = "classic"; // [classic, technic]
// Whether base knobs should be centered.
baseKnobCentered = false;

/* [Pit] */

// Pit wall thickness
basePitWallThickness = 0.333;
// Pit wall gaps
basePitWallGaps = [[0, 0, 0], [2, 0, 0]];
// Whether the pit should contain knobs
basePitKnobs = false;
// Type of the base pit knobs
basePitKnobType = "classic"; // [classic, technic]
// Whether base pit knobs should be centered.
basePitKnobCentered = false;

/* [Lid] */

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
// Whether lid should be permanent (non removable)
lidPermanent = false;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

block(
    grid=[boxSizeX, boxSizeY],
    baseLayers = boxLayers - (lid ? lidLayers : 0),
    baseCutoutType = baseCutoutType,

    knobs = baseKnobs,
    knobType = baseKnobType,
    knobCentered = baseKnobCentered,
    
    pit=true,
    pitWallGaps = basePitWallGaps, //boxType != "box" ? (boxType == "channel_corner" ? [ [ 0, 0, 0 ], [ 2, 0, 0 ] ] : [ [ 0, 0, 0 ], [ 1, 0, 0 ] ]) : [],
    pitWallThickness = basePitWallThickness,
    pitKnobs = basePitKnobs,
    pitKnobType = basePitKnobType,
    pitKnobCentered = basePitKnobCentered,

    tongue = baseTongue,
    tongueHeight = lidPermanent ? 2.0 : 1.8,
    tongueClampThickness = lidPermanent ? 0.1 : 0,
    tongueOuterAdjustment = lidPermanent ? 0.0 : -0.1,
    tongueRoundingRadius = lidPermanent ? 0.0 : 0.4,
    
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
);

if(lid){
    translate(viewMode != "print" ? [0, 0, ((boxLayers - lidLayers) + (viewMode == "cover" ? 2*lidLayers : 0)) * 3.2] : [boxSizeX > boxSizeY ? 0 : (boxSizeX + 0.5) * 8.0, boxSizeX > boxSizeY ? -(boxSizeY + 0.5) * 8.0 : 0, 0])
        block(
            grid=[boxSizeX, boxSizeY],
            baseLayers = lidLayers,
            baseCutoutType = baseTongue ? "groove" : "classic",

            knobs = lidKnobs,
            knobType = lidKnobType,
            knobCentered = lidKnobCentered,

            pillars = lidPillars,
            pitWallGaps = basePitWallGaps, //boxType != "box" ? (boxType == "channel_corner" ? [ [ 0, 0, 0 ], [ 2, 0, 0 ] ] : [ [ 0, 0, 0 ], [ 1, 0, 0 ] ]) : [],

            baseHeightAdjustment = baseHeightAdjustment,
            baseSideAdjustment = baseSideAdjustment,
            knobSize = knobSize,
            wallThickness = wallThickness,
            tubeZSize = tubeZSize,
            pinSize = pinSize
        );
}

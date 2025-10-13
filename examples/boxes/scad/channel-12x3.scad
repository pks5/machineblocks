/**
* MachineBlocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Channel 12x3
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


/* [View] */
// How to view the brick in the editor
viewMode = "print"; // [print, assembled, cover]

/* [Size] */

// Box size in X-direction specified as multiple of an 1x1 brick.
boxSizeX = 12; // [1:32] 
// Box size in Y-direction specified as multiple of an 1x1 brick.
boxSizeY = 3; // [1:32] 
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
// The box rounding radius
baseRoundingRadiusZ = 0;

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Pit] */

// Pit wall thickness
basePitWallThickness = 0.333;
// Pit wall gaps
basePitWallGaps = [[0, 0, 0], [1, 0, 0]];
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
// Text on lid
lidText = "";
//Text Font
textFont = "RBNo3.1";

machineblock(
    size=[boxSizeX, boxSizeY,boxLayers - (lid ? lidLayers : 0)],
    
    baseCutoutType = baseCutoutType,
    baseRoundingRadius = [0, 0, baseRoundingRadiusZ],
    baseColor = baseColor,

    studs = baseKnobs,
    studType = baseKnobType,
    studCentered = baseKnobCentered,
    
    pit=true,
    pitWallGaps = basePitWallGaps,
    pitWallThickness = basePitWallThickness,
    pitKnobs = basePitKnobs,
    pitKnobType = basePitKnobType,
    pitKnobCentered = basePitKnobCentered,

    tongue = baseTongue,
    tongueClampThickness = lidPermanent ? 0.1 : 0,
    
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

if(lid){
    translate(viewMode != "print" ? [0, 0, ((boxLayers - lidLayers) + (viewMode == "cover" ? 2*lidLayers : 0)) * 3.2] : [boxSizeX > boxSizeY ? 0 : (boxSizeX + 0.5) * 8.0, boxSizeX > boxSizeY ? -(boxSizeY + 0.5) * 8.0 : 0, 0])
        machineblock(
            size=[boxSizeX, boxSizeY, lidLayers],
            
            pillars = lidPillars,
            pitWallGaps = basePitWallGaps,
            baseCutoutType = baseTongue ? "groove" : "classic",
            baseRoundingRadius = [0, 0, baseRoundingRadiusZ],
            baseColor = baseColor,

            tongueThicknessAdjustment = 0.1,

            studs = lidKnobs,
            studType = lidKnobType,
            studCentered = lidKnobCentered,

            textSide = 5,
            textSize = 10,
            textDepth = 0.8,
            text = lidText,
            textFont = textFont,

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
}

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

/* [View] */
// How to view the brick in the editor
viewMode = "print"; // [print, assembled, cover]

/* [Size] */

// Brick size
size = [6, 6, 9]; // [1:32]

/* [Base] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]
// Whether the base should have a tongue
baseTongue = false;
// Whether the base should have knobs
baseKnobs = true;
// Type of the base knobs
baseKnobType = "classic"; // [classic, hollow]
// Whether base knobs should be centered.
baseKnobCentered = false;
// The box rounding radius
baseRoundingRadiusZ = 0;

/* [Pit] */

// Pit wall thickness
basePitWallThickness = 1;
// Pit wall gaps
basePitWallGaps = [];
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

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

machineblock(
    size=[size[0], size[1],size[2] - (lid ? lidLayers : 0)],
    
    baseCutoutType = baseCutoutType,
    baseRoundingRadius = [0, 0, baseRoundingRadiusZ],
    
    studs = baseKnobs,
    studType = baseKnobType,
    studCenteredX = baseKnobCentered,
    studCenteredY = baseKnobCentered,
    
    pit=true,
    pitWallGaps = basePitWallGaps,
    pitWallThickness = basePitWallThickness,
    pitKnobs = basePitKnobs,
    pitKnobType = basePitKnobType,
    pitKnobCenteredX = basePitKnobCentered,
    pitKnobCenteredY = basePitKnobCentered,
    
    tongue = baseTongue,
    tongueClampThickness = lidPermanent ? 0.1 : 0,

    /*{STYLE_PARAMETERS}*/
    
    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);

if(lid){
    translate(viewMode != "print" ? [0, 0, ((size[2] - lidLayers) + (viewMode == "cover" ? 2*lidLayers : 0)) * 3.2] : [size[0] > size[1] ? 0 : (size[0] + 0.5) * 8.0, size[0] > size[1] ? -(size[1] + 0.5) * 8.0 : 0, 0])
        machineblock(
            size=[size[0], size[1], lidLayers],
            
            pillars = lidPillars,
            pitWallGaps = basePitWallGaps,
            baseCutoutType = baseTongue ? "groove" : "classic",
            baseRoundingRadius = [0, 0, baseRoundingRadiusZ],
            

            tongueThicknessAdjustment = 0.1,

            studs = lidKnobs,
            studType = lidKnobType,
            studCenteredX = lidKnobCentered,
            studCenteredY = lidKnobCentered,
            

            textSide = 5,
            textSize = 10,
            textDepth = 0.8,
            text = lidText,
            textFont = textFont,

            /*{STYLE_PARAMETERS}*/

            baseSideAdjustment = bSideAdjustment,

            /*{PRESET_PARAMETERS}*/
        );
}

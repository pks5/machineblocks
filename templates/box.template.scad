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

// Box size in X-direction specified as multiple of an 1x1 brick.
boxSizeX = 6; // [1:32] 
// Box size in Y-direction specified as multiple of an 1x1 brick.
boxSizeY = 6; // [1:32] 
// Total box height specified as number of layers. Each layer has the height of one plate.
boxLayers = 9; // [1:24]

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

/*{BASE_VARIABLES}*/

/* [Studs] */

/*{STUD_VARIABLES}*/

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

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

machineblock(
    size=[boxSizeX, boxSizeY,boxLayers - (lid ? lidLayers : 0)],
    
    baseCutoutType = baseCutoutType,
    baseRoundingRadius = [0, 0, baseRoundingRadiusZ],
    /*{BASE_PARAMETERS}*/

    studs = baseKnobs,
    studType = baseKnobType,
    studCenteredX = baseKnobCentered,
    studCenteredY = baseKnobCentered,
    
    /*{STUD_PARAMETERS}*/
    
    pit=true,
    pitWallGaps = basePitWallGaps,
    pitWallThickness = basePitWallThickness,
    pitKnobs = basePitKnobs,
    pitKnobType = basePitKnobType,
    pitKnobCenteredX = basePitKnobCentered,
    pitKnobCenteredY = basePitKnobCentered,
    
    tongue = baseTongue,
    tongueClampThickness = lidPermanent ? 0.1 : 0,
    
    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
);

if(lid){
    translate(viewMode != "print" ? [0, 0, ((boxLayers - lidLayers) + (viewMode == "cover" ? 2*lidLayers : 0)) * 3.2] : [boxSizeX > boxSizeY ? 0 : (boxSizeX + 0.5) * 8.0, boxSizeX > boxSizeY ? -(boxSizeY + 0.5) * 8.0 : 0, 0])
        machineblock(
            size=[boxSizeX, boxSizeY, lidLayers],
            
            pillars = lidPillars,
            pitWallGaps = basePitWallGaps,
            baseCutoutType = baseTongue ? "groove" : "classic",
            baseRoundingRadius = [0, 0, baseRoundingRadiusZ],
            /*{BASE_PARAMETERS}*/

            tongueThicknessAdjustment = 0.1,

            studs = lidKnobs,
            studType = lidKnobType,
            studCenteredX = lidKnobCentered,
            studCenteredY = lidKnobCentered,
            studIcon = studIcon,

            textSide = 5,
            textSize = 10,
            textDepth = 0.8,
            text = lidText,
            textFont = textFont,

            baseSideAdjustment = bSideAdjustment,

            /*{PRESET_PARAMETERS}*/
        );
}

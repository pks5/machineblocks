/**
* MachineBlocks
* https://machineblocks.com/examples/containers
*
* Box with Lid 6x6
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
// Imports
use <../../lib/block.scad>;
include <../../config/config.scad>;


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
baseKnobType = "classic"; // [classic, technic]
// Whether base knobs should be centered.
baseKnobCentered = false;
// The box rounding radius
baseRoundingRadiusZ = 0;

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Studs] */
//Whether to render the stud icon
studIcon = "../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]

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

/* [Override Config] */
    overrideConfig=false;
    overrideScale = 1.0;
    overrideBaseHeightAdjustment = 0.0;
    overrideBaseSideAdjustment = -0.1;
    overrideBaseWallThicknessAdjustment = -0.1;
    overrideBaseClampThickness = 0.1;
    overrideTubeXDiameterAdjustment = -0.1;
    overrideTubeYDiameterAdjustment = -0.1;
    overrideTubeZDiameterAdjustment = -0.1;
    overrideHoleXDiameterAdjustment = 0.3;
    overrideHoleYDiameterAdjustment = 0.3;
    overrideHoleZDiameterAdjustment = 0.3;
    overridePinDiameterAdjustment = 0.0;
    overrideStudDiameterAdjustment = 0.2;
    overrideStudCutoutAdjustment = [0, 0.2];
    overridePreviewRender = true;
    overridePreviewQuality = 0.5;
    overrideRoundingResolution = 64;


/* [Hidden] */

bSideAdjustment = overrideConfig ? overrideBaseSideAdjustment : baseSideAdjustment;

machineblock(
    size=[boxSizeX, boxSizeY,boxLayers - (lid ? lidLayers : 0)],
    
    baseCutoutType = baseCutoutType,
    baseRoundingRadius = [0, 0, baseRoundingRadiusZ],
    baseColor = baseColor,

    studs = baseKnobs,
    studType = baseKnobType,
    studCenteredX = baseKnobCentered,
    studCenteredY = baseKnobCentered,
    studIcon = studIcon,
    
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
    
    unitMbu=unitMbu,
    unitGrid=unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
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
            studCenteredX = lidKnobCentered,
            studCenteredY = lidKnobCentered,
            studIcon = studIcon,

            textSide = 5,
            textSize = 10,
            textDepth = 0.8,
            text = lidText,
            textFont = textFont,

            baseSideAdjustment = bSideAdjustment,

            unitMbu=unitMbu,
    unitGrid=unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
        );
}

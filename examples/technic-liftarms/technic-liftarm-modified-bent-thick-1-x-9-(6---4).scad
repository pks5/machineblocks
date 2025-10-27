/**
* MachineBlocks
* https://machineblocks.com/examples/technic-liftarms
*
* Technic Liftarm Modified Bent Thick 1 x 9 (6 - 4)
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


/* [Size] */

// Whether lift arm should be thin
thin = false;

// Whether lift has axle in middle
leg1AxleHoleFirst = false;

// Whether lift has axle in middle
leg1AxleHoleLast = false;

// Size of first leg as multiple of an 1x1 brick.
leg1Size = 6;  // [1:32]

// Size of second leg as multiple of an 1x1 brick.
leg2Size = 4;  // [1:32]

// Rotation of second leg
leg2Rotation = 45;

/* [Base] */

// Color of the brick
baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
surfacePatternScale = 0.2; // [0:0.001:1]
surfacePattern = "none"; // [none:None, ../pattern/honeycombs.svg:Honeycombs, ../pattern/squares.svg:Squares, ../pattern/squares-diagonal.svg:Squares Diagonal, ../pattern/diamonds.svg:Diamonds, ../pattern/textile.svg:Textile, ../pattern/card-background.svg:Card Background, ../pattern/dots.svg:Dots, ../pattern/circuit-board.svg:Circuit Board]

/* [Studs] */
//Whether to render the stud icon
studIcon = "../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]

/* [Override Config] */
// Whether to override global config
overrideConfig=false;
// Scale of the brick
overrideScale = 1.0; // [0.1:0.1:128]

// Adjustment of base height
overrideBaseHeightAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of sides
overrideBaseSideAdjustment = -0.1; // [-10.0:0.1:10.0]
// Adjustment of wall thickness
overrideBaseWallThicknessAdjustment = -0.1; // [-10.0:0.1:10.0]
// Clamp thickness
overrideBaseClampThickness = 0.1; // [-10.0:0.1:10.0]

// Adjustment of tube X diameter
overrideTubeXDiameterAdjustment = -0.1; // [-10.0:0.1:10.0]
// Adjustment of tube Y diameter
overrideTubeYDiameterAdjustment = -0.1; // [-10.0:0.1:10.0]
// Adjustment of tube Z diameter
overrideTubeZDiameterAdjustment = -0.1; // [-10.0:0.1:10.0]

// Adjustment of hole X diameter
overrideHoleXDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]
// Adjustment of hole X inset thickness
overrideHoleXInsetThicknessAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole X inset depth
overrideHoleXInsetDepthAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole X grid offset Z
overrideHoleXGridOffsetZAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole X grid size Z
overrideHoleXGridSizeZAdjustment = 0.0; // [-10.0:0.1:10.0] 

// Adjustment of hole Y diameter
overrideHoleYDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]
// Adjustment of hole Y inset thickness
overrideHoleYInsetThicknessAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole Y inset depth
overrideHoleYInsetDepthAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole Y grid offset Z
overrideHoleYGridOffsetZAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole Y grid size Z
overrideHoleYGridSizeZAdjustment = 0.0; // [-10.0:0.1:10.0] 

// Adjustment of hole Z diameter
overrideHoleZDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]

// Adjustment of pin diameter
overridePinDiameterAdjustment = 0.0; // [-10.0:0.1:10.0]

// Adjustment of stud diameter
overrideStudDiameterAdjustment = 0.2; // [-10.0:0.1:10.0]
// Adjustment of stud height
overrideStudHeightAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of stud hole diameter
overrideStudHoleDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]
// Adjustment of stud cutout
overrideStudCutoutAdjustment = [0.2, 0.4]; // [-10.0:0.1:10.0]

// Whether to render in preview mode
overridePreviewRender = true;
// Quality of preview rendering
overridePreviewQuality = 0.5; // [0.1:0.1:1.0]

// Rounding resolution of final rendering
overrideRoundingResolution = 64; // [16:1:512]


/* [Hidden] */

holeY = leg1AxleHoleLast ? [true, [0,0,0,0,"axle"], [leg1Size-1,0,leg1Size-1,0,"axle"]] : [true, [0,0,0,0,"axle"]];

bSideAdjustment = overrideConfig ? overrideBaseSideAdjustment : baseSideAdjustment;

machineblock(
    baseRoundingRadius = [1.25,0,0],
    baseCutoutRoundingRadius = 0,
    baseCutoutType = "none",
    baseColor = baseColor,
    holeY = holeY,
    holeYCentered = false,
    holeYGridOffsetZ = 2.3125,
    size=[thin ? 0.5 : 1, leg1Size, 2.3125], 
    studs = false,

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
holeXInsetThicknessAdjustment=overrideConfig ? overrideHoleXInsetThicknessAdjustment : holeXInsetThicknessAdjustment,
holeXInsetDepthAdjustment=overrideConfig ? overrideHoleXInsetDepthAdjustment : holeXInsetDepthAdjustment,
holeXGridOffsetZAdjustment=overrideConfig ? overrideHoleXGridOffsetZAdjustment : holeXGridOffsetZAdjustment,
holeXGridSizeZAdjustment=overrideConfig ? overrideHoleXGridSizeZAdjustment : holeXGridSizeZAdjustment,

holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
holeYInsetThicknessAdjustment=overrideConfig ? overrideHoleYInsetThicknessAdjustment : holeYInsetThicknessAdjustment,
holeYInsetDepthAdjustment=overrideConfig ? overrideHoleYInsetDepthAdjustment : holeYInsetDepthAdjustment,
holeYGridOffsetZAdjustment=overrideConfig ? overrideHoleYGridOffsetZAdjustment : holeYGridOffsetZAdjustment,
holeYGridSizeZAdjustment=overrideConfig ? overrideHoleYGridSizeZAdjustment : holeYGridSizeZAdjustment,

holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,

pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,

studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
studHeightAdjustment=overrideConfig ? overrideStudHeightAdjustment : studHeightAdjustment,
studHoleDiameterAdjustment=overrideConfig ? overrideStudHoleDiameterAdjustment : studHoleDiameterAdjustment,
studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,

previewRender=overrideConfig ? overridePreviewRender : previewRender,
previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,

baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
){
    if(leg2Size > 0){
        machineblock(
            rotation = [leg2Rotation,0,0],
            rotationOffset = [0, -0.5, -1.25],
            offset = [0, leg1Size-1, 0],
            baseRoundingRadius = [1.25,0,0],
            baseCutoutRoundingRadius = 0,
            baseCutoutType = "none",
            baseColor = baseColor,
            holeY = [true, [leg2Size-1, 0, leg2Size-1, 0, "axle"]],
            holeYCentered = false,
            holeYGridOffsetZ = 2.3125,
            size=[thin ? 0.5 : 1, leg2Size, 2.3125], 
            studs = false,

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
holeXInsetThicknessAdjustment=overrideConfig ? overrideHoleXInsetThicknessAdjustment : holeXInsetThicknessAdjustment,
holeXInsetDepthAdjustment=overrideConfig ? overrideHoleXInsetDepthAdjustment : holeXInsetDepthAdjustment,
holeXGridOffsetZAdjustment=overrideConfig ? overrideHoleXGridOffsetZAdjustment : holeXGridOffsetZAdjustment,
holeXGridSizeZAdjustment=overrideConfig ? overrideHoleXGridSizeZAdjustment : holeXGridSizeZAdjustment,

holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
holeYInsetThicknessAdjustment=overrideConfig ? overrideHoleYInsetThicknessAdjustment : holeYInsetThicknessAdjustment,
holeYInsetDepthAdjustment=overrideConfig ? overrideHoleYInsetDepthAdjustment : holeYInsetDepthAdjustment,
holeYGridOffsetZAdjustment=overrideConfig ? overrideHoleYGridOffsetZAdjustment : holeYGridOffsetZAdjustment,
holeYGridSizeZAdjustment=overrideConfig ? overrideHoleYGridSizeZAdjustment : holeYGridSizeZAdjustment,

holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,

pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,

studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
studHeightAdjustment=overrideConfig ? overrideStudHeightAdjustment : studHeightAdjustment,
studHoleDiameterAdjustment=overrideConfig ? overrideStudHoleDiameterAdjustment : studHoleDiameterAdjustment,
studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,

previewRender=overrideConfig ? overridePreviewRender : previewRender,
previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,

baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
        );
    }
}


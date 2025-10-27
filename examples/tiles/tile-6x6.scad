/**
* MachineBlocks
* https://machineblocks.com/examples/tiles
*
* Tile 6x6
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

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 6; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 6; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]

/* [Base] */

// Rounding Radius X
baseRoundingRadiusX = 0; // [0:0.1:128]
// Rounding Radius Y
baseRoundingRadiusY = 0; // [0:0.1:128]
// Rounding Radius Z
baseRoundingRadiusZ = 0; // [0:0.1:128]
// Cutout Rounding Radius
baseCutoutRoundingRadius = "auto";


// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic, studs]
// Whether to draw pillars.
pillars = true;
// Whether to draw a relief cut
baseReliefCut = false;
// Relief Cut Height (mbu)
baseReliefCutHeight = 0.4; // [0:0.1:128]
// Relief Cut Thickness (mbu)
baseReliefCutThickness = 0.4; // [0:0.1:128]
// Grille in X direction
grilleX = false;
// Grille in Y direction
grilleY = false;

/* [Knobs] */

// Whether to draw knobs.
knobs = false;
// Whether knobs should be centered in X direction.
knobCenteredX = false;
// Whether knobs should be centered in Y direction.
knobCenteredY = false;
// Type of the knobs
knobType = "solid"; // [solid, hollow]
// Stud Padding
studPadding = [0.2, 0.2, 0.2, 0.2]; // [0:0.1:128]



/* [Bevel] */

// Bevel X and Y for the corner 0,0
bevel0 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner 0,1
bevel1 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner 1,1
bevel2 = [0, 0]; // [0:0.1:128]
// Bevel X and Y for the corner 1,0
bevel3 = [0, 0]; // [0:0.1:128]

/* [Holes] */

// Whether brick should have Technic holes along X-axis.
holesX = false;
// Type of X Holes.
holeXType = "pin"; // [pin, axle]
// Whether X Holes should be centered
holeXCentered = true;
// Hole X Grid Offset Z
holeXGridOffsetZ = 3.5; // [0:0.1:128]
// Whether brick should have Technic holes along Y-axis.
holesY = false;
// Type of Y Holes.
holeYType = "pin"; // [pin, axle]
// Whether Y Holes should be centered
holeYCentered = true;
// Hole Y Grid Offset Z
holeYGridOffsetZ = 3.5; // [0:0.1:128]
// Whether brick should have Technic holes along Z-axis.
holesZ = false;
// Type of Z Holes.
holeZType = "pin";
// Whether Z Holes should be centered on X direction
holeZCenteredX = true;
// Whether Z Holes should be centered on Y direction
holeZCenteredY = true;

/* [Pit] */

// Whether brick should have a pit
pit = false;
// Whether knobs should be drawn inside pit
pitKnobs = false;
// Pit wall thickness as multiple of one brick side length
pitWallThickness = 0.333; // [0:0.001:128]

/* [Slope] */

slope = [0, 0, 0, 0]; // [-128:0.1:128]

/* [Style] */


// Color of the brick
baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
surfacePatternScale = 0.2; // [0:0.001:1]
surfacePattern = "none"; // [none:None, ../pattern/honeycombs.svg:Honeycombs, ../pattern/squares.svg:Squares, ../pattern/squares-diagonal.svg:Squares Diagonal, ../pattern/diamonds.svg:Diamonds, ../pattern/textile.svg:Textile, ../pattern/card-background.svg:Card Background, ../pattern/dots.svg:Dots, ../pattern/circuit-board.svg:Circuit Board]
// Icons on studs
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
overrideHoleXDiameterAdjustment = 0.2; // [-10.0:0.1:10.0]
// Adjustment of hole X inset thickness
overrideHoleXInsetThicknessAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole X inset depth
overrideHoleXInsetDepthAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole X grid offset Z
overrideHoleXGridOffsetZAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole X grid size Z
overrideHoleXGridSizeZAdjustment = 0.0; // [-10.0:0.1:10.0] 

// Adjustment of hole Y diameter
overrideHoleYDiameterAdjustment = 0.2; // [-10.0:0.1:10.0]
// Adjustment of hole Y inset thickness
overrideHoleYInsetThicknessAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole Y inset depth
overrideHoleYInsetDepthAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole Y grid offset Z
overrideHoleYGridOffsetZAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole Y grid size Z
overrideHoleYGridSizeZAdjustment = 0.0; // [-10.0:0.1:10.0] 

// Adjustment of hole Z diameter
overrideHoleZDiameterAdjustment = 0.2; // [-10.0:0.1:10.0]

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

bSideAdjustment = overrideConfig ? overrideBaseSideAdjustment : baseSideAdjustment;

// Generate the block
machineblock(
    size = [brickSizeX, brickSizeY,baseLayers],
    
    baseRoundingRadius=[baseRoundingRadiusX, baseRoundingRadiusY, baseRoundingRadiusZ],
    baseCutoutRoundingRadius = baseCutoutRoundingRadius,
    
    baseCutoutType = baseCutoutType,
pillars = pillars,
baseReliefCut = baseReliefCut,
baseReliefCutHeight = baseReliefCutHeight,
baseReliefCutThickness = baseReliefCutThickness,
grilleX = grilleX,
grilleY = grilleY,

    bevel = [bevel0, bevel1, bevel2, bevel3],

    studs = knobs,
    studCenteredX = knobCenteredX,
    studCenteredY = knobCenteredY,
    studType = knobType,
    studPadding = studPadding,
    
    
    
    holeX = holesX,
    holeXType = holeXType,
    holeXCentered = holeXCentered,
    holeXGridOffsetZ = holeXGridOffsetZ,
    holeY = holesY,
    holeYType = holeYType,
    holeYCentered = holeYCentered,
    holeYGridOffsetZ = holeYGridOffsetZ,
    holeZ = holesZ,
    holeZType = holeZType,
    holeZCenteredX = holeZCenteredX,
    holeZCenteredY = holeZCenteredY,
    
    pit = pit,
    pitKnobs = pitKnobs,
    pitWallThickness = pitWallThickness,
    
    slope = slope, 

    baseColor = baseColor,
surfacePattern = surfacePattern,
surfacePatternScale = surfacePatternScale,
studIcon = studIcon,


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
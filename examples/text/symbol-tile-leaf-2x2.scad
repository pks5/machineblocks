/**
* MachineBlocks
* https://machineblocks.com/examples/text
*
* Symbol Tile Leaf 2x2
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
brickSizeX = 2; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]

/* [Base] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]

// Color of the brick
baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
surfacePatternScale = 0.2; // [0:0.001:1]
surfacePattern = "none"; // [none:None, ../pattern/honeycombs.svg:Honeycombs, ../pattern/squares.svg:Squares, ../pattern/squares-diagonal.svg:Squares Diagonal, ../pattern/diamonds.svg:Diamonds, ../pattern/textile.svg:Textile, ../pattern/card-background.svg:Card Background, ../pattern/dots.svg:Dots, ../pattern/circuit-board.svg:Circuit Board]

/* [Knobs] */

// Whether to draw knobs
knobs = false;
// Whether knobs should be centered.
knobCentered = false;
// Type of the knobs
knobType = "solid"; // [solid, hollow]
// Whether to draw pillars.
pillars = true;

// Whether to render icons on the studs
studIcon = "../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]

/* [Text] */

// Text to write on the brick.
text = "";
// Side of the brick on which text is written.
textSide = 5; // [0:X0, 1:X1, 2:Y0, 3:Y1, 4:Z0, 5:Z1]
// Letter Depth
textDepth = 1.2; // [-3.2:0.2:3.2]
// Text Size
textSize = 8; // [1:32]
// Font
textFont = "Font Awesome 6 Free Solid"; // [Creato Display, RBNo3.1 Black, Font Awesome 6 Free Regular, Font Awesome 6 Free Solid]
// Text Style
textStyle = "Regular"; // [Black, Black Italic, Bold, Bold Italic, Book, Book Italic, ExtraBold, ExtraBold Italic, Light, Light Italic, Medium, Medium Italic, Regular, Regular Italic, Thin, Thin Italic, Ultra, Ultra Italic]
// Spacing of the letters
textSpacing = 1; // [0.1:0.1:4]
// Color of the text
textColor = "#303D4E"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

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

// Adjustment of hole Y diameter
overrideHoleYDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]
// Adjustment of hole Y inset thickness
overrideHoleYInsetThicknessAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole Y inset depth
overrideHoleYInsetDepthAdjustment = 0.0; // [-10.0:0.1:10.0]

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

bSideAdjustment = overrideConfig ? overrideBaseSideAdjustment : baseSideAdjustment;

// Generate the block
machineblock(
    size = [brickSizeX, brickSizeY, baseLayers],
    
    baseCutoutType = baseCutoutType,
    baseColor = baseColor,
surfacePattern = surfacePattern,
surfacePatternScale = surfacePatternScale,

    studs = knobs,
    studCenteredX = knobCentered,
    studCenteredY = knobCentered,
    studType = knobType,
    
    studIcon = studIcon,
    
    pillars = pillars,

    textSide = textSide,
    textSize = textSize,
    text=text,
    textDepth=textDepth,
    textSpacing = textSpacing,
    textFont=str(textFont, (textStyle == "" ? "" : str(":style=", textStyle))),
    textColor = textColor,

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

holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
holeYInsetThicknessAdjustment=overrideConfig ? overrideHoleYInsetThicknessAdjustment : holeYInsetThicknessAdjustment,
holeYInsetDepthAdjustment=overrideConfig ? overrideHoleYInsetDepthAdjustment : holeYInsetDepthAdjustment,

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
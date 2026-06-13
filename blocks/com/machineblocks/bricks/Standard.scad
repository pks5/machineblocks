/**
 * MachineBlocks.com Block File
 *
 * Name: MachineBlock Standard Brick
 * Filename: Standard.scad
 * FQN: com.machineblocks.bricks.Standard
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * Visit machineblocks.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../lib/block.scad>;
// Global Config
include <../../../../config/mb_config.scad>;

/*
 * Customization
 */

/* [Size] */

// Brick size (grid)
size = [4, 2, 3]; // [1:0.25:32]

/* [Base] */

// Rounding Radius X (grid)
baseRoundingRadiusX = [0, 0, 0, 0]; // [0:0.25:128]
// Rounding Radius Y (grid)
baseRoundingRadiusY = [0, 0, 0, 0]; // [0:0.25:128]
// Rounding Radius Z (grid)
baseRoundingRadiusZ = [0, 0, 0, 0]; // [0:0.25:128]

// Type of cut-out on the underside.
baseCutoutType = "standard"; // [none, standard, studs, groove]
// Whether to draw pillars.
pillars = true;
// Whether to draw a relief cut
baseReliefCut = false;
// Relief Cut Height (mbu)
baseReliefCutHeight = 0.375; // [0:0.125:128]
// Relief Cut Thickness (mbu)
baseReliefCutThickness = 0.375; // [0:0.125:128]
// Grille
grille = "none"; // [none, x, y]
// Whether Grille is inverted
grilleInverted = false;
// Depth of Grille (mbu)
grilleDepth = 1; // [0.1:0.1:64]
// Count of Grille elements
grilleCount = 2.5; // [1:0.1:20]

/* [Studs] */

// Whether brick has studs.
studs = true;
// Whether studs should be shifted by a half brick.
studShift = false;
// Type of the studs
studType = "solid"; // [solid, hollow]
// Stud Padding (grid)
studPadding = [0.2, 0.2, 0.2, 0.2]; // [0:0.1:128]
// Stud Sink (mbu)
studSink = 0.25; // [0:0.25:8]

/* [Bevel] */

// Bevel X and Y for the corner [0,0] (grid)
bevel0 = [0, 0]; // [0:0.25:128]
// Bevel X and Y for the corner [0,1] (grid)
bevel1 = [0, 0]; // [0:0.25:128]
// Bevel X and Y for the corner [1,1] (grid)
bevel2 = [0, 0]; // [0:0.25:128]
// Bevel X and Y for the corner [1,0] (grid)
bevel3 = [0, 0]; // [0:0.25:128]

/* [Holes] */

// Whether brick should have Technic holes along X-axis.
holeX = false;
// Type of X Holes.
holeXType = "pin"; // [pin, axle]
// Whether X Holes should be centered
holeXShift = true;
// Hole X Grid Offset Z (mbu)
holeXGridOffsetZ = 3.5; // [0:0.1:128]
// Whether brick should have Technic holes along Y-axis.
holeY = false;
// Type of Y Holes.
holeYType = "pin"; // [pin, axle]
// Whether Y Holes should be centered
holeYShift = true;
// Hole Y Grid Offset Z (mbu)
holeYGridOffsetZ = 3.5; // [0:0.1:128]
// Whether brick should have Technic holes along Z-axis.
holeZ = false;
// Type of Z Holes.
holeZType = "pin"; // [pin, axle]
// Whether Z Holes should be shifted by a half brick.
holeZShift = true;

/* [Recess] */

// Whether brick should have a recess
recess = false;
// Whether knobs should be drawn inside recess
recessStuds = false;
// Recess wall thickness as multiple of one brick side length (grid)
recessWallThickness = [0.333, 0.333, 0.333, 0.333]; // [0:0.001:128]
// Auto Recess Depth
recessDepthAuto = true;
// Recess Depth (grid)
recessDepth = 0; //[0:0.25:32]
// Recess Stud Padding
recessStudPadding = [0.2, 0.2, 0.2, 0.2];

/* [Slope] */

// Slope per side (plates)
slope = [0, 0, 0, 0]; // [-128:0.1:128]

/* [Text] */

// Text to write on the brick.
text = "";
// Side of the brick on which text is written.
textSide = 5; // [0:X0, 1:X1, 2:Y0, 3:Y1, 4:Z0, 5:Z1]
// Letter Depth (mbu)
textDepth = 0.5; // [-3.2:0.05:3.2]
// Text Size (pt)
textSize = 9; // [1:32]
// Font
textFont = "RBNo3.1 Black"; // [Creato Display, RBNo3.1 Black, Font Awesome 6 Free Regular, Font Awesome 6 Free Solid]
// Text Style
textStyle = "Regular"; // [Black, Black Italic, Bold, Bold Italic, Book, Book Italic, ExtraBold, ExtraBold Italic, Light, Light Italic, Medium, Medium Italic, Regular, Regular Italic, Thin, Thin Italic, Ultra, Ultra Italic]
// Spacing of the letters
textSpacing = 1; // [0.1:0.1:4]
// Color of the text
textColor = "#303D4E"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Style] */

// Color of the brick
baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
// Surface Pattern Scale
surfacePatternScale = 0.2; // [0:0.001:1]
// Surface Pattern
surfacePattern = "none"; // [none:None, ../pattern/honeycombs.svg:Honeycombs, ../pattern/squares.svg:Squares, ../pattern/squares-diagonal.svg:Squares Diagonal, ../pattern/diamonds.svg:Diamonds, ../pattern/textile.svg:Textile, ../pattern/card-background.svg:Card Background, ../pattern/dots.svg:Dots, ../pattern/circuit-board.svg:Circuit Board]
// Icons on studs
studIcon = "../../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]

/* [Hidden] */

baseRoundingRadius = [baseRoundingRadiusX, baseRoundingRadiusY, baseRoundingRadiusZ];
bevel = [bevel0, bevel1, bevel2, bevel3];
textFontFull = str(textFont, (textStyle == "" ? "" : str(":style=", textStyle)));
recessDepthResolved = recessDepthAuto ? "auto" : recessDepth;

/*
 * Main Module Call
 */
mb_block__com__machineblocks__bricks__Standard(
    config = mb_config,
    settings = [
        ["size", size],
        ["baseRoundingRadius", baseRoundingRadius],
        ["baseCutoutType", baseCutoutType],
        ["pillars", pillars],
        ["reliefCut", baseReliefCut],
        ["reliefCutHeight", baseReliefCutHeight],
        ["reliefCutThickness", baseReliefCutThickness],
        ["grille", grille],
        ["grilleInverted", grilleInverted],
        ["grilleDepth", grilleDepth],
        ["grilleCount", grilleCount],
        ["bevel", bevel],
        ["studs", studs],
        ["studShift", studShift],
        ["studType", studType],
        ["studPadding", studPadding],
        ["holeX", holeX],
        ["holeXType", holeXType],
        ["holeXShift", holeXShift],
        ["holeXGridOffsetZ", holeXGridOffsetZ],
        ["holeY", holeY],
        ["holeYType", holeYType],
        ["holeYShift", holeYShift],
        ["holeYGridOffsetZ", holeYGridOffsetZ],
        ["holeZ", holeZ],
        ["holeZType", holeZType],
        ["holeZShift", holeZShift],
        ["recess", recess],
        ["recessStuds", recessStuds],
        ["recessWallThickness", recessWallThickness],
        ["recessDepth", recessDepthResolved],
        ["recessStuds", recessStuds],
        ["recessStudPadding", recessStudPadding],
        ["slope", slope],
        ["text", text],
        ["textSide", textSide],
        ["textDepth", textDepth],
        ["textSize", textSize],
        ["textFont", textFontFull],
        ["textSpacing", textSpacing],
        ["textColor", textColor],
        ["baseColor", baseColor],
        ["surfacePattern", surfacePattern],
        ["surfacePatternScale", surfacePatternScale],
        ["studIcon", studIcon],
        ["studSink", studSink]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__com__machineblocks__bricks__Standard(config = undef, settings = undef){
    mb_block(
        config = config,
        settings = settings
    );
}
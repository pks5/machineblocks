/**
 * MachineBlocks.com Block File
 *
 * Name: MachineBlock Standard Brick
 * Filename: Standard.scad
 * FQN: com.machineblocks.scad.bricks.Standard
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
use <../../../../../lib/block.scad>;
include <../../../../../config/mb_config.scad>;

/*
 * Customization
 */

/* [Size] */

// Brick size (grid)
size = [4, 2, 3]; // [1:1:32]

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
studBaseOverlap = 0.25; // [0:0.25:8]

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
recessDepth = 0; // [0:0.25:32]
// Recess Stud Padding
recessStudPadding = [0.2, 0.2, 0.2, 0.2];

/* [Slope] */

// Slope per side (plates)
slope = [0, 0, 0, 0]; // [-128:0.1:128]

/* [Text] */

// Text to write on the brick.
text = "";
// Side of the brick on which text is written.
textFace = 5; // [0:X-, 1:X+, 2:Y-, 3:Y+, 4:Z-, 5:Z+]
// Letter Depth (mbu)
textDepth = 0.5; // [-3.2:0.05:3.2]
// Text Size
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
studIcon = "../../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt]

/* [Hidden] */

baseRoundingRadius = [baseRoundingRadiusX, baseRoundingRadiusY, baseRoundingRadiusZ];
bevel = [bevel0, bevel1, bevel2, bevel3];
// textStyle is customizer-only — NativeBlock has textFont (may include :style=…)
textFontFull = str(textFont, (textStyle == "" ? "" : str(":style=", textStyle)));
recessDepthResolved = recessDepthAuto ? "auto" : recessDepth;
// Per-axis customizer UI → V3 NativeBlock / mb_param_* keys
holeXYZType = [holeXType, holeYType, holeZType];
holeXYZShift = [holeXShift, holeYShift, holeZShift];
holeXYGridOffsetZ = [holeXGridOffsetZ, holeYGridOffsetZ];

/*
 * Main Module Call
 */
mb__com__machineblocks__scad__bricks__Standard(
    config = mb_config,
    settings = [
        ["size",                 size],
        ["baseRoundingRadius",   baseRoundingRadius],
        ["baseCutoutType",       baseCutoutType],
        ["pillars",              pillars],
        ["reliefCut",            baseReliefCut],
        ["reliefCutHeight",      baseReliefCutHeight],
        ["reliefCutThickness",   baseReliefCutThickness],
        ["grille",               grille],
        ["grilleInverted",       grilleInverted],
        ["grilleDepth",          grilleDepth],
        ["grilleCount",          grilleCount],
        ["bevel",                bevel],
        ["studs",                studs],
        ["studShift",            studShift],
        ["studType",             studType],
        ["studPadding",          studPadding],
        ["studBaseOverlap",      studBaseOverlap],
        ["holeX",                holeX],
        ["holeY",                holeY],
        ["holeZ",                holeZ],
        ["holeXYZType",          holeXYZType],
        ["holeXYZShift",         holeXYZShift],
        ["holeXYGridOffsetZ",    holeXYGridOffsetZ],
        ["recess",               recess],
        ["recessStuds",          recessStuds],
        ["recessWallThickness",  recessWallThickness],
        ["recessDepth",          recessDepthResolved],
        ["recessStudPadding",    recessStudPadding],
        ["slope",                slope],
        ["text",                 text],
        ["textFace",             textFace],
        ["textDepth",            textDepth],
        ["textSize",             textSize],
        ["textFont",             textFontFull],
        ["textSpacing",          textSpacing],
        ["textColor",            textColor],
        ["baseColor",            baseColor],
        ["surfacePattern",       surfacePattern],
        ["surfacePatternScale",  surfacePatternScale],
        ["studIcon",             studIcon]
    ]
);

/*
 * Main Module Definition
 * com.machineblocks.scad.bricks.Standard
 *
 * CompositeBlock with a single NativeBlock child — no wrapper mb_block()
 * generated (1 child rule). Each NativeBlock property is extracted via
 * mb_param_* — no generic mb_param() for natives. Only the declared
 * parameter set of Standard is forwarded to mb_block().
 */
module mb__com__machineblocks__scad__bricks__Standard(config = undef, settings = undef) {

    blockId             = mb_param_id(config, settings, "com.machineblocks.scad.bricks.Standard");
    size                = mb_param_size(config, settings, [4, 2, 3]);
    baseRoundingRadius  = mb_param_baseRoundingRadius(config, settings, 0);
    baseCutoutType      = mb_param_baseCutoutType(config, settings);
    pillars             = mb_param_pillars(config, settings, true);
    reliefCut           = mb_param_reliefCut(config, settings, false);
    reliefCutHeight     = mb_param_reliefCutHeight(config, settings, 0.375);
    reliefCutThickness  = mb_param_reliefCutThickness(config, settings, 0.375);
    grille              = mb_param_grille(config, settings, "none");
    grilleInverted      = mb_param_grilleInverted(config, settings, false);
    grilleDepth         = mb_param_grilleDepth(config, settings, 1);
    grilleCount         = mb_param_grilleCount(config, settings, 2.5);
    bevel               = mb_param_bevel(config, settings, [[0,0],[0,0],[0,0],[0,0]]);
    studs               = mb_param_studs(config, settings);
    studShift           = mb_param_studShift(config, settings, false);
    studType            = mb_param_studType(config, settings, "solid");
    studPadding         = mb_param_studPadding(config, settings, [0.2,0.2,0.2,0.2]);
    studBaseOverlap     = mb_param_studBaseOverlap(config, settings, 0.25);
    holeX               = mb_param_holeX(config, settings, false);
    holeY               = mb_param_holeY(config, settings, false);
    holeZ               = mb_param_holeZ(config, settings, false);
    holeXYZType         = mb_param_holeXYZType(config, settings, "pin");
    holeXYZShift        = mb_param_holeXYZShift(config, settings, true);
    holeXYGridOffsetZ   = mb_param_holeXYGridOffsetZ(config, settings, 3.5);
    recess              = mb_param_recess(config, settings, false);
    recessStuds         = mb_param_recessStuds(config, settings, false);
    recessWallThickness = mb_param_recessWallThickness(config, settings,
                              [0.333,0.333,0.333,0.333]);
    recessDepth         = mb_param_recessDepth(config, settings, "auto");
    recessStudPadding   = mb_param_recessStudPadding(config, settings,
                              [0.2,0.2,0.2,0.2]);
    slope               = mb_param_slope(config, settings, [0,0,0,0]);
    text                = mb_param_text(config, settings, "");
    textFace            = mb_param_textFace(config, settings, 5);
    textDepth           = mb_param_textDepth(config, settings, 0.5);
    textSize            = mb_param_textSize(config, settings, 9);
    textFont            = mb_param_textFont(config, settings, "RBNo3.1 Black");
    textSpacing         = mb_param_textSpacing(config, settings, 1);
    textColor           = mb_param_textColor(config, settings, "#303D4E");
    baseColor           = mb_param_baseColor(config, settings);
    surfacePattern      = mb_param_surfacePattern(config, settings, "none");
    surfacePatternScale = mb_param_surfacePatternScale(config, settings, 0.2);
    studIcon            = mb_param_studIcon(config, settings, "none");

    // Single NativeBlock — no wrapper (1 child rule)
    mb_block(
        config = config,
        settings = [
            ["id",                  blockId],
            ["size",                size],
            ["baseRoundingRadius",  baseRoundingRadius],
            ["baseCutoutType",      baseCutoutType],
            ["pillars",             pillars],
            ["reliefCut",           reliefCut],
            ["reliefCutHeight",     reliefCutHeight],
            ["reliefCutThickness",  reliefCutThickness],
            ["grille",              grille],
            ["grilleInverted",      grilleInverted],
            ["grilleDepth",         grilleDepth],
            ["grilleCount",         grilleCount],
            ["bevel",               bevel],
            ["studs",               studs],
            ["studShift",           studShift],
            ["studType",            studType],
            ["studPadding",         studPadding],
            ["studBaseOverlap",     studBaseOverlap],
            ["holeX",               holeX],
            ["holeY",               holeY],
            ["holeZ",               holeZ],
            ["holeXYZType",         holeXYZType],
            ["holeXYZShift",        holeXYZShift],
            ["holeXYGridOffsetZ",   holeXYGridOffsetZ],
            ["recess",              recess],
            ["recessStuds",         recessStuds],
            ["recessWallThickness", recessWallThickness],
            ["recessDepth",         recessDepth],
            ["recessStudPadding",   recessStudPadding],
            ["slope",               slope],
            ["text",                text],
            ["textFace",            textFace],
            ["textDepth",           textDepth],
            ["textSize",            textSize],
            ["textFont",            textFont],
            ["textSpacing",         textSpacing],
            ["textColor",           textColor],
            ["baseColor",           baseColor],
            ["surfacePattern",      surfacePattern],
            ["surfacePatternScale", surfacePatternScale],
            ["studIcon",            studIcon]
        ]
    );
}

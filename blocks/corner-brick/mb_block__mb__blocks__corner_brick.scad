/**
 * MachineBlocks Block File
 *
 * Name: Corner Brick 4x4 B2
 * Filename: mb_block__mb__blocks__corner_brick.scad
 * Package: mb.blocks.corner_brick
 *
 * Original: Corner Brick 4x4 B2 (Legacy)
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 */

/*
 * Imports
 */
use <../../lib/block.scad>;
include <../../config/mb_config.scad>;

/*
 * Customization
 */

/* [Size] */

// Brick size
size = [4, 4, 3]; // [1:32]

// Brick 1 Grid Size in Y-direction as multiple of an 1x1 brick.
brick1SizeY = 2; // [1:32]
// Brick 2 Grid Size in X-direction as multiple of an 1x1 brick.
brick2SizeX = 2; // [1:32]

// Brick 1 Offset in Y-direction as multiple of an 1x1 brick.
brick1OffsetY = 0; // [0:31]
// Brick 2 Offset in X-direction as multiple of an 1x1 brick.
brick2OffsetX = 0; // [0:31]

/* [Base] */

// Type of cut-out on the underside.
baseCutoutType = "standard"; // [none, standard, studs, groove]
// Whether to draw pillars.
pillars = true;
// Whether to draw a relief cut
baseReliefCut = false;
// Relief Cut Height (mbu)
baseReliefCutHeight = 0.4; // [0:0.1:128]
// Relief Cut Thickness (mbu)
baseReliefCutThickness = 0.4; // [0:0.1:128]
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
studSink = 0.25; // [0:0.125:1]

/* [Style] */

// Color of the brick
baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
// Surface Pattern Scale
surfacePatternScale = 0.2; // [0:0.001:1]
// Surface Pattern
surfacePattern = "none"; // [none:None, ../pattern/honeycombs.svg:Honeycombs, ../pattern/squares.svg:Squares, ../pattern/squares-diagonal.svg:Squares Diagonal, ../pattern/diamonds.svg:Diamonds, ../pattern/textile.svg:Textile, ../pattern/card-background.svg:Card Background, ../pattern/dots.svg:Dots, ../pattern/circuit-board.svg:Circuit Board]
// Icons on studs
studIcon = "../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]

/* [Hidden] */

/*
 * Main Module Call
 */
mb_block__mb__blocks__corner_brick(
    config = mb_config,
    settings = [
        ["size", size],
        ["brick1SizeY", brick1SizeY],
        ["brick2SizeX", brick2SizeX],
        ["brick1OffsetY", brick1OffsetY],
        ["brick2OffsetX", brick2OffsetX],
        ["baseCutoutType", baseCutoutType],
        ["pillars", pillars],
        ["baseReliefCut", baseReliefCut],
        ["baseReliefCutHeight", baseReliefCutHeight],
        ["baseReliefCutThickness", baseReliefCutThickness],
        ["grille", grille],
        ["grilleInverted", grilleInverted],
        ["grilleDepth", grilleDepth],
        ["grilleCount", grilleCount],
        ["studs", studs],
        ["studShift", studShift],
        ["studType", studType],
        ["studPadding", studPadding],
        ["studSink", studSink],
        ["baseColor", baseColor],
        ["surfacePattern", surfacePattern],
        ["surfacePatternScale", surfacePatternScale],
        ["studIcon", studIcon]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mb__blocks__corner_brick(config = undef, settings = undef){
    size = mb_params_get(settings, "size", default=[4, 4, 3]);
    brick1SizeY = mb_params_get(settings, "brick1SizeY", default=2);
    brick2SizeX = mb_params_get(settings, "brick2SizeX", default=2);
    brick1OffsetY = mb_params_get(settings, "brick1OffsetY", default=0);
    brick2OffsetX = mb_params_get(settings, "brick2OffsetX", default=0);
    offset = mb_params_get(settings, "offset", default=[0, 0, 0]);
    direction = mb_params_get(settings, "direction", default="west");
    align = mb_params_get(settings, "align", default="start");
    baseCutoutType = mb_params_get(settings, "baseCutoutType", default="standard");
    pillars = mb_params_get(settings, "pillars", default=true);
    baseReliefCut = mb_params_get(settings, "baseReliefCut", default=false);
    baseReliefCutHeight = mb_params_get(settings, "baseReliefCutHeight", default=0.4);
    baseReliefCutThickness = mb_params_get(settings, "baseReliefCutThickness", default=0.4);
    grille = mb_params_get(settings, "grille", default="none");
    grilleInverted = mb_params_get(settings, "grilleInverted", default=false);
    grilleDepth = mb_params_get(settings, "grilleDepth", default=1);
    grilleCount = mb_params_get(settings, "grilleCount", default=5);
    studs = mb_params_get(settings, "studs", default=true);
    studShift = mb_params_get(settings, "studShift", default=false);
    studSink = mb_params_get(settings, "studSink", default=0.25);
    studType = mb_params_get(settings, "studType", default="solid");
    studPadding = mb_params_get(settings, "studPadding", default=[0.2, 0.2, 0.2, 0.2]);
    baseColor = mb_params_get(settings, "baseColor", default="#EAC645");
    surfacePattern = mb_params_get(settings, "surfacePattern", default="none");
    surfacePatternScale = mb_params_get(settings, "surfacePatternScale", default=0.2);
    studIcon = mb_params_get(settings, "studIcon", default="../pattern/bolt-solid-full.svg");

    // Shared settings for both sub-blocks
    sharedSettings = [
        ["baseCutoutType", baseCutoutType],
        ["pillars", pillars],
        ["baseReliefCut", baseReliefCut],
        ["baseReliefCutHeight", baseReliefCutHeight],
        ["baseReliefCutThickness", baseReliefCutThickness],
        ["grille", grille],
        ["grilleInverted", grilleInverted],
        ["grilleDepth", grilleDepth],
        ["grilleCount", grilleCount],
        ["studs", studs],
        ["studShift", studShift],
        ["studSink", studSink],
        ["studType", studType],
        ["studPadding", studPadding],
        ["baseColor", baseColor],
        ["surfacePattern", surfacePattern],
        ["surfacePatternScale", surfacePatternScale],
        ["studIcon", studIcon]
    ];

    // Wrapper block
    mb_block(
        config = config,
        settings = [
            ["base", false],
            ["studs", false],
            ["size", size],
            ["align", align],
            ["alignChildren", "ccs"],
            ["offset", offset],
            ["direction", direction]
        ]
    ){
        // Brick 1 — along X axis, narrow in Y
        mb_block(
            config = config,
            settings = concat(sharedSettings, [
                ["size", [size[0], brick1SizeY, size[2]]],
                ["align", "ccs"],
                ["offset", [0, brick1OffsetY - 0.5*(size[1] - brick1SizeY), 0]],
                ["baseWallGapsX", [[brick2OffsetX, 2, brick2SizeX]]]
            ])
        );

        // Brick 2 — along Y axis, narrow in X
        mb_block(
            config = config,
            settings = concat(sharedSettings, [
                ["size", [brick2SizeX, size[1], size[2]]],
                ["align", "ccs"],
                ["offset", [brick2OffsetX - 0.5*(size[0] - brick2SizeX), 0, 0]],
                ["baseWallGapsY", [[brick1OffsetY, 2, brick1SizeY]]]
            ])
        );
    }
}
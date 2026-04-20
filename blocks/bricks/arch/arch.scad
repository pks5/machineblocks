/**
 * MachineBlocks.com Block File
 *
 * Name: Arch
 * Filename: mb_block__mb__bricks__arch.scad
 * Package: mb.bricks.arch
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
use <../../../../machineblocks/lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;

/*
 * Customization
 */

/* [Size] */

// Brick size
size = [4, 1, 6]; // [1:32]

// Size of first pillar in X-direction specified as multiple of an 1x1 brick.
column1SizeX = 1; // [1:32]

// Height of the deck as multiple of a plate
deckHeight = 1; // [1:32]

// Whether the arc has a second column
secondColumn = true;

// Size of second pillar in X-direction specified as multiple of an 1x1 brick.
column2SizeX = 1; // [1:32]

// Whether the arch is inverted
inverted = false;

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
grilleCount = 5; // [2:64]

/* [Studs] */

// Whether brick has studs.
studs = true;

// Whether studs should be shifted by a half brick.
studShift = "none"; // [none:None, x:X-Direction, y:Y-Direction, xy:Both Directions]

// Type of the studs
studType = "solid"; // [solid, hollow]

// Stud Padding (grid)
studPadding = [0.2, 0.2, 0.2, 0.2]; // [0:0.1:128]

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

_sharedSettings = [
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
    ["baseColor", baseColor],
    ["surfacePattern", surfacePattern],
    ["surfacePatternScale", surfacePatternScale],
    ["studIcon", studIcon]
];

/*
 * Main Module Call
 */
mb_block__mb__bricks__arch(
    config = mb_config,
    settings = mb_params_merge(_sharedSettings, [
        ["size", size],
        ["column1SizeX", column1SizeX],
        ["deckHeight", deckHeight],
        ["secondColumn", secondColumn],
        ["column2SizeX", column2SizeX],
        ["inverted", inverted]
    ])
);

/*
 * Main Module Definition
 */
module mb_block__mb__bricks__arch(config = undef, settings = undef){

    // Native Parameters
    size             = mb_param_size(config, settings, [4, 1, 6]);
    baseCutoutType   = mb_param_baseCutoutType(config, settings);
    pillars          = mb_param_pillars(config, settings);
    baseReliefCut    = mb_param_baseReliefCut(config, settings);
    baseReliefCutHeight     = mb_param_baseReliefCutHeight(config, settings);
    baseReliefCutThickness  = mb_param_baseReliefCutThickness(config, settings);
    grille           = mb_param_grille(config, settings);
    grilleInverted   = mb_param_grilleInverted(config, settings);
    grilleDepth      = mb_param_grilleDepth(config, settings);
    grilleCount      = mb_param_grilleCount(config, settings);
    studs            = mb_param_studs(config, settings);
    studShift        = mb_param_studShift(config, settings);
    studType         = mb_param_studType(config, settings);
    studPadding      = mb_param_studPadding(config, settings);
    baseColor        = mb_param_baseColor(config, settings);
    surfacePattern   = mb_param_surfacePattern(config, settings);
    surfacePatternScale = mb_param_surfacePatternScale(config, settings);
    studIcon         = mb_param_studIcon(config, settings);
    baseSideAdjustment = mb_param_baseSideAdjustment(config, settings);

    // System Parameters
    unitMbu  = mb_param_unitMbu(config, settings);
    unitGrid = mb_param_unitGrid(config, settings);
    scale    = mb_param_scale(config, settings);

    // Custom Parameters
    column1SizeX = mb_param(config, settings, "column1SizeX", 1);
    deckHeight   = mb_param(config, settings, "deckHeight", 1);
    secondColumn = mb_param(config, settings, "secondColumn", true);
    column2SizeX = mb_param(config, settings, "column2SizeX", 1);
    inverted     = mb_param(config, settings, "inverted", false);

    // Internal computations
    bSideAdj = baseSideAdjustment[0];
    tunnelSpanX = (secondColumn ? 1 : 2) * (size[0] - column1SizeX - (secondColumn ? column2SizeX : 0));
    tunnelWidth  = tunnelSpanX * unitGrid[0] * unitMbu * scale;
    tunnelHeight = (size[2] - deckHeight) * unitGrid[1] * unitMbu * scale;
    brickTotalSizeY = size[1] * unitGrid[0] * unitMbu * scale + 2 * bSideAdj;

    // Shared settings forwarded to all mb_block() calls
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
        ["studType", studType],
        ["studPadding", studPadding],
        ["baseColor", baseColor],
        ["surfacePattern", surfacePattern],
        ["surfacePatternScale", surfacePatternScale],
        ["studIcon", studIcon]
    ];

    if(!inverted){
        // Column 1
        mb_block(
            config = config,
            settings = mb_params_merge(sharedSettings, [
                ["size", [column1SizeX, size[1], size[2]]],
                ["baseSideAdjustment", [bSideAdj, 0.01, bSideAdj, bSideAdj]]
            ])
        );

        // Column 2 (optional)
        if(secondColumn){
            mb_block(
                config = config,
                settings = mb_params_merge(sharedSettings, [
                    ["size", [column2SizeX, size[1], size[2]]],
                    ["offset", [size[0] - column2SizeX, 0, 0]],
                    ["baseSideAdjustment", [0.01, bSideAdj, bSideAdj, bSideAdj]]
                ])
            );
        }

        // Tunnel span — elliptical arch cut applied via raw difference()
        difference(){
            mb_block(
                config = config,
                settings = mb_params_merge(sharedSettings, [
                    ["size", [size[0] - column1SizeX - (secondColumn ? column2SizeX : 0), size[1], size[2]]],
                    ["offset", [column1SizeX, 0, 0]],
                    ["baseCutoutType", "none"],
                    ["baseSideAdjustment", [-bSideAdj, secondColumn ? -bSideAdj : bSideAdj, bSideAdj, bSideAdj]]
                ])
            );

            // Elliptical arch void
            translate([
                0.5 * tunnelWidth + column1SizeX * unitGrid[0] * unitMbu * scale,
                0.5 * brickTotalSizeY - bSideAdj,
                0
            ])
                rotate([90, 0, 0])
                    scale([1, 2 * tunnelHeight / tunnelWidth, 1])
                        cylinder(h = 1.1 * brickTotalSizeY, r = 0.5 * tunnelWidth, center = true);
        }

    } else {
        // Inverted arch — full brick with elliptical void cut from the top
        difference(){
            mb_block(
                config = config,
                settings = mb_params_merge(sharedSettings, [
                    ["size", size],
                    ["baseCutoutMaxDepth", 2],
                    ["baseSideAdjustment", [bSideAdj, bSideAdj, bSideAdj, bSideAdj]]
                ])
            );

            // Elliptical arch void (inverted — from top)
            translate([
                0.5 * tunnelWidth + column1SizeX * unitGrid[0] * unitMbu * scale,
                0.5 * brickTotalSizeY - bSideAdj,
                size[2] * unitGrid[1] * unitMbu * scale
            ])
                rotate([90, 0, 0])
                    scale([1, 2 * tunnelHeight / tunnelWidth, 1])
                        cylinder(h = 1.1 * brickTotalSizeY, r = 0.5 * tunnelWidth, center = true);
        }
    }
}

/**
 * MachineBlocks.com Block File
 *
 * Name: Arch
 * Filename: mb_block__mb__user__arch.scad
 * Package: mb.user.arch
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

// Size of first pillar in X-direction
column1SizeX = 1; // [1:32]

// Height of the deck as multiple of a plate
deckHeight = 1; // [1:32]

// Whether the arc has a second column
secondColumn = true;

// Size of second pillar in X-direction
column2SizeX = 1; // [1:32]

// Whether the arch is inverted
inverted = false;

/* [Base] */

// Type of cut-out on the underside
baseCutoutType = "standard"; // [none, standard, studs, groove]

// Whether to draw pillars
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

// Whether brick has studs
studs = true;

// Whether studs should be shifted by a half brick
studShift = "none"; // [none:None, x:X-Direction, y:Y-Direction, xy:Both Directions]

// Type of the studs
studType = "solid"; // [solid, hollow]

// Stud Padding (grid)
studPadding = [0.2, 0.2, 0.2, 0.2]; // [0:0.1:128]

/* [Style] */

// Color of the brick
baseColor = "#EAC645";

// Surface pattern scale
surfacePatternScale = 0.2; // [0:0.001:1]

// Surface pattern
surfacePattern = "none"; // [none:None, ../pattern/honeycombs.svg:Honeycombs, ../pattern/squares.svg:Squares]

// Icons on studs
studIcon = "../pattern/bolt-solid-full.svg";

/* [Hidden] */

tunnelWidth = (secondColumn ? 1 : 2) * (size[0] - column1SizeX - (secondColumn ? column2SizeX : 0)) * 8.0;
tunnelHeight = (size[2] - deckHeight) * 3.2;
brickTotalSizeY = size[1] * 8.0;

/*
 * Main Module Call
 */
mb_block__mb__user__arch(
    config = mb_config,
    settings = [
        ["size", size],
        ["column1SizeX", column1SizeX],
        ["deckHeight", deckHeight],
        ["secondColumn", secondColumn],
        ["column2SizeX", column2SizeX],
        ["inverted", inverted],
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
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mb__user__arch(config = undef, settings = undef) {
    // Native Parameters
    size         = mb_param_size(config, settings, [4, 1, 6]);
    baseColor    = mb_param_baseColor(config, settings);

    // Custom Parameters
    column1SizeX          = mb_param(config, settings, "column1SizeX", 1);
    deckHeight            = mb_param(config, settings, "deckHeight", 1);
    secondColumn          = mb_param(config, settings, "secondColumn", true);
    column2SizeX          = mb_param(config, settings, "column2SizeX", 1);
    inverted              = mb_param(config, settings, "inverted", false);
    baseCutoutType        = mb_param(config, settings, "baseCutoutType", "standard");
    pillars               = mb_param(config, settings, "pillars", true);
    baseReliefCut         = mb_param(config, settings, "baseReliefCut", false);
    baseReliefCutHeight   = mb_param(config, settings, "baseReliefCutHeight", 0.4);
    baseReliefCutThickness= mb_param(config, settings, "baseReliefCutThickness", 0.4);
    grille                = mb_param(config, settings, "grille", "none");
    grilleInverted        = mb_param(config, settings, "grilleInverted", false);
    grilleDepth           = mb_param(config, settings, "grilleDepth", 1);
    grilleCount           = mb_param(config, settings, "grilleCount", 5);
    studs                 = mb_param(config, settings, "studs", true);
    studShift             = mb_param(config, settings, "studShift", "none");
    studType              = mb_param(config, settings, "studType", "solid");
    studPadding           = mb_param(config, settings, "studPadding", [0.2, 0.2, 0.2, 0.2]);
    surfacePattern        = mb_param(config, settings, "surfacePattern", "none");
    surfacePatternScale   = mb_param(config, settings, "surfacePatternScale", 0.2);
    studIcon              = mb_param(config, settings, "studIcon", "../pattern/bolt-solid-full.svg");

    // Derived values (matching legacy logic, unitGrid=[5,2], unitMbu=1.6, scale=1)
    tunnelSpanX   = size[0] - column1SizeX - (secondColumn ? column2SizeX : 0);
    tunnelWidth   = (secondColumn ? 1 : 2) * tunnelSpanX * 8.0;
    tunnelHeight  = (size[2] - deckHeight) * 3.2;
    brickTotalSizeY = size[1] * 8.0;

    // Shared settings fragments
    sharedSettings = [
        ["baseCutoutType",         baseCutoutType],
        ["pillars",                pillars],
        ["baseReliefCut",          baseReliefCut],
        ["baseReliefCutHeight",    baseReliefCutHeight],
        ["baseReliefCutThickness", baseReliefCutThickness],
        ["grille",                 grille],
        ["grilleInverted",         grilleInverted],
        ["grilleDepth",            grilleDepth],
        ["grilleCount",            grilleCount],
        ["studs",                  studs],
        ["studShift",              studShift],
        ["studType",               studType],
        ["studPadding",            studPadding],
        ["baseColor",              baseColor],
        ["surfacePattern",         surfacePattern],
        ["surfacePatternScale",    surfacePatternScale],
        ["studIcon",               studIcon]
    ];

    difference() {
        // Column 1 (also serves as outer wrapper for non-inverted)
        mb_block(
            config = config,
            settings = mb_params_merge(sharedSettings, [
                ["size", [inverted ? size[0] : column1SizeX, size[1], size[2]]],
                ["baseCutoutMaxDepth", inverted ? 2 : 5]
            ])
        ) {
            if (!inverted) {
                // Column 2
                if (secondColumn) {
                    mb_block(
                        config = config,
                        settings = mb_params_merge(sharedSettings, [
                            ["size",   [column2SizeX, size[1], size[2]]],
                            ["offset", [size[0] - column2SizeX, 0, 0]]
                        ])
                    );
                }

                // Tunnel top block minus arch cutout
                difference() {
                    mb_block(
                        config = config,
                        settings = mb_params_merge(sharedSettings, [
                            ["size",             [tunnelSpanX, size[1], size[2]]],
                            ["offset",           [column1SizeX, 0, 0]],
                            ["baseCutoutType",   "none"],
                            ["baseSideAdjustment", [-0.1, secondColumn ? -0.1 : 0.1, 0.1, 0.1]]
                        ])
                    );

                    // Arch cutout — native OpenSCAD elliptic cylinder
                    translate([0.5 * tunnelWidth + column1SizeX * 8.0, 0.5 * brickTotalSizeY, 0])
                        rotate([90, 0, 0])
                            scale([1, 2 * tunnelHeight / tunnelWidth, 1])
                                cylinder(h = 1.1 * brickTotalSizeY, r = 0.5 * tunnelWidth,
                                         center = true, $fn = 64);
                }
            }
        }

        // Inverted arch cutout
        if (inverted) {
            translate([0.5 * tunnelWidth + column1SizeX * 8.0, 0.5 * brickTotalSizeY, size[2] * 3.2])
                rotate([90, 0, 0])
                    scale([1, 2 * tunnelHeight / tunnelWidth, 1])
                        cylinder(h = 1.1 * brickTotalSizeY, r = 0.5 * tunnelWidth,
                                 center = true, $fn = 64);
        }
    }
}
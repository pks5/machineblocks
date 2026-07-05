/**
 * MachineBlocks.com Block File
 *
 * Name: Frame
 * Filename: Frame.scad
 * FQN: com.machineblocks.examples.Frame
 */

/*
 * Imports
 */
use <../../../../lib/block.scad>;
include <../../../../config/mb_config.scad>;

/*
 * Customization
 */

/* [Size] */

size = [6, 6, 3]; // [1:32]

// Frame thickness in grid units
frameThickness = 1; // [1:32]

/* [Base] */

baseCutoutType = "standard"; // [none, standard, studs, groove]
pillars = true;
baseReliefCut = false;
baseReliefCutHeight = 0.4; // [0:0.1:128]
baseReliefCutThickness = 0.4; // [0:0.1:128]
grille = "none"; // [none, x, y]
grilleInverted = false;
grilleDepth = 1; // [0.1:0.1:64]
grilleCount = 2.5; // [1:0.1:20]

/* [Studs] */

studs = true;
studShift = false;
studType = "solid"; // [solid, hollow]
studPadding = [0.2, 0.2, 0.2, 0.2]; // [0:0.1:128]
studBaseOverlap = 0.25; // [0:0.125:1]

/* [Style] */

baseColor = "#EAC645";
surfacePatternScale = 0.2; // [0:0.001:1]
surfacePattern = "none";
studIcon = "../../pattern/bolt-solid-full.svg";

/* [Hidden] */

/*
 * Main Module Call
 */
mb__com__machineblocks__examples__Frame(
    config = mb_config,
    settings = [
        ["size", size],
        ["frameThickness", frameThickness],
        ["baseCutoutType", baseCutoutType],
        ["pillars", pillars],
        ["reliefCut", baseReliefCut],
        ["reliefCutHeight", baseReliefCutHeight],
        ["reliefCutThickness", baseReliefCutThickness],
        ["grille", grille],
        ["grilleInverted", grilleInverted],
        ["grilleDepth", grilleDepth],
        ["grilleCount", grilleCount],
        ["studs", studs],
        ["studShift", studShift],
        ["studType", studType],
        ["studPadding", studPadding],
        ["studBaseOverlap", studBaseOverlap],
        ["baseColor", baseColor],
        ["surfacePattern", surfacePattern],
        ["surfacePatternScale", surfacePatternScale],
        ["studIcon", studIcon]
    ]
);

/*
 * Main Module Definition
 */
module mb__com__machineblocks__examples__Frame(config = undef, settings = undef){
    // Native Parameters
    size = mb_param_size(config, settings);
    offset = mb_param_offset(config, settings);
    direction = mb_param_direction(config, settings);
    align = mb_param_align(config, settings);

    baseCutoutType = mb_param_baseCutoutType(config, settings);
    pillars = mb_param_pillars(config, settings);
    baseReliefCut = mb_param_reliefCut(config, settings);
    baseReliefCutHeight = mb_param_reliefCutHeight(config, settings);
    baseReliefCutThickness = mb_param_reliefCutThickness(config, settings);
    grille = mb_param_grille(config, settings);
    grilleInverted = mb_param_grilleInverted(config, settings);
    grilleDepth = mb_param_grilleDepth(config, settings);
    grilleCount = mb_param_grilleCount(config, settings);

    studs = mb_param_studs(config, settings);
    studShift = mb_param_studShift(config, settings);
    studBaseOverlap = mb_param_studBaseOverlap(config, settings);
    studType = mb_param_studType(config, settings);
    studPadding = mb_param_studPadding(config, settings);

    baseColor = mb_param_baseColor(config, settings);
    surfacePattern = mb_param_surfacePattern(config, settings);
    surfacePatternScale = mb_param_surfacePatternScale(config, settings);
    studIcon = mb_param_studIcon(config, settings);

    // Custom Parameters
    frameThicknessRaw = mb_param(config, settings, "frameThickness", 1);
    frameThickness = max(1, min(frameThicknessRaw, min(size[0], size[1]) / 2));

    innerSizeY = max(0, size[1] - 2 * frameThickness);

    sharedSettings = [
        ["baseCutoutType", baseCutoutType],
        ["pillars", pillars],
        ["reliefCut", baseReliefCut],
        ["reliefCutHeight", baseReliefCutHeight],
        ["reliefCutThickness", baseReliefCutThickness],
        ["grille", grille],
        ["grilleInverted", grilleInverted],
        ["grilleDepth", grilleDepth],
        ["grilleCount", grilleCount],
        ["studs", studs],
        ["studShift", studShift],
        ["studBaseOverlap", studBaseOverlap],
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
            ["offset", offset],
            ["direction", direction]
        ]
    ){
        // Bottom bar — full width
        mb_block(
            config = config,
            settings = concat(sharedSettings, [
                ["size", [size[0], frameThickness, size[2]]],
                ["offset", [0, 0, 0]],
                ["baseWallGaps", [["y+", 0, frameThickness], ["y+", size[0] - frameThickness, frameThickness]]]
            ])
        );

        // Top bar — full width
        mb_block(
            config = config,
            settings = concat(sharedSettings, [
                ["size", [size[0], frameThickness, size[2]]],
                ["offset", [0, size[1] - frameThickness, 0]],
                ["baseWallGaps", [["y-", 0, frameThickness], ["y-", size[0] - frameThickness, frameThickness]]]
            ])
        );

        // Left bar — full height
        mb_block(
            config = config,
            settings = concat(sharedSettings, [
                ["size", [frameThickness, size[1], size[2]]],
                ["offset", [0, 0, 0]],
                ["baseWallGaps", [["x+", 0, frameThickness], ["x+", size[1] - frameThickness, frameThickness]]]
            ])
        );

        // Right bar — full height
        mb_block(
            config = config,
            settings = concat(sharedSettings, [
                ["size", [frameThickness, size[1], size[2]]],
                ["offset", [size[0] - frameThickness, 0, 0]],
                ["baseWallGaps", [["x-", 0, frameThickness], ["x-", size[1] - frameThickness, frameThickness]]]
            ])
        );
    }
}
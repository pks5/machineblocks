/**
 * MachineBlocks.com Block File
 *
 * Name: BaseAdjustment
 * Filename: BaseAdjustment.scad
 * FQN: com.machineblocks.scad.examples.BaseAdjustment
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

// Bounding Box
size = [8, 8, 1]; // [1:1:16]

// Overlap at internal seams in mm
seamOverlap = 0.01; // [0:0.01:0.2]

/* [Style] */

colorP1 = "#55AB68";  // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
colorP2 = "#5296D5";  // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
colorP3 = "#EAC645";  // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
colorP4 = "#D65745";  // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

// Direction
direction = "west"; // [west, north, east, south]

/* [Hidden] */

/*
 * Main Module Call
 */
mb__com__machineblocks__scad__examples__BaseAdjustment(
    config = mb_config,
    settings = [
        ["size", size],
        ["seamOverlap", seamOverlap],
        ["colorP1", colorP1],
        ["colorP2", colorP2],
        ["colorP3", colorP3],
        ["colorP4", colorP4],
        ["direction", direction]
    ]
);

/*
 * Main Module Definition
 */
module mb__com__machineblocks__scad__examples__BaseAdjustment(config = undef, settings = undef){
    blockId = mb_param_id(config, settings, "mm.examples.base_adjustment");
    size = mb_param_size(config, settings, [8, 8, 1]);
    direction = mb_param_direction(config, settings);
    align = mb_param_align(config, settings);
    offset = mb_param_offset(config, settings);

    baseAdjustment = mb_param_baseAdjustment(config, settings);

    seamOverlap = mb_param(config, settings, "seamOverlap", 0.01);

    colorP1 = mb_param(config, settings, "colorP1", "#55AB68");
    colorP2 = mb_param(config, settings, "colorP2", "#5296D5");
    colorP3 = mb_param(config, settings, "colorP3", "#EAC645");
    colorP4 = mb_param(config, settings, "colorP4", "#D65745");

    partSize = [size[0] / 2, size[1] / 2, size[2]];

    mb_block(
        config = config,
        settings = [
            ["id", blockId],
            ["base", false],
            ["studs", false],
            ["size", size],
            ["direction", direction],
            ["align", align],
            ["offset", offset]
        ]
    ){
        // P1 — front left
        part_p1 = "p1";

        mb_block(
            config = config,
            settings = [
                ["id", mb_block_id(blockId, part_p1)],
                ["size", partSize],
                ["offset", [0, 0, 0]],
                ["baseColor", colorP1],
                ["baseAdjustment", mb_params_filter(baseAdjustment, part_p1, [
                    ["x+", seamOverlap],
                    ["y+", seamOverlap]
                ])]
            ]
        );

        // P2 — front right
        part_p2 = "p2";

        mb_block(
            config = config,
            settings = [
                ["id", mb_block_id(blockId, part_p2)],
                ["size", partSize],
                ["offset", [partSize[0], 0, 0]],
                ["baseColor", colorP2],
                ["baseAdjustment", mb_params_filter(baseAdjustment, part_p2, [
                    ["x-", seamOverlap],
                    ["y+", seamOverlap]
                ])]
            ]
        );

        // P3 — rear left
        part_p3 = "p3";

        mb_block(
            config = config,
            settings = [
                ["id", mb_block_id(blockId, part_p3)],
                ["size", partSize],
                ["offset", [0, partSize[1], 0]],
                ["baseColor", colorP3],
                ["baseAdjustment", mb_params_filter(baseAdjustment, part_p3, [
                    ["x+", seamOverlap],
                    ["y-", seamOverlap]
                ])]
            ]
        );

        // P4 — rear right
        part_p4 = "p4";

        mb_block(
            config = config,
            settings = [
                ["id", mb_block_id(blockId, part_p4)],
                ["size", partSize],
                ["offset", [partSize[0], partSize[1], 0]],
                ["baseColor", colorP4],
                ["baseAdjustment", mb_params_filter(baseAdjustment, part_p4, [
                    ["x-", seamOverlap],
                    ["y-", seamOverlap]
                ])]
            ]
        );
    }
}
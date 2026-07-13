/**
 * MachineBlocks.com Block File
 *
 * Name: Connector
 * Filename: Connector.scad
 * FQN: com.machineblocks.bml.examples.Connector
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
use <../../../../lib/block.scad>;
include <../../../../config/mb_config.scad>;

/*
 * Customization
 */

/* [Connector Example] */

// Number of columns
columns = 5; // [1:20]

// Number of rows
rows = 4; // [1:20]

// Size of one block
blockSize = [4, 2, 3]; // [1:32]

// First color
colorA = "#55AB68"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

// Second color
colorB = "#303D4E"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Hidden] */

size = [
    blockSize[0] * columns,
    blockSize[1] * rows,
    blockSize[2]
];

/*
 * Main Module Call
 */
mb__com__machineblocks__examples__Connector(
    config = mb_config,
    settings = [
        ["size", size],
        ["columns", columns],
        ["rows", rows],
        ["blockSize", blockSize],
        ["colorA", colorA],
        ["colorB", colorB]
    ]
);

/*
 * Main Module Definition
 */
module mb__com__machineblocks__examples__Connector(config = undef, settings = undef){

    // Native Parameters
    size = mb_param_size(config, settings);
    offset = mb_param_offset(config, settings);
    direction = mb_param_direction(config, settings);
    align = mb_param_align(config, settings);

    // Custom Parameters
    columns = mb_param(config, settings, "columns", 5);
    rows = mb_param(config, settings, "rows", 4);
    blockSize = mb_param(config, settings, "blockSize", [4,2,3]);
    colorA = mb_param(config, settings, "colorA", "#55AB68");
    colorB = mb_param(config, settings, "colorB", "#303D4E");

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

        for(x = [0 : columns - 1]){
            for(y = [0 : rows - 1]){

                mb_block(
                    config = config,
                    settings = [
                        ["size", blockSize],
                        [
                            "offset",
                            [
                                x * blockSize[0],
                                y * blockSize[1],
                                0
                            ]
                        ],
                        [
                            "baseColor",
                            (x + y) % 2 == 0 ? colorA : colorB
                        ],
                        [
                            "connectors",
                            concat(
                                x > 0 ? [["x-", "z", "female"]] : [],
                                x < columns - 1 ? [["x+", "z", "male"]] : [],
                                y > 0 ? [["y-", "z", "female"]] : [],
                                y < rows - 1 ? [["y+", "z", "male"]] : []
                            )
                        ]
                    ]
                );

            }
        }

    }
}
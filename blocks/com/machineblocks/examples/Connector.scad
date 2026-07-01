/**
 * MachineBlocks.com Block File
 *
 * Name: Corner Brick
 * Filename: corner.scad
 * Package: mb.bricks.corner
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
use <../../../lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;

/*
 * Customization
 */


/* [Hidden] */

/*
 * Main Module Call
 */
mb_block__mb__bricks__connector(
    config = mb_config,
    settings = [
        
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mb__bricks__connector(config = undef, settings = undef){
    // Native Parameters (provided by "mb_block()")
    size = mb_param_size(config, settings);
    offset = mb_param_offset(config, settings);
    direction = mb_param_direction(config, settings);
    align = mb_param_align(config, settings);
    

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
        mb_block(
            config = config,
            settings = [
                ["size", [4, 2, 3]],
                ["offset", [0, 0, 0]],
                ["connectors", [[3, "z", "male"]]]
            ]
        );


        color("blue")
        mb_block(
            config = config,
            settings = [
                ["size", [4, 2, 3]],
                ["offset", [0, 2, 0]],
                ["connectors", [[2, "z", "female"], [3, "z", "male"]]],
                ["studs", false]
            ]
        );
    }
}
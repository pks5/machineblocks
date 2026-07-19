/**
 * MachineBlocks.com Block File
 *
 * Name: FlatPyramid
 * Filename: FlatPyramid.scad
 * FQN: com.machineblocks.scad.examples.FlatPyramid
 */

use <../../../../../lib/block.scad>;
include <../../../../../config/mb_config.scad>;

/*
 * Customization
 */

/* [Size] */

// Size of one brick
brickSize = [4, 2, 1]; // [1:1:64]

// Number of bricks in the bottom row
bottomCount = 7; // [1:1:20]

// Seam overlap in mm
seamOverlap = 0.01; // [0:0.01:0.2]

/* [Style] */

colorA = "#55AB68"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
colorB = "#303D4E"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Hidden] */

size = [
    brickSize[0] * bottomCount,
    brickSize[1],
    brickSize[2] * bottomCount
];

/*
 * Main Module Call
 */
mb__com__machineblocks__scad__examples__FlatPyramid(
    config = mb_config,
    settings = [
        ["size", size],
        ["brickSize", brickSize],
        ["bottomCount", bottomCount],
        ["seamOverlap", seamOverlap],
        ["colorA", colorA],
        ["colorB", colorB]
    ]
);

/*
 * Main Module Definition
 */
module mb__com__machineblocks__scad__examples__FlatPyramid(config = undef, settings = undef){
    blockId = mb_param_id(config, settings, "mm.examples.staple_pyramid");
    size = mb_param_size(config, settings);
    offset = mb_param_offset(config, settings);
    direction = mb_param_direction(config, settings);
    align = mb_param_align(config, settings);

    brickSize = mb_param(config, settings, "brickSize", [4, 2, 1]);
    bottomCount = mb_param(config, settings, "bottomCount", 7);
    seamOverlap = mb_param(config, settings, "seamOverlap", 0.01);

    colorA = mb_param(config, settings, "colorA", "#55AB68");
    colorB = mb_param(config, settings, "colorB", "#303D4E");

    mb_block(
        config = config,
        settings = [
            ["id", blockId],
            ["base", false],
            ["studs", false],
            ["size", size],
            ["offset", offset],
            ["direction", direction],
            ["align", align]
        ]
    ){
        for(row = [0 : bottomCount - 1]){
            rowCount = bottomCount - row;
            rowOffsetX = row * brickSize[0] / 2;

            for(i = [0 : rowCount - 1]){
                mb_block(
                    config = config,
                    settings = [
                        ["id", mb_block_id(blockId, str("row_", row, "_brick_", i))],
                        ["size", brickSize],
                        ["slope", [i == 0 ? 0.5 * brickSize[0] : 0, i == rowCount - 1 ? 0.5 * brickSize[0] : 0, 0, 0]],
                        ["offset", [
                            rowOffsetX + i * brickSize[0],
                            0,
                            row * brickSize[2]
                        ]],
                        ["baseColor", (row + i) % 2 == 0 ? colorA : colorB],
                        ["baseAdjustment", concat(
                            i > 0 ? [["x-", seamOverlap]] : [],
                            i < rowCount - 1 ? [["x+", seamOverlap]] : [],
                            row > 0 ? [["z-", seamOverlap]] : [],
                            row < bottomCount - 1 ? [["z+", seamOverlap]] : []
                        )]
                    ]
                );
            }
        }
    }
}
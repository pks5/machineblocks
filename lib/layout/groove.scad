use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;
use <tongue.scad>;
use <base_wall_gaps.scad>;

function mb_block_part__groove(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        has_groove = mb_block_has_groove(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        slope = mb_block_dim_slope(block_dim),
        slope_pos = mb_slope_filter(slope, 1),
        tongue_offset = mb_block_get_tongue_offset(block_obj, true),
        tongue_height = mb_block_get_tongue_height(block_obj, true),
        bottom = mb_block_dim_this_offset(
                block_dim, 
                overlap = true
            ),
        top = mb_block_dim_opposite_offset(
                block_dim, 
                off = tongue_height,
                face = "z+"
            )
    )
    mb_block_part_model(
        render = has_groove,
        type = "union",
        items = [
            mb_block_part__tongue(block_obj, groove = true),
            mb_block_part_model(
                type = "difference",
                items = [
                    mb_block_part_model(
                        type = "union",
                        items = [
                            for(wall_gap = wall_gaps)
                                mb_block_part__base_wall_gaps(block_obj, "all", bottom, top, wall_gap)
                        ]),
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -slope_pos[f] - tongue_offset,
                            mb_block_dim_this_offset(
                                block_dim, 
                                overlap = true,
                                adjusted = true
                            ),
                            mb_block_dim_this_offset(
                                block_dim, 
                                overlap = true,
                                adjusted = true
                            )
                        ]]
                    )
                ]
            )
        ]
    );

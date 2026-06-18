use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;
use <base_wall_gaps.scad>;

/**
* -----------
* Base Cutout
* -----------
*/
function mb_block_part__base_cutout(block_obj, planes = "all", bottom = undef, top = undef, inner_adj = undef, top_offset = 0) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        slope_base_height_inner = mb_block_get_slope_base_height_inner(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        slope = mb_block_dim_slope(block_dim),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        

        bottom = is_undef(bottom) 
            ? mb_block_dim_this_offset(
                block_dim, 
                overlap = true
            ) 
            : bottom,
        top = is_undef(top) 
            ? mb_block_base_cutout_ceiling_offset(
                block_obj, 
                face = "z+"
            ) 
            : top,
        inner_adj = is_undef(inner_adj) ? 0 : inner_adj
    )

    [
        "list",
        [
            mb_block_part_prismoid(
                block_dim = block_dim, 
                expand = [
                    _mb_layout_plane_value(
                        planes = planes, 
                        plane = "bottom",
                        value = [
                            for(f = [0 : 3])
                                slope_neg[f] - wall_thickness + inner_adj,
                            bottom,
                            top
                        ]
                    ),
                    _mb_layout_plane_value(
                        planes = planes, 
                        plane = "top",
                        value = [
                            for(f = [0 : 3])
                                slope_neg[f] 
                                -wall_thickness - max(mb_block_slope_partial(block_obj, top_offset, f), 0)
                                + inner_adj,
                            bottom,
                            top
                        ]
                    )
                ],
                radius = mb_block_get_base_rounding_radius(block_obj),
                socket = _mb_layout_plane_value(
                    planes = planes, 
                    value = [slope_base_height_inner + mb_block_dim_overlap(block_dim, overlap = true), 0]
                )
            ),
            for(wall_gap = wall_gaps)
                mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, wall_gap, inner_adj, top_offset)
        ]
    ];











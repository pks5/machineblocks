use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

/**
* ----
* Tube
* ----
*/
function mb_block_part__tubes(block_obj, axis = "z") = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        tube_range = mb_block_tube_range(block_obj, axis),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj),
        base_clamp_height = mb_block_get_base_clamp_height(block_obj),
        base_clamp_offset = mb_block_get_base_clamp_offset(block_obj),
        top_plate_helpers_thickness = mb_block_get_top_plate_helpers_thickness(block_obj),
        top_plate_helpers_height = mb_block_get_top_plate_helpers_height(block_obj),
        base_cutout_ceiling_offset_with_cut = mb_block_base_cutout_ceiling_offset(block_obj, face = "z+", cut = true)
    )
    [
        "list",
        [
            for(x = tube_range[0])
                for(y = tube_range[1])
                    if(mb_block_tube_render(block_obj, axis, x, y))
                        let(
                            tube_clamp_end = [
                                top_plate_helpers_thickness, 
                                top_plate_helpers_height, 
                                mb_block_dim_overlap(block_dim, overlap = true)
                            ],
                            tube_clamp_start = [
                                base_clamp_thickness,
                                base_clamp_height,
                                base_clamp_offset
                            ]
                        )
                        mb_block_part_tube(
                            block_dim = block_dim,
                            radius = mb_block_tube_radius(block_obj, axis, x, y),
                            clamp_end = tube_clamp_end, 
                            clamp_start = tube_clamp_start, 
                            axis = axis,
                            expand = [
                                0,
                                base_cutout_ceiling_offset_with_cut
                            ],
                            offset = mb_block_tube_offset(block_obj, axis, x, y)
                        )
        ]
    ];
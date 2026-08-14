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
function mb_block_part__zholes(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj)
    )
    mb_block_part_model(
        type = "list",
        name = "zholes",
        items = [
            
                let(
                    axis = mb_axis_to_int("z"),
                    tube_range = mb_block_tube_z_range(block_obj),
                    top_plate_height = mb_block_get_top_plate_height(block_obj)
                )
                if(mb_block_has_holes(block_obj, axis) != false)
                    for(x = tube_range[0])
                        for(y = tube_range[1])
                            if(mb_block_tube_z_render(block_obj, x, y))
                                let(
                                    clamp = mb_block_tube_z_hole_inset(block_obj, x, y),
                                    tube_clamp_end = [
                                        clamp[0], 
                                        clamp[1] + mb_block_dim_overlap(block_dim, overlap = true)
                                    ]
                                )
                                mb_block_part_tube(
                                    block_dim = block_dim,
                                    radius = mb_block_tube_z_radius(block_obj, x, y, hole = true),
                                    clamp_outer_end = tube_clamp_end,
                                    axis = axis,
                                    expand = [
                                        mb_block_dim_face_edge_expand(
                                            block_dim, 
                                            overlap = true,
                                            opposite = true,
                                            exp = top_plate_height,
                                            face = "z-"
                                        ),
                                        mb_block_dim_face_edge_expand(
                                            block_dim, 
                                            adjusted = true,
                                            overlap = true,
                                            face = "z+"
                                        ),
                                    ],
                                    offset = mb_block_tube_z_offset(block_obj, x, y)
                                )
        ]
    );
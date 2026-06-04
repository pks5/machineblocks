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
function mb_block_part__tubes(block_obj, hole = false) = 
    let(
        block_dim = mb_block_get_dim(block_obj)
    )
    [
        "list",
        [
            for(axis = ["x", "y"])
                let(
                    tube_range = mb_block_tube_range(block_obj, axis),
                    axis_faces = mb_axis_faces(axis)
                )
                for(xy = tube_range[0])
                    for(z = tube_range[1])
                        if(mb_block_tube_render(block_obj, axis, xy, z))
                            let(
                                clamp = mb_block_tube_hole_inset(block_obj, axis, xy, z),
                                tube_clamp_start = [
                                    clamp[0], 
                                    clamp[1] + mb_block_dim_overlap(block_dim, overlap = true)
                                ],
                                tube_clamp_end = tube_clamp_start,
                            )
                            mb_block_part_tube(
                                block_dim = block_dim,
                                radius = mb_block_tube_radius(block_obj, axis, xy, z, hole = hole),
                                clamp_end = tube_clamp_end, 
                                clamp_start = tube_clamp_start, 
                                axis = axis,
                                expand = [
                                    mb_block_dim_face_edge_expand(
                                        block_dim, 
                                        adjusted = true,
                                        overlap = true,
                                        face = axis_faces[0]
                                    ),
                                    mb_block_dim_face_edge_expand(
                                        block_dim, 
                                        adjusted = true,
                                        overlap = true,
                                        face = axis_faces[1]
                                    ),
                                ],
                                offset = mb_block_tube_offset(block_obj, axis, xy, z)
                            )
        ]
    ];
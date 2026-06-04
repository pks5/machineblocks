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
                let(tube_range = mb_block_tube_range(block_obj, axis))
                for(xy = tube_range[0])
                    for(z = tube_range[1])
                        if(mb_block_tube_render(block_obj, axis, xy, z))
                            let(
                                tube_clamp_end = undef,
                                tube_clamp_start = undef
                            )
                            mb_block_part_tube(
                                block_dim = block_dim,
                                radius = mb_block_tube_radius(block_obj, axis, xy, z, hole = hole),
                                clamp_end = tube_clamp_end, 
                                clamp_start = tube_clamp_start, 
                                axis = axis,
                                expand = [
                                    0,
                                    0
                                ],
                                offset = mb_block_tube_offset(block_obj, axis, xy, z)
                            )
        ]
    ];
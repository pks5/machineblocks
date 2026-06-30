use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

/**
* -----------
* Stabilizers
* -----------
*/
function mb_block_part__stabilizers(block_obj) =
    !mb_block_has_stabilizers(block_obj) ? undef :
    let(
        block_dim = mb_block_get_dim(block_obj),
        top = mb_block_base_cutout_ceiling_offset(
            block_obj, 
            face = "z+",
            cut = true
        )
    )
    mb_block_part_model(
        type = "list",
        name = "stabilizers",
        items = [
            for(axis = ["x", "y"])
                let(range = mb_block_stabilizer_range(block_obj, axis))
                for(x = range[0])
                mb_block_part_model(
                    type = "list",
                    items = [
                        for(y = range[1])
                            let(
                                seg_offset = mb_block_stabilizer_segment_offset(block_obj, axis, x, y),
                                seg_size = mb_block_stabilizer_segment_size(block_obj, axis, x, y),
                                seg_expand = mb_block_stabilizer_segment_expand(block_obj, axis, x, y)
                            )
                            if(mb_block_stabilizer_segment_render(block_obj, axis, x, y))
                            mb_block_part_model(
                                type = "list",
                                items = [
                                    mb_block_part_cube(
                                        block_dim = block_dim,
                                        size = [
                                            seg_size[0][0], 
                                            seg_size[0][1], 
                                            seg_size[0][2] + mb_block_dim_overlap(block_dim, overlap = true)
                                        ],
                                        expand = [
                                            for(f = [0 : 3])
                                                seg_expand[f],
                                            "auto", 
                                            top
                                        ],
                                        offset = seg_offset
                                    ),
                                    if(len(seg_size) > 1)
                                        mb_block_part_cube(
                                            block_dim = block_dim,
                                            size = [
                                                seg_size[0][0] + seg_size[1][0], 
                                                seg_size[0][1] + seg_size[1][1], 
                                                                 seg_size[1][2] + mb_block_dim_overlap(block_dim, overlap = true)
                                            ],
                                            expand = [
                                                for(f = [0 : 3])
                                                    seg_expand[f],
                                                "auto", 
                                                top
                                            ],
                                            offset = seg_offset
                                        )
                                ]
                            )
                    ]
                )

            
        ]
    );
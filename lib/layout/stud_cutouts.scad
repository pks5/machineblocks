use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

/**
* -----
* Stud Cutouts
* ----.
*/
function mb_block_part__stud_cutouts(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        stud_cutout_diameter = mb_block_get_stud_cutout_diameter(block_obj),
        stud_cutout_height = mb_block_get_stud_cutout_height(block_obj),

        stud_range = mb_block_stud_cutouts_range(block_obj),
    )
    [
        "list",
        [
            for(x = stud_range[0])
                for(y = stud_range[1])
                    mb_block_part_tube(
                        block_dim = block_dim,
                        radius = 0.5 * stud_cutout_diameter,
                        axis = "z",
                        expand = [
                             mb_block_dim_this_offset(
                                block_dim, 
                                cut = true
                            ),
                            mb_block_dim_opposite_offset(
                                block_dim, 
                                off = stud_cutout_height, 
                                cut = true
                            )
                        ],
                        offset = mb_block_stud_offset(block_obj, x, y)
                    )
        ]
    ];
use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

/**
* ------------
* Stud Cutouts
* ------------
*/
function mb_block_part__stud_cutouts(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        stud_cutout_diameter = mb_block_get_stud_cutout_diameter(block_obj),
        
        stud_cutout_height = mb_block_get_stud_cutout_height(block_obj),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj),
        base_clamp_height = mb_block_get_base_clamp_height(block_obj),
        base_clamp_offset = mb_block_get_base_clamp_offset(block_obj),
        stud_range = mb_block_stud_cutouts_range(block_obj)
        
    )
    [
        "list",
        [
            for(x = stud_range[0])
                for(y = stud_range[1])
                    if(mb_block_stud_cutout_render(block_obj, x, y))
                        mb_block_part_tube(
                            block_dim = block_dim,
                            radius = 0.5 * stud_cutout_diameter,
                            axis = "z",
                            clamp_start = [
                                -base_clamp_thickness,
                                base_clamp_height,
                                base_clamp_offset + mb_block_dim_overlap(block_dim, overlap=true)
                            ],
                            expand = [
                                mb_block_dim_this_offset(
                                    block_dim, 
                                    overlap = true
                                ),
                                mb_block_dim_opposite_offset(
                                    block_dim, 
                                    off = stud_cutout_height
                                )
                            ],
                            offset = mb_block_stud_cutout_offset(block_obj, x, y)
                        )
        ]
    ];
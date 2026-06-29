use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;
use <base_cutout.scad>;

/**
* -----------------
* Base Cutout Clamp
* -----------------
*/
function mb_block_part__base_cutout_clamp(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj),
        base_clamp_height = mb_block_get_base_clamp_height(block_obj),
        base_clamp_offset = mb_block_get_base_clamp_offset(block_obj),

        bottom = mb_block_dim_this_offset(
            block_dim, 
            off = base_clamp_offset
        ),
        top = mb_block_dim_opposite_offset(
            block_dim, 
            off = base_clamp_height + base_clamp_offset
        )
    )
    mb_block_part_model(
        type = "difference",
        name = "base_cutout_clamp",
        items = [
            _mb_layout_mask_frame(
                block_dim = block_dim, 
                bottom = bottom, 
                top = top, 
                outer_adj = base_clamp_thickness
            ),
            mb_block_part__base_cutout(
                block_obj, 
                planes = "bottom", 
                bottom = mb_block_dim_this_offset(
                    block_dim, 
                    off = base_clamp_offset, 
                    overlap = true
                ), 
                top = mb_block_dim_opposite_offset(
                    block_dim, 
                    off = base_clamp_height + base_clamp_offset, 
                    overlap = true
                ), 
                inner_adj = -base_clamp_thickness
            )
        ]
    );
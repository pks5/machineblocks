use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;
use <base_cutout.scad>;

/**
* -----------------
* Top Plate Helpers
* -----------------
*/
function mb_block_part__top_plate_helpers(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        top_plate_helpers_thickness = mb_block_get_top_plate_helpers_thickness(block_obj),
        top_plate_helpers_height = mb_block_get_top_plate_helpers_height(block_obj)
    ) 
    mb_block_has_top_plate_helpers(block_obj) 
        ? mb_block_part_model(
            type = "difference",
            items = [
                _mb_layout_mask_frame(
                    block_dim = block_dim, 
                    bottom = mb_block_base_cutout_ceiling_offset(
                        block_obj, 
                        face = "z-", 
                        off = top_plate_helpers_height
                    ), 
                    top = mb_block_base_cutout_ceiling_offset(
                        block_obj, 
                        face = "z+", 
                        cut = true
                    )
                ),
                mb_block_part__base_cutout(
                    block_obj, 
                    planes = "top", 
                    bottom = mb_block_base_cutout_ceiling_offset(
                        block_obj, 
                        face = "z-", 
                        off = top_plate_helpers_height, 
                        cut = true
                    ), 
                    top = mb_block_base_cutout_ceiling_offset(
                        block_obj, 
                        face = "z+", 
                        cut = 2
                    ), 
                    inner_adj = -top_plate_helpers_thickness,
                    top_offset = 0, //top_plate_helpers_height
                )
            ]
        )
        : undef;
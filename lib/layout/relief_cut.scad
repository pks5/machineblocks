use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

/**
* ----------
* Relief Cut
* ----------
*/
function mb_block_part__relief_cut(block_obj) =
    
    !mb_block_has_relief_cut(block_obj) ? undef :
    
    let(
        block_dim = mb_block_get_dim(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        slope = mb_block_dim_slope(block_dim),
        slope_neg = mb_slope_filter(slope, -1),
        relief_cut_thickness = mb_block_get_relief_cut_thickness(block_obj),
        relief_cut_height = mb_block_get_relief_cut_height(block_obj),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj)
    ) 
    mb_block_part_model(
        type = "difference",
        items = [
            _mb_layout_mask_frame(
                block_dim = block_dim, 
                bottom = mb_block_dim_this_offset(
                    block_dim, 
                    overlap = 1
                ), 
                top =  mb_block_dim_opposite_offset(
                    block_dim, 
                    off = relief_cut_height
                ), 
                outer_adj = base_clamp_thickness
            ),
            mb_block_part_prismoid(
                block_dim = block_dim, 
                expand = [[
                    for(f = [0 : 3])
                        mb_block_dim_face_edge_expand(
                            block_dim, 
                            exp = -relief_cut_thickness + slope_neg[f], 
                            adjusted = true, 
                            face = f
                        ),
                    mb_block_dim_this_offset(
                        block_dim, 
                        overlap = 2
                    ),
                    mb_block_dim_opposite_offset(
                        block_dim, 
                        off = relief_cut_height, 
                        overlap = true
                    )
                ]]
            )
        ]
    );
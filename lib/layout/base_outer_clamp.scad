use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

/**
* ----------------
* Base Clamp Outer
* ----------------
*/
function mb_block_part__base_clamp_outer(block_obj) = 
    !mb_block_get_inverted(block_obj) ? undef :
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
    
        mb_block_part_prismoid(
            name = "base_outer_clamp",
            block_dim = block_dim, 
            expand = [[
                for(f = [0 : 3])
                    mb_block_dim_face_edge_expand(
                        block_dim, 
                        exp = base_clamp_thickness, 
                        adjusted = true, 
                        face = f
                    ),
                bottom,
                top
            ]]
        );
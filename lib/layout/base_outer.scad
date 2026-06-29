use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

/**
* ----------
* Base Outer
* ----------
*/
function mb_block_part__base_outer(block_obj, adjusted = true) =
    let(
        block_dim = mb_block_get_dim(block_obj)
    )
    mb_block_part_prismoid(
        name = "base_outer",
        block_dim = block_dim, 
        expand = adjusted ? [mb_block_get_base_adj(block_obj)] : undef,
        socket = mb_block_get_slope_socket(block_obj),
        slope = mb_block_dim_slope(block_dim),
        radius = mb_block_get_base_rounding_radius(block_obj)
    ); 


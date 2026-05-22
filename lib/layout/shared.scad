use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

/**
* -------
* HELPERS
* -------
*/

function _mb_layout_mask_frame(block_dim, bottom, top, outer_adj = 0) = 
    mb_block_part_cube(
        block_dim = block_dim, 
        expand = [
            for(f = [0 : 3])
                mb_block_dim_face_edge_expand(
                    block_dim, 
                    exp = outer_adj, 
                    adjusted = true, 
                    face = f
                ),
            bottom,
            top
        ]
    );

function _mb_layout_plane_value(planes, value, plane = "all", all = true, else_value = undef) = 
    planes == plane || (all && planes == "all") ? value : else_value;



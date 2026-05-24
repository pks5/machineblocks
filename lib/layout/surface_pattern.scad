use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

function mb_block_part__surface_pattern(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        surface_pattern = mb_block_get_surface_pattern(block_obj),
        surface_pattern_dimensions = mb_block_get_surface_pattern_dimensions(block_obj),
        surface_pattern_size = mb_block_get_surface_pattern_size(block_obj),
        surface_pattern_offset = mb_block_get_surface_pattern_offset(block_obj),
        surface_pattern_padding = mb_block_get_surface_pattern_padding(block_obj),
        surface_pattern_color = mb_block_get_surface_pattern_color(block_obj),
        height = abs(surface_pattern_size[2]),
        has_surface_pattern = !mb_is_empty_string(surface_pattern) && surface_pattern != "none" && height != 0,
        extruded = surface_pattern_size[2] > 0,
        overlap = mb_block_dim_overlap(block_dim, overlap = true),
        si = [
            surface_pattern_size[0],
            surface_pattern_size[1],
            undef
        ]
    )   
    mb_block_part_svg(
        block_dim,
        surface_pattern,
        surface_pattern_dimensions,
        size = si,
        expand = [
            0,
            0,
            0,
            0,
            mb_block_dim_opposite_offset(
                block_dim, 
                overlap = true, 
                adjusted = true, 
                face = "z-"
            ),
            mb_block_dim_face_edge_expand(
                block_dim, 
                exp = height, 
                adjusted = true, 
                face = "z+"
            )
        ],
        offset = surface_pattern_offset,
        render = has_surface_pattern
    ); 
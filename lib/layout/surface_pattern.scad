use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

function mb_block_part__surface_pattern(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        surface_pattern = mb_block_get_surface_pattern(block_obj),
        surface_pattern_depth = mb_block_get_surface_pattern_depth(block_obj),
        height = abs(surface_pattern_depth),
    )
    mb_is_empty_string(surface_pattern) || surface_pattern == "none" || height == 0 ? undef :
    let(
        mod_size = mb_block_dim_mod_size(block_dim),
        surface_pattern_dimensions = mb_block_get_surface_pattern_dimensions(block_obj),
        surface_pattern_size = mb_block_get_surface_pattern_size(block_obj),
        surface_pattern_offset = mb_resolve_xyz(mb_block_get_surface_pattern_offset(block_obj), default = [0, 0, 0]),
        surface_pattern_padding = mb_block_get_surface_pattern_padding(block_obj),
        surface_pattern_color = mb_block_get_surface_pattern_color(block_obj),
        surface_pattern_scale = mb_block_get_surface_pattern_scale(block_obj),
        
        extruded = surface_pattern_depth > 0,
        side_length = surface_pattern_scale * max(mod_size[0] - surface_pattern_padding[0] - surface_pattern_padding[1], mod_size[1] - surface_pattern_padding[2] - surface_pattern_padding[3]),
        overlap = mb_block_dim_overlap(block_dim, overlap = true),
        rel = surface_pattern_dimensions[1] / surface_pattern_dimensions[0],
        si = [
            side_length,
            side_length,
            undef
        ],
        surface_pattern_offset_res = [
            surface_pattern_offset[0] - 0.5 * (surface_pattern_padding[1] - surface_pattern_padding[0]),
            surface_pattern_offset[1] - 0.5 * (surface_pattern_padding[3] - surface_pattern_padding[2]),
            0
        ]
    )   
    mb_block_part_svg(
        block_dim,
        surface_pattern,
        surface_pattern_dimensions,
        "z+",
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
        offset = surface_pattern_offset
    ); 
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

function mb_block_part__svg_decorator(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        mod_size = mb_block_dim_mod_size(block_dim),
        svg_decorator = mb_block_get_svg(block_obj),
        svg_dimensions = mb_block_get_svg_dimensions(block_obj),
        svg_offset = mb_resolve_xyz(mb_block_get_svg_offset(block_obj), default = [0, 0, 0]),
        svg_color = mb_block_get_svg_color(block_obj),
        svg_scale = mb_block_get_svg_scale(block_obj),
        svg_depth = mb_block_get_svg_depth(block_obj),

        height = abs(svg_depth),
        has_svg_decorator = !mb_is_empty_string(svg_decorator) && svg_decorator != "none" && height != 0,
        extruded = svg_depth > 0,
        side_length = svg_scale * max(mod_size[0], mod_size[1] - surface_pattern_padding[2] - surface_pattern_padding[3]),
        overlap = mb_block_dim_overlap(block_dim, overlap = true),
        rel = svg_dimensions[1] / svg_dimensions[0],
        si = [
            side_length,
            side_length,
            undef
        ]
    )   
    mb_block_part_svg(
        block_dim,
        svg_decorator,
        svg_dimensions,
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
        offset = svg_offset,
        render = has_svg_decorator
    ); 
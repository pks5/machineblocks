use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

function mb_block_part__svg_decorator(block_obj, subtract = false) = 
    let(svg_depth = mb_block_get_svg_depth(block_obj),
        svg_decorator = mb_block_get_svg(block_obj))
    
    svg_decorator == false
        || mb_is_empty_string(svg_decorator) 
        || svg_decorator == "none"
        || svg_depth[0] == 0
        || (!subtract && svg_depth[0] < 0) 
        || (subtract && svg_depth[0] > 0) ? undef :

    let(
        block_dim = mb_block_get_dim(block_obj),
        mod_size = mb_block_dim_mod_size(block_dim),
        
        svg_dimensions = mb_block_get_svg_dimensions(block_obj),
        svg_offset = mb_resolve_xyz(mb_block_get_svg_offset(block_obj), default = [0, 0, 0]),
        svg_color = mb_block_get_svg_color(block_obj),
        svg_scale = mb_block_get_svg_scale(block_obj),
        
        svg_face = mb_face_to_int(mb_block_get_svg_face(block_obj)),
        axis = mb_face_to_axis(svg_face),
        min_size = mb_face_has_common(svg_face, "x") ? min(mod_size[1], mb_block_grd_z2xy(block_obj, mod_size[2])) 
            : mb_face_has_common(svg_face, "y") ? min(mod_size[0], mb_block_grd_z2xy(block_obj, mod_size[2])) 
            : min(mod_size[0], mod_size[1]),
        side_length = svg_scale * min_size,
        si = axis == 0 ?
        [
            undef,
            side_length,
            mb_block_grd_xy2z(block_obj, side_length)
        ] :
        axis == 1 ?
        [
            side_length,
            undef,
            mb_block_grd_xy2z(block_obj, side_length)
            
        ] :
        [
            side_length,
            side_length,
            undef
        ],

        off = axis == 0 ?
        [
            0,
            svg_offset[0],
            svg_offset[1]
        ] :
        axis == 1 ?
        [
            svg_offset[0],
            undef,
            svg_offset[1]
            
        ] :
        [
            svg_offset[0],
            svg_offset[1],
            undef
        ],

        expand = mb_face_has_common(svg_face, "x-") 
        ? [
            mb_block_dim_face_edge_expand(
                block_dim, 
                exp = !subtract ? abs(svg_depth[0]) : 0, 
                adjusted = true, 
                face = "x-"
            ),
            mb_block_dim_face_edge_expand(
                block_dim, 
                overlap = true, 
                adjusted = true, 
                exp = subtract ? abs(svg_depth[0]) : 0, 
                opposite = true,
                face = "x+"
            ),
            0,
            0,
            0,
            0
        ] 
        : mb_face_has_common(svg_face, "x+") 
        ? [
            mb_block_dim_face_edge_expand(
                block_dim, 
                overlap = true, 
                adjusted = true, 
                exp = subtract ? abs(svg_depth[0]) : 0, 
                opposite = true,
                face = "x-"
            ),
            mb_block_dim_face_edge_expand(
                block_dim, 
                exp = !subtract ? abs(svg_depth[0]) : 0,
                adjusted = true, 
                face = "x+"
            ),
            0,
            0,
            0,
            0
        ] 
        : mb_face_has_common(svg_face, "y-") 
        ? [
            0,
            0,
            mb_block_dim_face_edge_expand(
                block_dim, 
                exp = !subtract ? abs(svg_depth[1]) : 0,
                adjusted = true, 
                face = "y-"
            ),
            mb_block_dim_face_edge_expand(
                block_dim, 
                overlap = true, 
                adjusted = true, 
                exp = subtract ? abs(svg_depth[1]) : 0,
                opposite = true,
                face = "y+"
            ),
            
            0,
            0
        ] 
        : mb_face_has_common(svg_face, "y+") 
        ? [
            0,
            0,
            mb_block_dim_face_edge_expand(
                block_dim, 
                overlap = true, 
                adjusted = true, 
                exp = subtract ? abs(svg_depth[1]) : 0,
                opposite = true,
                face = "y-"
            ),
            mb_block_dim_face_edge_expand(
                block_dim, 
                exp = !subtract ? abs(svg_depth[1]) : 0,
                adjusted = true, 
                face = "y+"
            ),
            0,
            0
        ] 
        : mb_face_has_common(svg_face, "z-") 
        ? [
            0,
            0,
            0,
            0,
            mb_block_dim_face_edge_expand(
                block_dim, 
                exp = !subtract ? abs(svg_depth[2]) : 0, 
                adjusted = true, 
                face = "z-"
            ),
            mb_block_dim_face_edge_expand(
                block_dim, 
                overlap = true, 
                adjusted = true, 
                exp = subtract ? abs(svg_depth[2]) : 0, 
                opposite = true,
                face = "z+"
            )
        ] 
        : [
            0,
            0,
            0,
            0,
            mb_block_dim_face_edge_expand(
                block_dim, 
                overlap = true, 
                adjusted = true, 
                exp = subtract ? abs(svg_depth[2]) : 0, 
                opposite = true,
                face = "z-"
            ),
            mb_block_dim_face_edge_expand(
                block_dim, 
                exp = !subtract ? abs(svg_depth[2]) : 0, 
                adjusted = true, 
                face = "z+"
            )
        ] 
    )   
    mb_block_part_svg(
        block_dim,
        svg_decorator,
        svg_dimensions,
        svg_face,
        size = si,
        expand = expand,
        offset = off
    ); 
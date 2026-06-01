use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

function mb_block_part__text_decorator(block_obj, extrude = false) = 
    let(text_depth = mb_block_get_text_depth(block_obj),
        text_decorator = mb_block_get_text(block_obj))
    
    text_decorator == false
        || mb_is_empty_string(text_decorator) 
        || text_depth[0] == 0
        || (extrude && text_depth[0] < 0) 
        || (!extrude && text_depth[0] > 0) ? undef :

    let(
        block_dim = mb_block_get_dim(block_obj),
        text_face = mb_face_to_int(mb_block_get_text_face(block_obj)),
        axis = mb_face_to_axis(text_face),
        text_font = mb_block_get_text_font(block_obj),
        text_size = mb_block_get_text_size(block_obj),
        text_spacing = mb_block_get_text_spacing(block_obj),
        text_align = mb_block_get_text_align(block_obj),
        text_offset = mb_block_get_text_offset(block_obj),
        text_color = mb_block_get_text_color(block_obj)
    )
    mb_block_part_text(
        block_dim,
        text,
        text_size,
        height,
        text_font,
        text_spacing,
        text_align,
        face = text_face,
        expand = [
            0,
            0
        ],
        offset = undef,
        render = true
    );
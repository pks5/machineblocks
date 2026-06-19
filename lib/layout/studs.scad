use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;


/**
* -----
* Studs
* ----.
*/

function mb_block_part__stud_icon(block_obj, off, top) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        stud_diameter = mb_block_get_stud_diameter(block_obj, adjusted = false),
        stud_icon = mb_block_get_stud_icon(block_obj),
        stud_icon_dimensions = mb_block_get_stud_icon_dimensions(block_obj),
        
        stud_icon_scale = mb_block_get_stud_icon_scale(block_obj),
        stud_icon_depth = mb_block_get_stud_icon_depth(block_obj),
        height = abs(stud_icon_depth),
        has_stud_icon = !mb_is_empty_string(stud_icon) && stud_icon != "none" && height != 0,
        extruded = stud_icon_depth > 0,
        stud_icon_size = stud_diameter * stud_icon_scale,

        overlap = mb_block_dim_overlap(block_dim, overlap = true),
        si = [
            stud_icon_size,
            stud_icon_size,
            undef
        ]
    )
    mb_block_part_svg(
        block_dim,
        stud_icon,
        stud_icon_dimensions,
        "z+",
        size = si,
        expand = [
            0,
            0,
            0,
            0,
            mb_block_dim_opposite_offset(
                    block_dim,
                    off = -top + (extruded ? overlap : height)
            ),
            top + (extruded ? height : overlap)
        ],
        offset = off,
        render = has_stud_icon
    );

function mb_block_part__studs(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        stud_range = mb_block_stud_range(block_obj),
        stud_rounding = mb_block_get_stud_rounding(block_obj),
        stud_icon_depth = mb_block_get_stud_icon_depth(block_obj),
        stud_clamp_thickness = mb_block_get_stud_clamp_thickness(block_obj),
        stud_clamp_height = mb_block_get_stud_clamp_height(block_obj),
        stud_clamp_offset = mb_block_get_stud_clamp_offset(block_obj),
        stud_height = mb_block_get_stud_height(block_obj),
        stud_base_overlap = mb_block_get_stud_base_overlap(block_obj),
        clamp_offset = stud_height - stud_clamp_height - stud_clamp_offset
        
    )
    mb_block_part_model(
        render = mb_block_has_studs(block_obj),
        type = "list",
        items = [
            for(x = stud_range[0])
                for(y = stud_range[1])
                    let(
                        render = mb_block_stud_render(block_obj, x, y),
                        in_recess = render[2],
                        exp = [
                            in_recess 
                            ? mb_block_recess_floor_offset(
                                block_obj,
                                off = stud_base_overlap,
                                face = "z-"
                            )
                            : mb_block_dim_opposite_offset(
                                block_dim, 
                                off = stud_base_overlap, 
                                adjusted = true, 
                                face = "z-"
                            ),
                            in_recess ? 
                            mb_block_recess_floor_offset(
                                block_obj,
                                off = stud_height,
                                face = "z+"
                            )
                            : mb_block_dim_face_edge_expand(
                                block_dim, 
                                exp = stud_height, 
                                adjusted = true, 
                                face = "z+"
                            )
                        ]
                    )
                    if(render[0])
                        mb_block_part_model(
                            type = stud_icon_depth > 0 ? "union" : "difference", 
                            items = [
                                mb_block_part_tube(
                                    block_dim = block_dim,
                                    radius = render[3],
                                    rounding_radius = stud_rounding,
                                    axis = "z",
                                    expand = exp,
                                    offset = render[1],
                                    clamp_end = stud_clamp_thickness > 0 && stud_clamp_height > 0 ? [
                                        stud_clamp_thickness,
                                        stud_clamp_height,
                                        clamp_offset
                                    ] : undef
                                ),
                                mb_block_part__stud_icon(block_obj, render[1], exp[1]) 
                            ]
                        )
        ]
     );
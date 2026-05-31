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

function mb_block_part__stud_icon(block_obj, stud_render) =
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
                    off = -stud_render[2][1] + (extruded ? overlap : height)
            ),
            stud_render[2][1] + (extruded ? height : overlap)
        ],
        offset = stud_render[1],
        render = has_stud_icon
    );

function mb_block_part__studs(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        stud_range = mb_block_stud_range(block_obj),
        stud_rounding = mb_block_get_stud_rounding(block_obj),
        stud_icon_size = mb_block_get_stud_icon_size(block_obj)
    )
    mb_block_part_model(
        render = mb_block_has_studs(block_obj),
        type = "list",
        items = [
            for(x = stud_range[0])
                for(y = stud_range[1])
                    let(render = mb_block_stud_render(block_obj, x, y))
                    if(render[0])
                        mb_block_part_model(
                            type = stud_icon_size[2] > 0 ? "union" : "difference", 
                            items = [
                                mb_block_part_tube(
                                    block_dim = block_dim,
                                    radius = mb_block_stud_radius(block_obj, x, y),
                                    rounding_radius = stud_rounding,
                                    axis = "z",
                                    expand = render[2],
                                    offset = render[1]
                                ),
                                mb_block_part__stud_icon(block_obj, render) 
                            ]
                        )
        ]
     );
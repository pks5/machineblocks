use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

/**
* ------
* Recess
* ------
*/
function mb_block_part__recess(block_obj) = 
    !mb_block_has_recess(block_obj) ? undef :
    let(
        block_dim = mb_block_get_dim(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        slope = mb_block_dim_slope(block_dim),
        rwt = mb_block_get_recess_wall_thickness(block_obj),
        rwgs = mb_block_get_recess_wall_gaps(block_obj),

        rad_expand = mb_block_get_recess_rounding_radius(block_obj) == "auto",
        
        bottom = mb_block_recess_floor_offset(block_obj, "z-"),
        exp_top = mb_block_dim_face_edge_expand(
            block_dim, 
            adjusted = true, 
            face = "z+", 
            overlap = true
        )
    )
    mb_block_part_model(
        type = "list",
        name = "recess",
        items = [
            mb_block_part_model(
                type = "intersection",
                items = [
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -rwt[f],
                            0,
                            exp_top,
                        ]],
                        radius = mb_block_recess_rounding_radius(block_obj),
                        rad_expand = rad_expand,
                        slope = slope,
                        socket = socket
                    ),

                    mb_block_part_cube(
                        block_dim = block_dim, 
                        expand = [
                            0,
                            0,
                            0,
                            0,
                            bottom,
                            exp_top
                        ]
                    )
                ]
            ), 
            
            for(rwg = rwgs)
                let(gap_data = mb_block_recess_wall_gap(block_obj, rwg))
                for(gap = gap_data)
                    let(
                        face = gap[0],
                        gap_start_offset = gap[3],
                        gap_end_offset = gap[4]
                    )
                    mb_block_part_model(
                        type = "intersection",
                        items = [
                            mb_block_part_prismoid(
                                block_dim = block_dim, 
                                expand = [[
                                    for(f = [0 : 3])
                                        mb_face_has_common(face, f) 
                                            ? mb_block_dim_face_edge_expand(
                                                block_dim, 
                                                adjusted = true, 
                                                face = f,
                                                overlap = true
                                            ) 
                                            : -rwt[f],
                                    0,
                                    exp_top
                                ]],
                                radius = mb_block_recess_rounding_radius(block_obj, omit_face = face),
                                rad_expand = rad_expand,
                                slope = slope,
                                socket = socket
                            ),

                            mb_block_part_cube(
                                block_dim = block_dim, 
                                expand = [
                                    mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                                    mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                                    mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                                    mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                                    bottom,
                                    exp_top
                                ]
                            )
                        ]
                    )
        ]
    );
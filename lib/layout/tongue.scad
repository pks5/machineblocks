use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

/**
* -----
* Tongue
* ----.
*/
function mb_block_part__tongue(block_obj, groove = false) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        slope = mb_block_dim_slope(block_dim),
        slope_pos = mb_slope_filter(slope, 1),
        has_tongue = groove ? mb_block_has_groove(block_obj) : mb_block_has_tongue(block_obj),
        tongue_offset = mb_block_get_tongue_offset(block_obj, groove),
        tongue_height = mb_block_get_tongue_height(block_obj, groove),
        tongue_thickness = mb_block_get_tongue_thickness(block_obj, groove),
        tongue_clamp_offset = mb_block_get_tongue_clamp_offset(block_obj, groove),
        tongue_clamp_height = mb_block_get_tongue_clamp_height(block_obj, groove),
        tongue_clamp_thickness = mb_block_get_tongue_clamp_thickness(block_obj, groove),
        recess_wall_gaps = mb_block_get_recess_wall_gaps(block_obj),
        base_wall_gaps = mb_block_get_base_wall_gaps(block_obj),

        stud_sink = mb_block_get_stud_sink(block_obj),
        // Bottom
        tongue_bottom = groove
        ? mb_block_dim_this_offset(
            block_dim, 
            face = "z-",
            overlap = 1
        )
        : mb_block_dim_opposite_offset(
            block_dim, 
            off = stud_sink, 
            adjusted = true, 
            face = "z-"
        ),
        // Bottom Cut
        tongue_bottom_cut = groove
        ? mb_block_dim_this_offset(
            block_dim, 
            face = "z-",
            overlap = 2
        )
        : mb_block_dim_opposite_offset(
            block_dim, 
            off = stud_sink, 
            adjusted = true, 
            face = "z-",
            overlap = true
        ),
        // Top
        tongue_top = groove
        ? mb_block_dim_opposite_offset(
            block_dim, 
            off = tongue_height,
            face = "z+"
        )
        : mb_block_dim_face_edge_expand(
            block_dim, 
            exp = tongue_height, 
            adjusted = true, 
            face = "z+"
        ),
        // Top Cut
        tongue_top_cut = groove
        ? mb_block_dim_opposite_offset(
            block_dim, 
            off = tongue_height,
            face = "z+",
            overlap = true
        )
        : mb_block_dim_face_edge_expand(
            block_dim, 
            exp = tongue_height, 
            adjusted = true, 
            face = "z+",
            overlap = true
        ),
        // Bottom Clamp
        tongue_clamp_bottom = groove
        ? mb_block_dim_this_offset(
            block_dim, 
            off = tongue_clamp_offset,
            face = "z-"
        )
        : mb_block_dim_opposite_offset(
            block_dim, 
            off = - tongue_clamp_offset, 
            adjusted = true, 
            face = "z-"
        ),
        // Bottom Clamp Cut
        tongue_clamp_bottom_cut = groove
        ? mb_block_dim_this_offset(
            block_dim, 
            off = tongue_clamp_offset,
            face = "z-",
            overlap = true
        )
        : mb_block_dim_opposite_offset(
            block_dim, 
            off = - tongue_clamp_offset, 
            adjusted = true, 
            face = "z-",
            overlap = true
        ),
        // Top Clamp
        tongue_clamp_top = groove
        ? mb_block_dim_opposite_offset(
            block_dim, 
            off = tongue_clamp_offset + tongue_clamp_height,
            face = "z+"
        )
        : mb_block_dim_face_edge_expand(
            block_dim, 
            exp = tongue_clamp_offset + tongue_clamp_height, 
            adjusted = true, 
            face = "z+"
        ),
        // Top Clamp Cut
        tongue_clamp_top_cut = groove
        ? mb_block_dim_opposite_offset(
            block_dim, 
            off = tongue_clamp_offset + tongue_clamp_height,
            face = "z+",
            overlap = true
        )
        : mb_block_dim_face_edge_expand(
            block_dim, 
            exp =  tongue_clamp_offset + tongue_clamp_height, 
            adjusted = true, 
            face = "z+",
            overlap = true
        )
    )
    
    mb_block_part_model(
        render = has_tongue,
        type = "list",
        items = [
            // Main Frame
            mb_block_part_model(
                type = "difference",
                items = [
                    mb_block_part_model(
                        type = "union",
                        items = [
                            mb_block_part_prismoid(
                                block_dim = block_dim, 
                                expand = [[
                                    for(f = [0 : 3])
                                        -slope_pos[f] - tongue_offset,
                                    tongue_bottom,
                                    tongue_top
                                ]]
                            ),

                            // Base Wall Gaps
                            if(groove)
                            for(base_wall_gap = base_wall_gaps)
                                let(gap_data = mb_block_tongue_wall_gap(block_obj, base_wall_gap, clamp = false, groove = true))
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
                                                            : -(slope_pos[f] + tongue_offset),
                                                    tongue_bottom,
                                                    tongue_top
                                                ]]
                                            ),

                                            mb_block_part_cube(
                                                block_dim = block_dim, 
                                                expand = [
                                                    mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                                                    mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                                                    mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                                                    mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                                                    tongue_bottom,
                                                    tongue_top
                                                ]
                                            )
                                        ]
                                    ),

                        ]
                    ),

                    // Inner Cutout
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -slope_pos[f] - tongue_offset - tongue_thickness,
                            tongue_bottom_cut,
                            tongue_top_cut
                        ]]
                    ),
                    
                    // Recess Gaps
                    for(recess_gap = recess_wall_gaps)
                        let(gap_data = mb_block_tongue_wall_gap(block_obj, recess_gap, clamp = false))
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
                                                    : -(slope_pos[f] + tongue_offset + tongue_thickness),
                                            tongue_bottom_cut,
                                            tongue_top_cut
                                        ]]
                                    ),

                                    mb_block_part_cube(
                                        block_dim = block_dim, 
                                        expand = [
                                            mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                                            mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                                            mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                                            mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                                            tongue_bottom_cut,
                                            tongue_top_cut
                                        ]
                                    )
                                ]
                            ),
                ]
            ),
            // Clamp
            mb_block_part_model(
                type = "difference",
                items = [
                    mb_block_part_model(
                        type = "union",
                        items = [
                            // Main Frame Clamp
                            mb_block_part_prismoid(
                                block_dim = block_dim, 
                                expand = [[
                                    for(f = [0 : 3])
                                        -slope_pos[f] - tongue_offset + tongue_clamp_thickness,
                                    tongue_clamp_bottom,
                                    tongue_clamp_top
                                ]]
                            ),

                            // Base Wall Gaps
                            if(groove)
                            for(base_wall_gap = base_wall_gaps)
                                let(gap_data = mb_block_tongue_wall_gap(block_obj, base_wall_gap, clamp = true, groove = true))
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
                                                            : -(slope_pos[f] + tongue_offset - tongue_clamp_thickness),
                                                    tongue_clamp_bottom,
                                                    tongue_clamp_top
                                                ]]
                                            ),

                                            mb_block_part_cube(
                                                block_dim = block_dim, 
                                                expand = [
                                                    mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                                                    mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                                                    mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                                                    mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                                                    tongue_clamp_bottom,
                                                    tongue_clamp_top
                                                ]
                                            )
                                        ]
                                    ),
                        ]
                    ),

                    // Inner Cutout
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -slope_pos[f] - tongue_offset - tongue_thickness - tongue_clamp_thickness,
                            tongue_clamp_bottom_cut,
                            tongue_clamp_top_cut
                        ]]
                    ),
                    
                    // Recess Wall Gaps
                    for(recess_gap = recess_wall_gaps)
                        let(gap_data = mb_block_tongue_wall_gap(block_obj, recess_gap, clamp = true))
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
                                                    : -(slope_pos[f] + tongue_offset + tongue_thickness + tongue_clamp_thickness),
                                            tongue_clamp_bottom_cut,
                                            tongue_clamp_top_cut
                                        ]]
                                    ),

                                    mb_block_part_cube(
                                        block_dim = block_dim, 
                                        expand = [
                                            mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                                            mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                                            mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                                            mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                                            tongue_clamp_bottom_cut,
                                            tongue_clamp_top_cut
                                        ]
                                    )
                                ]
                            ),
                ]
            )
        ]
    );
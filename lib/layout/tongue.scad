use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

/**
* -----
* Tongue
* ----.
*/
function mb_block_part__tongue(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        slope = mb_block_dim_slope(block_dim),
        slope_pos = mb_slope_filter(slope, 1),
        has_tongue = mb_block_has_tongue(block_obj),
        tongue_offset = mb_block_get_tongue_offset(block_obj),
        tongue_height = mb_block_get_tongue_height(block_obj),
        tongue_thickness = mb_block_get_tongue_thickness(block_obj),
        tongue_clamp_offset = mb_block_get_tongue_clamp_offset(block_obj),
        tongue_clamp_height = mb_block_get_tongue_clamp_height(block_obj),
        tongue_clamp_thickness = mb_block_get_tongue_clamp_thickness(block_obj),
        wall_gaps = mb_block_get_recess_wall_gaps(block_obj),
        stud_sink = mb_block_get_stud_sink(block_obj)
    )
    mb_block_part_model(
        render = has_tongue,
        type = "list",
        items = [
            mb_block_part_model(
                type = "difference",
                items = [
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -slope_pos[f] - tongue_offset,
                            mb_block_dim_opposite_offset(
                                block_dim, 
                                off = stud_sink, 
                                adjusted = true, 
                                face = "z-"
                            ),
                            mb_block_dim_face_edge_expand(
                                block_dim, 
                                exp = tongue_height, 
                                adjusted = true, 
                                face = "z+"
                            )
                        ]]
                    ),
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -slope_pos[f] - tongue_offset - tongue_thickness,
                            mb_block_dim_opposite_offset(
                                block_dim, 
                                off = stud_sink, 
                                adjusted = true, 
                                face = "z-",
                                overlap = true
                            ),
                            mb_block_dim_face_edge_expand(
                                block_dim, 
                                exp = tongue_height, 
                                adjusted = true, 
                                face = "z+",
                                overlap = true
                            )
                        ]]
                    ),
                    
                    for(wall_gap = wall_gaps)
                        let(gap_data = mb_block_tongue_wall_gap(block_obj, wall_gap))
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
                                            mb_block_dim_opposite_offset(
                                                block_dim, 
                                                off = stud_sink, 
                                                adjusted = true, 
                                                face = "z-",
                                                overlap = true
                                            ),
                                            mb_block_dim_face_edge_expand(
                                                block_dim, 
                                                exp = tongue_height, 
                                                adjusted = true, 
                                                face = "z+",
                                                overlap = true
                                            )
                                        ]]
                                    ),

                                    mb_block_part_cube(
                                        block_dim = block_dim, 
                                        expand = [
                                            mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                                            mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                                            mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                                            mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                                            mb_block_dim_opposite_offset(
                                                block_dim, 
                                                off = stud_sink, 
                                                adjusted = true, 
                                                face = "z-",
                                                overlap = true
                                            ),
                                            mb_block_dim_face_edge_expand(
                                                block_dim, 
                                                exp = tongue_height, 
                                                adjusted = true, 
                                                face = "z+",
                                                overlap = true
                                            )
                                        ]
                                    )
                                ]
                            ),
                ]
            ),

            mb_block_part_model(
                type = "difference",
                items = [
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -slope_pos[f] - tongue_offset + tongue_clamp_thickness,
                            mb_block_dim_opposite_offset(
                                block_dim, 
                                off = -(tongue_height - tongue_clamp_offset - tongue_clamp_height), 
                                adjusted = true, 
                                face = "z-"
                            ),
                            mb_block_dim_face_edge_expand(
                                block_dim, 
                                exp = tongue_height - tongue_clamp_offset, 
                                adjusted = true, 
                                face = "z+"
                            )
                        ]]
                    ),
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -slope_pos[f] - tongue_offset - tongue_thickness - tongue_clamp_thickness,
                            mb_block_dim_opposite_offset(
                                block_dim, 
                                off = -(tongue_height - tongue_clamp_offset - tongue_clamp_height), 
                                adjusted = true, 
                                face = "z-",
                                overlap = true
                            ),
                            mb_block_dim_face_edge_expand(
                                block_dim, 
                                exp = tongue_height - tongue_clamp_offset, 
                                adjusted = true, 
                                face = "z+",
                                overlap = true
                            )
                        ]]
                    ),
                    
                    for(wall_gap = wall_gaps)
                        let(gap_data = mb_block_tongue_wall_gap(block_obj, wall_gap, true))
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
                                            mb_block_dim_opposite_offset(
                                                block_dim, 
                                                off = -(tongue_height - tongue_clamp_offset - tongue_clamp_height), 
                                                adjusted = true, 
                                                face = "z-",
                                                overlap = true
                                            ),
                                            mb_block_dim_face_edge_expand(
                                                block_dim, 
                                                exp = tongue_height - tongue_clamp_offset, 
                                                adjusted = true, 
                                                face = "z+",
                                                overlap = true
                                            )
                                        ]]
                                    ),

                                    mb_block_part_cube(
                                        block_dim = block_dim, 
                                        expand = [
                                            mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                                            mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                                            mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                                            mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                                            mb_block_dim_opposite_offset(
                                                block_dim, 
                                                off = -(tongue_height - tongue_clamp_offset - tongue_clamp_height), 
                                                adjusted = true, 
                                                face = "z-",
                                                overlap = true
                                            ),
                                            mb_block_dim_face_edge_expand(
                                                block_dim, 
                                                exp = tongue_height - tongue_clamp_offset, 
                                                adjusted = true, 
                                                face = "z+",
                                                overlap = true
                                            )
                                        ]
                                    )
                                ]
                            ),
                ]
            )
        ]
    );
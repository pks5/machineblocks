use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

/**
* -----------
* Base Cutout
* -----------
*/
function mb_block_part__base_cutout(block_obj, planes = "all", bottom = undef, top = undef, inner_adj = undef, top_offset = 0) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        slope_base_height_inner = mb_block_get_slope_base_height_inner(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        slope = mb_block_dim_slope(block_dim),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        

        bottom = is_undef(bottom) 
            ? mb_block_dim_this_offset(
                block_dim, 
                overlap = true
            ) 
            : bottom,
        top = is_undef(top) 
            ? mb_block_base_cutout_ceiling_offset(
                block_obj, 
                face = "z+"
            ) 
            : top,
        inner_adj = is_undef(inner_adj) ? 0 : inner_adj
    )

    [
        "list",
        [
            mb_block_part_prismoid(
                block_dim = block_dim, 
                expand = [
                    _mb_layout_plane_value(
                        planes = planes, 
                        plane = "bottom",
                        value = [
                            for(f = [0 : 3])
                                slope_neg[f] - wall_thickness + inner_adj,
                            bottom,
                            top
                        ]
                    ),
                    _mb_layout_plane_value(
                        planes = planes, 
                        plane = "top",
                        value = [
                            for(f = [0 : 3])
                                slope_neg[f] 
                                -wall_thickness - max(mb_block_slope_partial(block_obj, top_offset, f), 0)
                                //+ _mb_layout_plane_value(planes = planes, plane = "top", value = - slope_partial * slope_pos[f], else_value = 0, all = false) 
                                //- wall_thickness 
                                + inner_adj,
                            bottom,
                            top
                        ]
                    )
                ],
                /*slope = _mb_layout_plane_value(
                    planes = planes, 
                    value = mb_array_mul(slope_pos, slope_partial)
                ),*/
                socket = _mb_layout_plane_value(
                    planes = planes, 
                    value = [slope_base_height_inner + mb_block_dim_overlap(block_dim, overlap = true), 0]
                )
            ),
            for(wall_gap = wall_gaps)
                mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, wall_gap, inner_adj, top_offset)
        ]
    ];

/**
* --------------
* Base Wall Gaps
* --------------
*/
function mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, wall_gap, inner_adj = undef, top_offset = 0) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        slope = mb_block_dim_slope(block_dim),
        slope_base_height_inner = mb_block_get_slope_base_height_inner(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        base_wall_gap_res = mb_block_base_wall_gap(block_obj, wall_gap),
        block_inverted = mb_block_get_inverted(block_obj),
        inner_adj = is_undef(inner_adj) ? 0 : inner_adj,
        outer_adj = block_inverted ? mb_block_get_base_clamp_thickness(block_obj) : 0
    )
    
    [
        "list",
        [
            for(gap = base_wall_gap_res)
                let(
                    face = gap[0],
                    gap_start_offset = gap[3],
                    gap_end_offset = gap[4]
                )
                [
                    "intersection",
                    [
                        mb_block_part_prismoid(
                            block_dim = block_dim, 
                            expand = [
                                _mb_layout_plane_value(
                                    planes = planes, 
                                    plane = "bottom",
                                    value = [
                                        for(f = [0 : 3])
                                            mb_face_has_common(face, f) ? 
                                                mb_block_dim_face_edge_expand(
                                                    block_dim, 
                                                    exp = outer_adj, 
                                                    adjusted = true, 
                                                    face = f, 
                                                    overlap = true
                                                ) : 
                                                slope_neg[f] - wall_thickness + inner_adj,
                                        bottom,
                                        planes == "all" && slope_pos[face] > 0 ? mb_block_dim_opposite_offset(
                                            block_dim, 
                                            off = slope_base_height_inner
                                        ) : top
                                    ]
                                ),
                                _mb_layout_plane_value(
                                    planes = planes, 
                                    plane = "top",
                                    value = [
                                        for(f = [0 : 3])
                                            mb_face_has_common(face, f) ? 
                                                mb_block_dim_face_edge_expand(
                                                    block_dim, 
                                                    exp = outer_adj, 
                                                    adjusted = true, 
                                                    face = f, 
                                                    overlap = true
                                                ) : 
                                                slope_neg[f] + 
                                                    - wall_thickness - (planes == "all" && slope_pos[face] > 0 ? 0 : max(mb_block_slope_partial(block_obj, top_offset, f), 0))
                                                    //+ _mb_layout_plane_value(planes = planes, plane = "top", value = - slope_partial * slope_pos[f], else_value = 0, all = false) 
                                                    //- wall_thickness
                                                    + inner_adj,
                                        bottom,
                                        planes == "all" && slope_pos[face] > 0 ? mb_block_dim_opposite_offset(
                                            block_dim, 
                                            off = slope_base_height_inner
                                        ) : top
                                    ]
                                )
                            ],
                            /*slope = _mb_layout_plane_value(
                                planes = planes, 
                                value = mb_array_mul(slope_pos, slope_partial)
                            ),*/
                            socket = _mb_layout_plane_value(
                                planes = planes, 
                                value = [slope_base_height_inner + mb_block_dim_overlap(block_dim, overlap = true), 0]
                            )
                        ),
                        
                        mb_block_part_cube(
                            block_dim = block_dim,
                            expand = [
                                mb_face_has_common(face, "y") ? - gap_start_offset + inner_adj : 0,
                                mb_face_has_common(face, "y") ? - gap_end_offset + inner_adj : 0,
                                mb_face_has_common(face, "x") ? - gap_start_offset + inner_adj : 0,
                                mb_face_has_common(face, "x") ? - gap_end_offset + inner_adj : 0,
                                mb_block_dim_this_offset(
                                    block_dim, 
                                    overlap = true
                                ),
                                0
                            ]
                        )
                    ]
                ]
        ]
    ];



/**
* -----------------
* Base Cutout Clamp
* -----------------
*/
function mb_block_part__base_cutout_clamp(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj),
        base_clamp_height = mb_block_get_base_clamp_height(block_obj),
        base_clamp_offset = mb_block_get_base_clamp_offset(block_obj),

        bottom = mb_block_dim_this_offset(
            block_dim, 
            off = base_clamp_offset
        ),
        top = mb_block_dim_opposite_offset(
            block_dim, 
            off = base_clamp_height + base_clamp_offset
        )
    )
    [
        "difference",
        [
            _mb_layout_mask_frame(
                block_dim = block_dim, 
                bottom = bottom, 
                top = top, 
                outer_adj = base_clamp_thickness
            ),
            mb_block_part__base_cutout(
                block_obj, 
                planes = "bottom", 
                bottom = mb_block_dim_this_offset(
                    block_dim, 
                    off = base_clamp_offset, 
                    overlap = true
                ), 
                top = mb_block_dim_opposite_offset(
                    block_dim, 
                    off = base_clamp_height + base_clamp_offset, 
                    overlap = true
                ), 
                inner_adj = -base_clamp_thickness
            )
        ]
    ];






use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

/**
* -------
* HELPERS
* -------
*/

function _mb_layout_mask_frame(block_dim, bottom, top, outer_adj = 0) = 
    mb_block_part_prismoid(
        block_dim = block_dim, 
        expand = [[
            for(f = [0 : 3])
                mb_block_dim_face_edge_expand(
                    block_dim, 
                    exp = outer_adj, 
                    adjusted = true, 
                    face = f
                ),
            bottom,
            top
        ]]
    );

function _mb_layout_plane_value(planes, value, plane = "all") = 
    planes == plane || planes == "all" ? value : undef;

/**
* -----
* Tongue
* ----.
*/
function mb_block_part__tongue(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        slope = mb_block_get_slope(block_obj),
        slope_pos = mb_slope_filter(slope, 1),
        has_tongue = mb_block_has_tongue(block_obj),
        tongue_offset = mb_block_get_tongue_offset(block_obj),
        tongue_height = mb_block_get_tongue_height(block_obj),
        tongue_thickness = mb_block_get_tongue_thickness(block_obj),
        stud_sink = mb_block_get_stud_sink(block_obj)
    )
    has_tongue ? 
    [
        "difference",
        [
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
                ]],
                bevel = mb_block_get_bevel(block_obj)
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
                        cut = true
                    ),
                    mb_block_dim_face_edge_expand(
                        block_dim, 
                        exp = tongue_height, 
                        adjusted = true, 
                        face = "z+",
                        cut = true
                    )
                ]],
                bevel = mb_block_get_bevel(block_obj)
            )
        ]
    ] : undef;

/**
* -----
* Studs
* ----.
*/
function mb_block_part__studs(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        stud_range = mb_block_stud_range(block_obj),
        stud_rounding = mb_block_get_stud_rounding(block_obj)

        
    )
    [
        "list",
        [
            for(x = stud_range[0])
                for(y = stud_range[1])
                    let(render = mb_block_stud_render(block_obj, x, y))
                    if(render[0])
                        mb_block_part_tube(
                            block_dim = block_dim,
                            radius = mb_block_stud_radius(block_obj, x, y),
                            rounding_radius = stud_rounding,
                            axis = "z",
                            expand = render[2],
                            offset = render[1]
                        )
        ]
    ];

/**
* ----
* Tube
* ----
*/
function mb_block_part__tubes(block_obj, axis = "z") = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        tube_range = mb_block_tube_range(block_obj, axis),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj),
        base_clamp_height = mb_block_get_base_clamp_height(block_obj),
        base_clamp_offset = mb_block_get_base_clamp_offset(block_obj),
        top_plate_helpers_thickness = mb_block_get_top_plate_helpers_thickness(block_obj),
        top_plate_helpers_height = mb_block_get_top_plate_helpers_height(block_obj),
        base_cutout_ceiling_offset_with_cut = mb_block_base_cutout_ceiling_offset(block_obj, face = "z+", cut = true)
    )
    [
        "list",
        [
            for(x = tube_range[0])
                for(y = tube_range[1])
                    if(mb_block_tube_render(block_obj, axis, x, y))
                        let(
                            tube_clamp_end = [
                                    top_plate_helpers_thickness, 
                                    top_plate_helpers_height, 
                                    mb_block_dim_cut_offset(block_dim, cut = true)
                                ],
                            tube_clamp_start = [
                                    base_clamp_thickness,
                                    base_clamp_height,
                                    base_clamp_offset
                                ]
                        )
                        mb_block_part_tube(
                            block_dim = block_dim,
                            radius = mb_block_tube_radius(block_obj, axis, x, y),
                            clamp_end = tube_clamp_end, 
                            clamp_start = tube_clamp_start, 
                            axis = axis,
                            expand = [
                                0,
                                base_cutout_ceiling_offset_with_cut
                            ],
                            offset = mb_block_tube_offset(block_obj, axis, x, y)
                        )
        ]
    ];

/**
* ----------
* Base Outer
* ----------
*/
function mb_block_part__base_outer(block_obj, adjusted = true) =
    mb_block_part_prismoid(
        block_dim = mb_block_get_dim(block_obj), 
        expand = adjusted ? [mb_block_get_base_adj(block_obj)] : undef,
        socket = mb_block_get_slope_socket(block_obj),
        bevel = mb_block_get_bevel(block_obj),
        slope = mb_block_get_slope(block_obj)
    ); 



/**
* -----------
* Base Cutout
* -----------
*/
function mb_block_part__base_cutout(block_obj, planes = "all", bottom = undef, top = undef, inner_adj = undef) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        slope = mb_block_get_slope(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        
        bottom = is_undef(bottom) 
            ? mb_block_dim_this_offset(
                block_dim, 
                cut = true
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
                                -wall_thickness + slope_neg[f] + inner_adj,
                            bottom,
                            top
                        ]
                    ),
                    _mb_layout_plane_value(
                        planes = planes, 
                        plane = "top",
                        value = [
                            for(f = [0 : 3])
                                slope_neg[f] + (slope_pos[f] <= wall_thickness ? -(wall_thickness - slope_pos[f]) : 0) + inner_adj,
                            bottom,
                            top
                        ]
                    )
                ],
                bevel = bevel,
                slope = _mb_layout_plane_value(planes, slope_pos),
                socket = _mb_layout_plane_value(planes, [base_cutout_min_depth, 0])
            ),
            for(wall_gap = wall_gaps)
                mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, wall_gap, inner_adj)
        ]
    ];

/**
* --------------
* Base Wall Gaps
* --------------
*/
function mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, wall_gap, inner_adj = undef) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        gaps = mb_block_base_wall_gap(block_obj, wall_gap),
        block_inverted = mb_block_get_inverted(block_obj),
        inner_adj = is_undef(inner_adj) ? 0 : inner_adj,
        outer_adj = block_inverted ? mb_block_get_base_clamp_thickness(block_obj) : 0
    )
    
    [
        "list",
        [
            for(gap = gaps)
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
                                                    cut = true
                                                ) : 
                                                -wall_thickness + slope_neg[f] + inner_adj,
                                        bottom,
                                        top
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
                                                    cut = true
                                                ) : 
                                                slope_neg[f] + 
                                                    (slope_pos[f] <= wall_thickness ? -(wall_thickness - slope_pos[f]) : 0) + 
                                                    inner_adj,
                                        bottom,
                                        top
                                    ]
                                )
                            ],
                            socket = [base_cutout_min_depth, 0],
                            bevel = bevel,
                            slope = slope_pos
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
                                    cut = true
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
                    cut = true
                ), 
                top = mb_block_dim_opposite_offset(
                    block_dim, 
                    off = base_clamp_height + base_clamp_offset, 
                    cut = true
                ), 
                inner_adj = -base_clamp_thickness
            )
        ]
    ];

/**
* ----------------
* Base Clamp Outer
* ----------------
*/
function mb_block_part__base_clamp_outer(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        block_inverted = mb_block_get_inverted(block_obj),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj),
        base_clamp_height = mb_block_get_base_clamp_height(block_obj),
        base_clamp_offset = mb_block_get_base_clamp_offset(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        
        bottom = mb_block_dim_this_offset(
            block_dim, 
            off = base_clamp_offset
        ),
        top = mb_block_dim_opposite_offset(
            block_dim, 
            off = base_clamp_height + base_clamp_offset
        )
    )
    block_inverted ? 
        mb_block_part_prismoid(
            block_dim = block_dim, 
            expand = [[
                for(f = [0 : 3])
                    mb_block_dim_face_edge_expand(
                        block_dim, 
                        exp = base_clamp_thickness, 
                        adjusted = true, 
                        face = f
                    ),
                bottom,
                top
            ]],
            bevel = mb_block_get_bevel(block_obj)
        )
        : undef;

/**
* -----------------
* Top Plate Helpers
* -----------------
*/
function mb_block_part__top_plate_helpers(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        top_plate_helpers_thickness = mb_block_get_top_plate_helpers_thickness(block_obj),
        top_plate_helpers_height = mb_block_get_top_plate_helpers_height(block_obj)
    ) 
    mb_block_has_top_plate_helpers(block_obj) 
        ? [
            "difference",
            [
                _mb_layout_mask_frame(
                    block_dim = block_dim, 
                    bottom = mb_block_base_cutout_ceiling_offset(
                        block_obj, 
                        face = "z-", 
                        off = top_plate_helpers_height
                    ), 
                    top = mb_block_base_cutout_ceiling_offset(
                        block_obj, 
                        face = "z+", 
                        cut = true
                    )
                ),
                mb_block_part__base_cutout(
                    block_obj, 
                    planes = "bottom", 
                    bottom = mb_block_base_cutout_ceiling_offset(
                        block_obj, 
                        face = "z-", 
                        off = top_plate_helpers_height, 
                        cut = true
                    ), 
                    top = mb_block_base_cutout_ceiling_offset(
                        block_obj, 
                        face = "z+", 
                        cut = 2
                    ), 
                    inner_adj = -top_plate_helpers_thickness
                )
            ]
        ] 
        : undef;

/**
* -----------
* Stabilizers
* -----------
*/
function mb_block_part__stabilizers(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        top = mb_block_base_cutout_ceiling_offset(
            block_obj, 
            face = "z+",
            cut = true
        )
    )
    [
        "list",
        [
            for(axis = ["x", "y"])
                let(range = mb_block_stabilizer_range(block_obj, axis))
                for(x = range[0])
                [
                    "list",
                    [
                        for(y = range[1])
                            let(
                                seg_offset = mb_block_stabilizer_segment_offset(block_obj, axis, x, y),
                                seg_size = mb_block_stabilizer_segment_size(block_obj, axis, x, y),
                                seg_expand = mb_block_stabilizer_segment_expand(block_obj, axis, x, y)
                            )
                            if(mb_block_stabilizer_segment_render(block_obj, axis, x, y))
                            [
                                "list",
                                [
                                    mb_block_part_cube(
                                        block_dim = block_dim,
                                        size = [
                                            seg_size[0][0], 
                                            seg_size[0][1], 
                                            seg_size[0][2] + mb_block_dim_cut_offset(block_dim, cut = true)
                                        ],
                                        expand = [
                                            for(f = [0 : 3])
                                                seg_expand[f],
                                            "auto", 
                                            top
                                        ],
                                        offset = seg_offset
                                    ),
                                    if(len(seg_size) > 1)
                                        mb_block_part_cube(
                                            block_dim = block_dim,
                                            size = [
                                                seg_size[0][0] + seg_size[1][0], 
                                                seg_size[0][1] + seg_size[1][1], 
                                                                 seg_size[1][2] + mb_block_dim_cut_offset(block_dim, cut = true)
                                            ],
                                            expand = [
                                                for(f = [0 : 3])
                                                    seg_expand[f],
                                                "auto", 
                                                top
                                            ],
                                            offset = seg_offset
                                        )
                                ]
                            ]
                    ]
                ]

            
        ]
    ]; 

/**
* ----------
* Relief Cut
* ----------
*/
function mb_block_part__relief_cut(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        relief_cut_thickness = mb_block_get_relief_cut_thickness(block_obj),
        relief_cut_height = mb_block_get_relief_cut_height(block_obj),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj)
    ) 
    mb_block_has_relief_cut(block_obj) 
    ? [
        "difference",
        [
            _mb_layout_mask_frame(
                block_dim = block_dim, 
                bottom = mb_block_dim_this_offset(
                    block_dim, 
                    cut = 1
                ), 
                top =  mb_block_dim_opposite_offset(
                    block_dim, 
                    off = relief_cut_height
                ), 
                outer_adj = base_clamp_thickness
            ),
            mb_block_part_prismoid(
                block_dim = block_dim, 
                expand = [[
                    for(f = [0 : 3])
                        mb_block_dim_face_edge_expand(
                            block_dim, 
                            exp = -relief_cut_thickness + slope_neg[f], 
                            adjusted = true, 
                            face = f
                        ),
                    mb_block_dim_this_offset(
                        block_dim, 
                        cut = 2
                    ),
                    mb_block_dim_opposite_offset(
                        block_dim, 
                        off = relief_cut_height, 
                        cut = true
                    )
                ]],
                bevel = bevel,
                //slope = slope,
                //socket = socket
            )
        ]
    ]
    : undef;

/**
* ------
* Recess
* ------
*/
function mb_block_part__recess(block_obj) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        slope_pos = mb_slope_filter(slope, 1),
        rwt = mb_block_get_recess_wall_thickness(block_obj),
        rwgs = mb_block_get_recess_wall_gaps(block_obj),
        
        bottom = mb_block_recess_floor_offset(block_obj, "z-"),
        exp_top = mb_block_dim_face_edge_expand(
            block_dim, 
            adjusted = true, 
            face = "z+", 
            cut = true
        )
    )
    mb_block_has_recess(block_obj) 
    ? [
        "list",
        [
            [
                "intersection",
                [
                    mb_block_part_prismoid(
                        block_dim = block_dim, 
                        expand = [[
                            for(f = [0 : 3])
                                -rwt[f],
                            0,
                            exp_top,
                        ]],
                        bevel = bevel,
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
            ], 
            
            for(rwg = rwgs)
                let(gap_data = mb_block_recess_wall_gap(block_obj, rwg))
                for(gap = gap_data)
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
                                expand = [[
                                    for(f = [0 : 3])
                                        mb_face_has_common(face, f) 
                                            ? mb_block_dim_face_edge_expand(
                                                block_dim, 
                                                adjusted = true, 
                                                face = f,
                                                cut = true
                                            ) 
                                            : -rwt[f],
                                    0,
                                    exp_top
                                ]],
                                bevel = bevel,
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
                    ]
        ]
    ]
    : undef;

/**
* ----------------
* Stud Base Cutout
* ----------------
*/
function mb_block_part__stud_base_cutout(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        base_clamp_thickness = mb_block_get_base_clamp_thickness(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        cut_tol = mb_block_dim_cut_offset(block_dim, cut = true), //TODO remove
        slope = mb_block_get_slope(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        top = mb_block_dim_opposite_offset(
            block_dim, 
            off = base_cutout_min_depth
        )
    )
    mb_block_part_prismoid(
        block_dim = block_dim, 
        expand = [
            [
                for(f = [0 : 3])
                    -(wall_thickness + base_clamp_thickness) + slope_neg[f] - cut_tol,
                cut_tol,
                top
            ]
        ],
        bevel = mb_block_get_bevel(block_obj)
    );
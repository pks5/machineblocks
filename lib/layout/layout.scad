use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_part.scad>;

/**
* -------
* HELPERS
* -------
*/

function _mb_layout_mask_frame(mod_size, base_adj, bottom, top, cut_tol, outer_adjust = 0) = 
    mb_block_part_prismoid(
        block_size = mod_size, 
        expand = [[
            for(f = [0 : 3])
                base_adj[f] + cut_tol + outer_adjust,
            bottom,
            top
        ]]
    );

function _mb_layout_plane_value(planes, value, plane = "all") = 
    planes == plane || planes == "all" ? value : undef;




/**
* ----
* Tube
* ----
*/
function mb_block_part__tubes(block_obj, axis = "z") = 
    let(mod_size = mb_block_get_mod_size(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        tube_range = mb_block_tube_range(block_obj, axis)
    )
    [
        "list",
        [
            for(x = tube_range[0])
                for(y = tube_range[1])
                    if(mb_block_tube_render(block_obj, axis, x, y))
                        let(
                            tube_top_plate_helpers = mb_block_tube_top_plate_helpers(block_obj, axis, x, y),
                            tube_clamp = mb_block_tube_clamp(block_obj, axis, x, y),
                            tube_clamp_end = is_undef(tube_top_plate_helpers) 
                                ? undef
                                : [
                                    tube_top_plate_helpers[0], 
                                    tube_top_plate_helpers[1], 
                                    cut_tol
                                ],
                            tube_clamp_start = is_undef(tube_clamp) 
                                ? undef
                                : [
                                    tube_clamp[0],
                                    tube_clamp[1],
                                    tube_clamp[2]
                                ],
                            tube_expand = mb_block_tube_expand(block_obj, axis, x, y)
                        )
                        mb_block_part_tube(
                            block_size = mod_size,
                            radius = mb_block_tube_radius(block_obj, axis, x, y),
                            clamp_end = tube_clamp_end, 
                            clamp_start = tube_clamp_start, 
                            axis = axis,
                            //length = mb_block_tube_length(block_obj, axis, x, y) + cut_tol,
                            expand = [
                                tube_expand[0],
                                tube_expand[1] + cut_tol
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
        block_size = mb_block_get_mod_size(block_obj), 
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
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        mod_size = mb_block_get_mod_size(block_obj),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        base_cutout_ceiling_offset = mb_block_base_cutout_ceiling_offset(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        slope = mb_block_get_slope(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        bottom = is_undef(bottom) ? cut_tol : bottom,
        top = is_undef(top) ? -base_cutout_ceiling_offset[1] : top,
        inner_adj = is_undef(inner_adj) ? 0 : inner_adj
    )

    [
        "list",
        [
            mb_block_part_prismoid(
                block_size = mod_size, 
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
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        gaps = mb_block_base_wall_gap(block_obj, wall_gap),
        block_inverted = mb_block_get_inverted(block_obj),
        clamp = mb_block_get_clamp(block_obj),
        inner_adj = is_undef(inner_adj) ? 0 : inner_adj,
        outer_adj = block_inverted ? clamp[0] : 0
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
                            block_size = mod_size, 
                            expand = [
                                _mb_layout_plane_value(
                                    planes = planes, 
                                    plane = "bottom",
                                    value = [
                                        for(f = [0 : 3])
                                            mb_face_has_common(face, f) ? 
                                                base_adj[f] + cut_tol + outer_adj : 
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
                                                base_adj[f] + cut_tol + outer_adj : 
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
                            block_size = mod_size,
                            expand = [
                                mb_face_has_common(face, "y") ? - gap_start_offset + inner_adj : 0,
                                mb_face_has_common(face, "y") ? - gap_end_offset + inner_adj : 0,
                                mb_face_has_common(face, "x") ? - gap_start_offset + inner_adj : 0,
                                mb_face_has_common(face, "x") ? - gap_end_offset + inner_adj : 0,
                                cut_tol,
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
    let(base_adj = mb_block_get_base_adj(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        clamp = mb_block_get_clamp(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        bottom = -clamp[2],
        top = -(mod_size[2] - clamp[1] - clamp[2]))
    [
        "difference",
        [
            _mb_layout_mask_frame(
                mod_size = mod_size, 
                base_adj = base_adj, 
                bottom = bottom, 
                top = top, 
                cut_tol = cut_tol,
                outer_adjust = clamp[0]
            ),
            mb_block_part__base_cutout(
                block_obj, 
                planes = "bottom", 
                bottom = bottom + cut_tol, 
                top = top + cut_tol, 
                inner_adj = -clamp[0]
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
        block_inverted = mb_block_get_inverted(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        clamp = mb_block_get_clamp(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        bottom = -clamp[2],
        top = -(mod_size[2] - clamp[1] - clamp[2])
    )
    block_inverted ? 
    //[
    //    "difference",
    //    [
            mb_block_part_prismoid(
                block_size = mod_size, 
                expand = [[
                    for(f = [0 : 3])
                        base_adj[f] + clamp[0],
                    bottom,
                    top
                ]],
                bevel = mb_block_get_bevel(block_obj)
            )
            //for(wall_gap = wall_gaps)
            //    mb_block_part__base_wall_gaps(block_obj, "bottom", bottom + cut_tol, top + cut_tol, wall_gap, -clamp[0])
    //    ]
    //] 
    : undef;

/**
* -----------------
* Top Plate Helpers
* -----------------
*/
function mb_block_part__top_plate_helpers(block_obj) =
    let(base_adj = mb_block_get_base_adj(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        base_cutout_ceiling_offset = mb_block_base_cutout_ceiling_offset(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        bottom = -(base_cutout_ceiling_offset[0] - top_plate_helpers[1]),
        top = -base_cutout_ceiling_offset[1] + cut_tol
    ) 
    !top_plate_helpers ? undef : [
        "difference",
        [
            _mb_layout_mask_frame(
                mod_size = mod_size, 
                base_adj = base_adj, 
                bottom = bottom, 
                top = top, 
                cut_tol = cut_tol
            ),
            mb_block_part__base_cutout(
                block_obj, 
                planes = "top", 
                bottom = bottom + cut_tol, 
                top = top + cut_tol, 
                inner_adj = - top_plate_helpers[0]
            )
        ]
    ];

/**
* -----------
* Stabilizers
* -----------
*/
function mb_block_part__stabilizers(block_obj) =
    let(mod_size = mb_block_get_mod_size(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        base_cutout_ceiling_offset = mb_block_base_cutout_ceiling_offset(block_obj),
        top = -base_cutout_ceiling_offset[1]
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
                                        block_size = mod_size,
                                        size = [
                                            seg_size[0][0], 
                                            seg_size[0][1], 
                                            seg_size[0][2] + cut_tol
                                        ],
                                        expand = [
                                            for(f = [0 : 3])
                                                seg_expand[f],
                                            "auto", 
                                            top + cut_tol
                                        ],
                                        offset = seg_offset
                                    ),
                                    if(len(seg_size) > 1)
                                        mb_block_part_cube(
                                            block_size = mod_size,
                                            size = [
                                                seg_size[0][0] + seg_size[1][0], 
                                                seg_size[0][1] + seg_size[1][1], 
                                                                 seg_size[1][2] + cut_tol
                                            ],
                                            expand = [
                                                for(f = [0 : 3])
                                                    seg_expand[f],
                                                "auto", 
                                                top + cut_tol
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
    let(socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        relief_cut = mb_block_get_relief_cut_dim(block_obj),
        clamp = mb_block_get_clamp(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        bottom = cut_tol,
        top = -(mod_size[2] - relief_cut[1])) 
    [
        "difference",
        [
            _mb_layout_mask_frame(
                mod_size = mod_size, 
                base_adj = base_adj, 
                bottom = bottom, 
                top = top, 
                cut_tol = cut_tol,
                outer_adjust = clamp[0]
            ),
            mb_block_part_prismoid(
                block_size = mod_size, 
                expand = [[
                    for(f = [0 : 3])
                        base_adj[f] - relief_cut[0],
                    bottom + cut_tol,
                    top + cut_tol
                ]],
                bevel = bevel,
                slope = slope,
                socket = socket
            )
        ]
    ];

/**
* ------
* Recess
* ------
*/
function mb_block_part__recess(block_obj) = 
    let(mod_size = mb_block_get_mod_size(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        slope_pos = mb_slope_filter(slope, 1),
        recess_depth = mb_block_get_recess_depth(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        rwt = mb_block_get_recess_wall_thickness(block_obj),
        rwgs = mb_block_get_recess_wall_gaps(block_obj),
        bottom = -(base_cutout_depth + top_plate_height),
        top_cutout = base_cutout_depth + top_plate_height - socket[0])  
    [
        "list",
        [
           mb_block_part_prismoid(
                block_size = mod_size, 
                expand = [[
                    for(f = [0 : 3])
                        -rwt[f],
                    bottom,
                    cut_tol
                ]],
                bevel = bevel,
                slope = slope
            ), 
            
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
                                block_size = mod_size, 
                                expand = [[
                                    for(f = [0 : 3])
                                        mb_face_has_common(face, f) ? cut_tol : -rwt[f],
                                    bottom,
                                    top_cutout
                                ]],
                                bevel = bevel,
                                slope = [
                                    for(f = [0 : 3])
                                        mb_face_has_common(face, f) ? slope_pos[f] : 0, 
                                ]
                            ),

                            mb_block_part_cube(
                                block_size = mod_size, 
                                expand = [
                                    mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                                    mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                                    mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                                    mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                                    0,
                                    cut_tol
                                ]
                            )
                        ]
                    ]
        ]
    ];

/**
* ----------------
* Stud Base Cutout
* ----------------
*/
function mb_block_part__stud_base_cutout(block_obj) =
    let(mod_size = mb_block_get_mod_size(block_obj),
        clamp = mb_block_get_clamp(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        slope = mb_block_get_slope(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        top = -(mod_size[2] - base_cutout_min_depth))
    mb_block_part_prismoid(
        block_size = mod_size, 
        expand = [
            [
                for(f = [0 : 3])
                    -(wall_thickness + clamp[0]) + slope_neg[f] - cut_tol,
                cut_tol,
                top
            ]
        ],
        bevel = mb_block_get_bevel(block_obj)
    );
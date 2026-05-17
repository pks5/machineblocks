use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_part.scad>;

/**
* -------
* HELPERS
* -------
*/

function _mb_block_part__mask_frame(mod_size, base_adj, bottom, top, cut_tol) = 
    mb_block_part_prismoid(
        block_size = mod_size, 
        expand = [[
            for(f = [0 : 3])
                base_adj[f] + cut_tol,
            bottom,
            top
        ]]
    );

function _mb_block_part__plane_value(planes, value, plane = "all") = 
    planes == plane || planes == "all" ? value : undef;




/**
* ----
* Tube
* ----
*/
function mb_block_part__tube(block_obj) = 
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        tube_z_hole_size = mb_block_get_tube_hole_size(block_obj, "z"),
        clamp = mb_block_get_clamp(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        tube_length = base_cutout_depth + cut_tol,
        offset = mb_block_pos_to_offset(block_obj, [0.5, 0, 2]))
    [
        "difference",
        [
            mb_block_part_tube(
                block_size = size,
                block_mod = mod,
                radius = [0.5 * tube_z_hole_size, 0.5 * tube_z_diameter],
                clamp_end = [top_plate_helpers[0], top_plate_helpers[1]], 
                clamp_start = [clamp[0], clamp[1] + cut_tol, clamp[2]], 
                axis = "z",
                length = tube_length,
                expand = [tube_length, "auto"],
                offset = offset
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
* Clamp Outer
* -----------
*/
function mb_block_part__base_clamp_outer(block_obj) = 
    let(
        mod_size = mb_block_get_mod_size(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        clamp = mb_block_get_clamp(block_obj)
    )
    mb_block_part_prismoid(
        block_size = mod_size, 
        expand = [[
                for(f = [0 : 3])
                    base_adj[f] + clamp[0],
                -clamp[2],
                -(mod_size[2] - clamp[1] - clamp[2])
        ]],
        bevel = mb_block_get_bevel(block_obj)
    );

/**
* -----------
* Base Cutout
* -----------
*/
function mb_block_part__base_cutout(block_obj, planes = "all", bottom = undef, top = undef, red = undef) = 
    let(base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        mod_size = mb_block_get_mod_size(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        slope = mb_block_get_slope(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        bottom = is_undef(bottom) ? cut_tol : bottom,
        top = is_undef(top) ? -(top_plate_height + recess_depth) : top,
        red = is_undef(red) ? 0 : red
        
        )

    [
        "list",
        [
            mb_block_part_prismoid(
                block_size = mod_size, 
                expand = [
                    _mb_block_part__plane_value(
                        planes = planes, 
                        plane = "bottom",
                        value = [
                            for(f = [0 : 3])
                                -wall_thickness + slope_neg[f] + red,
                            bottom,
                            top
                        ]
                    ),
                    _mb_block_part__plane_value(
                        planes = planes, 
                        plane = "top",
                        value = [
                            for(f = [0 : 3])
                                slope_neg[f] + (slope_pos[f] <= wall_thickness ? -(wall_thickness - slope_pos[f]) : 0) + red,
                            bottom,
                            top
                        ]
                    )
                ],
                bevel = bevel,
                slope = _mb_block_part__plane_value(planes, slope_pos),
                socket = _mb_block_part__plane_value(planes, [base_cutout_min_depth, 0])
            ),
            for(wall_gap = wall_gaps)
                mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, wall_gap, red)
        ]
    ];

/**
* --------------
* Base Wall Gaps
* --------------
*/
function mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, wall_gap, red = undef) =
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
        red = is_undef(red) ? 0 : red
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
                                _mb_block_part__plane_value(
                                    planes = planes, 
                                    plane = "bottom",
                                    value = [
                                        for(f = [0 : 3])
                                            mb_face_has_common(face, f) ? 
                                                base_adj[f] + cut_tol : 
                                                -wall_thickness + slope_neg[f] + red,
                                        bottom,
                                        top
                                    ]
                                ),
                                _mb_block_part__plane_value(
                                    planes = planes, 
                                    plane = "top",
                                    value = [
                                        for(f = [0 : 3])
                                            mb_face_has_common(face, f) ? 
                                                base_adj[f] + cut_tol : 
                                                slope_neg[f] + (slope_pos[f] <= wall_thickness ? -(wall_thickness - slope_pos[f]) : 0) + red,
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
                                mb_face_has_common(face, "y") ? - gap_start_offset + red : 0,
                                mb_face_has_common(face, "y") ? - gap_end_offset + red : 0,
                                mb_face_has_common(face, "x") ? - gap_start_offset + red : 0,
                                mb_face_has_common(face, "x") ? - gap_end_offset + red : 0,
                                cut_tol,
                                0
                            ]
                        )
                    ]
                ]
        ]
    ];

/**
* -----------
* Stabilizers
* -----------
*/
function mb_block_part__stabilizers(block_obj) =
    let(mod_size = mb_block_get_mod_size(block_obj),
        stabilizers = mb_block_get_stabilizers(block_obj),
        
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        tube_wall_thickness = mb_block_get_tube_wall_thickness(block_obj, "z"),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        min_max_index = mb_block_get_min_max_index(block_obj),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        default_segment_length = 1 - tube_z_diameter + tube_wall_thickness,
        segment_thickness = stabilizers[0],
        stabilizer_expansion = stabilizers[4],
        segment_height_expanded = max(base_cutout_depth - stabilizers[3], 0)
        )
    [
        "list",
        [
            // X (lines in Y direction)
            for(x = [start_index_x + 1 : end_index_x])
            [
                "list",
                [
                    for(y = [start_index_y : end_index_y])
                        let(offset = mb_block_pos_to_offset(block_obj, [x, y + 0.5, undef]))
                        if(mb_block_render_stabilizer_segment(block_obj, "x", x, y))
                        [
                            "list",
                            [
                                mb_block_part_cube(
                                    block_size = mod_size,
                                    size = [
                                        segment_thickness, 
                                        default_segment_length, 
                                        ((x % stabilizer_expansion) == 0 ? segment_height_expanded : stabilizers[1]) + stabilizers[2] + cut_tol
                                    ],
                                    expand = [
                                        0, 
                                        0, 
                                        y == 0 ? 0.5 * tube_z_diameter + cut_tol : 0, 
                                        y == end_index_y ? 0.5 * tube_z_diameter + cut_tol : 0, 
                                        "auto", 
                                        - (recess_depth + top_plate_height) + cut_tol],
                                    
                                    offset = offset
                                ),
                                if(top_plate_helpers) 
                                    mb_block_part_cube(
                                        block_size = mod_size,
                                        size = [
                                            segment_thickness + 2 * top_plate_helpers[0], 
                                            default_segment_length, 
                                            top_plate_helpers[1] + cut_tol
                                        ],
                                        expand = [
                                            0, 
                                            0, 
                                            y == 0 ? 0.5 * tube_z_diameter + cut_tol : 0, 
                                            y == end_index_y ? 0.5 * tube_z_diameter + cut_tol : 0, 
                                            "auto", 
                                            - (recess_depth + top_plate_height) + cut_tol],
                                        
                                        offset = offset
                                    )
                            ]
                        ]
                ]
            ],

            // Y (lines in X direction)
            for(y = [start_index_y + 1 : end_index_y])
            [
                "list",
                [
                    for(x = [start_index_x : end_index_x])
                        let(
                            offset = mb_block_pos_to_offset(block_obj, [x + 0.5, y, undef])
                            
                        )
                        if(mb_block_render_stabilizer_segment(block_obj, "y", x, y))
                        [
                            "list",
                            [
                                mb_block_part_cube(
                                    block_size = mod_size,
                                    size = [
                                        default_segment_length, 
                                        segment_thickness, 
                                        ((y % stabilizer_expansion) == 0 ? segment_height_expanded : stabilizers[1]) + cut_tol
                                    ],
                                    expand = [
                                        x == 0 ? 0.5 * tube_z_diameter + cut_tol : 0, 
                                        x == end_index_x ? 0.5 * tube_z_diameter + cut_tol : 0, 
                                        0, 
                                        0, 
                                    
                                        "auto", 
                                        - (recess_depth + top_plate_height) + cut_tol],
                                    
                                    offset = offset
                                ),
                                if(top_plate_helpers)
                                    mb_block_part_cube(
                                        block_size = mod_size,
                                        size = [
                                            default_segment_length, 
                                            segment_thickness + 2 * top_plate_helpers[0], 
                                            top_plate_helpers[1] + cut_tol
                                        ],
                                        expand = [
                                            x == 0 ? 0.5 * tube_z_diameter + cut_tol : 0, 
                                            x == end_index_x ? 0.5 * tube_z_diameter + cut_tol : 0, 
                                            0, 
                                            0, 
                                        
                                            "auto", 
                                            - (recess_depth + top_plate_height) + cut_tol],
                                        
                                        offset = offset
                                    )
                            ]
                        ]
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
            _mb_block_part__mask_frame(
                mod_size = mod_size, 
                base_adj = base_adj, 
                bottom = bottom, 
                top = top, 
                cut_tol = cut_tol
            ),
            mb_block_part__base_cutout(
                block_obj, 
                planes = "bottom", 
                bottom = bottom + cut_tol, 
                top = top + cut_tol, 
                red = -clamp[0]
            )
        ]
    ];

/**
* -----------------
* Top Plate Helpers
* -----------------
*/
function mb_block_part__top_plate_helpers(block_obj) =
    let(base_adj = mb_block_get_base_adj(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        bottom = -(base_cutout_depth - top_plate_helpers[1]),
        top = -(top_plate_height + recess_depth) + cut_tol
    ) 
    !top_plate_helpers ? undef : [
        "difference",
        [
            _mb_block_part__mask_frame(
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
                red = - top_plate_helpers[0]
            )
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
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        bottom = cut_tol,
        top = -(mod_size[2] - relief_cut[1])) 
    [
        "difference",
        [
            _mb_block_part__mask_frame(
                mod_size = mod_size, 
                base_adj = base_adj, 
                bottom = bottom, 
                top = top, 
                cut_tol = cut_tol
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
use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_part.scad>;

function mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, wall_gap, red = undef) =
 let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
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
                let(face = gap[0],
                    gap_start_offset = gap[3],
                    gap_end_offset = gap[4]
                )
                [
                    "intersection",
                    [
                        
                        mb_block_part_prismoid(
                            block_size = mod_size, 
                            block_mod = undef,
                            
                            expand = [
                                planes == "bottom" || planes == "all" ? [
                                    for(f = [0 : 3])
                                        mb_face_has_common(face, f) ? base_adj[f] + cut_tol : -wall_thickness + slope_neg[f] + red,
                                    //mb_face_contains(face, 1) ? base_adj[1] + cut_tol : -wall_thickness + slope_neg[1] + red,
                                    //mb_face_contains(face, 2) ? base_adj[2] + cut_tol : -wall_thickness + slope_neg[2] + red,
                                    //mb_face_contains(face, 3) ? base_adj[3] + cut_tol : -wall_thickness + slope_neg[3] + red,
                                    bottom,
                                    top
                                ] : undef,
                                planes == "top" || planes == "all" ? [
                                    
                                    for(f = [0 : 3])
                                        mb_face_has_common(face, f) ? base_adj[f] + cut_tol : slope_neg[f] + (slope_pos[f] <= wall_thickness ? -(wall_thickness - slope_pos[f]) : 0) + red,
                                    //mb_face_has_common(face, 1) ? base_adj[1] + cut_tol : slope_neg[1] + (slope_pos[1] <= wall_thickness ? -(wall_thickness - slope_pos[1]) : 0) + red,
                                    //mb_face_has_common(face, 2) ? base_adj[2] + cut_tol : slope_neg[2] + (slope_pos[2] <= wall_thickness ? -(wall_thickness - slope_pos[2]) : 0) + red,
                                    //mb_face_has_common(face, 3) ? base_adj[3] + cut_tol : slope_neg[3] + (slope_pos[3] <= wall_thickness ? -(wall_thickness - slope_pos[3]) : 0) + red,
                                    bottom,
                                    top
                                ] : undef
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

function mb_block_part__tube(block_obj) = 
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        tube_z_hole_size = mb_block_get_tube_hole_size(block_obj, "z"),
        clamp = mb_block_get_clamp(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        offset = mb_block_pos_to_offset(block_obj, [0.5, 0, 2]))
    [
        "difference",
        [
            mb_block_part_tube(
                block_size = size,
                block_mod = mod,
                radius = [0.5 * tube_z_hole_size, 0.5 * tube_z_diameter],
                clamp_end = [top_plate_helpers[0], top_plate_helpers[1]], 
                clamp_start = [clamp[0], clamp[1], clamp[2]], 
                rounding_radius = 0,
                axis = "z",
                length = base_cutout_depth + cut_tol,
                expand = [base_cutout_depth + cut_tol, "auto"],
                offset = offset
            ),
           /* mb_block_part_tube(
                block_size = size,
                block_mod = mod,
                radius = 0.4, 
                axis = "x",
                length = 2.2,
                expand = [2.1, "auto"],
                offset = offset
            )*/
            
        ]
    ]    
    ;

function mb_block_part__base(block_obj) =
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj))
    mb_block_part_prismoid(
        block_size = size, 
        block_mod = mod,
        socket = socket,
        bevel = bevel,
        slope = slope
    ); 

function mb_block_part__base_adjusted(block_obj) =
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj))
    mb_block_part_prismoid(
        block_size = mod_size, 
        expand = [base_adj],
        socket = socket,
        bevel = mb_bevel_shrink(bevel, base_adj),
        slope = mb_slope_shrink(slope, base_adj)
    ); 

function mb_block_part__base_clamp_outer(block_obj) = 
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        clamp = mb_block_get_clamp(block_obj),
        slope = mb_block_get_slope(block_obj))
    mb_block_part_prismoid(
        block_size = size, 
        block_mod = mod,
        expand = [[
                base_adj[0] + clamp[0],
                base_adj[1] + clamp[0],
                base_adj[2] + clamp[0],
                base_adj[3] + clamp[0],
                -clamp[1],
                -(mod_size[2] - clamp[1] - clamp[2])
            ]]
        ,
        socket = undef,
        bevel = bevel,
        
        slope = undef
    );

function mb_block_part__base_cutout(block_obj, planes = "all", bottom = undef, top = undef, red = undef) = 
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
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
                block_size = size, 
                block_mod = mod,
                
                expand = [
                    planes == "bottom" || planes == "all" ? [
                        -wall_thickness + slope_neg[0] + red,
                        -wall_thickness + slope_neg[1] + red,
                        -wall_thickness + slope_neg[2] + red,
                        -wall_thickness + slope_neg[3] + red,
                        bottom,
                        top
                    ] : undef,
                    planes == "top" || planes == "all" ? [
                        slope_neg[0] + (slope_pos[0] <= wall_thickness ? -(wall_thickness - slope_pos[0]) : 0) + red,
                        slope_neg[1] + (slope_pos[1] <= wall_thickness ? -(wall_thickness - slope_pos[1]) : 0) + red,
                        slope_neg[2] + (slope_pos[2] <= wall_thickness ? -(wall_thickness - slope_pos[2]) : 0) + red,
                        slope_neg[3] + (slope_pos[3] <= wall_thickness ? -(wall_thickness - slope_pos[3]) : 0) + red,
                        bottom,
                        top
                    ] : undef
                ],
                bevel = bevel,
                slope = planes == "all" ? slope_pos : undef,
                socket = planes == "all" ? [base_cutout_min_depth, 0] : undef
            ),
            for(wall_gap = wall_gaps)
                mb_block_part__base_wall_gaps(block_obj, "all", bottom, top, wall_gap, red)
        ]
    ];

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

function mb_block_part__base_cutout_clamp(block_obj) = 
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        clamp = mb_block_get_clamp(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        wall_thickness_clamp = -(wall_thickness + clamp[0]),
        clamp_offset = -clamp[1],
        slope_neg = mb_slope_filter(slope, -1))
    [
        "difference",
        [
            mb_block_part_prismoid(
                block_size = mod_size, 
                expand = [[
                    0,
                    0,
                    0,
                    0,
                    -clamp[1],
                    -(mod_size[2] - clamp[1] - clamp[2])
                ]],
                bevel = undef,
                slope = undef,
                socket = undef
            ),
            mb_block_part__base_cutout(block_obj, planes = "bottom", bottom = -clamp[1] + cut_tol, top = -(mod_size[2] - clamp[1] - clamp[2]) + cut_tol, red = -clamp[0]),
        ]
    ];

function mb_block_part__top_plate_helpers(block_obj) =
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1),
        mod_size = mb_block_get_mod_size(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        bottom = -(base_cutout_depth - top_plate_helpers[1]),
        top = -(top_plate_height + recess_depth) + cut_tol
        ) 
    !top_plate_helpers ? undef : [
        "difference",
        [
            mb_block_part_prismoid(
                block_size = mod_size, 
                expand = [[
                    base_adj[0] + cut_tol,
                    base_adj[1] + cut_tol,
                    base_adj[2] + cut_tol,
                    base_adj[3] + cut_tol,
                    bottom,
                    top
                ]],
                bevel = undef,
                slope = undef
            ),

            mb_block_part__base_cutout(block_obj, planes = "top", bottom = bottom + cut_tol, top = top + cut_tol, red = - top_plate_helpers[0])
        ]
    ];

function mb_block_part__relief_cut(block_obj) =
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        relief_cut = mb_block_get_relief_cut_dim(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj)) 
    [
        "difference",
        [
            mb_block_part_prismoid(
                block_size = mod_size, 
                expand = [[
                    base_adj[0] + cut_tol,
                    base_adj[1] + cut_tol,
                    base_adj[2] + cut_tol,
                    base_adj[3] + cut_tol,
                    0,
                    -(mod_size[2] - relief_cut[1])
                ]],
                bevel = undef,
                slope = undef,
                socket = undef
            ),
            mb_block_part_prismoid(
                block_size = mod_size, 
                expand = [[
                    base_adj[0] - relief_cut[0],
                    base_adj[1] - relief_cut[0],
                    base_adj[2] - relief_cut[0],
                    base_adj[3] - relief_cut[0],
                    cut_tol,
                    -(mod_size[2] - relief_cut[1]) + cut_tol
                ]],
                bevel = bevel,
                slope = slope,
                socket = socket
            )
        ]
    ];

function mb_block_part__recess(block_obj) = 
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
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
        exp_bottom = -(base_cutout_depth + top_plate_height),
        exp_cutout_top = base_cutout_depth + top_plate_height - socket[0])  
    [
        "list",
        [
           mb_block_part_prismoid(
                block_size = size, 
                block_mod = mod,
                expand = [[
                    for(f = [0 : 3])
                        -rwt[f],
                    exp_bottom,
                    cut_tol
                ]],
                socket = undef,
                bevel = bevel,
                slope = slope
            ), 
            
            for(rwg = rwgs)
                let(gap_data = mb_block_recess_wall_gap(block_obj, rwg))
                for(gap = gap_data)
                    let(face = gap[0],
                        gap_start_offset = gap[3],
                        gap_end_offset = gap[4]
                    )
            [
                
                "intersection",
                [
                    mb_block_part_prismoid(
                        block_size = size, 
                        block_mod = mod,
                        expand = [[
                            for(f = [0 : 3])
                                mb_face_has_common(face, f) ? cut_tol : -rwt[f],
                            exp_bottom,
                            exp_cutout_top
                        ]],
                        socket = undef,
                        bevel = bevel,
                        slope = [
                            for(f = [0 : 3])
                                mb_face_has_common(face, f) ? slope_pos[f] : 0, 
                        ]
                    ),

                    mb_block_part_cube(
                        block_size = size, 
                        block_mod = mod,
                        expand = [
                            mb_face_has_common(face, "y") ? - gap_start_offset : 0,
                            mb_face_has_common(face, "y") ? - gap_end_offset : 0,
                            mb_face_has_common(face, "x") ? - gap_start_offset : 0,
                            mb_face_has_common(face, "x") ? - gap_end_offset : 0,
                            cut_tol,
                            0
                        ]
                    )
                ]
            ]
        ]
    ];

function mb_block_part__stud_base_cutout(block_obj) =
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        clamp = mb_block_get_clamp(block_obj),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        wall_thickness_clamp = (wall_thickness +  clamp[0]),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1))
    mb_block_part_prismoid(
        block_size = size, 
        block_mod = mod,
        expand = [
            [
                -wall_thickness_clamp + slope_neg[0] - cut_tol,
                -wall_thickness_clamp + slope_neg[1] - cut_tol,
                -wall_thickness_clamp + slope_neg[2] - cut_tol,
                -wall_thickness_clamp + slope_neg[3] - cut_tol,
                cut_tol,
                -(mod_size[2] - base_cutout_min_depth)
            ]
        ],
        bevel = bevel
    );
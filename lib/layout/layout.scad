use <../utils.scad>;
use <../core/block_model.scad>;
use <../core/block_part.scad>;

function mb_block_part__base_wall_gaps(block_obj, planes, bottom, top, face = 0, gap_pos = 0, gap_length = 1, red = undef) =
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
        red = is_undef(red) ? 0 : red)
    [
        "intersection",
        [
    
            mb_block_part_prismoid(
                block_size = mod_size, 
                block_mod = undef,
                
                expand = [
                    planes == "bottom" || planes == "all" ? [
                        face == 0 ? base_adj[0] + cut_tol : -wall_thickness + slope_neg[0] + red,
                        face == 1 ? base_adj[1] + cut_tol : -wall_thickness + slope_neg[1] + red,
                        face == 2 ? base_adj[2] + cut_tol : -wall_thickness + slope_neg[2] + red,
                        face == 3 ? base_adj[3] + cut_tol : -wall_thickness + slope_neg[3] + red,
                        bottom,
                        top
                    ] : undef,
                    planes == "top" || planes == "all" ? [
                        face == 0 ? base_adj[0] + cut_tol : slope_neg[0] + (slope_pos[0] <= wall_thickness ? -(wall_thickness - slope_pos[0]) : 0) + red,
                        face == 1 ? base_adj[1] + cut_tol : slope_neg[1] + (slope_pos[1] <= wall_thickness ? -(wall_thickness - slope_pos[1]) : 0) + red,
                        face == 2 ? base_adj[2] + cut_tol : slope_neg[2] + (slope_pos[2] <= wall_thickness ? -(wall_thickness - slope_pos[2]) : 0) + red,
                        face == 3 ? base_adj[3] + cut_tol : slope_neg[3] + (slope_pos[3] <= wall_thickness ? -(wall_thickness - slope_pos[3]) : 0) + red,
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
                    face > 1 && face < 4 ? - gap_pos - (gap_pos == 0 ? 0 : wall_thickness) + red : 0,
                    face > 1 && face < 4 ? - (mod_size[0] - gap_length - gap_pos) - wall_thickness + red : 0,
                    face < 2 ? - gap_pos - (gap_pos == 0 ? 0 : wall_thickness) + red : 0,
                    face < 2 ? - (mod_size[1] - gap_length - gap_pos) - wall_thickness + red : 0,
                    cut_tol,
                    0
                ]
            )
        ]
    ];

function mb_block_part__tube(block_obj) = 
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        offset = mb_block_pos_to_offset(block_obj, [0.5, 0, 2]))
    [
        "difference",
        [
            mb_block_part_tube(
                block_size = size,
                block_mod = mod,
                radius = [0.25, 0.5], 
                rounding_radius = 1,
                axis = "x",
                length = 2,
                expand = [2, "auto"],
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
                let(gap = mb_block_base_wall_gap(block_obj, wall_gap))
                    mb_block_part__base_wall_gaps(block_obj, "all", bottom, top, gap[0], gap[1], gap[2], red)
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
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        bottom = -(base_cutout_depth - top_plate_helpers[1]),
        top = -(top_plate_height + recess_depth) + cut_tol
        ) 
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
        recess_depth = mb_block_get_recess_depth(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj),
        rwt = mb_block_get_recess_wall_thickness(block_obj),
        gaps = mb_block_get_recess_wall_gaps(block_obj))  
    [
        "list",
        [
           mb_block_part_prismoid(
                block_size = size, 
                block_mod = mod,
                expand = [[
                    -rwt[0],
                    -rwt[1],
                    -rwt[2],
                    -rwt[3],
                    -(base_cutout_depth + top_plate_height),
                    cut_tol
                ]],
                socket = undef,
                bevel = bevel,
                slope = slope
            ), 
        for(gap = gaps)
        let(gap_data = mb_block_recess_wall_gap(block_obj, gap),
            face = gap_data[0])
        face == 0 ?
        mb_block_part_prismoid(
            block_size = size, 
            block_mod = mod,
            expand = [[
                +cut_tol,
                -rwt[1],
                -rwt[2] + gap_data[2] ,
                -rwt[3] + gap_data[1],
                -(base_cutout_depth + top_plate_height),
                base_cutout_depth + top_plate_height - socket[0]
            ]],
            socket = undef,
            bevel = bevel,
            slope = [slope[0], 0, 0, 0]
        ) :
        face == 1 ? 
        mb_block_part_prismoid(
            block_size = size, 
            block_mod = mod,
            expand = [[
                -rwt[0],
                cut_tol,
                -rwt[2] - gap_data[1],
                -rwt[3] - gap_data[2],
                -(base_cutout_depth + top_plate_height),
                base_cutout_depth + top_plate_height - socket[0]
            ]],
            socket = undef,
            bevel = bevel,
            slope = [0, slope[1], 0, 0]
        ) :
        face == 2 ?
        mb_block_part_prismoid(
            block_size = size, 
            block_mod = mod,
            expand = [[
                -rwt[0] - gap_data[1],
                -rwt[1] - gap_data[2],
                cut_tol,
                -rwt[3],
                -(base_cutout_depth + top_plate_height),
                base_cutout_depth + top_plate_height - socket[0]
            ]],
            socket = undef,
            bevel = bevel,
            slope = [0, 0, slope[2], 0]
        ) :
        face == 3 ?
        mb_block_part_prismoid(
            block_size = size, 
            block_mod = mod,
            expand = [[
                -rwt[0] - gap_data[1],
                -rwt[1] - gap_data[2],
                -rwt[2],
                cut_tol,
                -(base_cutout_depth + top_plate_height),
                base_cutout_depth + top_plate_height - socket[0]
            ]],
            socket = undef,
            bevel = bevel,
            slope = [0, 0, 0, slope[3]]
        ) : undef
        ]
    ];

function mb_block_part__stud_base_cutout(block_obj) =
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
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
        socket = undef,
        bevel = bevel,
        slope = undef
    );
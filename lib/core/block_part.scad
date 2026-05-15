use <geometry.scad>;
use <block_model.scad>;
use <../utils.scad>;
use <../prismoid.scad>;
use <../shape/tube.scad>;

include <../custom.scad>;

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

function mb_block_part_tube(
    block_size,
    block_mod = undef,
    radius,
    rounding_radius = undef,
    clamp_start = undef,
    clamp_end = undef,
    axis = "z",
    length = undef,
    expand = undef,
    offset = undef
) = 
    let(offset = mb_resolve_xyz(xyz = offset, default = [0, 0, 0]),
        mod_min_max = mb_block_mod_min_max(block_size = block_size, block_mod = block_mod),
        mod_size = mod_min_max[1][0],
        axis = mb_axis_to_int(axis),
        h = mod_size[axis],
        h_adj = is_undef(expand) || expand == "auto" || expand == ["auto", "auto"] ? [-0.5 * (!is_undef(length) ? length : h), 0.5 * (!is_undef(length) ? length : h)] :
            [expand[0] == "auto" ? 0.5 * h + expand[1] - (!is_undef(length) ? length : h) : -0.5 * h - expand[0], 
            expand[1] == "auto" ? -0.5 * h - expand[0] + (!is_undef(length) ? length : h) : 0.5 * h + expand[1]]
        
    )
    [
        "tube",
        [
            [
                
                radius,
                h_adj,
                rounding_radius,
                clamp_start,
                clamp_end,
                axis,
                [axis != 0 ? offset[0] : 0, axis != 1 ? offset[1] : 0, axis != 2 ? offset[2] : 0]
            ]
        ]
    ];

function mb_block_part_cube(
    block_size,
    block_mod = undef,
    size = undef,
    expand = undef,
    offset = [0, 0, 0]
) = 
    let(mod_min_max = mb_block_mod_min_max(block_size = block_size, block_mod = block_mod),
        mod_size = mod_min_max[1][0],
        
        si = is_undef(size) ? mod_size : size,
        si2 = [(is_undef(si[0]) ? mod_size[0] : si[0]), (is_undef(si[1]) ? mod_size[1] : si[1]), (is_undef(si[2]) ? mod_size[2] : si[2])],
        s_adj = is_undef(expand) || expand == "auto" || expand == ["auto", "auto", "auto"] ? 
            si :

            [
                [
                    expand[0] == "auto" && expand[1] == "auto" ? 
                        -0.5 * si2[0] : expand[0] == "auto" ? 
                        (0.5 * mod_size[0] + expand[1] - si2[0]) : 
                        -0.5 * (expand[1] == "auto" ? mod_size[0] : si2[0]) - expand[0],
                    expand[2] == "auto" && expand[3] == "auto" ? 
                        -0.5 * si2[1] : expand[2] == "auto" ? 
                        (0.5 * mod_size[1] + expand[3] - si2[1]) : 
                        -0.5 * (expand[3] == "auto" ? mod_size[1] : si2[1]) - expand[2],
                    expand[4] == "auto" && expand[5] == "auto" ? 
                        -0.5 * si2[2] : expand[4] == "auto" ? 
                        (0.5 * mod_size[2] + expand[5] - si2[2]) : 
                        -0.5 * (expand[5] == "auto" ? mod_size[2] : si2[2]) - expand[4]
                ],
                [
                    expand[0] == "auto" && expand[1] == "auto" ? 
                        0.5 * si2[0] : expand[1] == "auto" ? 
                        (-0.5 * mod_size[0] - expand[0] + si2[0]) : 
                        0.5 * (expand[0] == "auto" ? mod_size[0] : si2[0]) + expand[1],
                    expand[2] == "auto" && expand[3] == "auto" ? 
                        0.5 * si2[1] : expand[3] == "auto" ? 
                        (-0.5 * mod_size[1] - expand[2] + si2[1]) : 
                        0.5 * (expand[2] == "auto" ? mod_size[1] : si2[1]) + expand[3],
                    expand[4] == "auto" && expand[5] == "auto" ? 
                        0.5 * si2[2] : expand[5] == "auto" ? 
                        (-0.5 * mod_size[2] - expand[4] + si2[2]) : 
                        0.5 * (expand[4] == "auto" ? mod_size[2] : si2[2]) + expand[5]
                ]
            ]
    )
    [
        "cube",
        [
            [
                s_adj,
                offset
            ]
        ]
    ];

function mb_block_part_prismoid(
    block_size, 
    block_mod = undef, 
    bevel = undef, 
    slope = undef, 
    socket = undef, 
    expand = undef, 
    height = undef
) =
    let(
        mod_min_max = mb_block_mod_min_max(block_size = block_size, block_mod = block_mod),
        mod_size = mod_min_max[1][0],
        min_max = mod_min_max[1][2],
        h_d = is_undef(height) ? [min_max[0][2], min_max[1][2]] : [-0.5 * height, 0.5 * height],

        exp_sin = is_list(expand) && (len(expand) == 2) && is_list(expand[0]) && is_list(expand[1]),
        exp_1 = is_list(expand) && (((len(expand) == 1) && is_list(expand[0])) 
            || (len(expand) == 2 && is_undef(expand[0]) && !is_undef(expand[1])) 
            || (len(expand) == 2 && !is_undef(expand[0]) && is_undef(expand[1]))),
        exp_h = is_undef(expand) ? undef : (!is_undef(expand[0]) ? expand[0] : (!is_undef(expand[1]) ? expand[1] : undef)),

        h = is_undef(exp_h) || (exp_h[4] == "auto" && exp_h[5] == "auto") ? h_d : [exp_h[4] == "auto" ? min_max[1][2] - height : h_d[0], exp_h[5] == "auto" ? min_max[0][2] + height : h_d[1] ],
        h_exp = is_undef(exp_h) ? h : [h[0] - (exp_h[4] == "auto" ? 0 : exp_h[4]), h[1] + (exp_h[5] == "auto" ? 0 : exp_h[5])],
        exp = is_undef(expand) ? undef : exp_sin ? [ is_undef(expand[0]) ? undef : [expand[0][0], expand[0][1], expand[0][2], expand[0][3], 0, 0], is_undef(expand[1]) ? undef : [expand[1][0], expand[1][1], expand[1][2], expand[1][3], 0, 0]] : exp_1 ? [[exp_h[0], exp_h[1], exp_h[2], exp_h[3], 0, 0]] : undef,
        
        
        bevel_matrix = mb_bevel_matrix(is_undef(bevel) ? mb_bevel_resolve(0) : bevel, mod_size, min_max),
        bevel_res = bevel_matrix[0],
        bevel_fil = bevel_matrix[1],
        
        slope = is_undef(slope) ? mb_qc_resolve(0, false) : slope,
        //sl = mb_slope_matrix(slope, bevel_res, mod_size),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1)
    )
    [
        "prismoid",
        [
            [
                mb_prismoid_plane_expand(bevel_fil, 0, slope_neg),
                mb_prismoid_plane_expand(bevel_fil, 1, [-slope_pos[0], -slope_pos[1], -slope_pos[2], -slope_pos[3]]),
                [h_exp, socket, undef, exp]
            ]
        ] // Shape
    ];

function mb_block_part_type_is_builtin(type) = 
    is_string(type) && (
        type == "prismoid" || 
        type == "tube" ||
        type == "cube" ||  
        type == "union" || 
        type == "difference" || 
        type == "intersection"  || 
        type == "list");

function mb_block_part_to_prismoid(
    block_obj,
    part = undef,
    part_params = undef,
    radius = undef,
    mul = undef, 
    add = undef
) =
    is_undef(part) || !is_list(part) ? undef : 
        let(type = part[0], 
            list = part[1])
        mb_block_part_type_is_builtin(type) ?
        [
            type,
            [
                for(list_item = list)
                 
                 mb_block_part_type_is_builtin(list_item[0]) ?

                    mb_block_part_to_prismoid(
                        block_obj,
                        part = list_item,
                        part_params = part_params,
                        radius = radius,
                        mul = mul, 
                        add = add
                    ) : 

                    type == "prismoid" ?
                    mb_prismoid_shape_resolve(
                        shape = list_item, 
                        radius = radius,
                        mul = mul,
                        add = add
                    ) : undef

            ]
        ] : undef;

module mb_block_part(block_obj, part, part_params = undef, debug = false, mul = undef){
    mul = is_undef(mul) ? mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from="grd", to="mm") : mul;
    
    if(!is_undef(part) && is_list(part)){
        type = part[0];
        list = part[1];
        list_len = len(list);
        if(is_string(type) && list_len > 0){
            if(type == "list"){
                for(list_item = list){
                    mb_block_part(block_obj, part = list_item, part_params=part_params, mul = mul, debug = debug);
                }
            }
            else if(type == "union"){
                if(list_len > 1){
                    union(){
                        mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                        for(i = [1 : list_len - 1]){
                            mb_block_part(block_obj, part = list[i], part_params=part_params, mul = mul, debug = debug);
                        }
                    }
                }
                else{
                    mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                }
            }
            else if(type == "difference"){
                if(list_len > 1){
                    difference(){
                        mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                        for(i = [1 : list_len - 1]){
                            mb_block_part(block_obj, part = list[i], part_params=part_params, mul = mul, debug = debug);
                        }
                    }
                }
                else{
                    mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                }
            }
            else if(type == "intersection"){
                if(list_len > 1){
                    intersection(){
                        mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                        for(i = [1 : list_len - 1]){
                            mb_block_part(block_obj, part = list[i], part_params=part_params, mul = mul, debug = debug);
                        }
                    }
                }
                else{
                    mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                }
            }
            else if(type == "prismoid"){
                mb_prismoid(shape = list[0], mul = mul, debug = debug);
                
                mb_block_part(block_obj, part = list[1], part_params=part_params, mul = mul, debug = debug);
            }
            else if(type == "tube"){
                mb_tube(
                    radius = list[0][0],
                    length = list[0][1],
                    rounding_radius = list[0][2],
                    clamp_start = list[0][3],
                    clamp_end = list[0][4],
                    axis = list[0][5],
                    offset = list[0][6],
                    mul = mul,
                    debug = debug
                );
                
                mb_block_part(block_obj, part = list[1], part_params=part_params, mul = mul, debug = debug);
            }
            else if(type == "cube"){
                mb_cube(
                    size = list[0][0],
                    offset = list[0][1],
                    mul = mul
                );
                
                mb_block_part(block_obj, part = list[1], part_params=part_params, mul = mul, debug = debug);
            }
            else{
                mapping = mb_block_custom_module_mapping(block_obj, type);
                
                if(mapping == 0){
                    mb_block_part__custom_0(block_obj, list, part_params, debug, mul);
                }
                else if(mapping == 1){
                    mb_block_part__custom_1(block_obj, list, part_params, debug, mul);
                }
                else if(mapping == 2){
                    mb_block_part__custom_2(block_obj, list, part_params, debug, mul);
                }
                else if(mapping == 3){
                    mb_block_part__custom_3(block_obj, list, part_params, debug, mul);
                }
            }
        }
    }
}

/*
module mb_cylinder(
    
    radius,
    length,
    axis = "z",
    offset = [0, 0, 0],
    
    mul = [1, 1, 1],
    center = true,
    debug = false
){
    offset = mb_resolve_xyz(offset, default = [0, 0, 0]);
    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);
    axis = mb_axis_to_int(axis);
    hl = is_list(length) ? length[1] - length[0] : length;
    length_offset = is_list(length) ? 0.5*(length[0] + length[1]) : 0;
    rot = axis == 0 ? [0, 90 , 0] : axis == 1 ? [90, 0, 0] : [0, 0, 0];
echo (l = length, hl = hl, lo = length_offset);
    translate([offset[0] * mul[0], offset[1] * mul[1], offset[2] * mul[2]])
        rotate(rot)
            translate([0, 0, length_offset * mul[axis]])
                cylinder(r =  radius * mul[axis == 2 ? 0 : 2], h = hl * mul[axis], center = center, $fn = 100);
}*/

/**
* CUBE
*/
module mb_cube(
    size, 
    offset = [0, 0, 0],
    mul = [1, 1, 1],
    radius = 0, 
    xyz_rad = false, 
    center = true, 
    resolution = 80, 
    debug = false
){
    size = is_list(size) && len(size) == 2 && is_list(size[0]) && is_list(size[1]) ? 
        [
            mb_resolve_xyz(size[0]),
            mb_resolve_xyz(size[1])
        ] : [mb_resolve_xyz(size[0], mul = -0.5), mb_resolve_xyz(size[0], mul = 0.5)];

    rad0 = radius == 0 || radius == [0, 0, 0] || (xyz_rad && (radius == [[0,0,0,0],[0,0,0,0],[0,0,0,0]]));

    if(rad0){
        si = [(size[1][0] - size[0][0]) * mul[0], (size[1][1] - size[0][1]) * mul[1], (size[1][2] - size[0][2]) * mul[2]];
        echo (si = si, size0 = size[0], size1 = size[1]);
        translate([(0.5* (size[0][0] + size[1][0]) + offset[0]) * mul[0], 
        (0.5*(size[0][1] + size[1][1]) + offset[1]) * mul[1], 
        (0.5*(size[0][2] + size[1][2]) + offset[2]) * mul[2]])
        
            cube(si, center = center);
    }
    else{
        rad = xyz_rad ? mb_xyz_rad_convert(radius) : radius;

        prismoid_shape = [
        [
            [size[0][0], size[0][1]], [size[0][0], size[1][1]], [size[1][0], size[1][1]], [size[1][0], size[0][1]]],
            undef,
            [[size[0][2], size[1][2]]]
        ];

        mb_prismoid(shape = prismoid_shape, add = [offset], mul = mul, radius = rad, align = center ? "center" : "start", resolution = resolution, debug = debug);
    }
}

/*
* ----------------------
* START TESTING (REMOVE)
* ----------------------
*/


sr = [80, 10.1, 10];
corner = [1,0];


*color("#ffffff55")
mb_rounding_corner(corner = corner, radius = sr, angle = [0, 0, 0, 0], resolution = 80);


*translate([0, -300, 0])
mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-0, -50], undef, [-0, 50], undef, [40, 50], undef, [40, -50], undef]
], height = 120, socket = [20, 0], socket_top = undef, radius = 0, resolution = 160);

translate([0, 300, 0])
mb_prismoid(shape = [
    [[-70, -50], [-140, 0], [-70, 50], undef, [50, 40], undef, [50, -40], undef],
    
    [[-20, -30], [-70, 0], [-20, 30], undef, [20, 40], undef, [50, -40], undef]
], height = 120, socket = [20, 0], radius = [15, 14, 6, 12], resolution = 160, debug=true, align="sticky");

translate([200, 0, 0])
mb_cube(
    debug = true, 
    size = [4, 4, 3], 
    mul = [8, 8, 3.2],
    radius = [[[1, 1, 0], [1, 1, 0], [1, 1, 0], [1, 1, 0]], [[1.2, 1.2, 1, 2], [1.2, 1.2, 1, 1.2], [0.1, 0.1, 0.1,0.1], [1, 1, 1, 1]]]);


*mb_prismoid(shape = [
    [[-20, -30, undef, [10,10,0]], [-20, 30, undef,[10,10,0]], [50, 30,undef, [10,10,0]], [50, -30,undef, [10,10,0]]],
    [[-20, -30, undef,[10,10,0]], [-20, 30,undef, [10,10,0]], [20, 30, undef,[10,10,0]], [20, -30, undef,[10,10,0]]]
    
], height = 120, socket = [0, 20], radius = 0, resolution = 160);



*mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-20, -50], undef, [-20, 50], undef, [40, 40], undef, [20, -50], undef]
], height = 120, socket = [20, 20], radius = 0, resolution = 160, debug=true);
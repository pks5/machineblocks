use <geometry.scad>;
use <block_model.scad>;
use <../utils.scad>;
use <../prismoid.scad>;

include <../custom.scad>;

function mb_block_part__base_adjusted(block_obj) =
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj))
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = base_adj,
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
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
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

function mb_block_part__base_cutout(block_obj) = 
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
        slope_pos = mb_slope_filter(slope, 1))
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        
        expand = [
            [
                -wall_thickness + slope_neg[0],
                -wall_thickness + slope_neg[1],
                -wall_thickness + slope_neg[2],
                -wall_thickness + slope_neg[3],
                cut_tol,
                -(top_plate_height + recess_depth)
            ],
            [
                slope_neg[0] + (slope_pos[0] <= wall_thickness ? -(wall_thickness - slope_pos[0]) : 0),
                slope_neg[1] + (slope_pos[1] <= wall_thickness ? -(wall_thickness - slope_pos[1]) : 0),
                slope_neg[2] + (slope_pos[2] <= wall_thickness ? -(wall_thickness - slope_pos[2]) : 0),
                slope_neg[3] + (slope_pos[3] <= wall_thickness ? -(wall_thickness - slope_pos[3]) : 0),
                cut_tol,
                -(top_plate_height + recess_depth)
            ]
        ],
        socket = [base_cutout_min_depth, 0],
        bevel = bevel,
        slope = slope_pos
    );

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
        slope_pos = mb_slope_filter(slope, -1))
    [
        "difference",
        [
            _mb_block_to_shape_parts(
                size = size, 
                mod = mod,
                adj = [
                    0,
                    0,
                    0,
                    0,
                    -clamp[1],
                    -(mod_size[2] - clamp[1] - clamp[2])
                    ]
                ,
                bevel = undef,
                slope = undef,
                socket = socket
            ),
            _mb_block_to_shape_parts(
                size = size, 
                mod = mod,
                expand = [[
                        wall_thickness_clamp + slope_pos[0],
                        wall_thickness_clamp + slope_pos[1],
                        wall_thickness_clamp + slope_pos[2],
                        wall_thickness_clamp + slope_pos[3],
                        -clamp[1] + cut_tol,
                        -(mod_size[2] - clamp[1] - clamp[2]) + cut_tol
                    ]]
                ,
                socket = undef,
                bevel = bevel,
                
                slope = undef
            )
        ]
    ];

function mb_block_part__top_plate_helpers(block_obj) =
    let(size = mb_block_obj_size(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj)) 
    [
        "difference",
        [
            _mb_block_to_shape_parts(
                size = size, 
                mod = mod,
                adj = [
                    base_adj[0] + cut_tol,
                    base_adj[1] + cut_tol,
                    base_adj[2] + cut_tol,
                    base_adj[3] + cut_tol,
                    -(base_cutout_depth - top_plate_helpers[1]),
                    -(top_plate_height + recess_depth)
                    ]
                ,
                bevel = undef,
                slope = undef
            ),
            _mb_block_to_shape_parts(
                size = size, 
                mod = mod,
                expand = [
                    -wall_thickness - top_plate_helpers[0],
                    -wall_thickness - top_plate_helpers[0],
                    -wall_thickness - top_plate_helpers[0],
                    -wall_thickness - top_plate_helpers[0],
                    -(base_cutout_depth - top_plate_helpers[1]) + cut_tol,
                    -(top_plate_height + recess_depth) + cut_tol
                    ]
                ,
                bevel = bevel,
                slope = undef
            )
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
            _mb_block_to_shape_parts(
                size = size, 
                mod = mod,
                adj = [
                    base_adj[0] + cut_tol,
                    base_adj[1] + cut_tol,
                    base_adj[2] + cut_tol,
                    base_adj[3] + cut_tol,
                    0,
                    -(mod_size[2] - relief_cut[1])
                    ]
                ,
                bevel = undef,
                slope = undef,
                socket = undef
            ),
            _mb_block_to_shape_parts(
                size = size, 
                mod = mod,
                adj = [
                    base_adj[0] - relief_cut[0],
                    base_adj[1] - relief_cut[0],
                    base_adj[2] - relief_cut[0],
                    base_adj[3] - relief_cut[0],
                    cut_tol,
                    -(mod_size[2] - relief_cut[1]) + cut_tol
                    ]
                ,
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
           _mb_block_to_shape_parts(
                size = size, 
                mod = mod,
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
        let(gap_data = mb_recess_wall_gap(block_obj, gap),
            face = gap_data[0])
        face == 0 ?
        _mb_block_to_shape_parts(
            size = size, 
            mod = mod,
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
        _mb_block_to_shape_parts(
            size = size, 
            mod = mod,
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
        _mb_block_to_shape_parts(
            size = size, 
            mod = mod,
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
        _mb_block_to_shape_parts(
            size = size, 
            mod = mod,
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

function mb_block_part_shapes(block_obj, part = undef, part_params = undef) = 
    let(
        size = mb_block_obj_size(block_obj),
        socket = mb_block_get_slope_socket(block_obj),
        base_adj = mb_block_get_base_adj(block_obj),
        bevel = mb_block_get_bevel(block_obj), 
        slope = mb_block_get_slope(block_obj),
        mod = mb_block_get_size_mod(block_obj),
        mod_size = mb_block_get_mod_size(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        top_plate_height = mb_block_get_top_plate_height(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        base_cutout_min_depth = mb_block_get_base_cutout_min_depth(block_obj),
        recess_depth = mb_block_get_recess_depth(block_obj),
        relief_cut = mb_block_get_relief_cut_dim(block_obj),
        clamp = mb_block_get_clamp(block_obj),
        cut_tol = mb_block_get_cut_tolerance(block_obj)
    )

    part == "stud_base_cutout" ?    
    let(wall_thickness_clamp = (wall_thickness +  clamp[0]),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1))
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
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
    ) :

    part == "simple" ?
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        socket = socket,
        bevel = bevel,
        slope = slope
    ) : undef;

function _mb_block_to_shape_parts(
    size, 
    mod, 
    bevel = undef, 
    slope = undef, 
    socket = undef, 
    expand = undef, 
    adj = undef
) =
    let(
        
        mod_min_max = mb_block_mod_min_max(size = size, mod = mod, adj = adj),
        mod_size = mod_min_max[1][0],
        min_max = mod_min_max[1][2],
        
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
                [[min_max[0][2], min_max[1][2]], socket, undef, expand]
            ]
        ] // Shape
    ];

function mb_block_part_to_prismoid(
    block_obj,
    part = undef,
    part_params = undef,
    radius = undef,
    mul = undef, 
    add = undef
) =
    let(part_shapes = is_string(part) ? mb_block_part_shapes(block_obj, part = part, part_params = part_params) : part)
    
    is_undef(part_shapes) || !is_list(part_shapes) ? undef : 
        (part_shapes[0] == "prismoid" || part_shapes[0] == "union" || part_shapes[0] == "difference" || part_shapes[0] == "intersection"  || part_shapes[0] == "list") ?
        [
            part_shapes[0],
            [
                for(part_shape = part_shapes[1])
                 
                 is_string(part_shape[0]) ?

                    mb_block_part_to_prismoid(
                        block_obj,
                        part = part_shape,
                        part_params = part_params,
                        radius = radius,
                        mul = mul, 
                        add = add
                    ) : 

                    mb_prismoid_shape_resolve(
                        shape = part_shape, 
                        radius = radius,
                        mul = mul,
                        add = add
                    )

            ]
        ] : undef;

module mb_block_part(block_obj, part, part_params = undef, debug = false, mul = undef){
    mul = is_undef(mul) ? mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from="grd", to="mm") : mul;
    
    part_node = is_string(part) ? mb_block_part_shapes(block_obj, part = part, part_params = part_params) : part;
        
    if(!is_undef(part_node) && is_list(part_node)){
        type = part_node[0];
        list = part_node[1];
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



/**
* CUBE
*/
module mb_cube(
    size, 
    radius = 0, 
    xyz_rad = false, 
    center = true, 
    resolution = 80, 
    debug = false
){
    size = mb_resolve_xyz(xyz = size);
    rad0 = radius == 0 || radius == [0, 0, 0] || (xyz_rad && (radius == [[0,0,0,0],[0,0,0,0],[0,0,0,0]]));

    if(rad0){
        cube(size, center = center);
    }
    else{
        rad = xyz_rad ? mb_xyz_rad_convert(radius) : radius;

        block_obj = mb_block_obj(size);

        mul = mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from="grd", to="mm");
        prismoid_shape = mb_block_part_to_prismoid(
            block_obj,
            part = "simple",
            radius = radius,
            mul = mul
        );

        mb_prismoid(shape = prismoid_shape[0], align = center ? "center" : "start", resolution = resolution, debug = debug);
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
    radius = [[[1, 1, 0], [1, 1, 0], [1, 1, 0], [1, 1, 0]], [[1.2, 1.2, 1, 2], [1.2, 1.2, 1, 1.2], [0.1, 0.1, 0.1,0.1], [1, 1, 1, 1]]]);


*mb_prismoid(shape = [
    [[-20, -30, undef, [10,10,0]], [-20, 30, undef,[10,10,0]], [50, 30,undef, [10,10,0]], [50, -30,undef, [10,10,0]]],
    [[-20, -30, undef,[10,10,0]], [-20, 30,undef, [10,10,0]], [20, 30, undef,[10,10,0]], [20, -30, undef,[10,10,0]]]
    
], height = 120, socket = [0, 20], radius = 0, resolution = 160);



*mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-20, -50], undef, [-20, 50], undef, [40, 40], undef, [20, -50], undef]
], height = 120, socket = [20, 20], radius = 0, resolution = 160, debug=true);
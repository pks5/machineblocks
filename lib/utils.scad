function mb_resolve_xyz(xyz, default = [0, 0, 0], mul = undef, min_value = undef, precision = undef) = 
    let(m = is_undef(mul) ? [1, 1, 1] : mb_resolve_xyz(mul, default = [1, 1, 1]),
        r = is_list(xyz) ? 
        ([
            m[0] * (is_num(xyz[0]) ? xyz[0] : (is_undef(default) ? 0 : default[0])), 
            m[1] * (is_num(xyz[1]) ? xyz[1] : (is_undef(default) ? 0 : default[1])), 
            m[2] * (is_num(xyz[2]) ? xyz[2] : (is_undef(default) ? 0 : default[2]))
        ]) : 
        is_num(xyz) ? [m[0] * xyz, m[1] * xyz, m[2] * xyz] : default,
        p = is_undef(r) ? undef : (is_undef(precision) ? r : [mb_round_prec(r[0], precision), mb_round_prec(r[1], precision), mb_round_prec(r[2], precision)]))
    is_undef(p) ? undef : (is_undef(min_value) ? p : [max(min_value, p[0]), max(min_value, p[1]), max(min_value, p[2])]);

/*
* ---------------
* START BLOCK OBJ
* ---------------
*/


function mb_bounding_box(size) = [ceil(size[0]), ceil(size[1]), ceil(size[2])];

function _mb_block_to_shape_parts(size, mod, bevel, slope, socket, adj = undef) =
    let(
        mod_min_max = mb_block_mod_min_max(size = size, mod = mod, adj = adj),
        mod_size = mod_min_max[1][0],
        min_max = mod_min_max[1][2],
        
        bevel_matrix = mb_bevel_matrix(bevel, mod_size, min_max),
        bevel_res = bevel_matrix[0],
        bevel_fil = bevel_matrix[1],
        
        sl = mb_slope_matrix(slope, bevel_res, mod_size)
    )
    [
        [
            [   
                for(i=[0:7])
                    is_undef(bevel_fil[i]) ? undef : [bevel_fil[i][0] + sl[0][i][0], bevel_fil[i][1] + sl[0][i][1]]
            ],
            [
                for(i=[0:7])
                    is_undef(bevel_fil[i]) ? undef : [bevel_fil[i][0] + sl[1][i][0], bevel_fil[i][1] + sl[1][i][1]]
            ]
        ],
        [min_max[0][2], min_max[1][2]], // Height
        socket
    ];

function mb_unit_mul(grid_cfg, scale = 1, from = "grd", to="mm") =
    let(
        mul = (from == "grd" && to == "mm") ? [grid_cfg[1] * grid_cfg[0] * scale, grid_cfg[1] * grid_cfg[0] * scale, grid_cfg[2] * grid_cfg[0] * scale] :
              (from == "grd" && to == "mbu") ?  [grid_cfg[1], grid_cfg[1], grid_cfg[2]] :
              (from == "mbu" && to == "grd") ? [1 / grid_cfg[1], 1 / grid_cfg[1], 1 / grid_cfg[2]] :
              (from == "mbu" && to == "mm") ? grid_cfg[0] * scale :
              (from == "mm" && to == "mbu") ? 1 / (grid_config[0] * scale) :
              (from == "mm" && to == "grd") ? [1 / (grid_cfg[1] * grid_cfg[0] * scale), 1 / (grid_cfg[1] * grid_cfg[0] * scale), 1 / (grid_cfg[2] * grid_cfg[0] * scale)] : undef
    )
    mul;

function mb_block_mod_min_max(size, mod, adj = undef) =
    let(bb = mb_bounding_box(size),
        c = [0.5 * bb[0], 0.5 * bb[1], 0.5 * bb[2]],
        mod_final = is_undef(adj) ? mod : mb_array_add(mod, adj),
        mi = [-mod_final[0], -mod_final[2], is_undef(adj) ? 0 : -adj[4]],
        ma = [size[0] + mod_final[1], size[1] + mod_final[3], size[2] + mod_final[5]],
        mod_size = [
                    size[0] + mod_final[0] + mod_final[1],
                    size[1] + mod_final[2] + mod_final[3],
                    size[2] + mod_final[4] + mod_final[5]
                ],
        
        min_max = [
                [mi[0] - c[0], mi[1] - c[1], mi[2] - c[2]], // min from org center
                [ma[0] - c[0], ma[1] - c[1], ma[2] - c[2]] // max from org center
            ],

        
    )
        [
            [size, bb, c],
            [
                mod_size,
                mb_bounding_box(mod_size),
                min_max
            ],
            
            [mi, ma]
            
        ];

function mb_block_obj(
    size, 
    size_mod = undef, 
    size_adj = [-0.1, 0],
    base_adj = undef,
    bevel = undef,
    slope = undef,
    grid_cfg = [1.6, 5, 2], 
    scale = 1,
    top_plate_height = [1, -0.6],
    recess_depth = "auto",
    slope_base = [1.333, 1],
    wall_thickness = ["auto", -0.1],
    cutout_max_depth = 5,
    cutout_type = "standard",
    recess = false,
    recess_depth = "auto",
    recess_wall_thickness = 0.333,
    clamp = [0.1, 0.25, 0.5],
    clamp_outer = true,
    stud_diameter = 3,
    relief_cut = false,
    relief_cut_dim = [0.375, 0.375]
) =
    let(mul_mbu_to_grid = mb_unit_mul(grid_cfg, scale = scale, from="mbu", to="grd"),
        mul_mm_to_grid = mb_unit_mul(grid_cfg, scale = scale, from="mm", to="grd"),
        
        si = mb_resolve_xyz(xyz = size, default = [1, 1, 1]),
        mod = mb_qc_resolve(qc = size_mod, cube = true),
        
        mod_min_max = mb_block_mod_min_max(size = size, mod = mod),
        mod_size = mod_min_max[1][0],
        min_max = mod_min_max[1][2],

        bsa_grd = mb_qc_resolve(
            qc = base_adj, 
            cube = true, 
            default = [size_adj[0], size_adj[0], size_adj[0], size_adj[0], 0, size_adj[1]],
            mul = mul_mm_to_grid
        ),
        
        adj_size = [
            mod_size[0] + bsa_grd[0] + bsa_grd[1],
            mod_size[1] + bsa_grd[2] + bsa_grd[3],
            mod_size[2] + bsa_grd[4] + bsa_grd[5],
        ],

        /*
        * Top Plate, Recess Depth, Base Cutout
        */
        top_plate_height_pref = top_plate_height[0] * mul_mbu_to_grid[2] + top_plate_height[1] * mul_mm_to_grid[2],
        
        recess_depth_max = mod_size[2] - top_plate_height_pref - (cutout_type == "none" ? 0 : 1 - top_plate_height_pref),
        recess_depth_final = recess ? (recess_depth != "auto" ? min(recess_depth, recess_depth_max) : recess_depth_max) : 0,
        recess_walls = mb_qc_resolve(
            qc = recess_wall_thickness, 
            cube = true
        ),
        
        cutout_depth_calc = max(0, min(cutout_max_depth * mul_mbu_to_grid[2], mod_size[2] - top_plate_height_pref - recess_depth_final)),
        
        top_plate_height_final = mod_size[2] - recess_depth_final - cutout_depth_calc,
        cutout_depth = cutout_type == "none" ? 0 : cutout_depth_calc,

        /*
        * Base Wall Thickness
        */
        p_diameter = grid_cfg[1] - stud_diameter,
        wall_thickness_pref = (wall_thickness[0] == "auto" ? 0.5 * p_diameter : wall_thickness[0]) * mul_mbu_to_grid[0],
        wall_thickness_final = wall_thickness_pref + wall_thickness[1] * mul_mm_to_grid[0],
        wall_thickness_clamp = wall_thickness_final + clamp[0] * mul_mm_to_grid[0],
    
        clamp_final = [clamp[0] * mul_mm_to_grid[0], clamp[1] * mul_mbu_to_grid[2], clamp[2] * mul_mbu_to_grid[2], clamp_outer],
        relief_cut_final = [relief_cut_dim[0] * mul_mbu_to_grid[0], relief_cut_dim[1] * mul_mbu_to_grid[2]]
    )
        [
            [
                mod_min_max[0], 
                mod_min_max[1], 
                [adj_size]
            ], // 0 - Original Size / Mod Size
            [mb_bevel_resolve(bevel), mb_qc_resolve(slope, false)], // 1 - Bevel / Slope
            mod_min_max[3], // 2 - Min / Max (modified)
            [ 
                [floor(-mod[0]), floor(-mod[2]), 0], // Min Index (modified)
                [ceil(si[0] + mod[1] - 1), ceil(si[1] + mod[3] - 1), ceil(si[2] + mod[5] - 1)] // Max Index (modified)
            ], // 3 - Min / Max Index
            [cutout_depth, top_plate_height_final, recess_depth_final, wall_thickness_final, clamp_final], // 4 - Top Plate Height
            [slope_base[0] * mul_mbu_to_grid[2], slope_base[1] * mul_mbu_to_grid[2]], // 5 - Slope Base 
            [mod, bsa_grd], // 6 - Adjustments
            [grid_cfg, scale], // 7 - Units
            [recess, recess_walls, relief_cut, relief_cut_final] // 8 - Recesss & Relief Cut
        ];

/*
* Getters
*/

function mb_block_obj_size(block_obj, bb = false, unit = "grd") = 
    mb_block_unit_convert(block_obj, block_obj[0][0][bb ? 0 : 1], from = "grd", to = unit);

function mb_block_obj_size_mod(block_obj, bb = false, unit = "grd") = 
    mb_block_unit_convert(block_obj, block_obj[0][1][bb ? 0 : 1], from = "grd", to = unit);

function mb_block_obj_size_adj(block_obj, unit = "grd") = 
    mb_block_unit_convert(block_obj, block_obj[0][2][0], from = "grd", to = unit);

function mb_block_size_mod(block_obj, unit = "grd") = mb_block_unit_convert(block_obj, block_obj[6][0], from = "grd", to = unit);

function mb_block_base_adj(block_obj, unit = "grd") = mb_block_unit_convert(block_obj, block_obj[6][1], from = "grd", to = unit);

function mb_block_grid_cfg(block_obj) = block_obj[7][0];

function mb_block_scale(block_obj) = block_obj[7][1];

function mb_block_shape_parts(block_obj, mode = "normal") = 
    let(size = block_obj[0][0][0],
        socket = block_obj[5],
        bevel = block_obj[1][0], 
        slope = block_obj[1][1],
        mod = block_obj[6][0],
        mod_size = block_obj[0][1][0],
        base_adj = block_obj[6][1],
        cut_tol = 0.01
        )
    mode == "base_adjusted" ?    
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = base_adj,
        socket = socket,
        bevel = bevel,
        slope = slope
    ) :
    mode == "recess" ?  
    let(rwt = block_obj[8][1])  
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = [
            -rwt[0],
            -rwt[1],
            -rwt[2],
            -rwt[3],
            -block_obj[4][0],
            cut_tol
        ],
        socket = socket,
        bevel = bevel,
        slope = slope
    ) :
    mode == "base_cutout" ?    
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = [
            -block_obj[4][3],
            -block_obj[4][3],
            -block_obj[4][3],
            -block_obj[4][3],
            cut_tol,
            -(block_obj[4][1] + block_obj[4][2])],
        socket = socket,
        bevel = bevel,
        slope = slope
    ) :

    mode == "base_cutout_clamp_mask" ?
    
    //let(wall_thickness_clamp = -(block_obj[4][3] + block_obj[4][4][0]))
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = [
            0,
            0,
            0,
            0,
            -block_obj[4][4][1],
            -(mod_size[2] - block_obj[4][4][1] - block_obj[4][4][2])
            ]
        ,
        bevel = mb_bevel_resolve(0),
        slope = mb_qc_resolve(0, false),
        socket = socket
    ):

    mode == "base_cutout_clamp_mask_inner" ?
    let(wall_thickness_clamp = -(block_obj[4][3] + block_obj[4][4][0]),
       clamp_offset = -block_obj[4][4][1])
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = [
                wall_thickness_clamp,
                wall_thickness_clamp,
                wall_thickness_clamp,
                wall_thickness_clamp,
                -block_obj[4][4][1] + cut_tol,
                -(mod_size[2] - block_obj[4][4][1] - block_obj[4][4][2]) + cut_tol
            ]
        ,
        socket = socket,
        bevel = bevel,
        
        slope = slope
    ):

    mode == "base_clamp_outer" ?
    let(clamp_thickness = block_obj[4][4][0],
       clamp_offset = -block_obj[4][4][1])
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = [
                base_adj[0] + clamp_thickness,
                base_adj[1] + clamp_thickness,
                base_adj[2] + clamp_thickness,
                base_adj[3] + clamp_thickness,
                clamp_offset,
                -(mod_size[2] - block_obj[4][4][1] - block_obj[4][4][2])
            ]
        ,
        socket = socket,
        bevel = bevel,
        
        slope = slope
    ):

    mode == "relief_cut_mask" ?
    
    //let(wall_thickness_clamp = -(block_obj[4][3] + block_obj[4][4][0]))
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = [
            base_adj[0] + cut_tol,
            base_adj[1] + cut_tol,
            base_adj[2] + cut_tol,
            base_adj[3] + cut_tol,
            0,
            -(mod_size[2] - block_obj[8][3][1])
            ]
        ,
        bevel = mb_bevel_resolve(0),
        slope = mb_qc_resolve(0, false),
        socket = socket
    ):

    mode == "relief_cut" ?
    
    let(relief_cut_final = block_obj[8][3])
    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        adj = [
            base_adj[0] - relief_cut_final[0],
            base_adj[1] - relief_cut_final[0],
            base_adj[2] - relief_cut_final[0],
            base_adj[3] - relief_cut_final[0],
            + cut_tol,
            -(mod_size[2] - relief_cut_final[1]) + cut_tol
            ]
        ,
        bevel = bevel,
        slope = slope,
        socket = socket
    ):

    _mb_block_to_shape_parts(
        size = size, 
        mod = mod,
        socket = socket,
        bevel = bevel,
        slope = slope
    );
/*
* Methods
*/

function mb_block_unit_convert(block_obj, v, from = "grd", to="mm") = 
    let(mul = mb_unit_mul(mb_block_grid_cfg(block_obj), scale = mb_block_scale(block_obj), from = from, to = to))
    is_num(v) || (is_list(v) && len(v) <= 3) ? 
        mb_resolve_xyz(xyz = v, mul = mul) :
        (is_list(v) && len(v) == 4) ? [v[0] * mul[0], v[1] * mul[0], v[2] * mul[1], v[3] * mul[1]] :
        (is_list(v) && len(v) <= 6) ? [v[0] * mul[0], v[1] * mul[0], v[2] * mul[1], v[3] * mul[1], v[4] * mul[2], len(v) > 5 ? v[5] * mul[2] : undef] :
        undef;



/*
* -------------
* END BLOCK OBJ
* -------------
*/

function mb_rounding_radius(radius, gridSize) = (is_num(radius) ? 
        [radius * gridSize, radius * gridSize, radius * gridSize, radius * gridSize] 
        : [radius[0] * gridSize, radius[1] * gridSize, radius[2] * gridSize, radius[3] * gridSize]); 

/*
* Extracts the (x, y, z) radius from the base radius as four dimensional vector
*/
function mb_base_rounding_radius_xyz(radius, i, gridSize) = is_num(radius) ? 
        [radius * gridSize, radius * gridSize, radius * gridSize, radius * gridSize] : 
        mb_rounding_radius(radius[i], gridSize);

function mb_base_rounding_radius(radius, gridSizeXY, gridSizeZ) = [
    mb_base_rounding_radius_xyz(radius, 0, gridSizeZ),
    mb_base_rounding_radius_xyz(radius, 1, gridSizeZ),
    mb_base_rounding_radius_xyz(radius, 2, gridSizeXY)
];

/*
* Creates a four dimensional vector with the inner rounding radius
* Deprecated use mb_calc_rel_radius instead!
*/
function mb_base_cutout_radius(cutoutRadius, baseRadiusZ, minSide) = cutoutRadius == 0 ? [0,0,0,0] : (cutoutRadius[0] == undef ? 
    [
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[0], minSide), 
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[1], minSide),
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[2], minSide),
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[3], minSide)   
    ] : 
    [
        mb_calc_rounding_radius(cutoutRadius[0], baseRadiusZ[0], minSide), 
        mb_calc_rounding_radius(cutoutRadius[1], baseRadiusZ[1], minSide),
        mb_calc_rounding_radius(cutoutRadius[2], baseRadiusZ[2], minSide),
        mb_calc_rounding_radius(cutoutRadius[3], baseRadiusZ[3], minSide)   
    ]);
    
function mb_calc_rounding_radius(radius, baseRadius, minSide) = radius < 0 ? max(0, baseRadius * ((minSide + 2*radius) / minSide)) : radius;

/*
* Calculate relative radius
*/
function mb_base_rel_radius(cutoutRadius, baseRadiusZ, minSide, alwaysRel) = 
    let(newRadius = is_list(cutoutRadius) ? cutoutRadius : [cutoutRadius, cutoutRadius, cutoutRadius, cutoutRadius])
    [
        newRadius[0] >= 0 && !alwaysRel ? newRadius[0] : mb_calc_rel_radius(newRadius[0], baseRadiusZ[0], minSide), 
        newRadius[1] >= 0 && !alwaysRel ? newRadius[1] : mb_calc_rel_radius(newRadius[1], baseRadiusZ[1], minSide),
        newRadius[2] >= 0 && !alwaysRel ? newRadius[2] : mb_calc_rel_radius(newRadius[2], baseRadiusZ[2], minSide),
        newRadius[3] >= 0 && !alwaysRel ? newRadius[3] : mb_calc_rel_radius(newRadius[3], baseRadiusZ[3], minSide)   
    ];

function mb_calc_rel_radius(radius, baseRadius, minSide) = max(0, baseRadius * ((minSide + 2*radius) / minSide));

function mb_resolve_side_quad(quad, multiplier = 1) = 
    is_list(quad) ? 
    (len(quad) == 2 ? [quad[0]*multiplier, quad[0]*multiplier, quad[1]*multiplier, quad[1]*multiplier] : [quad[0]*multiplier, quad[1]*multiplier, quad[2]*multiplier, quad[3]*multiplier]) 
    : [quad * multiplier, quad * multiplier, quad * multiplier, quad * multiplier];



/*
* Whether a given string is empty
*/
function mb_is_empty_string(s) = (s == undef) || len(s) == 0;

/*
* get the grid size
*/

function mb_grid_size_x(grid, slope) = slope != false ? grid[0] + (slope[0] < 0 ? slope[0] : 0) + (slope[1] < 0 ? slope[1] : 0) : grid[0];
function mb_grid_size_y(grid, slope) = slope != false ? grid[1] + (slope[2] < 0 ? slope[2] : 0) + (slope[3] < 0 ? slope[3] : 0) : grid[1];


/*
* Determine position of grid cell relative to object origin
*/ 
function mb_grid_pos_x(a, grid, gridSizeXY) = (a - 0.5 * (grid[0] - 1)) * gridSizeXY;
function mb_grid_pos_y(b, grid, gridSizeXY) = (b - 0.5 * (grid[1] - 1)) * gridSizeXY;

function mb_resolve_bevel_horizontal(bevelHorizontal, grid, gridSizeXY) = 
    let(x1 = mb_grid_pos_x(bevelHorizontal[0][0] - 0.5, grid, gridSizeXY),
        y1 = mb_grid_pos_y(bevelHorizontal[0][1] - 0.5, grid, gridSizeXY),
        x2 = mb_grid_pos_x(bevelHorizontal[1][0] - 0.5, grid, gridSizeXY),
        y2 = mb_grid_pos_y(grid[1] - 1 + bevelHorizontal[1][1] + 0.5, grid, gridSizeXY),
        x3 = mb_grid_pos_x(grid[0] - 1 + bevelHorizontal[2][0] + 0.5, grid, gridSizeXY),
        y3 = mb_grid_pos_y(grid[1] - 1 + bevelHorizontal[2][1] + 0.5, grid, gridSizeXY),
        x4 = mb_grid_pos_x(grid[0] - 1 + bevelHorizontal[3][0] + 0.5, grid, gridSizeXY),
        y4 = mb_grid_pos_y(bevelHorizontal[3][1] - 0.5, grid, gridSizeXY)
        )
    [
        [x1, y1],
        [x2, y2],
        [x3, y3],
        [x4, y4]
    ];

/*
* Resolve base side adjustment
*/
//function mb_calc_side_adjusmtent(baseSideAdjustment, cropResolved) =
//    [baseSideAdjustment[0] - cropResolved[0], baseSideAdjustment[1] - cropResolved[1], baseSideAdjustment[2] - cropResolved[2], baseSideAdjustment[3] - cropResolved[3]];

/*
* Strings
*/

function mb_str_starts_with(s, prefix, i=0) =
    (i >= mb_str_len(prefix)) ? true :
    (mb_char_at(s, i) != mb_char_at(prefix, i)) ? false :
    mb_str_starts_with(s, prefix, i+1);

function mb_str_len(s, i=0) =
    (str(s[i]) == "undef") ? i : mb_str_len(s, i+1);

function mb_char_at(s, i) = str(s[i]);

function mb_substr_from(s, start, i=0) =
    (start + i >= mb_str_len(s)) ? "" :
    str(mb_char_at(s, start + i), mb_substr_from(s, start, i+1));

/*
* ARRAYS
*/

function mb_array_filter_ns(arr, ns) =
    is_list(arr) ? [
        for (item = arr)
            if (is_list(item) && 
                len(item) > 0 && 
                is_string(item[0]) &&
                mb_str_starts_with(item[0], str(ns, ".")))
                let(newKey = mb_substr_from(item[0], len(ns) + 1))
                    concat([newKey], mb_array_slice(item, 1))
    ] : [];

function mb_to_array(v) = is_list(v) ? v : [v];

function mb_in_array(arr, val) =
    len([for (a = arr) if (a == val) 1]) > 0;

function mb_array_slice(a, from, to=undef) =
    [
        for (i = [from : 1 : (is_undef(to) ? len(a) - 1 : to - 1)])
            a[i]
    ];

function mb_array_sub_simple(a, b) =
    [for (i = [0 : len(a)-1]) a[i] - b[i]];

function mb_array_add(a, b) =
    is_list(a) && is_list(b)
        ? [for (i = [0 : len(a)-1]) a[i] + b[i]]
        : is_list(a)
            ? [for (i = [0 : len(a)-1]) a[i] + b]
            : is_list(b)
                ? [for (i = [0 : len(b)-1]) a + b[i]]
                : a + b;

function mb_array_mul(a, b) =
    is_list(a) && is_list(b)
        ? [for (i = [0 : len(a)-1]) a[i] * b[i]]
        : is_list(a)
            ? [for (i = [0 : len(a)-1]) a[i] * b]
            : is_list(b)
                ? [for (i = [0 : len(b)-1]) a * b[i]]
                : a * b;

/*
* MAPS
*/

function mb_map_has_key(params, key) =
    len([
        for (p = params)
            if (p[0] == key)
                1
    ]) > 0;

function mb_map_get(params, key, default=undef) =
    let(found = [for (p = params) if (p[0] == key) p[1]])
    len(found) > 0 ? found[len(found)-1] : default;

function mb_map_merge(a, b) =
    concat(
        [
            for (pa = a)
                if (!mb_map_has_key(b, pa[0]))
                    pa
        ],
        b
    );

/*
* BEVEL
*/    

/*
function mb_corner_to_int(axis, corner) =
    let(axis = mb_axis_to_int(axis))
    is_string(corner) ? (
    corner == "sw" ? (axis == 0 ? 1 : 0) : 
    corner == "nw" ? (axis == 0 ? 2 : 1) :
    corner == "ne" ? (axis == 0 ? 3 : 2) :
    corner == "se" ? (axis == 0 ? 0 : 3) :
    undef
    ) : corner;    

function mb_xy_corner_side_resolve(items, i = 0, result = [[0,0], [0,0], [0,0], [0,0]]) =
    i >= len(items)
        ? result
        : mb_xy_corner_side_resolve(
            items,
            i + 1,
            mb_xy_corner_side_apply(result, items[i])
        );

function mb_xy_corner_side_apply(result, item) =
    len(item) == 3
        ? mb_xy_corner_set(
            result,
            mb_corner_to_int("z", item[0]),
            [item[1], item[2]]
        )
        : mb_xy_side_apply(
            result,
            mb_side_to_int(item[0]),
            item[1]
        );

function mb_xy_corner_set(result, c, value) =
    [
        c == 0 ? value : result[0],
        c == 1 ? value : result[1],
        c == 2 ? value : result[2],
        c == 3 ? value : result[3]
    ];

function mb_xy_side_apply(result, side, s) =
    side == 0 ? [ // x-
        [-s, result[0][1]],
        [-s, result[1][1]],
        result[2],
        result[3]
    ] :
    side == 1 ? [ // x+
        result[0],
        result[1],
        [s, result[2][1]],
        [s, result[3][1]]
    ] :
    side == 2 ? [ // y-
        [result[0][0], -s],
        result[1],
        result[2],
        [result[3][0], -s]
    ] :
    side == 3 ? [ // y+
        result[0],
        [result[1][0], s],
        [result[2][0], s],
        result[3]
    ] :
    result;

function mb_xy_add_generic(a, b, i = 0) =
    i >= len(a)
        ? []
        : concat(
            [[a[i][0] + b[i][0], a[i][1] + b[i][1]]],
            mb_xy_add_generic(a, b, i + 1)
        );
*/
/*
* MISC
*/

function mb_round_prec(x, p) = round(x / p) * p;

function mb_undef_to(v, to = 0) = is_undef(v) ? to : v;

function mb_side_to_int(side) =
    is_string(side) ? (
    side == "x-" ? 0 :
    side == "x+" ? 1 :
    side == "y-" ? 2 :
    side == "y+" ? 3 :
    side == "z-" ? 4 :
    side == "z+" ? 5 :
    undef
    ) : side;

function mb_face_to_int(face) =
    is_string(face) ? (
    face == "x-" ? 0 :
    face == "x+" ? 1 :
    face == "y-" ? 2 :
    face == "y+" ? 3 :
    face == "z-" ? 4 :
    face == "z+" ? 5 :
    face == "x" ? 6 :
    face == "y" ? 7 :
    face == "z" ? 8 :
    face == "xy" ? 9 :
    face == "xz" ? 10 :
    face == "yz" ? 11 :
    face == "xyz" ? 12 :
    undef
    ) : (face >= 0 && face <= 12 ? face : undef);

/*
* -----------
* START BEVEL
* -----------
*/

function mb_bevel_matrix(bevel, mod_size, min_max) =
    let(
        
        mn = min_max[0],
        mx = min_max[1],
        bev = [
            [min(mod_size[0], bevel[0][0]), min(mod_size[1], bevel[0][1])],
            [min(mod_size[0], bevel[1][0]), min(mod_size[1], bevel[1][1])],
            [min(mod_size[0], bevel[2][0]), min(mod_size[1], bevel[2][1])],
            [min(mod_size[0], bevel[3][0]), min(mod_size[1], bevel[3][1])]
        ],
        bv = [
            [min(mod_size[0] - bev[3][0], bev[0][0]), bev[0][1]],
            [bev[1][0], min(mod_size[1] - bev[0][1], bev[1][1])],
            [min(mod_size[0] - bev[1][0], bev[2][0]), bev[2][1]],
            [bev[3][0], min(mod_size[1] - bev[2][1], bev[3][1])]
        ],
        bc = [
            [mn[0], mn[1]], [mn[0], mn[1]],
            [mn[0], mx[1]], [mn[0], mx[1]], 
            [mx[0], mx[1]], [mx[0], mx[1]], 
            [mx[0], mn[1]], [mx[0], mn[1]]
        ],
        bs = [
            bv[0][0] == 0 && bv[0][1] > 0 ? undef : [bv[0][0], 0], 
            bv[0][1] == 0 && bv[0][0] >= 0 ? undef : [0, bv[0][1]],
            
            bv[1][1] == 0 && bv[1][0] > 0 ? undef :  [0, -bv[1][1]], 
            bv[1][0] == 0 && bv[1][1] >= 0 ? undef : [bv[1][0], 0],
            
            bv[2][0] == 0 && bv[2][1] > 0 ? undef : [-bv[2][0], 0], 
            bv[2][1] == 0 && bv[2][0] >= 0 ? undef : [0, -bv[2][1]],
            
            bv[3][1] == 0 && bv[3][0] > 0 ? undef : [0, bv[3][1]], 
            bv[3][0] == 0 && bv[3][1] >= 0 ? undef : [-bv[3][0], 0]
        ],
        bb = [
            for(i=[0:7])
                is_undef(bs[i]) ? undef : [bc[i][0] + bs[i][0], bc[i][1] + bs[i][1]]
        ],
        bu = [
            for(i=[0:7])
                is_undef(bb[i]) || (
                    //(bb[i] == bb[(i + 2) % 8] && false) || 
                    (bb[i] == bb[(i + 8 - 2) % 8] && true) || 
                
                    //(bb[i] == bb[(i + 8 - 1) % 8] && false) ||
                    (bb[i] == bb[(i + 1) % 8] && true)
                ) ? undef : bb[i]
        ]
    )
    [bv, bu];

function mb_clamp0(v) = (is_num(v) && v > 0) ? v : 0;

function mb_is_pair(v) =
    is_list(v) && len(v) == 2 && is_num(v[0]) && is_num(v[1]);

function mb_pair(v) =
    mb_is_pair(v)
        ? [mb_clamp0(v[0]), mb_clamp0(v[1])]
        : is_num(v)
            ? [mb_clamp0(v), mb_clamp0(v)]
            : [0,0];

function mb_pair_or_undef(v) =
    mb_is_pair(v)
        ? [mb_clamp0(v[0]), mb_clamp0(v[1])]
        : undef;

// b overwrites a if b != undef
function mb_pair_overwrite(a, b) =
    b == undef ? a : b;

function mb_bevel_merge(a, b) = [
    mb_pair_overwrite(a[0], b[0]),
    mb_pair_overwrite(a[1], b[1]),
    mb_pair_overwrite(a[2], b[2]),
    mb_pair_overwrite(a[3], b[3])
];

function mb_bevel_normalize(a) = [
    a[0] == undef ? [0,0] : a[0],
    a[1] == undef ? [0,0] : a[1],
    a[2] == undef ? [0,0] : a[2],
    a[3] == undef ? [0,0] : a[3]
];

// direction mapping → 4 slots, undef = no overwrite
function mb_bevel_dir_map(d, x, y) =
    let(p = [mb_clamp0(x), mb_clamp0(y)])
    d == 0 ? [p, undef, undef, undef] :       // sw
    d == 1 ? [p, p, undef, undef] :           // w
    d == 2 ? [undef, p, undef, undef] :       // nw
    d == 3 ? [undef, p, p, undef] :           // n
    d == 4 ? [undef, undef, p, undef] :       // ne
    d == 5 ? [undef, undef, p, p] :           // e
    d == 6 ? [undef, undef, undef, p] :       // se
    d == 7 ? [p, undef, undef, p] :           // s
    [undef, undef, undef, undef];

function mb_bevel_reduce(arr, i=0, acc=[undef, undef, undef, undef]) =
    i >= len(arr)
        ? mb_bevel_normalize(acc)
        : let(v = arr[i])
          mb_bevel_reduce(
              arr,
              i + 1,
              (is_list(v) && len(v) == 3)
                  ? mb_bevel_merge(
                        acc,
                        mb_bevel_dir_map(
                            mb_dir_to_int(v[0], true),
                            v[1],
                            v[2]
                        )
                    )
                  : acc
          );

function mb_bevel_all(p) = [p,p,p,p];

// --- main ---
function mb_bevel_resolve(bevel) =
    // undef / [] / string
    (!is_list(bevel) || len(bevel) == 0)
        ? [[0,0],[0,0],[0,0],[0,0]]

    // number or [x]
    : is_num(bevel) || (len(bevel) == 1 && is_num(bevel[0]))
        ? let(v = mb_clamp0(is_num(bevel) ? bevel : bevel[0]))
          mb_bevel_all([v,v])

    // [x,y]
    : mb_is_pair(bevel)
        ? mb_bevel_all(mb_pair(bevel))

    // [[x,y]]
    : len(bevel) == 1 && mb_is_pair(bevel[0])
        ? mb_bevel_all(mb_pair(bevel[0]))

    // [[x1,y1],[x2,y2]]
    : len(bevel) == 2 && mb_is_pair(bevel[0]) && mb_is_pair(bevel[1])
        ? let(a = mb_pair(bevel[0]), b = mb_pair(bevel[1]))
          [a,a,b,b]

    // [[x1,y1],[x2,y2],[x3,y3]]
    : len(bevel) == 3 && mb_is_pair(bevel[0]) && mb_is_pair(bevel[1]) && mb_is_pair(bevel[2])
        ? let(a = mb_pair(bevel[0]), b = mb_pair(bevel[1]), c = mb_pair(bevel[2]))
          [a,b,c,[0,0]]

    // [[x1,y1],[x2,y2],[x3,y3],[x4,y4]]
    : len(bevel) == 4 && mb_is_pair(bevel[0]) && mb_is_pair(bevel[1]) && mb_is_pair(bevel[2]) && mb_is_pair(bevel[3])
        ? [
            mb_pair(bevel[0]),
            mb_pair(bevel[1]),
            mb_pair(bevel[2]),
            mb_pair(bevel[3])
          ]

    // complex mode
    : mb_bevel_reduce(bevel);

/*
* ---------
* END BEVEL
* ---------
*/

/*
* -----------
* START SLOPE
* -----------
*/

function mb_slope_matrix(slope, bevel_res, mod_size) =
    let(
        mx_bvx = mod_size[0] - max((bevel_res[0][0] + bevel_res[3][1]), (bevel_res[1][1] + bevel_res[2][0])),
        mx_bvy = mod_size[1] - max((bevel_res[0][1] + bevel_res[3][0]), (bevel_res[1][0] + bevel_res[2][1])),
        slo = [
            min(abs(slope[0]), mx_bvx),
            min(abs(slope[1]), mx_bvx),
            min(abs(slope[2]), mx_bvy),
            min(abs(slope[3]), mx_bvy),
        ],
        slo2 = [
            sign(slope[0]) * slo[0],
            sign(slope[1]) * min(slo[1], mx_bvx - slo[0]),
            sign(slope[2]) * slo[2],
            sign(slope[3]) * min(slo[3], mx_bvy - slo[2]),
        ],
        sl = [
            [abs(min(0, slo2[0])), abs(min(0, slo2[1])), abs(min(0, slo2[2])), abs(min(0, slo2[3]))],
            [abs(max(0, slo2[0])), abs(max(0, slo2[1])), abs(max(0, slo2[2])), abs(max(0, slo2[3]))]
        ]
    )
    [
        for(i=[0:1])
            [   
                [sl[i][0], sl[i][2]], [sl[i][0], sl[i][2]],
                [sl[i][0], -sl[i][3]], [sl[i][0], -sl[i][3]],
                [-sl[i][1], -sl[i][3]], [-sl[i][1], -sl[i][3]],
                [-sl[i][1], sl[i][2]], [-sl[i][1], sl[i][2]]
            ]
    ];

/*
function mb_slope_is_num_array(a, n, i = 0) =
    is_list(a) && len(a) == n &&
    (i >= n || (is_num(a[i]) && mb_slope_is_num_array(a, n, i + 1)));

function mb_slope_normal(slope) =
    is_num(slope)
        ? [slope, slope, slope, slope]
        : mb_slope_is_num_array(slope, 1)
            ? [slope[0], slope[0], slope[0], slope[0]]
        : mb_slope_is_num_array(slope, 2)
            ? [slope[0], slope[0], slope[1], slope[1]]
        : mb_slope_is_num_array(slope, 3)
            ? [slope[0], slope[1], slope[2], 0]
        : mb_slope_is_num_array(slope, 4)
            ? [slope[0], slope[1], slope[2], slope[3]]
        : undef;

function mb_slope_complex_item(item) =
    is_list(item) && len(item) == 2 && is_num(item[1])
        ? let(k = mb_face_to_int(item[0]), v = item[1])
            k == 0 ? [v, undef, undef, undef] :
            k == 1 ? [undef, v, undef, undef] :
            k == 2 ? [undef, undef, v, undef] :
            k == 3 ? [undef, undef, undef, v] :
            k == 6 ? [v, v, undef, undef] :
            k == 7 ? [undef, undef, v, v] :
            k == 9 ? [v, v, v, v] :
            undef
        : undef;

function mb_slope_overwrite(a, b) = [
    b[0] == undef ? a[0] : b[0],
    b[1] == undef ? a[1] : b[1],
    b[2] == undef ? a[2] : b[2],
    b[3] == undef ? a[3] : b[3]
];

function mb_slope_complex(items, i = 0, acc = [0, 0, 0, 0]) =
    !is_list(items) || i >= len(items)
        ? acc
        : let(b = mb_slope_complex_item(items[i]))
            mb_slope_complex(
                items,
                i + 1,
                b == undef ? acc : mb_slope_overwrite(acc, b)
            );

function mb_slope_resolve(slope) =
    let(normal = mb_slope_normal(slope))
        normal != undef
            ? normal
            : is_list(slope)
                ? mb_slope_complex(slope)
                : [0, 0, 0, 0];
*/
/*
* ---------
* END SLOPE
* ---------
*/

/*
* ------------------------
* START mb_qc_resolve()
* ------------------------
*/

function mb_qc_is_num_array(a, n, i = 0) =
    is_list(a) && len(a) == n &&
    (i >= n || (is_num(a[i]) && mb_qc_is_num_array(a, n, i + 1)));

function mb_qc_normal_2d(qc) =
    is_num(qc)
        ? [qc, qc, qc, qc]
        : mb_qc_is_num_array(qc, 1)
            ? [qc[0], qc[0], qc[0], qc[0]]
        : mb_qc_is_num_array(qc, 2)
            ? [qc[0], qc[0], qc[1], qc[1]]
        : mb_qc_is_num_array(qc, 3)
            ? [qc[0], qc[1], qc[2], 0]
        : mb_qc_is_num_array(qc, 4)
            ? [qc[0], qc[1], qc[2], qc[3]]
        : undef;

function mb_qc_normal_3d(qc) =
    is_num(qc)
        ? [qc, qc, qc, qc, qc, qc]
        : mb_qc_is_num_array(qc, 1)
            ? [qc[0], qc[0], qc[0], qc[0], qc[0], qc[0]]
        : mb_qc_is_num_array(qc, 2)
            ? [qc[0], qc[0], qc[1], qc[1], 0, 0]
        : mb_qc_is_num_array(qc, 3)
            ? [qc[0], qc[0], qc[1], qc[1], qc[2], qc[2]]
        : mb_qc_is_num_array(qc, 4)
            ? [qc[0], qc[1], qc[2], qc[3], 0, 0]
        : mb_qc_is_num_array(qc, 5)
            ? [qc[0], qc[1], qc[2], qc[3], qc[4], 0]
        : mb_qc_is_num_array(qc, 6)
            ? [qc[0], qc[1], qc[2], qc[3], qc[4], qc[5]]
        : undef;

function mb_qc_normal(qc, cube = false) =
    cube ? mb_qc_normal_3d(qc) : mb_qc_normal_2d(qc);

function mb_qc_complex_item_2d(item) =
    is_list(item) && len(item) == 2 && is_num(item[1])
        ? let(k = mb_face_to_int(item[0]), v = item[1])
            k == 0 ? [v, undef, undef, undef] :
            k == 1 ? [undef, v, undef, undef] :
            k == 2 ? [undef, undef, v, undef] :
            k == 3 ? [undef, undef, undef, v] :
            k == 6 ? [v, v, undef, undef] :
            k == 7 ? [undef, undef, v, v] :
            k == 9 ? [v, v, v, v] :
            undef
        : undef;

function mb_qc_complex_item_3d(item) =
    is_list(item) && len(item) == 2 && is_num(item[1])
        ? let(k = mb_face_to_int(item[0]), v = item[1])
            k == 0  ? [v, undef, undef, undef, undef, undef] :
            k == 1  ? [undef, v, undef, undef, undef, undef] :
            k == 2  ? [undef, undef, v, undef, undef, undef] :
            k == 3  ? [undef, undef, undef, v, undef, undef] :
            k == 4  ? [undef, undef, undef, undef, v, undef] :
            k == 5  ? [undef, undef, undef, undef, undef, v] :
            k == 6  ? [v, v, undef, undef, undef, undef] :
            k == 7  ? [undef, undef, v, v, undef, undef] :
            k == 8  ? [undef, undef, undef, undef, v, v] :
            k == 9  ? [v, v, v, v, undef, undef] :
            k == 10 ? [v, v, undef, undef, v, v] :
            k == 11 ? [undef, undef, v, v, v, v] :
            k == 12 ? [v, v, v, v, v, v] :
            undef
        : undef;

function mb_qc_complex_item(item, cube = false) =
    cube ? mb_qc_complex_item_3d(item) : mb_qc_complex_item_2d(item);

function mb_qc_overwrite(a, b, cube = false) =
    cube
        ? [
            b[0] == undef ? a[0] : b[0],
            b[1] == undef ? a[1] : b[1],
            b[2] == undef ? a[2] : b[2],
            b[3] == undef ? a[3] : b[3],
            b[4] == undef ? a[4] : b[4],
            b[5] == undef ? a[5] : b[5]
        ]
        : [
            b[0] == undef ? a[0] : b[0],
            b[1] == undef ? a[1] : b[1],
            b[2] == undef ? a[2] : b[2],
            b[3] == undef ? a[3] : b[3]
        ];

function mb_qc_complex(items, cube = false, i = 0, acc = undef, def = def) =
    let(acc0 = acc == undef ? def : acc)
    !is_list(items) || i >= len(items)
        ? acc0
        : let(b = mb_qc_complex_item(items[i], cube))
            mb_qc_complex(
                items,
                cube,
                i + 1,
                b == undef ? acc0 : mb_qc_overwrite(acc0, b, cube),
                def = def
            );

function mb_qc_resolve(qc, cube = false, mul = undef, default = [0, 0, 0, 0, 0, 0]) =
    let(def = cube
                    ? default
                    : [default[0], default[1], default[2], default[3]],
        normal = mb_qc_normal(qc, cube),
        r = normal != undef
            ? normal
            : is_list(qc)
                ? mb_qc_complex(qc, cube, def = def)
                : def,
        m = mb_resolve_xyz(xyz = mul, default = [1, 1, 1]))
    is_undef(mul) ? r : [ for(i = [0 : 1 : len(r) - 1]) is_undef(r[i]) ? undef : r[i] * (i < 2 ? m[0] : i < 4 ? m[1] : i < 6 ? m[2] : 1) ];


/*
* ----------------------
* END mb_qc_resolve()
* ----------------------
*/

function mb_dir_to_int(dir, m = false) =
    let( d = is_string(dir) ? (
    dir == "sw" ? 0 :
    dir == "w" ? 1 :
    dir == "nw" ? 2 :
    dir == "n" ? 3 :
    dir == "ne" ? 4 :
    dir == "e" ? 5 :
    dir == "se" ? 6 :
    dir == "s" ? 7 :
    
    dir == "sw-" ? 8 :
    dir == "w-" ? 9 :
    dir == "nw-" ? 10 :
    dir == "n-" ? 11 :
    dir == "ne-" ? 12 :
    dir == "e-" ? 13 :
    dir == "se-" ? 14 :
    dir == "s-" ? 15 :

    dir == "sw+" ? 16 :
    dir == "w+" ? 17 :
    dir == "nw+" ? 18 :
    dir == "n+" ? 19 :
    dir == "ne+" ? 20 :
    dir == "e+" ? 21 :
    dir == "se+" ? 22 :
    dir == "s+" ? 23 :
    undef
    ) : (dir >= 0 && dir <= 23 ? dir : undef)) m ? d % 8 : d;



function mb_side_to_axis(side) = floor(mb_side_to_int(side) / 2);

function mb_side_to_axis_face(side) = mb_side_to_int(side) % 2;

function mb_axis_to_int(axis) = 
    is_string(axis) ? (
        axis == "x" ? 0 :
        axis == "y" ? 1 :
        axis == "z" ? 2 :
        undef
    ) : axis;

function mb_decorator_rotation(side) =
    let(rots = [[90, 0, -90], [90, 0, 90], [90, 0, 0], [90, 0, 180], [0, 180, 180], [0, 0, 0]])
        rots[mb_side_to_int(side)];

function mb_array_min_pair_cycle_neg(a) =
    [
        -min(a[2], a[0]),
        -min(a[0], a[3]),
        -min(a[3], a[1]),
        -min(a[1], a[2])
    ];

module mb_pre_render(do_render, convexity){
    if(do_render){
        render(convexity)
            children();
    }
    else{
        children();
    }
}

// Returns how many round holes fit vertically inside a rectangle
// without violating the bottom/top margins.
function mb_vertical_hole_count(
    rect_height,                    // total rectangle height
    first_hole_center_from_bottom,  // center of first hole measured from bottom edge
    hole_diameter,                  // hole diameter
    hole_center_spacing,            // vertical spacing between hole centers
    min_top_margin                  // required minimum margin at the top
) =
    (hole_center_spacing <= 0) ? 0 :
    (first_hole_center_from_bottom < hole_diameter/2 ||
     (rect_height - min_top_margin - hole_diameter/2) < first_hole_center_from_bottom) ? 0 :
    floor(
        (rect_height - min_top_margin - hole_diameter/2 - first_hole_center_from_bottom)
        / hole_center_spacing
    ) + 1;

function mb_direction_to_int(d) =
    is_string(d) ?
        (d == "west" ? 0 :
         d == "north" ? 1 :
         d == "east" ? 2 :
         d == "south" ? 3 :
         undef)
    : d;

/*
* Recess
*/



/*
* ALIGNMENT
*/

function mb_align_resolve(v) =
    is_list(v) ?
        [ for (e = v) _mb_align_word_resolve(e) ] :

    is_string(v) ?
        (
            len(v) == 3 ?
                [ for (i = [0:2]) _mb_align_char_to_word(v[i]) ] :
                [ for (i = [0:2]) _mb_align_word_resolve(v) ]
        ) :

    ["start", "start", "start"];


// --- helpers ---

function _mb_align_char_to_word(c) =
    c == "c" ? "center" :
    c == "s" ? "start"  :
    c == "e" ? "end"    :
    "start"; // fallback


function _mb_align_word_resolve(w) =
    w == "center" ? "center" :
    w == "start"  ? "start"  :
    w == "end"    ? "end"    :
    "start"; // fallback

function mb_align_offset(axisAlign, size, invert = false) =
    let(sign = invert ? -1 : 1)
    axisAlign == "center" ? 0 :
    axisAlign == "start"  ?  sign * 0.5 * size :
                            -sign * 0.5 * size;

function mb_align_to_axis_face(align) =
    align == "start" ? 0 :
    align == "center" ? 0.5 :
    align == "end" ? 1 :
    undef;
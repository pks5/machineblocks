use <geometry.scad>;
use <utils.scad>;

function mb_block_obj(
    size, 
    size_mod = undef, 
    size_adj = [-0.1, 0], // [XY Side Adjustment (mm), Height Adjustment (mm)]
    base_adj = undef,
    bevel = undef,
    slope = undef,
    grid_cfg = [1.6, 5, 2], // [1 mbu (mm), Grid Size XY (mbu), Grid Size Z (mbu)]
    scale = 1,
    top_plate_height = [1, -0.6], // [Height (mbu), Adjustment (mm)]
    top_plate_helpers = [0.2, 0.2], // [Thickness (mbu), Height (mbu)]
    recess_depth = "auto",
    slope_base = [1.333, 1], // [Bottom, Top]
    wall_thickness = ["auto", -0.1], // [Thickness (mbu), Adjustment (mm)]
    cutout_max_depth = 5,
    cutout_type = "standard",
    recess = false,
    recess_depth = "auto",
    recess_wall_thickness = 0.333, 
    recess_wall_gaps = [],
    clamp = [0.1, 0.5, 0.25], // [Thickness (mm), Height (mbu), Offset (mbu)]
    clamp_outer = true,
    stud_diameter = 3,
    relief_cut = false,
    relief_cut_dim = [0.375, 0.375], // [Thickness (mbu), Height (mbu)]
    id = "[Block]",
    custom_modules = ["my_cube"],
    debug = false,
    baseWallGaps = [],
    stabilizers = [0.5, 0.5, 0.2, 1, 2],
    tubeWallThickness = 0.53125,
    pinDiameter = "auto",
    pinDiameterAdjustment = 0
) =
    let(mul_mbu_to_grid = mb_unit_mul(grid_cfg, scale = scale, from="mbu", to="grd"),
        mul_mm_to_grid = mb_unit_mul(grid_cfg, scale = scale, from="mm", to="grd"),
        
        mod_min_max = mb_block_mod_min_max(block_size = size, block_mod = size_mod),

        si = mod_min_max[0][0],
        mod = mod_min_max[0][3],
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
        cutout_min_depth = 1 - top_plate_height_pref,
        recess_depth_max = mod_size[2] - top_plate_height_pref - (cutout_type == "none" ? 0 : cutout_min_depth),
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
    
        clamp_final = [
            clamp[0] * mul_mm_to_grid[0], // Thickness
            clamp[1] * mul_mbu_to_grid[2], // Height
            clamp[2] * mul_mbu_to_grid[2], // Offset
            clamp_outer
        ],
        relief_cut_final = [relief_cut_dim[0] * mul_mbu_to_grid[0], relief_cut_dim[1] * mul_mbu_to_grid[2]],

        top_plate_helpers_final = [top_plate_helpers[0] * mul_mm_to_grid[0], top_plate_helpers[1] * mul_mm_to_grid[2]],
        tube_wall_thickness_res = tubeWallThickness * mul_mbu_to_grid[0],  // TODO XYZ
        stud_diameter_res = stud_diameter * mul_mbu_to_grid[0],
        default_tube_diameter = stud_diameter_res + 2 * tube_wall_thickness_res,  // TODO XYZ
        tube_hole_size = stud_diameter_res, // TODO XYZ

        stabilizers_res = [
            stabilizers[0] * mul_mbu_to_grid[0], // Thickness (mbu)
            stabilizers[1] * mul_mbu_to_grid[2], // Height (mbu)
            stabilizers[2] * mul_mm_to_grid[2], // Offset (mm)
            stabilizers[3] * mul_mbu_to_grid[2], // Expansion Offset (mbu)
            stabilizers[4]                       // Expansion Each
        ],

        pin_diameter = (pinDiameter == "auto" ? p_diameter : pinDiameter) * mul_mbu_to_grid[0] + pinDiameterAdjustment * mul_mm_to_grid[0]
    )
        [
            [
                mod_min_max[0], 
                mod_min_max[1], 
                [adj_size]
            ], // 0 - Original Size / Mod Size
            [mb_bevel_resolve(bevel), mb_qc_resolve(slope, false)], // 1 - Bevel / Slope
            mod_min_max[3], // 2 - Min / Max Index
            undef, // 3 - 
            [cutout_depth, top_plate_height_final, recess_depth_final, wall_thickness_final, clamp_final, cutout_min_depth], // 4 - Top Plate Height
            [slope_base[0] * mul_mbu_to_grid[2], slope_base[1] * mul_mbu_to_grid[2]], // 5 - Slope Base 
            [mod, bsa_grd], // 6 - Adjustments
            [grid_cfg, scale], // 7 - Units
            [recess, recess_walls, relief_cut, relief_cut_final, recess_wall_gaps], // 8 - Recesss & Relief Cut
            [top_plate_height_final, top_plate_helpers_final],  // 9 - Top Plate
            [],  // 10 - 
            [],  // 11 - 
            [],  // 12 - 
            [],  // 13 - 
            [],  // 14 - 
            [default_tube_diameter, tube_hole_size, tube_wall_thickness_res, pin_diameter],  // 15 - 
            [stabilizers_res],  // 16 - 
            [baseWallGaps],  // 17 - 
            [custom_modules],  // 18 - 
            [true],  // 19 - Inverted
            [id, debug, 0.01] // 20 - ID, Debug, Cut Tolerance
        ];

/*
* Getters
*/

function mb_block_get_id(block_obj) =                               block_obj[20][0];
function mb_block_get_cut_tolerance(block_obj) =                    block_obj[20][2];

function mb_block_get_bevel(block_obj) =                            block_obj[1][0];
function mb_block_get_inverted(block_obj) =                         block_obj[19][0];

function mb_block_get_slope(block_obj) =                            block_obj[1][1];

function mb_block_get_slope_socket(block_obj) =                     block_obj[5];

function mb_block_get_base_cutout_depth(block_obj) =                block_obj[4][0];
function mb_block_get_base_adj(block_obj) =                         block_obj[6][1];
function mb_block_get_size_mod(block_obj) =                         block_obj[6][0];

function mb_block_get_size(block_obj) =                             block_obj[0][0][0];
function mb_block_get_center(block_obj) =                           block_obj[0][0][2];
function mb_block_get_mod_size(block_obj) =                         block_obj[0][1][0];

function mb_block_get_wall_thickness(block_obj) =                   block_obj[4][3];

function mb_block_get_top_plate_height(block_obj) =                 block_obj[4][1];
function mb_block_get_top_plate_helpers(block_obj) =                block_obj[9][1];

function mb_block_get_recess(block_obj) =                           block_obj[8][0];
function mb_block_get_recess_wall_thickness(block_obj) =            block_obj[8][1];
function mb_block_get_recess_depth(block_obj) =                     block_obj[4][2];
function mb_block_get_recess_wall_gaps(block_obj) =                 block_obj[8][4];

function mb_block_get_base_wall_gaps(block_obj) =                   block_obj[17][0];

function mb_block_get_grid_cfg(block_obj) =                         block_obj[7][0];

function mb_block_get_scale(block_obj) =                            block_obj[7][1];

function mb_block_get_relief_cut(block_obj) =                       block_obj[8][2];
function mb_block_get_relief_cut_dim(block_obj) =                   block_obj[8][3];

function mb_block_get_clamp(block_obj) =                            block_obj[4][4];

function mb_block_get_base_cutout_min_depth(block_obj) =            block_obj[4][5];

function mb_block_get_stabilizers(block_obj) =                      block_obj[16][0];

function mb_block_get_min_max_index(block_obj) =                    block_obj[2];
function mb_block_get_custom_modules(block_obj) =                   block_obj[18];

// Tubes
function mb_block_get_tube_diameter(block_obj, axis) =              block_obj[15][0];
function mb_block_get_tube_hole_size(block_obj, axis) =             block_obj[15][1];
function mb_block_get_tube_wall_thickness(block_obj, axis) =        block_obj[15][2];
function mb_block_get_pin_diameter(block_obj) =                     block_obj[15][3];

/*
* TODO Rename or delete
*/

function mb_block_obj_size(block_obj, bb = false, unit = "grd") = 
    mb_block_unit_convert(block_obj, block_obj[0][0][bb ? 0 : 1], from = "grd", to = unit);

function mb_block_obj_size_mod(block_obj, bb = false, unit = "grd") = 
    mb_block_unit_convert(block_obj, block_obj[0][1][bb ? 0 : 1], from = "grd", to = unit);

function mb_block_obj_size_adj(block_obj, unit = "grd") = 
    mb_block_unit_convert(block_obj, block_obj[0][2][0], from = "grd", to = unit);

function mb_block_size_mod(block_obj, unit = "grd") = mb_block_unit_convert(block_obj, block_obj[6][0], from = "grd", to = unit);

function mb_block_base_adj(block_obj, unit = "grd") = mb_block_unit_convert(block_obj, block_obj[6][1], from = "grd", to = unit);

function mb_block_unit_convert(block_obj, v, from = "grd", to="mm") = 
    let(mul = mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from = from, to = to))
    is_num(v) || (is_list(v) && len(v) <= 3) ? 
        mb_resolve_xyz(xyz = v, mul = mul) :
        (is_list(v) && len(v) == 4) ? [v[0] * mul[0], v[1] * mul[0], v[2] * mul[1], v[3] * mul[1]] :
        (is_list(v) && len(v) <= 6) ? [v[0] * mul[0], v[1] * mul[0], v[2] * mul[1], v[3] * mul[1], v[4] * mul[2], len(v) > 5 ? v[5] * mul[2] : undef] :
        undef;

/*
* END TODO Rename or delete
*/

function mb_block_base_cutout_ceiling_offset(block_obj) = 
    [
        mb_block_get_base_cutout_depth(block_obj),
        mb_block_get_recess_depth(block_obj) + mb_block_get_top_plate_height(block_obj)
    ];

/**
* -----
* Tubes
* -----
*/

function mb_block_tube_range(block_obj, axis) =
    let(
        axis = mb_axis_to_int(axis),
        min_max_index = mb_block_get_min_max_index(block_obj),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        is_pin = mb_block_tube_is_pin(block_obj, axis),
        range_offset_start = is_pin[0] || is_pin[1] ? [is_pin[0] ? 0 : 1, is_pin[1] ? 0 : 1] : [1, 1],
        range_offset_end = [0, 0]
    )
    [
        [start_index_x + range_offset_start[0] : end_index_x + range_offset_end[0]],
        [start_index_y + range_offset_start[1] : end_index_y + range_offset_end[1]]
    ];

function mb_block_tube_render(block_obj, axis, x, y) =
    true;

function mb_block_tube_offset(block_obj, axis, x, y) = //TODO
    let(
        is_pin = mb_block_tube_is_pin(block_obj, axis, x, y),
        tube_offset = is_pin[0] || is_pin[1] ? [is_pin[0] ? 0.5 : 0, is_pin[1] ? 0.5 : 0] : [0, 0]
    )
    mb_block_pos_to_offset(block_obj, [x + tube_offset[0], y + tube_offset[1], undef]);

function mb_block_tube_is_pin(block_obj, axis, x = undef, y = undef) =
    let(
        min_max_index = mb_block_get_min_max_index(block_obj),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        is_pin = [end_index_x - start_index_x == 0, end_index_y - start_index_y == 0],
    )
    is_pin;

function mb_block_tube_radius(block_obj, axis, x, y) =
    let(
        axis = mb_axis_to_int(axis),
        is_pin = mb_block_tube_is_pin(block_obj, axis, x, y),

        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        tube_z_hole_size = mb_block_get_tube_hole_size(block_obj, "z"),
        pin_diameter = mb_block_get_pin_diameter(block_obj)
        
    )
    is_pin[0] || is_pin[1] ? 0.5 * pin_diameter : [0.5 * tube_z_hole_size, 0.5 * tube_z_diameter];

/**
* -----------
* Stabilizers
* -----------
*/

function mb_block_stabilizer_range(block_obj, axis) =
    let(
        axis = mb_axis_to_int(axis),
        min_max_index = mb_block_get_min_max_index(block_obj),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1])
    axis == 1 ? 
    [
        [start_index_x + 1 : end_index_x],
        [start_index_y : end_index_y]
    ] :
    [
        [start_index_x : end_index_x],
        [start_index_y + 1 : end_index_y]
    ];

function mb_block_stabilizer_segment_offset(block_obj, axis, x, y) =
    let(
        axis = mb_axis_to_int(axis)
    )
    mb_block_pos_to_offset(block_obj, axis == 1 ? [x, y + 0.5, undef] : [x + 0.5, y, undef]);

function mb_block_stabilizer_segment_size(block_obj, axis, x, y) =
    let(
        axis = mb_axis_to_int(axis),
        stabilizers = mb_block_get_stabilizers(block_obj),
        top_plate_helpers = mb_block_get_top_plate_helpers(block_obj),
        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        tube_wall_thickness = mb_block_get_tube_wall_thickness(block_obj, "z"),
        default_segment_length = 1 - tube_z_diameter + tube_wall_thickness,
        segment_thickness = stabilizers[0],
        stabilizer_expansion = stabilizers[4],
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        segment_height_expanded = max(base_cutout_depth - stabilizers[3], 0),
        expanded = axis == 1 ? 
            (x % stabilizer_expansion) == 0 : 
            (y % stabilizer_expansion) == 0,
        seg_size = [
            axis == 1 ? segment_thickness : default_segment_length, 
            axis == 1 ? default_segment_length : segment_thickness, 
            (expanded ? segment_height_expanded : stabilizers[1]) + (axis == 1 ? -stabilizers[2] : 0)
        ]
    )
    [
        seg_size,
        [
            (axis == 1 ? 2 * top_plate_helpers[0] : 0),
            (axis == 0 ? 2 * top_plate_helpers[0] : 0),
            top_plate_helpers[1]
        ]
    ];

function mb_block_stabilizer_segment_expand(block_obj, axis, x, y) =
    let(    
        axis = mb_axis_to_int(axis),
        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        min_max_index = mb_block_get_min_max_index(block_obj),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
    )    
    [
        axis == 0 && x == 0 ? 0.5 * tube_z_diameter : 0, 
        axis == 0 && x == end_index_x ? 0.5 * tube_z_diameter : 0, 
        axis == 1 && y == 0 ? 0.5 * tube_z_diameter : 0, 
        axis == 1 && y == end_index_y ? 0.5 * tube_z_diameter : 0
    ];

function mb_block_stabilizer_segment_render(block_obj, axis, x, y) =
    let(axis = mb_axis_to_int(axis = axis),
        min_max_index = mb_block_get_min_max_index(block_obj),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        stabilizers = mb_block_get_stabilizers(block_obj),
        
        stablilizer_thickness = stabilizers[0],
        x_min = x - 0.5 * stablilizer_thickness,
        x_max = x + 0.5 * stablilizer_thickness,
        y_min = y - 0.5 * stablilizer_thickness,
        y_max = y + 0.5 * stablilizer_thickness
    )
    !((axis == 0 && x == start_index_x && mb_block_in_base_wall_gap(block_obj, "x-", y_min, y_max)) ||
    (axis == 0 && x == end_index_x && mb_block_in_base_wall_gap(block_obj, "x+", y_min, y_max)) || 
    (axis == 1 && y == start_index_y && mb_block_in_base_wall_gap(block_obj, "y-", x_min, x_max)) || 
    (axis == 1 && y == end_index_y && mb_block_in_base_wall_gap(block_obj, "y+", x_min, x_max))
    );





/**
* ------
* Recess 
* ------
*/  

function mb_block_recess_wall_gap(block_obj, gap, split_axis = true) = 
    let(mod_size = mb_block_get_mod_size(block_obj),
        recess_wall_thickness = mb_block_get_recess_wall_thickness(block_obj),
        min_max_index = mb_block_get_min_max_index(block_obj),
        gap = mb_to_array(gap),
        faces = mb_face_split(gap[0], split_axis ? ["x", "y"] : ["x-", "x+", "y-", "y+"])
    )
    [
        for(face = faces)
            let(axis = mb_face_to_axis(face),
            gap_start_pos = is_undef(gap[1]) ? 0 : max(0, gap[1]),
            gap_length = is_undef(gap[2]) ? 1 : min(mod_size[axis], gap[2]),
            gap_start_offset = gap_start_pos + recess_wall_thickness[axis == 0 ? 0 : 2],
            gap_end_offset = mod_size[axis] - gap_length - gap_start_pos + recess_wall_thickness[axis == 0 ? 1 : 3])
            [
                face,
                gap_start_pos,
                gap_length,
                gap_start_offset,
                gap_end_offset,
                min_max_index[0][1 - axis] + gap_start_offset,
                min_max_index[1][1 - axis] + 1 - gap_end_offset,
            ]
    ];

/**
* ---------
* Base Wall
* ---------
*/ 

function mb_block_base_wall_gap(block_obj, gap, split_axis = true) = 
    let(
        mod_size = mb_block_get_mod_size(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        min_max_index = mb_block_get_min_max_index(block_obj),
        faces = mb_face_split(gap[0], split_axis ? ["x", "y"] : ["x-", "x+", "y-", "y+"])
    )
    [
        for(face = faces)
        
        let(
            axis = mb_face_to_axis(face),
            gap_start_pos = is_undef(gap[1]) ? 0 : max(0, gap[1]),
            gap_length = is_undef(gap[2]) ? 1 : min(mod_size[axis], gap[2]),
            gap_start_offset = gap_start_pos + wall_thickness,
            gap_end_offset = mod_size[axis] - gap_length - gap_start_pos + wall_thickness
        )
        [
            face,
            gap_start_pos,
            gap_length,
            gap_start_offset,
            gap_end_offset,
            min_max_index[0][1 - axis] + gap_start_offset,
            min_max_index[1][1 - axis] + 1 - gap_end_offset
        ]
    ];

function mb_block_in_base_wall_gap(block_obj, face, pos_min, pos_max) = 
    let(
        face = mb_face_to_int(face),
        wall_gaps = mb_block_get_base_wall_gaps(block_obj),
        found = [
            for(wall_gap = wall_gaps)
               let(gaps = mb_block_base_wall_gap(block_obj, wall_gap, split_axis = false))
               for(g = gaps)
                if(face == g[0] && ((pos_min > g[5] && pos_min < g[6]) || (pos_max > g[5] && pos_max < g[6]))) 1
        ]
    )
    len(found) > 0;

/**
* ----
* Misc
* ----
*/ 

function mb_block_custom_module_mapping(block_obj, mname) = 
    let(custom_modules = mb_block_get_custom_modules(block_obj),
        mappings = custom_modules[0], f = [
        for(i = [0:len(mappings)-1])
            if (mappings[i] == mname)
                i
    ])
    len(f) > 0 ? f[0] : undef;

function mb_block_pos_to_offset(block_obj, pos) = 
    let(center = mb_block_get_center(block_obj))
        [is_undef(pos[0]) ? 0 : pos[0] - center[0], is_undef(pos[1]) ? 0 : pos[1] - center[1], is_undef(pos[2]) ? 0 : pos[2] - center[2]];
        
//TODO Rename & remove adj
function mb_block_mod_min_max(block_size, block_mod = undef, adj = undef) =
    let(size = mb_resolve_xyz(xyz = block_size, default = [1, 1, 1]),
        mod = mb_qc_resolve(qc = block_mod, cube = true),
        
        bb = mb_bounding_box(size),
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
            [size, bb, c, mod], // 0
            [
                mod_size,
                mb_bounding_box(mod_size),
                min_max
            ], // 1
            
            [mi, ma], // 2

            [ 
                [floor(-mod[0]), floor(-mod[2]), 0], // Min Index (modified)
                [ceil(size[0] + mod[1] - 1), ceil(size[1] + mod[3] - 1), ceil(size[2] + mod[5] - 1)] // Max Index (modified)
            ] // 3
        ];

/*
* -------------
* END BLOCK OBJ
* -------------
*/
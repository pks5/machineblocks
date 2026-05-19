use <geometry.scad>;
use <utils.scad>;
use <block_dim.scad>;
use <../bevel.scad>;

function mb_block_obj(
    size, 
    size_mod = undef, 
    size_adj = [-0.1, 0], // [XY Side Adjustment (mm), Height Adjustment (mm)]
    base_adj = undef,
    bevel = undef,
    slope = undef,
    inverted = false,
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
    recessStudPadding = 0.2,
    clamp = [0.1, 0.5, 0.25], // [Thickness (mm), Height (mbu), Offset (mbu)]
    clamp_outer = true,
    studDiameter = 3,
    studRounding = 0.0625,
    studDiameterAdjustment = 0.2,
    studHeight = 1,
    studHeightAdjustment = 0,
    studSink = 0.25,
    studMaxOverhang = 0,
    studPadding = 0.2,
    relief_cut = false,
    relief_cut_dim = [0.375, 0.375], // [Thickness (mbu), Height (mbu)]
    id = "[Block]",
    custom_modules = ["my_cube"],
    debug = false,
    baseWallGaps = [],
    stabilizers = [0.5, 0.5, 0.2, 1, 2],
    tubeWallThickness = 0.53125,
    pinDiameter = "auto",
    pinDiameterAdjustment = 0,
    tongue = false,
    tongueHeight = 1.25,
    tongueThickness = 0.666,
    tongueThicknessAdjustment = 0,
    tongueOffset = 1
) =
    let(
        mul_mbu_to_grid = mb_unit_mul(grid_cfg, scale = scale, from="mbu", to="grd"),
        mul_mm_to_grid = mb_unit_mul(grid_cfg, scale = scale, from="mm", to="grd"),

        base_adj_grd = mb_qc_resolve(
            qc = base_adj, 
            cube = true, 
            default = [
                size_adj[0], 
                size_adj[0], 
                size_adj[0], 
                size_adj[0], 
                0, 
                size_adj[1]
            ],
            mul = mul_mm_to_grid
        ),
        
        block_dim = mb_block_dim(
            size = size, 
            size_mod = size_mod,
            base_adj = base_adj_grd
        ),

        size_res = mb_block_dim_size(block_dim),
        size_mod_res = mb_block_dim_size_mod(block_dim),
        center = mb_block_dim_center(block_dim),
        
        mod_size = mb_block_dim_mod_size(block_dim),
        min_max_pos = mb_block_dim_min_max_pos(block_dim),

        
        
        adj_size = mb_block_dim_adj_size(block_dim),

        /*
        * Top Plate, Recess Depth, Base Cutout
        */
        top_plate_height_pref = top_plate_height[0] * mul_mbu_to_grid[2] + top_plate_height[1] * mul_mm_to_grid[2],
        
        cutout_min_depth = 1 - top_plate_height_pref,
        cutout_max_depth = cutout_max_depth * mul_mbu_to_grid[2],
        
        recess_depth_max = mod_size[2] - top_plate_height_pref - (cutout_type == "none" ? 0 : cutout_min_depth),
        
        recess_depth_final = recess ? (recess_depth != "auto" ? min(recess_depth, recess_depth_max) : recess_depth_max) : 0,
        cutout_depth_calc = max(0, min(cutout_max_depth, mod_size[2] - top_plate_height_pref - recess_depth_final)),
        top_plate_height_final = mod_size[2] - recess_depth_final - cutout_depth_calc,
        cutout_depth = cutout_type == "none" ? 0 : cutout_depth_calc,

        recess_walls = mb_qc_resolve(
            qc = recess_wall_thickness
        ),

        /*
        * Base Wall Thickness
        */
        p_diameter = grid_cfg[1] - studDiameter,
        wall_thickness_pref = (wall_thickness[0] == "auto" ? 0.5 * p_diameter : wall_thickness[0]) * mul_mbu_to_grid[0],
        wall_thickness_final = wall_thickness_pref + wall_thickness[1] * mul_mm_to_grid[0],
        wall_thickness_clamp = wall_thickness_final + clamp[0] * mul_mm_to_grid[0],
        stud_diameter_res = studDiameter * mul_mbu_to_grid[0],

        stud_diameter_final = stud_diameter_res + studDiameterAdjustment * mul_mm_to_grid[0],
        stud_height_final = studHeight * mul_mbu_to_grid[2] + studHeightAdjustment * mul_mm_to_grid[2],
        stud_sink_final = studSink * mul_mbu_to_grid[2],
        stud_rounding_final = studRounding * mul_mbu_to_grid[0],

        clamp_final = [
            clamp[0] * mul_mm_to_grid[0], // Thickness
            clamp[1] * mul_mbu_to_grid[2], // Height
            clamp[2] * mul_mbu_to_grid[2], // Offset
            clamp_outer
        ],
        relief_cut_final = [relief_cut_dim[0] * mul_mbu_to_grid[0], relief_cut_dim[1] * mul_mbu_to_grid[2]],

        top_plate_helpers_final = [top_plate_helpers[0] * mul_mm_to_grid[0], top_plate_helpers[1] * mul_mm_to_grid[2]],
        tube_wall_thickness_res = tubeWallThickness * mul_mbu_to_grid[0],  // TODO XYZ
        
        default_tube_diameter = stud_diameter_res + 2 * tube_wall_thickness_res,  // TODO XYZ
        tube_hole_size = stud_diameter_res, // TODO XYZ

        tongue_thickness_adj = tongueThicknessAdjustment * mul_mm_to_grid[0],
        tongue_final = [
            tongue,
            tongueThickness * mul_mbu_to_grid[0] + tongue_thickness_adj,
            tongueHeight * mul_mbu_to_grid[2],
            tongueOffset * mul_mbu_to_grid[0] - 0.5 * tongue_thickness_adj
        ],


        stabilizers_res = [
            stabilizers[0] * mul_mbu_to_grid[0], // Thickness (mbu)
            stabilizers[1] * mul_mbu_to_grid[2], // Height (mbu)
            stabilizers[2] * mul_mm_to_grid[2], // Offset (mm)
            stabilizers[3] * mul_mbu_to_grid[2], // Expansion Offset (mbu)
            stabilizers[4]                       // Expansion Each
        ],

        pin_diameter = (pinDiameter == "auto" ? p_diameter : pinDiameter) * mul_mbu_to_grid[0] + pinDiameterAdjustment * mul_mm_to_grid[0],

        bevel = mb_bevel_resolve(bevel),
        slope = mb_qc_resolve(slope, false),
        studPadding = mb_qc_resolve(studPadding, false),
        surface_shape = _mb_block_model_surface_shape(mod_size, min_max_pos, bevel, slope, studPadding),
        recess_surface_shape = _mb_block_model_recess_surface_shape(mod_size, min_max_pos, bevel, slope, recess_walls, recessStudPadding),
        recess_inverse_shape = _mb_block_model_recess_inverse_shape(mod_size, min_max_pos, bevel, slope, recess_walls, studPadding)
    )
        [
            [
                size, 
                mod_size, 
                adj_size,
                center
            ], // 0 - Original Size / Mod Size
            [bevel, slope], // 1 - Bevel / Slope
            mb_block_dim_min_max_index(block_dim), // 2 - Min / Max Index
            block_dim, // 3 - 
            [cutout_depth, top_plate_height_final, recess_depth_final, wall_thickness_final, clamp_final, cutout_min_depth], // 4 - Top Plate Height
            [slope_base[0] * mul_mbu_to_grid[2], slope_base[1] * mul_mbu_to_grid[2]], // 5 - Slope Base 
            [size_mod_res, mb_block_dim_base_adj(block_dim)], // 6 - Adjustments
            [grid_cfg, scale], // 7 - Units
            [recess, recess_walls, relief_cut, relief_cut_final, recess_wall_gaps], // 8 - Recesss & Relief Cut
            [top_plate_height_final, top_plate_helpers_final],  // 9 - Top Plate
            [surface_shape, recess_surface_shape, recess_inverse_shape],  // 10 - 
            [],  // 11 - 
            [],  // 12 - 
            tongue_final,  // 13 - Tongue
            [stud_diameter_final, stud_height_final, stud_sink_final, stud_rounding_final, stud_diameter_res],  // 14 - 
            [default_tube_diameter, tube_hole_size, tube_wall_thickness_res, pin_diameter],  // 15 - 
            [stabilizers_res],  // 16 - 
            [baseWallGaps],  // 17 - 
            [custom_modules],  // 18 - 
            [inverted],  // 19 - Inverted
            [id, debug] // 20 - ID, Debug
        ];

/*
* Getters
*/

function mb_block_get_dim(block_obj) =                              block_obj[3];

function mb_block_get_size(block_obj) =                             block_obj[0][0];
function mb_block_get_mod_size(block_obj) =                         block_obj[0][1];
function mb_block_get_size_adjusted(block_obj) =                    block_obj[0][2];
function mb_block_get_center(block_obj) =                           block_obj[0][3];

function mb_block_get_id(block_obj) =                               block_obj[20][0];

function mb_block_get_bevel(block_obj) =                            block_obj[1][0];
function mb_block_get_inverted(block_obj) =                         block_obj[19][0];

function mb_block_get_slope(block_obj) =                            block_obj[1][1];

function mb_block_get_slope_socket(block_obj) =                     block_obj[5];

function mb_block_get_base_cutout_depth(block_obj) =                block_obj[4][0];
function mb_block_get_base_adj(block_obj) =                         block_obj[6][1];
function mb_block_get_size_mod(block_obj) =                         block_obj[6][0];

function mb_block_get_wall_thickness(block_obj) =                   block_obj[4][3];

function mb_block_get_top_plate_height(block_obj) =                 block_obj[4][1];

function mb_block_has_top_plate_helpers(block_obj) =                block_obj[9][1];
function mb_block_get_top_plate_helpers_thickness(block_obj) =      block_obj[9][1][0];
function mb_block_get_top_plate_helpers_height(block_obj) =         block_obj[9][1][1];

function mb_block_has_recess(block_obj) =                           block_obj[8][0];
function mb_block_get_recess_wall_thickness(block_obj) =            block_obj[8][1];
function mb_block_get_recess_depth(block_obj) =                     block_obj[4][2];
function mb_block_get_recess_wall_gaps(block_obj) =                 block_obj[8][4];

function mb_block_get_base_wall_gaps(block_obj) =                   block_obj[17][0];

function mb_block_get_grid_cfg(block_obj) =                         block_obj[7][0];

function mb_block_get_scale(block_obj) =                            block_obj[7][1];

function mb_block_has_relief_cut(block_obj) =                       block_obj[8][2];
function mb_block_get_relief_cut_thickness(block_obj) =             block_obj[8][3][0];
function mb_block_get_relief_cut_height(block_obj) =                block_obj[8][3][1];

function mb_block_get_base_clamp_thickness(block_obj) =             block_obj[4][4][0];
function mb_block_get_base_clamp_height(block_obj) =                block_obj[4][4][1];
function mb_block_get_base_clamp_offset(block_obj) =                block_obj[4][4][2];

function mb_block_get_base_cutout_min_depth(block_obj) =            block_obj[4][5];

function mb_block_get_stabilizers(block_obj) =                      block_obj[16][0];

function mb_block_get_min_max_index(block_obj) =                    block_obj[2];
function mb_block_get_custom_modules(block_obj) =                   block_obj[18];

// Tubes
function mb_block_get_tube_diameter(block_obj, axis) =              block_obj[15][0];
function mb_block_get_tube_hole_size(block_obj, axis) =             block_obj[15][1];
function mb_block_get_tube_wall_thickness(block_obj, axis) =        block_obj[15][2];
function mb_block_get_pin_diameter(block_obj) =                     block_obj[15][3];

// Studs
function mb_block_get_stud_diameter(block_obj, adjusted = true) =   block_obj[14][adjusted ? 0 : 4];
function mb_block_get_stud_height(block_obj) =                      block_obj[14][1];
function mb_block_get_stud_sink(block_obj) =                        block_obj[14][2];
function mb_block_get_stud_rounding(block_obj) =                    block_obj[14][3];

// Tongue
function mb_block_has_tongue(block_obj) =                           block_obj[13][0];
function mb_block_get_tongue_thickness(block_obj) =                 block_obj[13][1];
function mb_block_get_tongue_height(block_obj) =                    block_obj[13][2];
function mb_block_get_tongue_offset(block_obj) =                    block_obj[13][3];

// Shapes
function mb_block_get_surface_shape(block_obj) =                    block_obj[10][0];
function mb_block_get_recess_surface_shape(block_obj) =             block_obj[10][1];
function mb_block_get_recess_inverse_shape(block_obj) =             block_obj[10][2];

/*
* TODO Rename or delete
*/

function mb_block_obj_size(block_obj, unit = "grd") = 
    mb_block_unit_convert(block_obj, mb_block_get_size(block_obj), from = "grd", to = unit);

function mb_block_obj_size_mod(block_obj, unit = "grd") = 
    mb_block_unit_convert(block_obj, mb_block_get_mod_size(block_obj), from = "grd", to = unit);

function mb_block_obj_size_adj(block_obj, unit = "grd") = 
    mb_block_unit_convert(block_obj, mb_block_get_size_adjusted(block_obj), from = "grd", to = unit);

function mb_block_size_mod(block_obj, unit = "grd") = 
    mb_block_unit_convert(block_obj, mb_block_get_size_mod(block_obj), from = "grd", to = unit);

function mb_block_base_adj(block_obj, unit = "grd") = 
    mb_block_unit_convert(block_obj, mb_block_get_base_adj(block_obj), from = "grd", to = unit);

function mb_block_unit_convert(block_obj, v, from = "grd", to="mm") = 
    let(
        mul = mb_unit_mul(mb_block_get_grid_cfg(block_obj), 
            scale = mb_block_get_scale(block_obj), 
            from = from, 
            to = to
        )
    )
    is_num(v) || (is_list(v) && len(v) <= 3) ? 
        mb_resolve_xyz(xyz = v, mul = mul) :
        (is_list(v) && len(v) == 4) ? [v[0] * mul[0], v[1] * mul[0], v[2] * mul[1], v[3] * mul[1]] :
        (is_list(v) && len(v) <= 6) ? [v[0] * mul[0], v[1] * mul[0], v[2] * mul[1], v[3] * mul[1], v[4] * mul[2], len(v) > 5 ? v[5] * mul[2] : undef] :
        undef;

/*
* END TODO Rename or delete
*/

function mb_block_base_cutout_ceiling_offset(block_obj, face, off = 0, cut = false) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        face = mb_face_to_int(face),
        offs = [
            mb_block_get_base_cutout_depth(block_obj),
            mb_block_get_recess_depth(block_obj) + mb_block_get_top_plate_height(block_obj)
        ]
    )
    face == 4 || face == 5 ? (face == 4 ? -(offs[0] - off) : -(offs[1] - off)) + mb_block_dim_cut_offset(block_dim, cut) : undef;

function mb_block_recess_floor_offset(block_obj, face, off = 0, cut = false) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        face = mb_face_to_int(face),
        offs = [
            mb_block_get_base_cutout_depth(block_obj) + mb_block_get_top_plate_height(block_obj),
            mb_block_get_recess_depth(block_obj)
        ]
    )
    face == 4 || face == 5 ? (face == 4 ? -(offs[0] - off) : -(offs[1] - off)) + mb_block_dim_cut_offset(block_dim, cut) : undef;

/**
* -----
* Studs
* -----
*/

function mb_block_stud_range(block_obj) =
    let(
        min_max_index = mb_block_get_min_max_index(block_obj),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1]
    )
    [
        [start_index_x : end_index_x],
        [start_index_y : end_index_y]
    ];

function mb_block_stud_render(block_obj, x, y) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        surface_shape = mb_block_get_surface_shape(block_obj),
        recess_surface_shape = mb_block_get_recess_surface_shape(block_obj),
        recess_inverse_shape = mb_block_get_recess_inverse_shape(block_obj),
        stud_offset = mb_block_stud_offset(block_obj, x, y),
        stud_diameter = mb_block_get_stud_diameter(block_obj, false),
        stud_height = mb_block_get_stud_height(block_obj),
        stud_sink = mb_block_get_stud_sink(block_obj),
        render_stud = mb_circle_in_convex_quad(surface_shape, stud_offset, 0.5 * stud_diameter, overhang = 0.2),
        in_recess = mb_circle_in_convex_quad(recess_surface_shape, stud_offset, 0.5 * stud_diameter, overhang = 0.2),
        on_recess_wall = !mb_circle_in_convex_quad(recess_inverse_shape, stud_offset, 0.5 * stud_diameter, touch = true, overhang = 0),
        bottom = in_recess 
        ? mb_block_recess_floor_offset(
            block_obj,
            off = stud_sink,
            face = "z-"
        )
        : mb_block_dim_opposite_offset(
            block_dim, 
            off = stud_sink, 
            adjusted = true, 
            face = "z-"
        ),
        top = in_recess ? 
        mb_block_recess_floor_offset(
            block_obj,
            off = stud_height,
            face = "z+"
        )
        : mb_block_dim_face_edge_expand(
            block_dim, 
            exp = stud_height, 
            adjusted = true, 
            face = "z+"
        )
        
    )
    [
        render_stud && (in_recess || on_recess_wall),
        stud_offset,
        [bottom, top]  
    ];

function mb_block_stud_offset(block_obj, x, y) = //TODO
    let(
        
    )
    mb_block_pos_to_offset(block_obj, [x + 0.5, y + 0.5, undef]);

function mb_block_stud_radius(block_obj, x, y) =
    let(stud_diameter = mb_block_get_stud_diameter(block_obj))
        0.5 * stud_diameter;


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
        range_offset_start = (is_pin[0] || is_pin[1]) && !(is_pin[0] && is_pin[1]) 
            ? [is_pin[0] ? 0 : 1, is_pin[1] ? 0 : 1] 
            : [1, 1],
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
        tube_offset = is_pin[0] || is_pin[1] 
            ? [is_pin[0] ? 0.5 : 0, is_pin[1] ? 0.5 : 0] 
            : [0, 0]
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
    is_pin[0] || is_pin[1] 
        ? 0.5 * pin_diameter 
        : [0.5 * tube_z_hole_size, 0.5 * tube_z_diameter];

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
        min_max_index = mb_block_get_min_max_index(block_obj),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        axis = mb_axis_to_int(axis),
        stabilizers = mb_block_get_stabilizers(block_obj),
        top_plate_helpers_thickness = mb_block_get_top_plate_helpers_thickness(block_obj),
        top_plate_helpers_height = mb_block_get_top_plate_helpers_height(block_obj),
        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        tube_wall_thickness = mb_block_get_tube_wall_thickness(block_obj, "z"),
        default_segment_length = 1 - tube_z_diameter + tube_wall_thickness,
        segment_thickness = stabilizers[0],
        stabilizer_expansion = stabilizers[4],
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        segment_height_expanded = max(base_cutout_depth - stabilizers[3], 0),
        is_pin = mb_block_tube_is_pin(block_obj, axis),
        expanded = axis == 1 ? 
            is_pin[1] || ((x % stabilizer_expansion) == 0 && ((end_index_x - start_index_x) > 2)): 
            is_pin[0] || ((y % stabilizer_expansion) == 0 && ((end_index_y - start_index_y) > 2)),
        seg_size = [
            axis == 1 ? segment_thickness : default_segment_length, 
            axis == 1 ? default_segment_length : segment_thickness, 
            (expanded ? segment_height_expanded : stabilizers[1]) + (axis == 1 ? -stabilizers[2] : 0)
        ]
    )
    [
        seg_size,
        [
            (axis == 1 ? 2 * top_plate_helpers_thickness : 0),
            (axis == 0 ? 2 * top_plate_helpers_thickness : 0),
            top_plate_helpers_height
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
        
/**
* ---------------
* Private Helpers
* ---------------
*/ 

function _mb_block_model_surface_shape(mod_size, min_max_pos, bevel, slope, stud_padding) =
    let(
        exp = mb_array_add(mb_slope_filter(slope, 1, -1), mb_array_mul(stud_padding, -1)),
        bevel_matrix = mb_bevel_matrix(bevel, mod_size, min_max_pos),
        bevel_res = bevel_matrix[0],
        bevel_fil = bevel_matrix[1]
    )
    mb_prismoid_plane_expand(bevel_fil, 0, exp);

function _mb_block_model_recess_surface_shape(mod_size, min_max_pos, bevel, slope, recess_wall_thickness, recess_stud_padding) =
    let(
        pad = mb_array_add(recess_wall_thickness, recess_stud_padding),
        exp = mb_array_add(mb_slope_filter(slope, 1, -1), mb_array_mul(pad, -1)),
        bevel_matrix = mb_bevel_matrix(bevel, mod_size, min_max_pos),
        bevel_res = bevel_matrix[0],
        bevel_fil = bevel_matrix[1]
    )
    mb_prismoid_plane_expand(bevel_fil, 0, exp);

function _mb_block_model_recess_inverse_shape(mod_size, min_max_pos, bevel, slope, recess_wall_thickness, stud_padding) =
    let(
        pad = mb_array_add(mb_array_sub_simple(recess_wall_thickness, stud_padding), 0.0125),
        exp = mb_array_add(mb_slope_filter(slope, 1, -1), mb_array_mul(pad, -1)),
        bevel_matrix = mb_bevel_matrix(bevel, mod_size, min_max_pos),
        bevel_res = bevel_matrix[0],
        bevel_fil = bevel_matrix[1]
    )
    mb_prismoid_plane_expand(bevel_fil, 0, exp);

/*
* -------------
* END BLOCK OBJ
* -------------
*/
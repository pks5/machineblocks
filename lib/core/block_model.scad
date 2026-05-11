use <geometry.scad>;
use <../utils.scad>;

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
    top_plate_helpers = [0.4, 0.2], // [Thickness (mbu), Height (mbu)]
    recess_depth = "auto",
    slope_base = [1.333, 1], // [Bottom, Top]
    wall_thickness = ["auto", -0.1], // [Thickness (mbu), Adjustment (mm)]
    cutout_max_depth = 5,
    cutout_type = "standard",
    recess = false,
    recess_depth = "auto",
    recess_wall_thickness = 0.333, 
    recess_wall_gaps = [],
    clamp = [0.1, 0.25, 0.5], // [Thickness (mm), Offset (mbu), Height (mbu)]
    clamp_outer = true,
    stud_diameter = 3,
    relief_cut = false,
    relief_cut_dim = [0.375, 0.375], // [Thickness (mbu), Height (mbu)]
    id = "[Block]",
    custom_modules = ["my_cube"],
    debug = false
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
    
        clamp_final = [clamp[0] * mul_mm_to_grid[0], clamp[1] * mul_mbu_to_grid[2], clamp[2] * mul_mbu_to_grid[2], clamp_outer],
        relief_cut_final = [relief_cut_dim[0] * mul_mbu_to_grid[0], relief_cut_dim[1] * mul_mbu_to_grid[2]],

        top_plate_helpers_final = [top_plate_helpers[0] * mul_mm_to_grid[0], top_plate_helpers[1] * mul_mm_to_grid[2]]
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
            [],  // 15 - 
            [],  // 16 - 
            [],  // 17 - 
            [custom_modules],  // 18 - 
            [false],  // 19 - 
            [id, debug, 0.01] // 20 - ID, Debug, Cut Tolerance
        ];

/*
* Getters
*/

function mb_block_get_id(block_obj) = block_obj[20][0];
function mb_block_get_cut_tolerance(block_obj) = block_obj[20][2];

function mb_block_get_bevel(block_obj) = block_obj[1][0];
function mb_block_get_inverted(block_obj) = block_obj[19][0];

function mb_block_get_slope(block_obj) = block_obj[1][1];

function mb_block_get_slope_socket(block_obj) = block_obj[5];

function mb_block_get_base_cutout_depth(block_obj) = block_obj[4][0];
function mb_block_get_base_adj(block_obj) = block_obj[6][1];
function mb_block_get_size_mod(block_obj) = block_obj[6][0];

function mb_block_get_size(block_obj) = block_obj[0][0][0];
function mb_block_get_center(block_obj) = block_obj[0][0][2];
function mb_block_get_mod_size(block_obj) = block_obj[0][1][0];

function mb_block_get_wall_thickness(block_obj) = block_obj[4][3];

function mb_block_get_top_plate_height(block_obj) = block_obj[4][1];
function mb_block_get_top_plate_helpers(block_obj) = block_obj[9][1];

function mb_block_get_recess(block_obj) = block_obj[8][0];
function mb_block_get_recess_wall_thickness(block_obj) = block_obj[8][1];
function mb_block_get_recess_depth(block_obj) = block_obj[4][2];
function mb_block_get_recess_wall_gaps(block_obj) = block_obj[8][4];

function mb_block_get_grid_cfg(block_obj) = block_obj[7][0];

function mb_block_get_scale(block_obj) = block_obj[7][1];

function mb_block_get_relief_cut(block_obj) = block_obj[8][2];
function mb_block_get_relief_cut_dim(block_obj) = block_obj[8][3];

function mb_block_get_clamp(block_obj) = block_obj[4][4];

function mb_block_get_base_cutout_min_depth(block_obj) = block_obj[4][5];


/*
* TODO Rename or delete
*/

function mb_block_custom_module_mapping(block_obj, mname) = 
    let(mappings = block_obj[18][0], f = [
        for(i = [0:len(mappings)-1])
            if (mappings[i] == mname)
                i
    ])
    len(f) > 0 ? f[0] : undef;

    
    


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

function mb_recess_wall_gap(block_obj, gap) = 
    let(gap = mb_to_array(gap),
        face = mb_side_to_int(gap[0]),
        recess_walls = mb_block_get_recess_wall_thickness(block_obj))
        [
            face,
            is_undef(gap[1]) ? 0 : gap[1],
            is_undef(gap[2]) ? 0 : gap[2]
        ];

function mb_block_pos_to_offset(block_obj, pos) = 
    let(center = mb_block_get_center(block_obj))
        [pos[0] - center[0], pos[1] - center[1], pos[2] - center[2]];
        

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
/*
* Methods
*/





/*
* -------------
* END BLOCK OBJ
* -------------
*/
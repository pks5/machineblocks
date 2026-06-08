use <geometry.scad>;
use <utils.scad>;
use <block_dim.scad>;
use <bevel.scad>;
use <poly_expand.scad>;
use <api.scad>;

function mb_block_obj(
    config,
    settings
) =
    let(
        id = mb_param_id(config, settings),
        debug = mb_param_debug(config, settings),

        unitMbuToMm = mb_param_unitMbuToMm(config, settings),
        unitGridToMbu = mb_param_unitGridToMbu(config, settings),
        scale = mb_param_scale(config, settings),

        size = mb_param_size(config, settings),
        sizeMod = mb_param_sizeMod(config, settings),
        sizeAdjustment = mb_param_sizeAdjustment(config, settings),

        grid_cfg = [unitMbuToMm, unitGridToMbu[0], unitGridToMbu[1]],
        mul_mbu_to_grid = mb_unit_mul(grid_cfg, scale = scale, from="mbu", to="grd"),
        mul_mm_to_grid = mb_unit_mul(grid_cfg, scale = scale, from="mm", to="grd"),
        mbu2grd_xy = mul_mbu_to_grid[0],
        mbu2grd_z = mul_mbu_to_grid[2],
        mm2grd_xy = mul_mm_to_grid[0],
        mm2grd_z = mul_mm_to_grid[2],


        base_adj_grd = mb_qc_resolve(
            qc = mb_param_baseAdjustment(config, settings), 
            cube = true, 
            default = [
                sizeAdjustment[0], 
                sizeAdjustment[0], 
                sizeAdjustment[0], 
                sizeAdjustment[0], 
                0, 
                sizeAdjustment[1]
            ],
            mul = mul_mm_to_grid
        ),
        
        block_dim = mb_block_dim(
            size = size, 
            size_mod = sizeMod,
            base_adj = base_adj_grd,
            bevel = mb_param_bevel(config, settings),
            slope = mb_param_slope(config, settings)
        ),

        size_res = mb_block_dim_size(block_dim),
        size_mod_res = mb_block_dim_size_mod(block_dim),
        center = mb_block_dim_center(block_dim),
        
        mod_size = mb_block_dim_mod_size(block_dim),
        min_max_pos = mb_block_dim_min_max_pos(block_dim),

        
        
        adj_size = mb_block_dim_adj_size(block_dim),

        inverted = false,
        printerNozzleDiameter = mb_param_printerNozzleDiameter(config, settings) * mm2grd_xy,
        printerLayerHeight = mb_param_printerLayerHeight(config, settings) * mm2grd_z,
        

        /*
        * Top Plate, Recess Depth, Base Cutout
        */
        top_plate_height_pref = mb_param_topPlateHeight(config, settings) * mbu2grd_z 
                                + mb_param_topPlateHeightAdjustment(config, settings) * mm2grd_z,
        
        cutout_min_depth = 1 - top_plate_height_pref,
        
        baseCutoutType = mb_param_baseCutoutType(config, settings),
        baseCutoutMaxDepth = mb_param_baseCutoutMaxDepth(config, settings) * mbu2grd_z,
        
        recess_depth_max = mod_size[2] - top_plate_height_pref - (baseCutoutType == "none" ? 0 : cutout_min_depth),
        
        recess = mb_param_recess(config, settings),
        recessDepth = mb_param_recessDepth(config, settings),
        recess_depth_final = recess ? (recessDepth != "auto" ? min(recessDepth, recess_depth_max) : recess_depth_max) : 0,
        cutout_depth_calc = max(0, min(baseCutoutMaxDepth, mod_size[2] - top_plate_height_pref - recess_depth_final)),
        top_plate_height_final = mod_size[2] - recess_depth_final - cutout_depth_calc,
        cutout_depth = baseCutoutType == "none" ? 0 : cutout_depth_calc,

        recess_walls = mb_qc_resolve(mb_param_recessWallThickness(config, settings)),
        recessStudPadding =  mb_param_recessStudPadding(config, settings),
        recessWallGaps = mb_to_array(mb_param_recessWallGaps(config, settings)),

        /*
        * Base Wall Thickness
        */
        baseWallThickness = mb_param_baseWallThickness(config, settings),
        baseClampThickness = mb_param_baseClampThickness(config, settings),
        stud_diameter = mb_param_studDiameter(config, settings),
        p_diameter = grid_cfg[1] - stud_diameter,
        wall_thickness_pref = (baseWallThickness == "auto" ? 0.5 * p_diameter : baseWallThickness) * mbu2grd_xy,
        wall_thickness_final = wall_thickness_pref + mb_param_baseWallThicknessAdjustment(config, settings) * mm2grd_xy,
        wall_thickness_clamp = wall_thickness_final + baseClampThickness * mm2grd_xy,
        
        /*
        * Base Clamp
        */
        base_clamp = [
            baseClampThickness * mm2grd_xy, // Thickness
            mb_param_baseClampHeight(config, settings) * mbu2grd_z, // Height
            mb_param_baseClampOffset(config, settings) * mbu2grd_z // Offset
        ],

        /*
        * Studs
        */
        has_studs = mb_param_studs(config, settings), // TODO
        stud_diameter_res = stud_diameter * mbu2grd_xy,
        stud_height_res = mb_param_studHeight(config, settings) * mbu2grd_z,

        stud_diameter_final = stud_diameter_res + mb_param_studDiameterAdjustment(config, settings) * mm2grd_xy,
        stud_height_final = stud_height_res + mb_param_studHeightAdjustment(config, settings) * mm2grd_z,
        stud_sink_final = mb_param_studBaseOverlap(config, settings) * mbu2grd_z,
        stud_rounding_final = mb_param_studRounding(config, settings) * mbu2grd_xy,
        stud_max_overhang = mb_param_studMaxOverhang(config, settings) * mbu2grd_xy,

        stud_padding = mb_qc_resolve(mb_param_studPadding(config, settings), false),
        studHoleDiameter  = mb_param_studHoleDiameter(config, settings),
        stud_hole_diameter = (studHoleDiameter == "auto" ? p_diameter : studHoleDiameter) * mbu2grd_xy 
                              + mb_param_studHoleDiameterAdjustment(config, settings) * mm2grd_xy,
        
        stud_icon = mb_param_studIcon(config, settings),
        stud_icon_dimensions = mb_param_studIconDimensions(config, settings),
        stud_icon_color = mb_param_studIconColor(config, settings),
        stud_icon_scale = mb_param_studIconScale(config, settings),
        stud_icon_depth = mb_param_studIconDepth(config, settings) * mbu2grd_z,

        stud_cutout_diameter = stud_diameter_res + mb_param_studCutoutDiameterAdjustment(config, settings) * mm2grd_xy,
        stud_cutout_height = stud_height_res + mb_param_studCutoutHeightAdjustment(config, settings) * mm2grd_z,

        /*
        * Surface Pattern
        */
        surface_pattern = mb_param_surfacePattern(config, settings),
        surface_pattern_dimensions = mb_param_surfacePatternDimensions(config, settings),
        surface_pattern_offset = mb_param_surfacePatternOffset(config, settings),
        surface_pattern_size = mb_param_surfacePatternSize(config, settings),
        surface_pattern_color = mb_param_surfacePatternColor(config, settings),
        surface_pattern_padding = mb_qc_resolve(mb_param_surfacePatternPadding(config, settings)),
        surface_pattern_scale = mb_param_surfacePatternScale(config, settings),
        surface_pattern_depth = mb_param_surfacePatternDepth(config, settings),

        

        /*
        * Relief Cut
        */
        relief_cut_final = [
            mb_param_reliefCut(config, settings),
            mb_param_reliefCutThickness(config, settings) * mbu2grd_xy, 
            mb_param_reliefCutHeight(config, settings) * mbu2grd_z
        ],

        /*
        * Top Plate Helpers
        */
        top_plate_helpers_final = [
            mb_param_topPlateHelpers(config, settings),
            mb_param_topPlateHelperThickness(config, settings) * mm2grd_xy, 
            mb_param_topPlateHelperHeight(config, settings) * mm2grd_z
        ],
        
        /*
        * Tube / Pin
        */
        tube_diameter = mb_param_tubeDiameter(config, settings),
        tube_diameter_adj = mb_param_tubeDiameterAdjustment(config, settings),
        pillar_org_wall_thickness = mb_param_pillarOriginalWallThickness(config, settings) * mbu2grd_xy,
        tube_diameter_original = stud_diameter_res + 2 * pillar_org_wall_thickness,  // TODO XYZ
        tube_diameter_xyz = [
            for(i = [0 : 2])
                (tube_diameter[i] == "auto" ? tube_diameter_original : (tube_diameter[i] * mbu2grd_xy)) + tube_diameter_adj[i] * mm2grd_xy
        ],
        hole_xyz_diameter = mb_param_holeXYZDiameter(config, settings),
        tube_hole_size_adj = mb_param_holeXYZDiameterAdjustment(config, settings),
        tube_hole_size_xyz = [
            for(i = [0 : 2])
                (hole_xyz_diameter[i] == "auto" ? stud_diameter_res : (hole_xyz_diameter[i] * mbu2grd_xy)) + tube_hole_size_adj[i] * mm2grd_xy
        ],
        pinDiameter = mb_param_pinDiameter(config, settings),
        pin_diameter = (pinDiameter == "auto" ? p_diameter : pinDiameter) * mbu2grd_xy 
                        + mb_param_pinDiameterAdjustment(config, settings) * mm2grd_xy,

        hole_xyz_inset_thickness = mb_param_holeXYZInsetThickness(config, settings),
        hole_xyz_inset_thickness_adj = mb_param_holeXYZInsetThicknessAdjustment(config, settings),

        tube_hole_inset_thickness = [
            for(i = [0 : 2])
                hole_xyz_inset_thickness[i] * mbu2grd_xy + hole_xyz_inset_thickness_adj[i] * mm2grd_xy
        ],

        hole_xyz_inset_depth = mb_param_holeXYZInsetDepth(config, settings),
        hole_xyz_inset_depth_adj = mb_param_holeXYZInsetDepthAdjustment(config, settings),
        
        tube_hole_inset_depth = [
            for(i = [0 : 2])
                hole_xyz_inset_depth[i] * mbu2grd_xy + hole_xyz_inset_depth_adj[i] * mm2grd_xy
        ],

        tube_hole_grid_offset_z = [
            for(i = [0 : 1])
                mb_param_holeXYGridOffsetZ(config, settings)[i] * mbu2grd_z
                            + mb_param_holeXYGridOffsetZAdjustment(config, settings)[i] * mm2grd_z
        ],

        tube_hole_grid_size_z = [
            for(i = [0 : 1])
                mb_param_holeXYGridSizeZ(config, settings)[i] * mbu2grd_z
                            + mb_param_holeXYGridSizeZAdjustment(config, settings)[i] * mm2grd_z
        ],

        tube_hole_min_top_margin = [
            for(i = [0 : 1])
                mb_param_holeXYMinTopMargin(config, settings)[i] * mbu2grd_z
        ],

        has_holes = [
            mb_param_holeX(config, settings),
            mb_param_holeY(config, settings),
            mb_param_holeZ(config, settings)
        ],

        /*
        * Tongue
        */
        tongue_thickness_adj = mb_param_tongueThicknessAdjustment(config, settings) * mm2grd_xy,
        tongue_final = [
            mb_param_tongue(config, settings),
            mb_param_tongueThickness(config, settings) * mbu2grd_xy + tongue_thickness_adj,
            mb_param_tongueHeight(config, settings) * mbu2grd_z,
            mb_param_tongueOffset(config, settings) * mbu2grd_xy - 0.5 * tongue_thickness_adj,
            mb_param_tongueClampThickness(config, settings) * mbu2grd_xy,
            mb_param_tongueClampHeight(config, settings) * mbu2grd_z,
            mb_param_tongueClampOffset(config, settings) * mbu2grd_z
        ],

        /*
        * Stabilizers
        */
        stabilizers_res = [
            mb_param_stabilizers(config, settings), // Has Stabilizers
            mb_param_stabilizerThickness(config, settings) * mbu2grd_xy, // Thickness (mbu)
            mb_param_stabilizerHeight(config, settings) * mbu2grd_z, // Height (mbu)
            mb_param_stabilizerLayerOffset(config, settings) * mm2grd_z, // Offset (mm)
            mb_param_stabilizerExpansion(config, settings),                       // Expansion Each
            mb_param_stabilizerExpansionOffset(config, settings) * mbu2grd_z // Expansion Offset (mbu)
        ],

        /*
        * Connectors
        */
        connectorLength = mb_param_connectorLength(config, settings),
        
        connector_length_xyz_male = connectorLength == "auto" ? mb_param_resolve_xyz(connectorLength) : mb_array_mul(mul_mbu_to_grid, connectorLength),
        connector_depth_xyz_male = mb_array_mul(mul_mbu_to_grid, mb_param_connectorDepth(config, settings)),
        connector_width_xyz_male = mb_array_mul(mul_mbu_to_grid, mb_param_connectorWidth(config, settings)),
        
        connector_length_xyz_clearance = mb_array_mul(mul_mm_to_grid, mb_param_connectorLengthClearance(config, settings)),
        connector_side_xyz_clearance = mb_array_mul(mul_mm_to_grid, mb_param_connectorSideClearance(config, settings)),

        connector_length_xyz_female = connectorLength == "auto" ? mb_param_resolve_xyz(connectorLength) : mb_array_add(connector_length_xyz_male, connector_length_xyz_clearance),
        connector_depth_xyz_female = mb_array_add(connector_depth_xyz_male, connector_side_xyz_clearance),
        connector_width_xyz_female = mb_array_add(connector_width_xyz_male, mb_array_mul(connector_side_xyz_clearance, 4.82842712)),
        
        /*
        * Masks
        */
        bevel_matrix = mb_block_dim_bevel_matrix(block_dim),
        slope = mb_block_dim_slope(block_dim),
        
        base_cutout_mask = mb_poly_expand(bevel_matrix, 0, -wall_thickness_final),
        surface_shape = _mb_block_model_surface_shape(bevel_matrix, slope, stud_padding),
        recess_surface_shape = _mb_block_model_recess_surface_shape(bevel_matrix, slope, recess_walls, recessStudPadding),
        recess_inverse_shape = _mb_block_model_recess_inverse_shape(bevel_matrix, slope, recess_walls, stud_padding, stud_max_overhang)
    )
        [
            [
                size, 
                mod_size, 
                adj_size,
                center
            ], // 0 - Original Size / Mod Size
            [], // 1 - 
            top_plate_helpers_final, // 2 - 
            block_dim, // 3 - 
            [
                cutout_depth, 
                top_plate_height_final, 
                baseCutoutType, 
                wall_thickness_final, 
                base_clamp, 
                cutout_min_depth,
                mb_param_base(config, settings)
            ], // 4 - Top Plate Height
            [
                mb_param_slopeBaseHeightBottom(config, settings) * mbu2grd_z, 
                mb_param_slopeBaseHeightTop(config, settings) * mbu2grd_z, 
                mb_param_slopeBaseHeightInner(config, settings) * mbu2grd_z
            ], // 5 - Slope Base 
            [
                size_mod_res, 
                mb_block_dim_base_adj(block_dim)
            ], // 6 - Adjustments
            [
                grid_cfg, 
                scale
            ], // 7 - Units
            [
                recess, 
                recess_walls, 
                recess_depth_final, 
                recessWallGaps
            ], // 8 - Recesss & Relief Cut
            [
                top_plate_height_final
            ],  // 9 - Top Plate
            [
                surface_shape, 
                recess_surface_shape, 
                recess_inverse_shape, 
                base_cutout_mask
            ],  // 10 - 
            [
                top_plate_height_pref
            ],  // 11 - 
            relief_cut_final,  // 12 - 
            tongue_final,  // 13 - Tongue
            [
                stud_diameter_final, 
                stud_height_final, 
                stud_sink_final, 
                stud_rounding_final, 
                stud_diameter_res, 
                stud_max_overhang,
                has_studs,
                stud_cutout_diameter,
                stud_cutout_height,
                mb_param_studShift(config, settings),
                stud_hole_diameter,
                mb_param_studHoleClampThickness(config, settings),
                mb_param_studType(config, settings),
                mb_param_recessStuds(config, settings),
                mb_param_recessStudType(config, settings),
                mb_param_recessStudShift(config, settings)
            ],  // 14 - 
            [
                tube_diameter_xyz, 
                undef, 
                pillar_org_wall_thickness, 
                pin_diameter
            ],  // 15 - 
            stabilizers_res,  // 16 - 
            [
                mb_to_array(mb_param_baseWallGaps(config, settings))
            ],  // 17 - 
            [
                surface_pattern,
                surface_pattern_dimensions,
                surface_pattern_size,
                surface_pattern_offset,
                surface_pattern_padding,
                surface_pattern_color,
                surface_pattern_scale,
                surface_pattern_depth
            ],  // 18 - 
            [
                inverted
            ],  // 19 - Inverted
            [
                id, 
                debug
            ], // 20 - ID, Debug
            [
                stud_icon,
                stud_icon_dimensions,
                undef,
                stud_icon_color,
                stud_icon_scale,
                stud_icon_depth
            ], // 21 - Stud Icon
            [
                mb_param_grille(config, settings),
                mb_param_grilleInverted(config, settings),
                mb_param_grilleDepth(config, settings) * mbu2grd_z,
                mb_param_grilleCount(config, settings)
            ], // 22 - Grille
            [
                mb_param_svg(config, settings),
                mb_param_svgDimensions(config, settings),
                mb_param_svgFace(config, settings),
                mb_array_mul(mul_mbu_to_grid, mb_param_svgDepth(config, settings)),
                mb_param_svgScale(config, settings),
                mb_param_svgOffset(config, settings),
                mb_param_svgColor(config, settings)
            ], // 23 - SVG Decorator
            [
                mb_param_connectors(config, settings),
                [
                    connector_length_xyz_male,
                    connector_length_xyz_female
                ],
                [
                    connector_depth_xyz_male,
                    connector_depth_xyz_female
                ],
                [
                    connector_width_xyz_male,
                    connector_width_xyz_female
                ]
            ], // 24 Connectors
            [
                mb_param_text(config, settings),
                mb_param_textFace(config, settings),
                mb_array_mul(mul_mbu_to_grid, mb_param_textDepth(config, settings)),
                mb_param_textFont(config, settings),
                mb_param_textSize(config, settings),
                mb_param_textSpacing(config, settings),
                mb_param_textAlign(config, settings),
                mb_param_textOffset(config, settings),
                mb_param_textColor(config, settings)
            ], // 25 Text
            [
                mb_param_pcb(config, settings),
                mb_param_pcbDimensions(config, settings),
                mb_array_mul(mb_param_pcbOffset(config, settings), mm2grd_xy),
                mb_param_pcbSocketDiameter(config, settings) * mm2grd_xy,
                mb_param_pcbSocketHoleDiameter(config, settings) * mm2grd_xy,
                mb_param_pcbSocketHeight(config, settings) * mm2grd_z,
                mb_param_pcbSockets(config, settings)
            ], // 26 PCB
            [
                mb_param_screwHoles(config, settings),
                mb_array_mul(mul_mm_to_grid, mb_param_screwHoleDiameter(config, settings)),
                mb_array_mul(mul_mm_to_grid, mb_param_screwHoleDepth(config, settings)),
                mb_array_mul(mul_mm_to_grid, mb_param_screwHoleInsetThickness(config, settings)),
                mb_array_mul(mul_mm_to_grid, mb_param_screwHoleInsetDepth(config, settings))
            ], // 27 - Screw Holes
            [
                has_holes,
                tube_hole_size_xyz,
                mb_param_holeXYZShift(config, settings),
                tube_hole_inset_thickness,
                tube_hole_inset_depth,
                tube_hole_grid_offset_z,
                tube_hole_grid_size_z,
                tube_hole_min_top_margin
            ] // 28 - Pin Holes
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

// Slope
function mb_block_get_slope_socket(block_obj) =                     [block_obj[5][0], block_obj[5][1]];
function mb_block_get_slope_base_height_bottom(block_obj) =          block_obj[5][0];
function mb_block_get_slope_base_height_inner(block_obj) =          block_obj[5][2];

function mb_block_get_base_cutout_depth(block_obj) =                block_obj[4][0];
function mb_block_in_base_cutout(block_obj, off, dia) =
    mb_circle_in_convex_quad(block_obj[10][3], off, 0.5 * dia, overhang = 0);

function mb_block_get_base_adj(block_obj) =                         block_obj[6][1];
function mb_block_get_size_mod(block_obj) =                         block_obj[6][0];

function mb_block_get_wall_thickness(block_obj) =                   block_obj[4][3];
function mb_block_has_base(block_obj) =                             block_obj[4][6];

// Top Plate
function mb_block_get_top_plate_height(block_obj) =                 block_obj[4][1];
function mb_block_get_top_plate_height_pref(block_obj) =            block_obj[11][0];

function mb_block_has_top_plate_helpers(block_obj) =                block_obj[2][0];
function mb_block_get_top_plate_helpers_thickness(block_obj) =      block_obj[2][1];
function mb_block_get_top_plate_helpers_height(block_obj) =         block_obj[2][2];

// Recess
function mb_block_has_recess(block_obj) =                           block_obj[8][0];
function mb_block_get_recess_wall_thickness(block_obj) =            block_obj[8][1];
function mb_block_get_recess_depth(block_obj) =                     block_obj[8][2];
function mb_block_get_recess_wall_gaps(block_obj) =                 block_obj[8][3];

function mb_block_get_base_wall_gaps(block_obj) =                   block_obj[17][0];

function mb_block_get_grid_cfg(block_obj) =                         block_obj[7][0];

function mb_block_get_scale(block_obj) =                            block_obj[7][1];

// Relief Cut
function mb_block_has_relief_cut(block_obj) =                       block_obj[12][0];
function mb_block_get_relief_cut_thickness(block_obj) =             block_obj[12][1];
function mb_block_get_relief_cut_height(block_obj) =                block_obj[12][2];

// Base Clamp
function mb_block_get_base_clamp_thickness(block_obj) =             block_obj[4][4][0];
function mb_block_get_base_clamp_height(block_obj) =                block_obj[4][4][1];
function mb_block_get_base_clamp_offset(block_obj) =                block_obj[4][4][2];

// Base Cutout

function mb_block_get_base_cutout_min_depth(block_obj) =            block_obj[4][5];
function mb_block_has_standard_cutout(block_obj) =                  block_obj[4][2] == "standard";

// Grille
function mb_block_get_grille(block_obj) =                           block_obj[22][0];
function mb_block_is_grille_inverted(block_obj) =                   block_obj[22][1];
function mb_block_get_grille_depth(block_obj) =                     block_obj[22][2];
function mb_block_get_grille_count(block_obj) =                     block_obj[22][3];

// Stabilizers
function mb_block_has_stabilizers(block_obj) =                      block_obj[16][0];
function mb_block_get_stabilizer_thickness(block_obj) =             block_obj[16][1];
function mb_block_get_stabilizer_height(block_obj) =                block_obj[16][2];
function mb_block_get_stabilizer_start_offset(block_obj) =          block_obj[16][3];
function mb_block_get_stabilizer_expansion(block_obj) =             block_obj[16][4];
function mb_block_get_stabilizer_expansion_offset(block_obj) =      block_obj[16][5];

// Tubes
function mb_block_get_tube_diameter(block_obj, axis) =              block_obj[15][0][mb_axis_to_int(axis)];

// Pillars
function mb_block_get_pillar_wall_thickness(block_obj) =            block_obj[15][2];
function mb_block_get_pin_diameter(block_obj) =                     block_obj[15][3];

// Holes
function mb_block_has_holes(block_obj, axis) =                      block_obj[28][0][mb_axis_to_int(axis)];
function mb_block_get_hole_xyz_diameter(block_obj, axis) =          block_obj[28][1][mb_axis_to_int(axis)];
function mb_block_get_hole_xyz_shift(block_obj, axis) =             block_obj[28][2][mb_axis_to_int(axis)];
function mb_block_get_hole_xyz_inset_thickness(block_obj, axis) =   block_obj[28][3][mb_axis_to_int(axis)];
function mb_block_get_hole_xyz_inset_depth(block_obj, axis) =       block_obj[28][4][mb_axis_to_int(axis)];
function mb_block_get_hole_xy_grid_offset_z(block_obj, axis) =      block_obj[28][5][mb_axis_to_int(axis)];
function mb_block_get_hole_xy_grid_size_z(block_obj, axis) =        block_obj[28][6][mb_axis_to_int(axis)];
function mb_block_get_hole_xy_min_top_margin(block_obj, axis) =     block_obj[28][7][mb_axis_to_int(axis)];

// Studs
function mb_block_get_stud_diameter(block_obj, adjusted = true) =   block_obj[14][adjusted ? 0 : 4];
function mb_block_get_stud_height(block_obj) =                      block_obj[14][1];
function mb_block_get_stud_sink(block_obj) =                        block_obj[14][2];
function mb_block_get_stud_rounding(block_obj) =                    block_obj[14][3];
function mb_block_get_stud_max_overhang(block_obj) =                block_obj[14][5];
function mb_block_has_studs(block_obj) =                            block_obj[14][6];
function mb_block_get_stud_cutout_diameter(block_obj) =             block_obj[14][7];
function mb_block_get_stud_cutout_height(block_obj) =               block_obj[14][8];
function mb_block_get_stud_shift(block_obj) =                       block_obj[14][9];
function mb_block_get_stud_hole_diameter(block_obj) =               block_obj[14][10];
function mb_block_get_stud_hole_clamp_thickness(block_obj) =        block_obj[14][11];
function mb_block_get_stud_type(block_obj) =                        block_obj[14][12];
function mb_block_get_recess_studs(block_obj) =                     block_obj[14][13];
function mb_block_get_recess_stud_type(block_obj) =                 block_obj[14][14];
function mb_block_get_recess_stud_shift(block_obj) =                block_obj[14][15];

function mb_block_get_stud_icon(block_obj) =                        block_obj[21][0];
function mb_block_get_stud_icon_dimensions(block_obj) =             block_obj[21][1];
function mb_block_get_stud_icon_color(block_obj) =                  block_obj[21][3];
function mb_block_get_stud_icon_scale(block_obj) =                  block_obj[21][4];
function mb_block_get_stud_icon_depth(block_obj) =                  block_obj[21][5];

// Surface Pattern
function mb_block_get_surface_pattern(block_obj) =                  block_obj[18][0];
function mb_block_get_surface_pattern_dimensions(block_obj) =       block_obj[18][1];
function mb_block_get_surface_pattern_size(block_obj) =             block_obj[18][2];
function mb_block_get_surface_pattern_offset(block_obj) =           block_obj[18][3];
function mb_block_get_surface_pattern_padding(block_obj) =          block_obj[18][4];
function mb_block_get_surface_pattern_color(block_obj) =            block_obj[18][5];
function mb_block_get_surface_pattern_scale(block_obj) =            block_obj[18][6];
function mb_block_get_surface_pattern_depth(block_obj) =            block_obj[18][7];

// Tongue
function mb_block_has_tongue(block_obj) =                           block_obj[13][0];
function mb_block_get_tongue_thickness(block_obj, groove) =         block_obj[13][1];
function mb_block_get_tongue_height(block_obj, groove) =            block_obj[13][2];
function mb_block_get_tongue_offset(block_obj, groove) =            block_obj[13][3];
function mb_block_get_tongue_clamp_thickness(block_obj, groove) =   block_obj[13][4];
function mb_block_get_tongue_clamp_height(block_obj, groove) =      block_obj[13][5];
function mb_block_get_tongue_clamp_offset(block_obj, groove) =      block_obj[13][6];

// Groove
function mb_block_has_groove(block_obj) =                           block_obj[4][2] == "groove";

// Connectors
function mb_block_get_connectors(block_obj) =                       block_obj[24][0];
function mb_block_get_connector_length(block_obj, face, subtract) = block_obj[24][1][subtract ? 1 : 0][(face == 4 || face == 5) ? 0 : 2];
function mb_block_get_connector_depth(block_obj, face, subtract) =  block_obj[24][2][subtract ? 1 : 0][(face == 4 || face == 5) ? 2 : 0];
function mb_block_get_connector_width(block_obj, face, subtract) =  block_obj[24][3][subtract ? 1 : 0][0];

// Shapes
function mb_block_get_surface_shape(block_obj) =                    block_obj[10][0];
function mb_block_get_recess_surface_shape(block_obj) =             block_obj[10][1];
function mb_block_get_recess_inverse_shape(block_obj) =             block_obj[10][2];

// SVG Decorator
function mb_block_get_svg(block_obj) =                              block_obj[23][0];
function mb_block_get_svg_dimensions(block_obj) =                   block_obj[23][1];
function mb_block_get_svg_face(block_obj) =                         block_obj[23][2];
function mb_block_get_svg_depth(block_obj) =                        block_obj[23][3];
function mb_block_get_svg_scale(block_obj) =                        block_obj[23][4];
function mb_block_get_svg_offset(block_obj) =                       block_obj[23][5];
function mb_block_get_svg_color(block_obj) =                        block_obj[23][6];

// Text Decorator
function mb_block_get_text(block_obj) =                             block_obj[25][0];
function mb_block_get_text_face(block_obj) =                        block_obj[25][1];
function mb_block_get_text_depth(block_obj) =                       block_obj[25][2];
function mb_block_get_text_font(block_obj) =                        block_obj[25][3];
function mb_block_get_text_size(block_obj) =                        block_obj[25][4];
function mb_block_get_text_spacing(block_obj) =                     block_obj[25][5];
function mb_block_get_text_align(block_obj) =                       block_obj[25][6];
function mb_block_get_text_offset(block_obj) =                      block_obj[25][7];
function mb_block_get_text_color(block_obj) =                       block_obj[25][8];

// PCB
function mb_block_get_pcb(block_obj) =                             block_obj[26][0];
function mb_block_get_pcb_dimensions(block_obj) =                  block_obj[26][1];
function mb_block_get_pcb_offset(block_obj) =                      block_obj[26][2];
function mb_block_get_pcb_socket_diameter(block_obj) =             block_obj[26][3];
function mb_block_get_pcb_socket_hole_diameter(block_obj) =        block_obj[26][4];
function mb_block_get_pcb_socket_height(block_obj) =               block_obj[26][5];
function mb_block_get_pcb_sockets(block_obj) =                     block_obj[26][6];

// Screw Holes
function mb_block_get_screw_holes(block_obj) =                     block_obj[27][0];
function mb_block_get_screw_hole_diameter(block_obj) =             block_obj[27][1];
function mb_block_get_screw_hole_depth(block_obj) =                block_obj[27][2];
function mb_block_get_screw_hole_inset_thickness(block_obj) =      block_obj[27][3];
function mb_block_get_screw_hole_inset_depth(block_obj) =          block_obj[27][4];

/*
* TODO Rename or delete
*/

function mb_block_default_multiplier(block_obj) =
    mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from="grd", to="mm");

function mb_block_grd_z2xy(block_obj, grd_z) = 
    let(grid_cfg = mb_block_get_grid_cfg(block_obj))
        grd_z / (grid_cfg[1] / grid_cfg[2]);

function mb_block_grd_xy2z(block_obj, grd_xy) = 
    let(grid_cfg = mb_block_get_grid_cfg(block_obj))
        grd_xy * (grid_cfg[1] / grid_cfg[2]);

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
    face == 4 || face == 5 ? (face == 4 ? -(offs[0] - off) : -(offs[1] - off)) + mb_block_dim_overlap(block_dim, overlap = cut) : undef;

function mb_block_recess_floor_offset(block_obj, face, off = 0, overlap = false) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        face = mb_face_to_int(face),
        offs = [
            mb_block_get_base_cutout_depth(block_obj) + mb_block_get_top_plate_height(block_obj),
            mb_block_get_recess_depth(block_obj)
        ]
    )
    face == 4 || face == 5 ? (face == 4 ? -(offs[0] - off) : -(offs[1] - off)) + mb_block_dim_overlap(block_dim, overlap = overlap) : undef;

/**
* -----
* Studs
* -----
*/

function mb_block_stud_cutouts_range(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1]
    )
    [
        [start_index_x : end_index_x],
        [start_index_y : end_index_y]
    ];

function mb_block_stud_cutout_render(block_obj, x, y) =
    let(
        stud_diameter = mb_block_get_stud_cutout_diameter(block_obj),
        stud_offset = mb_block_stud_cutout_offset(block_obj, x, y)
    )
    !mb_block_in_base_cutout(block_obj, stud_offset, stud_diameter);

function mb_block_stud_range(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index_top(block_dim),
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
        stud_diameter = mb_block_get_stud_diameter(block_obj, false),
        stud_height = mb_block_get_stud_height(block_obj),
        stud_sink = mb_block_get_stud_sink(block_obj),
        has_recess = mb_block_has_recess(block_obj),
        stud_max_overhang = mb_block_get_stud_max_overhang(block_obj),
        
        stud_shift = mb_block_get_stud_shift(block_obj),
        off = stud_shift ? 1 : 0.5,
        stud_offset = mb_block_pos_to_offset(block_obj, [x + off, y + off, undef]),
        
        recess_stud_shift = mb_block_get_recess_stud_shift(block_obj),
        r_off = recess_stud_shift ? 1 : 0.5,
        recess_stud_offset = mb_block_pos_to_offset(block_obj, [x + r_off, y + r_off, undef]),

        in_recess = has_recess && mb_circle_in_convex_quad(recess_surface_shape, recess_stud_offset, 0.5 * stud_diameter, overhang = stud_max_overhang),
        

        render_stud = mb_circle_in_convex_quad(surface_shape, in_recess ? recess_stud_offset : stud_offset, 0.5 * stud_diameter, overhang = stud_max_overhang),
        
        on_recess_wall = has_recess && !mb_circle_in_convex_quad(recess_inverse_shape, stud_offset, 0.5 * stud_diameter, touch = true, overhang = 0),
        
        
        
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
        render_stud && (!has_recess || in_recess || on_recess_wall),
        in_recess ? recess_stud_offset : stud_offset,
        [bottom, top]  
    ];

function mb_block_stud_cutout_offset(block_obj, x, y) =
    let(
        
    )
    mb_block_pos_to_offset(block_obj, [x + 0.5, y + 0.5, undef]);

function mb_block_stud_radius(block_obj, x, y) =
    let(
        stud_diameter = mb_block_get_stud_diameter(block_obj),
        stud_hole_diameter = mb_block_get_stud_hole_diameter(block_obj),
        stud_type = mb_block_get_stud_type(block_obj)
    )
       stud_type == "solid" ? 0.5 * stud_diameter : [0.5 * stud_hole_diameter, 0.5 * stud_diameter];

/*
* ----------
* Connectors
* ----------
*/

function mb_block_connector_face(block_obj, connector, subtract = false) =
    let(
        f = mb_face_to_int(connector[0]),
        face = subtract ? mb_face_opposite(f) : f
    )
    face;

function mb_block_connector_gender(block_obj, connector) =
    let(connector_gender = connector[2])
    is_string(connector_gender) ?
    (connector_gender == "male" ? 0 :
    connector_gender == "female" ? 1 : undef) :
    is_num(connector_gender) && connector_gender >= 0 && connector_gender <= 1 ? connector_gender : undef;

function mb_block_connector_dir(block_obj, connector) =
    mb_axis_to_int(connector[1]);

function mb_block_connector_render(block_obj, connector, subtract) =
    let(
        connector_gender = mb_block_connector_gender(block_obj, connector)
    )
    (!subtract && connector_gender == 0) || (subtract && connector_gender == 1);

function mb_block_connector_range(block_obj, connector) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        face = mb_face_to_int(connector[0]),
        axis = mb_face_to_axis(face),
        dir = mb_block_connector_dir(block_obj, connector),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1]
    )
    axis == 1 || dir == 1 ?
        [start_index_x : end_index_x] : 
        [start_index_y : end_index_y];

function mb_block_connector_offset(block_obj, connector, xy, subtract) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        face = mb_block_connector_face(block_obj, connector, false),
        dir = mb_block_connector_dir(block_obj, connector),
        gender = mb_block_connector_gender(block_obj, connector),
        axis = mb_face_to_axis(face),
        face_sign = mb_face_sign(face),
       
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        off_xy = (face == 4 || face == 5) ? undef : (face_sign == -1 ? min_max_index[0][axis] : min_max_index[1][axis] + 1),
        off_z = (face == 5) ? (min_max_index[1][2] + 1) : (face == 4) ? min_max_index[0][2] : undef
    )
    mb_block_pos_to_offset(block_obj, [(axis == 0 || dir == 0) ? off_xy : (xy + 0.5), (axis == 1 || dir == 1) ? off_xy : (xy + 0.5), off_z]);

/*
* -----------
* Screw Holes
* -----------
*/
function mb_block_screw_hole_offset(block_obj, axis, off) =
    mb_block_pos_to_offset(block_obj, mb_axis_offset2d(axis, off, shift = [0.5, 0.5, 0.5]));

/*
* -----
* Tubes
* -----
*/

function mb_block_tube_range(block_obj, axis) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        mod_size = mb_block_dim_mod_size(block_dim),
        axis = mb_axis_to_int(axis),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        start_index_xy = min_max_index[0][1 - axis],
        end_index_xy = min_max_index[1][1 - axis],
        

        hole_xyz_diameter = mb_block_get_hole_xyz_diameter(block_obj, 1 - axis),
        inset_thickness = mb_block_get_hole_xyz_inset_thickness(block_obj, 1 - axis),
        tube_hole_grid_offset_z = mb_block_get_hole_xy_grid_offset_z(block_obj, 1 - axis),
        tube_hole_grid_size_z = mb_block_get_hole_xy_grid_size_z(block_obj, 1 - axis),
        tube_hole_min_top_margin = mb_block_get_hole_xy_min_top_margin(block_obj, 1 - axis),
        tube_shift = mb_block_get_hole_xyz_shift(block_obj, 1 - axis),

        hole_max_rows = mb_vertical_hole_count(
            rect_height = mod_size[2],
            first_hole_center_from_bottom = tube_hole_grid_offset_z,
            hole_diameter = hole_xyz_diameter + inset_thickness,
            hole_center_spacing = tube_hole_grid_size_z,
            min_top_margin = tube_hole_min_top_margin
        ),
        range_offset_start = 0,
        range_offset_end = tube_shift ? 0 : -1
    )
    [
        [(start_index_xy + range_offset_start) : (end_index_xy + range_offset_end)],
        [0 : hole_max_rows - 1]
    ];

function mb_block_tube_render(block_obj, axis, xy, z) =
    let(axis = mb_axis_to_int(axis))
    true;

function mb_block_tube_offset(block_obj, axis, xy, z) =
    let(
        axis = mb_axis_to_int(axis),
        
        tube_hole_grid_offset_z = mb_block_get_hole_xy_grid_offset_z(block_obj, 1 - axis),
        tube_hole_grid_size_z = mb_block_get_hole_xy_grid_size_z(block_obj, 1 - axis),
        tube_shift = mb_block_get_hole_xyz_shift(block_obj, 1 - axis),
        tube_offset_xy = tube_shift ? 0.5 : 1,
    )
    mb_block_pos_to_offset(block_obj, [
        axis == 1 ? xy + tube_offset_xy : undef, 
        axis == 0 ? xy + tube_offset_xy : undef, 
        tube_hole_grid_offset_z + z * tube_hole_grid_size_z
    ]);

function mb_block_tube_radius(block_obj, axis, xy, z, hole = false) =
    let(
        axis = mb_axis_to_int(axis),
        tube_diameter = mb_block_get_tube_diameter(block_obj, axis),
        hole_xyz_diameter = mb_block_get_hole_xyz_diameter(block_obj, 1 - axis)
        
    )
    0.5 * (hole ? hole_xyz_diameter : tube_diameter);

function mb_block_tube_hole_inset(block_obj, axis, xy, z) =
    let(
        inset_thickness = mb_block_get_hole_xyz_inset_thickness(block_obj, 1 - axis),
        inset_depth = mb_block_get_hole_xyz_inset_depth(block_obj, 1 - axis)
    )
    [inset_thickness, inset_depth];

/**
* -------
* Pillars
* -------
*/

function mb_block_pillar_range(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        is_pin = mb_block_pillar_is_pin(block_obj),
        range_offset_start = (is_pin[0] || is_pin[1]) && !(is_pin[0] && is_pin[1]) 
            ? [is_pin[0] ? 0 : 1, is_pin[1] ? 0 : 1] 
            : [1, 1],
        range_offset_end = [0, 0]
    )
    [
        [start_index_x + range_offset_start[0] : end_index_x + range_offset_end[0]],
        [start_index_y + range_offset_start[1] : end_index_y + range_offset_end[1]]
    ];

function mb_block_pillar_render(block_obj, x, y) =
    true;

function mb_block_pillar_offset(block_obj, x, y) = //TODO
    let(
        is_pin = mb_block_pillar_is_pin(block_obj, x, y),
        tube_offset = is_pin[0] || is_pin[1] 
            ? [is_pin[0] ? 0.5 : 0, is_pin[1] ? 0.5 : 0] 
            : [0, 0]
    )
    mb_block_pos_to_offset(block_obj, [x + tube_offset[0], y + tube_offset[1], undef]);

function mb_block_pillar_is_pin(block_obj, x = undef, y = undef) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        is_pin = [end_index_x - start_index_x == 0, end_index_y - start_index_y == 0],
    )
    is_pin;

function mb_block_pillar_radius(block_obj, x, y) =
    let(
        is_pin = mb_block_pillar_is_pin(block_obj, x, y),

        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        tube_z_hole_size = mb_block_get_hole_xyz_diameter(block_obj, "z"),
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
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        axis = mb_axis_to_int(axis),
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
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        axis = mb_axis_to_int(axis),
        top_plate_helpers_thickness = mb_block_get_top_plate_helpers_thickness(block_obj),
        top_plate_helpers_height = mb_block_get_top_plate_helpers_height(block_obj),
        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        pillar_wall_thickness = mb_block_get_pillar_wall_thickness(block_obj),
        default_segment_length = 1 - tube_z_diameter + pillar_wall_thickness,
        segment_thickness = mb_block_get_stabilizer_thickness(block_obj),
        stabilizer_expansion = mb_block_get_stabilizer_expansion(block_obj),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
        segment_height_expanded = max(base_cutout_depth - mb_block_get_stabilizer_expansion_offset(block_obj), 0),
        is_pin = mb_block_pillar_is_pin(block_obj, axis),
        expanded = axis == 1 ? 
            is_pin[1] || ((x % stabilizer_expansion) == 0 && ((end_index_x - start_index_x) > 2)): 
            is_pin[0] || ((y % stabilizer_expansion) == 0 && ((end_index_y - start_index_y) > 2)),
        seg_size = [
            axis == 1 ? segment_thickness : default_segment_length, 
            axis == 1 ? default_segment_length : segment_thickness, 
            (expanded ? segment_height_expanded : mb_block_get_stabilizer_height(block_obj)) + (axis == 1 ? -mb_block_get_stabilizer_start_offset(block_obj) : 0)
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
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        axis = mb_axis_to_int(axis),
        tube_z_diameter = mb_block_get_tube_diameter(block_obj, "z"),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
    )    
    [
        axis == 0 && x == start_index_x ? 0.5 * tube_z_diameter : 0, 
        axis == 0 && x == end_index_x ? 0.5 * tube_z_diameter : 0, 
        axis == 1 && y == start_index_y ? 0.5 * tube_z_diameter : 0, 
        axis == 1 && y == end_index_y ? 0.5 * tube_z_diameter : 0
    ];

function mb_block_stabilizer_segment_render(block_obj, axis, x, y) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index_bottom(block_dim),
        axis = mb_axis_to_int(axis = axis),
        start_index_x = min_max_index[0][0],
        start_index_y = min_max_index[0][1],
        end_index_x = min_max_index[1][0],
        end_index_y = min_max_index[1][1],
        stablilizer_thickness = mb_block_get_stabilizer_thickness(block_obj),
        
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
    let(
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index(block_dim),
        mod_size = mb_block_get_mod_size(block_obj),
        recess_wall_thickness = mb_block_get_recess_wall_thickness(block_obj),
        gap = mb_to_array(gap),
        faces = mb_face_split(gap[0], split_axis ? ["x", "y"] : ["x-", "x+", "y-", "y+"])
    )
    [
        for(face = faces)
            let(axis = mb_face_to_axis(face),
            gap_start_pos = is_undef(gap[1]) ? 0 : max(0, gap[1]),
            max_gap_length = mod_size[1 - axis] - gap_start_pos,
            gap_length = is_undef(gap[2]) ? max_gap_length : min(max_gap_length, gap[2]),
            gap_start_offset = gap_start_pos + recess_wall_thickness[axis == 0 ? 0 : 2],
            gap_end_offset = mod_size[1 - axis] - gap_length - gap_start_pos + recess_wall_thickness[axis == 0 ? 1 : 3])
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

function mb_block_slope_partial(block_obj, top_offset, f) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        slope_base_height_inner = mb_block_get_slope_base_height_inner(block_obj),
        slope_base_height_bottom = mb_block_get_slope_base_height_bottom(block_obj),
        mod_size = mb_block_dim_mod_size(block_dim),
        
        slope = mb_block_dim_slope(block_dim),
        slope_pos = mb_slope_filter(slope, 1),
        base_cutout_depth = mb_block_get_base_cutout_depth(block_obj),
    )
    slope_pos[f] == 0 ? 0 : (base_cutout_depth - top_offset - slope_base_height_inner) * (slope_pos[f] / (mod_size[2] - slope_base_height_bottom));

function mb_block_base_wall_gap(block_obj, gap, split_axis = false) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index(block_dim),
        mod_size = mb_block_get_mod_size(block_obj),
        wall_thickness = mb_block_get_wall_thickness(block_obj),
        faces = mb_face_split(gap[0], split_axis ? ["x", "y"] : ["x-", "x+", "y-", "y+"])
    )
    [
        for(face = faces)
        
        let(
            axis = mb_face_to_axis(face),
            gap_start_pos = is_undef(gap[1]) ? 0 : max(0, gap[1]),
            gap_length = is_undef(gap[2]) ? 1 : min(mod_size[1 - axis] - gap_start_pos, gap[2]),
            gap_start_offset = gap_start_pos + wall_thickness,
            gap_end_offset = mod_size[1 - axis] - gap_length - gap_start_pos + wall_thickness
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

function mb_block_tongue_wall_gap(block_obj, gap, clamp = false, groove = false, split_axis = false) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        min_max_index = mb_block_dim_min_max_index(block_dim),
        mod_size = mb_block_get_mod_size(block_obj),
        gap = mb_to_array(gap),
        tongue_offset = mb_block_get_tongue_offset(block_obj),
        tongue_height = mb_block_get_tongue_height(block_obj),
        tongue_thickness = mb_block_get_tongue_thickness(block_obj),
        tongue_clamp_offset = mb_block_get_tongue_clamp_offset(block_obj),
        tongue_clamp_height = mb_block_get_tongue_clamp_height(block_obj),
        tongue_clamp_thickness = mb_block_get_tongue_clamp_thickness(block_obj),
        wall_thickness = groove
            ? tongue_offset - (clamp ? tongue_clamp_thickness : 0)
            : tongue_offset + tongue_thickness + (clamp ? tongue_clamp_thickness : 0),
        faces = mb_face_split(gap[0], split_axis ? ["x", "y"] : ["x-", "x+", "y-", "y+"])
    )
    [
        for(face = faces)
        
        let(
            axis = mb_face_to_axis(face),
            gap_start_pos = is_undef(gap[1]) ? 0 : max(0, gap[1]),
            max_gap_length = mod_size[1-axis] - gap_start_pos,
            gap_length = is_undef(gap[2]) ? max_gap_length : min(max_gap_length, gap[2]),
            gap_start_offset = gap_start_pos + wall_thickness,
            gap_end_offset = mod_size[1-axis] - gap_length - gap_start_pos + wall_thickness
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


function mb_block_pos_to_offset(block_obj, pos) = 
    let(center = mb_block_get_center(block_obj))
        [is_undef(pos[0]) ? 0 : pos[0] - center[0], is_undef(pos[1]) ? 0 : pos[1] - center[1], is_undef(pos[2]) ? 0 : pos[2] - center[2]];
        
/**
* ---------------
* Private Helpers
* ---------------
*/ 

function _mb_block_model_surface_shape(bevel_matrix, slope, stud_padding) =
    let(
        exp = mb_array_add(mb_slope_filter(slope, 1, -1), mb_array_mul(stud_padding, -1)),
    )
    mb_poly_expand(bevel_matrix, 0, exp);

function _mb_block_model_recess_surface_shape(bevel_matrix, slope, recess_wall_thickness, recess_stud_padding) =
    let(
        pad = mb_array_add(recess_wall_thickness, recess_stud_padding),
        exp = mb_array_add(mb_slope_filter(slope, 1, -1), mb_array_mul(pad, -1)),
    )
    mb_poly_expand(bevel_matrix, 0, exp);

function _mb_block_model_recess_inverse_shape(bevel_matrix, slope, recess_wall_thickness, stud_padding, stud_max_overhang) =
    let(
        pad = mb_array_add(mb_array_sub_simple(recess_wall_thickness, stud_padding), stud_max_overhang),
        exp = mb_array_add(mb_slope_filter(slope, 1, -1), mb_array_mul(pad, -1)),
    )
    mb_poly_expand(bevel_matrix, 0, exp);

/*
* -------------
* END BLOCK OBJ
* -------------
*/
/*
* Extracts the z-radis from the base radius as four dimensional vector
*/
function mb_base_rounding_radius_z(radius) = radius[2] == undef ? 
        [radius, radius, radius, radius] : 
        (radius[2][0] == undef ? [radius[2], radius[2], radius[2], radius[2]] : radius[2]);

/*
* Creates a four dimensional vector with the inner rounding radius
*/
function mb_base_cutout_radius(cutoutRadius, baseRadiusZ) = cutoutRadius == 0 ? [0,0,0,0] : (cutoutRadius[0] == undef ? 
    [
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[0]), 
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[1]),
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[2]),
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[3])   
    ] : 
    [
        mb_calc_rounding_radius(cutoutRadius[0], baseRadiusZ[0]), 
        mb_calc_rounding_radius(cutoutRadius[1], baseRadiusZ[1]),
        mb_calc_rounding_radius(cutoutRadius[2], baseRadiusZ[2]),
        mb_calc_rounding_radius(cutoutRadius[3], baseRadiusZ[3])   
    ]);
function mb_calc_rounding_radius(radius, baseRadius) = radius < 0 ? max(0, baseRadius + radius) : radius;

/*
* Whether a given string is empty
*/
function mb_is_empty_string(s) = (s == undef) || len(s) == 0;

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
function mb_resolve_base_side_adjustment(baseSideAdjustment) = baseSideAdjustment[0] == undef ? [baseSideAdjustment, baseSideAdjustment, baseSideAdjustment, baseSideAdjustment] : (len(baseSideAdjustment) == 2 ? [baseSideAdjustment[0], baseSideAdjustment[0], baseSideAdjustment[1], baseSideAdjustment[1]] : baseSideAdjustment);
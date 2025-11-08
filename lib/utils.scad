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

function mb_resolve_side_quad(quad, multiplier) = 
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

function grid_size_x(grid, slope) = slope != false ? grid[0] + (slope[0] < 0 ? slope[0] : 0) + (slope[1] < 0 ? slope[1] : 0) : grid[0];
function grid_size_y(grid, slope) = slope != false ? grid[1] + (slope[2] < 0 ? slope[2] : 0) + (slope[3] < 0 ? slope[3] : 0) : grid[1];


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
function mb_resolve_crop(crop, gridSizeXY) = 
    is_list(crop)
        ? (len(crop) == 2 ? [crop[0] * gridSizeXY, crop[0] * gridSizeXY, crop[1] * gridSizeXY, crop[1] * gridSizeXY] : [crop[0] * gridSizeXY, crop[1] * gridSizeXY, crop[2] * gridSizeXY, crop[3] * gridSizeXY])
        : [crop * gridSizeXY, crop * gridSizeXY, crop * gridSizeXY, crop * gridSizeXY];

function mb_resolve_base_side_adjustment(baseSideAdjustment) = 
    is_list(baseSideAdjustment) 
        ? (len(baseSideAdjustment) == 2 ? [baseSideAdjustment[0], baseSideAdjustment[0], baseSideAdjustment[1], baseSideAdjustment[1]] : baseSideAdjustment) 
        : [baseSideAdjustment, baseSideAdjustment, baseSideAdjustment, baseSideAdjustment];

function mb_calc_side_adjusmtent(baseSideAdjustment, cropResolved) =
    [baseSideAdjustment[0] - cropResolved[0], baseSideAdjustment[1] - cropResolved[1], baseSideAdjustment[2] - cropResolved[2], baseSideAdjustment[3] - cropResolved[3]];

module pre_render(do_render, convexity){
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
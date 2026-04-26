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
* ARRAYS
*/

function mb_array_sub(a, b) =
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
    len(found) > 0 ? found[0] : default;

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
* MISC
*/

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
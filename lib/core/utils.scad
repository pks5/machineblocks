
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

function mb_resolve_quad(xyz, default = [0, 0, 0, undef], mul = undef, min_value = undef, precision = undef) = 
    let(m = is_undef(mul) ? [1, 1, 1, 1] : mb_resolve_quad(mul, default = [1, 1, 1, 1]),
        r = is_list(xyz) ? 
        ([
            is_num(xyz[0]) ? xyz[0] : (is_undef(default) ? 0 : default[0]), 
            is_num(xyz[1]) ? xyz[1] : (is_undef(default) ? 0 : default[1]), 
            is_num(xyz[2]) ? xyz[2] : (is_undef(default) ? 0 : default[2]),
            is_num(xyz[3]) ? xyz[3] : (is_undef(default) ? undef : default[3])
        ]) : 
        is_num(xyz) ? [m[0] * xyz, m[1] * xyz, m[2] * xyz, undef] : default,
        r1 = is_undef(r) ? undef : [m[0] * r[0], m[1] * r[1], m[2] * r[2], is_undef(r[3]) ? undef : m[3] * r[3]],
        p = is_undef(r1) ? undef : (is_undef(precision) ? r1 : [mb_round_prec(r1[0], precision), mb_round_prec(r1[1], precision), mb_round_prec(r1[2], precision), is_undef(r1[3]) ? undef : mb_round_prec(r1[3], precision)]))
    is_undef(p) ? undef : (is_undef(min_value) ? p : [max(min_value, p[0]), max(min_value, p[1]), max(min_value, p[2]), is_undef(p[3]) ? undef : max(min_value, p[3])]);

function mb_cube_size_resolve(size) = is_num(size) || (is_list(size) && (is_undef(size[0]) || is_num(size[0])) && (is_undef(size[1]) || is_num(size[1])) && (is_undef(size[2]) || is_num(size[2]))) ?
        [
            mb_resolve_xyz(size, mul = -0.5),
            mb_resolve_xyz(size, mul = 0.5)
        ] :
        is_list(size) && len(size) == 2 && is_list(size[0]) && is_list(size[1]) ? 
        [
            mb_resolve_xyz(size[0]),
            mb_resolve_xyz(size[1])
        ] : 
        [
            mb_resolve_xyz(size[0], mul = -0.5), 
            mb_resolve_xyz(size[0], mul = 0.5)
        ];

function mb_cube_radius_resolve(radius) = is_num(radius) ?
        [[radius, radius], [radius, radius], [radius, radius], [radius, radius]] :
        is_list(radius) && len(radius) == 1 && is_num(radius[0]) ?
        [[radius[0], radius[0]], [radius[0], radius[0]], [radius[0], radius[0]], [radius[0], radius[0]]] :
        is_list(radius) && len(radius) == 2 && is_num(radius[0]) && is_num(radius[1]) ?
        [[radius[0], radius[1]], [radius[0], radius[1]], [radius[0], radius[1]], [radius[0], radius[1]]] :
        is_list(radius) && len(radius) == 4 && is_num(radius[0]) && is_num(radius[1]) && is_num(radius[2]) && is_num(radius[3]) ?
        [[radius[0], radius[0]], [radius[1], radius[1]], [radius[2], radius[2]], [radius[3], radius[3]]] :
        is_list(radius) && len(radius) == 1 && is_list(radius[0]) && is_num(radius[0][0]) && is_num(radius[0][1]) ?
        [radius[0], radius[0], radius[0], radius[0]] :
        radius;
 /*
* ---------------
* START BLOCK OBJ
* ---------------
*/


function mb_bounding_box(size) = [ceil(size[0]), ceil(size[1]), ceil(size[2])];





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



/*
* -----------
* START BEVEL
* -----------
*/

function _mb_radius_pair(v) =
    is_list(v) && len(v) >= 2
        ? [max(0, v[0]), max(0, v[1])]
        : [0, 0];

function _mb_radius_resolve_pair(a, b, max_size) =
    let(
        aa = max(0, a),
        bb = max(0, b),
        sum = aa + bb,
        scale = sum > max_size ? max_size / sum : 1
    )
    [
        aa * scale,
        bb * scale
    ];

function mb_corner_radius_resolve(radius, mod_size) =
    let(
        r = [
            _mb_radius_pair(radius[0]),
            _mb_radius_pair(radius[1]),
            _mb_radius_pair(radius[2]),
            _mb_radius_pair(radius[3])
        ],

        // X-Kanten: unten sw+se, oben nw+ne
        x0 = _mb_radius_resolve_pair(r[0][0], r[3][0], mod_size[0]),
        x1 = _mb_radius_resolve_pair(r[1][0], r[2][0], mod_size[0]),

        // Y-Kanten: links sw+nw, rechts se+ne
        y0 = _mb_radius_resolve_pair(r[0][1], r[1][1], mod_size[1]),
        y1 = _mb_radius_resolve_pair(r[3][1], r[2][1], mod_size[1])
    )
    [
        [x0[0], y0[0]], // sw
        [x1[0], y0[1]], // nw
        [x1[1], y1[1]], // ne
        [x0[1], y1[0]]  // se
    ];



function mb_bevel_matrix(bevel, mod_size, min_max) =
    let(
        bv = is_undef(bevel) ? mb_bevel_resolve(0, mod_size) : bevel,
        mn = min_max[0],
        mx = min_max[1],
        /*bv = [
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
        ],*/
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

function _mb_bevel_clamp0(v) = (is_num(v) && v > 0) ? v : 0;

function _mb_bevel_is_pair(v) =
    is_list(v) && len(v) == 2 && is_num(v[0]) && is_num(v[1]);

function mb_pair(v) =
    _mb_bevel_is_pair(v)
        ? [_mb_bevel_clamp0(v[0]), _mb_bevel_clamp0(v[1])]
        : is_num(v)
            ? [_mb_bevel_clamp0(v), _mb_bevel_clamp0(v)]
            : [0,0];

function mb_pair_or_undef(v) =
    _mb_bevel_is_pair(v)
        ? [_mb_bevel_clamp0(v[0]), _mb_bevel_clamp0(v[1])]
        : undef;

// b overwrites a if b != undef
function _mb_bevel_pair_overwrite(a, b) =
    b == undef ? a : b;

function mb_bevel_merge(a, b) = [
    _mb_bevel_pair_overwrite(a[0], b[0]),
    _mb_bevel_pair_overwrite(a[1], b[1]),
    _mb_bevel_pair_overwrite(a[2], b[2]),
    _mb_bevel_pair_overwrite(a[3], b[3])
];

function _mb_bevel_normalize(a) = [
    a[0] == undef ? [0,0] : a[0],
    a[1] == undef ? [0,0] : a[1],
    a[2] == undef ? [0,0] : a[2],
    a[3] == undef ? [0,0] : a[3]
];

// direction mapping → 4 slots, undef = no overwrite
function _mb_bevel_dir_map(d, x, y) =
    let(p = [_mb_bevel_clamp0(x), _mb_bevel_clamp0(y)])
    d == 0 ? [p, undef, undef, undef] :       // sw
    d == 1 ? [p, p, undef, undef] :           // w
    d == 2 ? [undef, p, undef, undef] :       // nw
    d == 3 ? [undef, p, p, undef] :           // n
    d == 4 ? [undef, undef, p, undef] :       // ne
    d == 5 ? [undef, undef, p, p] :           // e
    d == 6 ? [undef, undef, undef, p] :       // se
    d == 7 ? [p, undef, undef, p] :           // s
    [undef, undef, undef, undef];

function _mb_bevel_reduce(arr, i=0, acc=[undef, undef, undef, undef]) =
    i >= len(arr)
        ? _mb_bevel_normalize(acc)
        : let(v = arr[i])
          _mb_bevel_reduce(
              arr,
              i + 1,
              (is_list(v) && len(v) == 3)
                  ? mb_bevel_merge(
                        acc,
                        _mb_bevel_dir_map(
                            mb_dir_to_int(v[0], true),
                            v[1],
                            v[2]
                        )
                    )
                  : acc
          );

function _mb_bevel_all(p) = [p,p,p,p];

function mb_bevel_resolve(bevel, mod_size) =
    mb_corner_radius_resolve(_mb_bevel_resolve(bevel), mod_size);

// --- main ---
function _mb_bevel_resolve(bevel) =
    // undef / [] / string
    (!is_list(bevel) || len(bevel) == 0)
        ? [[0,0],[0,0],[0,0],[0,0]]

    // number or [x]
    : is_num(bevel) || (len(bevel) == 1 && is_num(bevel[0]))
        ? let(v = _mb_bevel_clamp0(is_num(bevel) ? bevel : bevel[0]))
          _mb_bevel_all([v,v])

    // [x,y]
    : _mb_bevel_is_pair(bevel)
        ? _mb_bevel_all(mb_pair(bevel))

    // [[x,y]]
    : len(bevel) == 1 && _mb_bevel_is_pair(bevel[0])
        ? _mb_bevel_all(mb_pair(bevel[0]))

    // [[x1,y1],[x2,y2]]
    : len(bevel) == 2 && _mb_bevel_is_pair(bevel[0]) && _mb_bevel_is_pair(bevel[1])
        ? let(a = mb_pair(bevel[0]), b = mb_pair(bevel[1]))
          [a,a,b,b]

    // [[x1,y1],[x2,y2],[x3,y3]]
    : len(bevel) == 3 && _mb_bevel_is_pair(bevel[0]) && _mb_bevel_is_pair(bevel[1]) && _mb_bevel_is_pair(bevel[2])
        ? let(a = mb_pair(bevel[0]), b = mb_pair(bevel[1]), c = mb_pair(bevel[2]))
          [a,b,c,[0,0]]

    // [[x1,y1],[x2,y2],[x3,y3],[x4,y4]]
    : len(bevel) == 4 && _mb_bevel_is_pair(bevel[0]) && _mb_bevel_is_pair(bevel[1]) && _mb_bevel_is_pair(bevel[2]) && _mb_bevel_is_pair(bevel[3])
        ? [
            mb_pair(bevel[0]),
            mb_pair(bevel[1]),
            mb_pair(bevel[2]),
            mb_pair(bevel[3])
          ]

    // complex mode
    : _mb_bevel_reduce(bevel);

/*
*function mb_bevel_shrink(bevel, shrink) = 
    [
        [max(0, bevel[0][0] + shrink[0]), max(0, bevel[0][1] + shrink[2])],
        [max(0, bevel[1][0] + shrink[0]), max(0, bevel[1][1] + shrink[3])],
        [max(0, bevel[2][0] + shrink[1]), max(0, bevel[2][1] + shrink[3])],
        [max(0, bevel[3][0] + shrink[1]), max(0, bevel[3][1] + shrink[2])]
    ];
*/

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



function _mb_slope_resolve_pair(a, b, max_size, allow_neg=true) =
    let(
        // optional negatives clampen
        a0 = (!allow_neg && a < 0) ? 0 : a,
        b0 = (!allow_neg && b < 0) ? 0 : b,

        aa = abs(a0),
        ab = abs(b0),
        sa = sign(a0),
        sb = sign(b0),

        sum = aa + ab,

        scale = (a0 != 0 && b0 != 0 && sa == sb && sum > max_size)
            ? max_size / sum
            : 1
    )
    [
        a0 == 0 ? 0 : sa * min(aa * scale, max_size),
        b0 == 0 ? 0 : sb * min(ab * scale, max_size)
    ];

function mb_slope_resolve(slope, mod_size, allow_neg=true) =
    let(
        s = mb_qc_resolve(slope, false),

        x = _mb_slope_resolve_pair(s[0], s[1], mod_size[0], allow_neg),
        y = _mb_slope_resolve_pair(s[2], s[3], mod_size[1], allow_neg)
    )
    [x[0], x[1], y[0], y[1]];

function mb_slope_filter(slope, filter = 1, res = 0) = 
    [
        for(f = [0 : 3])
            sign(slope[f]) == filter ? (res < 0 ? -abs(slope[f]) : res > 0 ? abs(slope[f]) : slope[f]) : 0
    ];

/*

function mb_slope_shrink(slope, shrink) = 
    [
        sign(slope[0]) * (abs(slope[0]) + shrink[0]), 
        sign(slope[1]) * (abs(slope[1]) + shrink[1]),
        sign(slope[2]) * (abs(slope[2]) + shrink[2]),
        sign(slope[3]) * (abs(slope[3]) + shrink[3])
    ];

function mb_slope_matrix(slope, bevel_res, mod_size) =
    let(
        mx_bvx = mod_size[0] - max((bevel_res[0][0] + bevel_res[3][0]), (bevel_res[1][0] + bevel_res[2][0])),
        mx_bvy = mod_size[1] - max((bevel_res[0][1] + bevel_res[1][1]), (bevel_res[2][1] + bevel_res[3][1])),
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

function mb_side_to_int(side) =
    is_string(side) ? (
    side == "x-" ? 0 :
    side == "x+" ? 1 :
    side == "y-" ? 2 :
    side == "y+" ? 3 :
    side == "z-" ? 4 :
    side == "z+" ? 5 :
    undef
    ) : (side >= 0 && side <= 5 ? side : undef);

function mb_side_to_axis(side) = floor(mb_side_to_int(side) / 2);

function mb_side_to_axis_face(side) = mb_side_to_int(side) % 2;

function mb_face_to_int(face) =
    is_undef(face) ? undef :
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

function mb_face_common(face, cface) =
    let(
        face = mb_face_to_int(face),
        cface = mb_face_to_int(cface)
    )
    face == cface ? cface :

    // xyz
    face == 12 ? cface :
    cface == 12 ? face :

    // yz
    face == 11 ? ((cface == 10) ? 8 : (cface == 9) ? 7 : ((cface == 8 || cface == 7 || cface == 5 || cface == 4 || cface == 3 || cface == 2) ? cface : undef)) :
    // xz
    face == 10 ? ((cface == 11) ? 8 : (cface == 9) ? 6 : ((cface == 8 || cface == 6 || cface == 5 || cface == 4  || cface == 1 || cface == 0) ? cface : undef)) :
    // xy
    face == 9 ? ((cface == 11) ? 7 : (cface == 10) ? 6 : (cface == 7 || cface == 6 || cface == 3 || cface == 2  || cface == 1 || cface == 0) ? cface : undef) :
    
    // z
    face == 8 ? ((cface == 11) ? face : (cface == 10) ? face : (cface == 5 || cface == 4) ? cface : undef) :
    // y
    face == 7 ? ((cface == 11) ? face : (cface == 9) ? face : (cface == 3 || cface == 2) ? cface : undef) :
    // x
    face == 6 ? ((cface == 10) ? face : (cface == 9) ? face : (cface == 1 || cface == 0) ? cface : undef) :

    // z+
    face == 5 ? ((cface == 11 || cface == 10 || cface == 8) ? face : undef):
    // z-
    face == 4 ? ((cface == 11 || cface == 10 || cface == 8) ? face : undef):
    // y+
    face == 3 ? ((cface == 11 || cface == 9 || cface == 7) ? face : undef):
    // y-
    face == 2 ? ((cface == 11 || cface == 9 || cface == 7) ? face : undef):
    // x+
    face == 1 ? ((cface == 10 || cface == 9 || cface == 6) ? face : undef):
    // x-
    face == 0 ? ((cface == 10 || cface == 9 || cface == 6) ? face : undef) : undef;

function mb_face_has_common(face, cface) = !is_undef(mb_face_common(face, cface));

function mb_face_to_axis(face) =
    face == 6 ? 0 :
    face == 7 ? 1 :
    face == 8 ? 2 :
    face < 6 ? mb_side_to_axis(side = face) :
    undef;

function mb_face_split(face, splits) = 
    [
        for(split = splits)
            let(f = mb_face_common(face, split))
                if(!is_undef(f)) f
    ];

/*
function mb_face_contains(face, cface) =
    let(
        face = mb_face_to_int(face),
        cface = mb_face_to_int(cface)
    )
    face == 12 ||
    face == cface ||
    (face == 6 && (cface == 0 || cface == 1)) ||
    (face == 7 && (cface == 2 || cface == 3)) ||
    (face == 8 && (cface == 4 || cface == 5)) ||
    
    (face == 9 && (cface == 0 || cface == 1 || cface == 2 || cface == 3 || cface == 6 || cface == 7)) ||
    (face == 10 && (cface == 0 || cface == 1 || cface == 4 || cface == 5 || cface == 6 || cface == 8)) || 
    (face == 11 && (cface == 2 || cface == 3 || cface == 4 || cface == 5 || cface == 7 || cface == 8));

function mb_face_is(face, cface) =
    let(face = mb_face_to_int(face),
    cface = mb_face_to_int(cface))
    face == cface;

function mb_face_contains_axis(face, axis) =
    let(face = mb_face_to_int(face),
    axis = mb_axis_to_int(axis))
    (axis == 0 && (face == 0 || face == 1 || face == 6 || face == 9 || face == 10 || face == 12)) ||
    (axis == 1 && (face == 2 || face == 3 || face == 7 || face == 9 || face == 11 || face == 12)) ||
    (axis == 2 && (face == 4 || face == 5 || face == 8 || face == 10 || face == 11 || face == 12));
*/



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
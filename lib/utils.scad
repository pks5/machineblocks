function mb_resolve_xyz(xyz, default = [0, 0, 0], mul = undef, min_value = undef, precision = undef) = 
    let(m = is_undef(mul) ? [1, 1, 1] : mb_resolve_xyz(mul, default = [1, 1, 1]),
        r = is_list(xyz) ? 
        ([
            m[0] * (is_num(xyz[0]) ? xyz[0] : (is_undef(default) ? 0 : default[0])), 
            m[1] * (is_num(xyz[1]) ? xyz[1] : (is_undef(default) ? 0 : default[1])), 
            m[2] * (is_num(xyz[2]) ? xyz[2] : (is_undef(default) ? 0 : default[2]))
        ]) : 
        is_num(xyz) ? [m[0] * xyz, m[1] * xyz, m[2] * xyz] : default,
        p = is_undef(r) ? undef : (is_undef(precision) ? r : [round_prec(r[0], precision), round_prec(r[1], precision), round_prec(r[2], precision)]))
    is_undef(p) ? undef : (is_undef(min_value) ? p : [max(min_value, p[0]), max(min_value, p[1]), max(min_value, p[2])]);
 

function mb_resolve_face_sext(sext, mul = undef) = 
    let(mul = mb_resolve_xyz(mul, default = [1, 1, 1]))
    is_undef(sext) || is_string(sext) ? [0, 0, 0, 0, 0, 0] : 
    is_list(sext) ? 
    (len(sext) == 3 ? 
        [
            sext[0]*mul[0], 
            sext[0]*mul[0], 
            sext[1]*mul[1], 
            sext[1]*mul[1], 
            sext[2]*mul[2], 
            sext[2]*mul[2]
        ] : 
        [
            sext[0]*mul[0], 
            sext[1]*mul[0], 
            sext[2]*mul[1], 
            sext[3]*mul[1], 
            sext[4]*mul[2], 
            sext[5]*mul[2]
        ]) : 
        [
            sext * mul[0], 
            sext * mul[0], 
            sext * mul[1], 
            sext * mul[1], 
            sext * mul[2], 
            sext * mul[2]
        ];

function mb_bounding_box(size) = [ceil(size[0]), ceil(size[1]), ceil(size[2])];

function mb_block_dim(size, base_mod = undef, unitMbu = 1.6, unitGrid = [5, 2]) =
    let(mod = mb_resolve_face_sext(base_mod),
        bb = mb_bounding_box(size),
        c = [0.5 * bb[0], 0.5 * bb[1], 0.5 * bb[2]],
        mi = [-mod[0], -mod[2], 0],
        ma = [size[0] + mod[1], size[1] + mod[3], size[2] + mod[5]],
        mod_size = [
            size[0] + mod[0] + mod[1],
            size[1] + mod[2] + mod[3],
            size[2] + mod[4] + mod[5]
        ])
    [
        [size, bb], // Original Size 
        [mod_size, mb_bounding_box(mod_size)], // Modified Size
        [mi, ma], // Max
        [
            [floor(-mod[0]), floor(-mod[2]), 0], // Min Index
            [ceil(size[0] + mod[1] - 1), ceil(size[1] + mod[3] - 1), ceil(size[2] + mod[5] - 1)] // Max Index
        ],
        [c], // org center (without mod)
        [
            [mi[0] - c[0], mi[1] - c[1], mi[2] - c[2]], // min from org center
            [ma[0] - c[0], ma[1] - c[1], ma[2] - c[2]] // max from org center
        ],
        [unitMbu, unitGrid]
    ];

function mb_slope_matrix(slope, bevel_res, mod_size) =
    let(
        slope = mb_slope_resolve(slope),
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

function mb_bevel_matrix(bevel, mod_size, min_max) =
    let(
        bevel = mb_bevel_resolve(bevel),
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
                    (bb[i] == bb[(i + 2) % 8] && false) || 
                    (bb[i] == bb[(i + 8 - 2) % 8] && true) || 
                
                    (bb[i] == bb[(i + 8 - 1) % 8] && false) ||
                    (bb[i] == bb[(i + 1) % 8] && true)
                ) ? undef : bb[i]
        ]
    )
    [bv, bu];

function mb_block_to_shape(block_dim, bevel = undef, slope = undef) =
    let(
        mod_size = block_dim[1][0],
        min_max = block_dim[5],
        
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
        [min_max[0][2], min_max[1][2]],
        [0.2, 0.2]
        //,bevel_matrix
    ];

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
    [
        for (item = arr)
            if (mb_str_starts_with(item[0], str(ns, ".")))
                let(newKey = mb_substr_from(item[0], len(ns) + 1))
                    concat([newKey], mb_array_slice(item, 1))
    ];

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

/*
* MISC
*/

function round_prec(x, p) = round(x / p) * p;

function mb_undef_to(v, to = 0) = v == undef ? to : v;

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
* ------------------------
* START mb_bevel_resolve()
* ------------------------
*/

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
* ----------------------
* END mb_bevel_resolve()
* ----------------------
*/

/*
* ------------------------
* START mb_slope_resolve()
* ------------------------
*/
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

function mb_slope_key(k) =
    k == "x-" || k == 0 ? 0 :
    k == "x+" || k == 1 ? 1 :
    k == "y-" || k == 2 ? 2 :
    k == "y+" || k == 3 ? 3 :
    k == "x"  || k == 6 ? 6 :
    k == "y"  || k == 7 ? 7 :
    k == "xy" || k == 9 ? 9 :
    undef;

function mb_slope_complex_item(item) =
    is_list(item) && len(item) == 2 && is_num(item[1])
        ? let(k = mb_slope_key(item[0]), v = item[1])
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
/*
* ----------------------
* END mb_slope_resolve()
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

function mb_corner_to_int(axis, corner) =
    let(axis = mb_axis_to_int(axis))
    is_string(corner) ? (
    corner == "sw" ? (axis == 0 ? 1 : 0) : 
    corner == "nw" ? (axis == 0 ? 2 : 1) :
    corner == "ne" ? (axis == 0 ? 3 : 2) :
    corner == "se" ? (axis == 0 ? 0 : 3) :
    undef
    ) : corner;    

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
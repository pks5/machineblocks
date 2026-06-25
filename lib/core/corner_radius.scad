use <utils.scad>;

function mb_crfsv_axis(v) =
    is_list(v) 
        ? [
            len(v) > 0 ? (is_list(v[0]) || is_num(v[0]) ? v[0] : 0) : 0, 
            len(v) > 1 ? (is_list(v[1]) || is_num(v[1]) ? v[1] : 0) : 0, 
            len(v) > 2 ? (is_list(v[2]) || is_num(v[2]) ? v[2] : 0) : 0
        ] 
        : is_num(v) ? [v, v, v] : [0, 0, 0];

function mb_crfsv_quad(v) =
    is_list(v) 
        ? (
        len(v) == 2 && is_num(v[0]) && is_num(v[1]) ? 
        [
            v, v, v, v
        ]
        : [
            len(v) > 0 ? (is_list(v[0]) || is_num(v[0]) ? v[0] : 0) : 0, 
            len(v) > 1 ? (is_list(v[1]) || is_num(v[1]) ? v[1] : 0) : 0, 
            len(v) > 2 ? (is_list(v[2]) || is_num(v[2]) ? v[2] : 0) : 0, 
            len(v) > 3 ? (is_list(v[3]) || is_num(v[3]) ? v[3] : 0) : 0
        ]) 
        : is_num(v) ? [v, v, v, v] : [0, 0, 0, 0];

function mb_crfsv_pair(v) =
    is_list(v) 
        ? [
            len(v) > 0 ? (is_num(v[0]) ? v[0] : 0) : 0, 
            len(v) > 1 ? (is_num(v[1]) ? v[1] : 0) : 0
        ] 
        : is_num(v) ? [v, v] : [0, 0];

function mb_corner_radius_from_side_views(r) =
    let(
        rv = mb_crfsv_axis(r),

        x = mb_crfsv_quad(rv[0]),
        y = mb_crfsv_quad(rv[1]),
        z = mb_crfsv_quad(rv[2]),

        // Z view: from z+, direct top-down corner order
        z_sw = mb_crfsv_pair(z[0]),
        z_nw = mb_crfsv_pair(z[1]),
        z_ne = mb_crfsv_pair(z[2]),
        z_se = mb_crfsv_pair(z[3]),

        // X view: from x-, side rectangle order
        // sw -> bottom, nw -> top, ne -> top opposite, se -> bottom opposite
        x_b0 = mb_crfsv_pair(x[0]),
        x_t0 = mb_crfsv_pair(x[1]),
        x_t1 = mb_crfsv_pair(x[2]),
        x_b1 = mb_crfsv_pair(x[3]),

        // Y view: from y-, side rectangle order
        y_b0 = mb_crfsv_pair(y[0]),
        y_t0 = mb_crfsv_pair(y[1]),
        y_t1 = mb_crfsv_pair(y[2]),
        y_b1 = mb_crfsv_pair(y[3])
    )
    [
        // lower z plane: sw-, nw-, ne-, se-
        [
            [ z_sw, y_b0, x_b0 ], // sw-: [[xy,yx], [xz,zx], [yz,zy]]
            [ z_sw, y_b0, x_b0 ],
            [ z_nw, y_b0, x_b1 ], // nw-
            [ z_nw, y_b0, x_b1 ],
            [ z_ne, y_b1, x_b1 ], // ne-
            [ z_ne, y_b1, x_b1 ],
            [ z_se, y_b1, x_b0 ], // se-
            [ z_se, y_b1, x_b0 ]
        ],

        // upper z plane: sw+, nw+, ne+, se+
        [
            [ z_sw, y_t0, x_t0 ], // sw+
            [ z_sw, y_t0, x_t0 ],
            [ z_nw, y_t0, x_t1 ], // nw+
            [ z_nw, y_t0, x_t1 ],
            [ z_ne, y_t1, x_t1 ], // ne+
            [ z_ne, y_t1, x_t1 ],
            [ z_se, y_t1, x_t0 ], // se+
            [ z_se, y_t1, x_t0 ]
        ]
    ];

function mb_radius_pair_resolve(v, default = [0, 0], mul = 1, min_value = undef, precision = undef) =
    let(
        p0 =
            is_num(v) ? [v, v] :
            is_list(v) ? [
                len(v) > 0 && is_num(v[0]) ? v[0] : default[0],
                len(v) > 1 && is_num(v[1]) ? v[1] : default[1]
            ] :
            default,

        p1 = [
            p0[0] * mul,
            p0[1] * mul
        ],

        p2 = is_undef(min_value) ? p1 : [
            max(min_value, p1[0]),
            max(min_value, p1[1])
        ],

        p3 = is_undef(precision) ? p2 : [
            mb_round_prec(p2[0], precision),
            mb_round_prec(p2[1], precision)
        ]
    )
    (p3[0] > 0 && p3[1] > 0) ? p3 : is_undef(min_value) ? [0,0] : [min_value, min_value];


function mb_corner_radius_resolve(
    corner_radius,
    default = [[0, 0], [0, 0], [0, 0]],
    mul = undef,
    min_value = undef,
    precision = undef
) =
    let(
        m = is_undef(mul) ? [1, 1, 1] : mb_resolve_xyz(mul, default = [1, 1, 1]),

        // normalize input to 3 raw pair values
        r =
            is_num(corner_radius) ? [
                corner_radius,
                corner_radius,
                corner_radius
            ] :
            is_list(corner_radius) ? [
                len(corner_radius) > 0 ? corner_radius[0] : default[0],
                len(corner_radius) > 1 ? corner_radius[1] : default[1],
                len(corner_radius) > 2 ? corner_radius[2] : default[2]
            ] :
            default
    )
    [
        mb_radius_pair_resolve(r[0], default[0], m[0], min_value, precision), // [xy, yx]
        mb_radius_pair_resolve(r[1], default[1], m[1], min_value, precision), // [xz, zx]
        mb_radius_pair_resolve(r[2], default[2], m[2], min_value, precision)  // [yz, zy]
    ];

// true = this pair is inactive / no usable radius
function mb_radius_pair_is_none(pair, min_value = 0) =
    !is_list(pair) || len(pair) < 2 ||
    pair[0] <= min_value || pair[1] <= min_value;


// true = all 3 radius pairs are inactive
function mb_corner_radius_is_none(corner_radius, min_value = 0) =
    mb_radius_pair_is_none(corner_radius[0], min_value) &&
    mb_radius_pair_is_none(corner_radius[1], min_value) &&
    mb_radius_pair_is_none(corner_radius[2], min_value);


// true = exactly 2 pairs are inactive
// means: only one radius pair remains active => ellipse disk case
function mb_corner_radius_is_ellipse_disk(corner_radius, min_value = 0) =
    (
        (mb_radius_pair_is_none(corner_radius[0], min_value) ? 1 : 0) +
        (mb_radius_pair_is_none(corner_radius[1], min_value) ? 1 : 0) +
        (mb_radius_pair_is_none(corner_radius[2], min_value) ? 1 : 0)
    ) == 2;

function mb_corner_radius_active_pair_index(r, min_value = 0) =
    !mb_radius_pair_is_none(r[0], min_value) ? 0 :
    !mb_radius_pair_is_none(r[1], min_value) ? 1 :
    !mb_radius_pair_is_none(r[2], min_value) ? 2 :
    undef;

function mb_corner_radius_is_sphere(r) =
    let(v = r[0][0])
    r == [
        [v,v],
        [v,v],
        [v,v]
    ];

function mb_corner_radius_max_xyz(corner_radius) =
[
    max(corner_radius[0][0], corner_radius[1][0]), // max(xy, xz)
    max(corner_radius[0][1], corner_radius[2][0]), // max(yx, yz)
    max(corner_radius[1][1], corner_radius[2][1])  // max(zx, zy)
];
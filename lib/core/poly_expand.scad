use <utils.scad>;

/*
 * Polygon expand / inset helper
 * All functions are prefixed with mb_poly_expand_*
 */

// =====================
// Vector helpers
// =====================

function mb_poly_expand_vadd(a, b) =
    [a[0] + b[0], a[1] + b[1]];

function mb_poly_expand_vsub(a, b) =
    [a[0] - b[0], a[1] - b[1]];

function mb_poly_expand_vmul(a, s) =
    [a[0] * s, a[1] * s];

function mb_poly_expand_vlen(a) =
    sqrt(a[0] * a[0] + a[1] * a[1]);

function mb_poly_expand_vunit(a) =
    let(l = mb_poly_expand_vlen(a))
        l == 0 ? [0, 0] : mb_poly_expand_vmul(a, 1 / l);

function mb_poly_expand_cross2(a, b) =
    a[0] * b[1] - a[1] * b[0];


// =====================
// Polygon area / orientation
// =====================

function mb_poly_expand_area2(p, i = 0, acc = 0) =
    i >= len(p)
        ? acc
        : mb_poly_expand_area2(
            p,
            i + 1,
            acc + mb_poly_expand_cross2(p[i], p[(i + 1) % len(p)])
        );

function mb_poly_expand_signed_area(p) =
    0.5 * mb_poly_expand_area2(p);

function mb_poly_expand_same_orientation(a, b, eps = 0.000001) =
    let(
        aa = mb_poly_expand_area2(a),
        bb = mb_poly_expand_area2(b)
    )
    abs(bb) > eps &&
    (
        (aa > 0 && bb > 0) ||
        (aa < 0 && bb < 0)
    );


// =====================
// Line / segment checks
// =====================

function mb_poly_expand_orient2(a, b, c) =
    (b[0] - a[0]) * (c[1] - a[1]) -
    (b[1] - a[1]) * (c[0] - a[0]);

function mb_poly_expand_between(a, b, c, eps = 0.000001) =
    min(a, b) - eps <= c && c <= max(a, b) + eps;

function mb_poly_expand_point_on_segment(a, b, p, eps = 0.000001) =
    abs(mb_poly_expand_orient2(a, b, p)) <= eps &&
    mb_poly_expand_between(a[0], b[0], p[0], eps) &&
    mb_poly_expand_between(a[1], b[1], p[1], eps);

function mb_poly_expand_segments_intersect(a, b, c, d, eps = 0.000001) =
    let(
        o1 = mb_poly_expand_orient2(a, b, c),
        o2 = mb_poly_expand_orient2(a, b, d),
        o3 = mb_poly_expand_orient2(c, d, a),
        o4 = mb_poly_expand_orient2(c, d, b)
    )
    (
        (o1 * o2 < -eps && o3 * o4 < -eps) ||
        mb_poly_expand_point_on_segment(a, b, c, eps) ||
        mb_poly_expand_point_on_segment(a, b, d, eps) ||
        mb_poly_expand_point_on_segment(c, d, a, eps) ||
        mb_poly_expand_point_on_segment(c, d, b, eps)
    );

function mb_poly_expand_line_intersect(p0, r, q0, s, eps = 0.000000000001) =
    let(den = mb_poly_expand_cross2(r, s))
        abs(den) < eps
            ? undef
            : mb_poly_expand_vadd(
                p0,
                mb_poly_expand_vmul(
                    r,
                    mb_poly_expand_cross2(
                        mb_poly_expand_vsub(q0, p0),
                        s
                    ) / den
                )
            );


// =====================
// Self-intersection check
// =====================

function mb_poly_expand_edges_adjacent(n, i, j) =
    i == j ||
    (i + 1) % n == j ||
    (j + 1) % n == i;

function mb_poly_expand_self_intersects_pair(p, i, j, eps) =
    let(n = len(p))
        mb_poly_expand_edges_adjacent(n, i, j)
            ? false
            : mb_poly_expand_segments_intersect(
                p[i],
                p[(i + 1) % n],
                p[j],
                p[(j + 1) % n],
                eps
            );

function mb_poly_expand_self_intersects_j(p, i, j, eps) =
    j >= len(p)
        ? false
        : mb_poly_expand_self_intersects_pair(p, i, j, eps)
            ? true
            : mb_poly_expand_self_intersects_j(p, i, j + 1, eps);

function mb_poly_expand_self_intersects_i(p, i = 0, eps = 0.000001) =
    i >= len(p)
        ? false
        : mb_poly_expand_self_intersects_j(p, i, i + 1, eps)
            ? true
            : mb_poly_expand_self_intersects_i(p, i + 1, eps);

function mb_poly_expand_valid_simple(p, eps = 0.000001) =
    len(p) >= 3 &&
    !mb_poly_expand_self_intersects_i(p, 0, eps);


// =====================
// Array helpers
// =====================

function mb_poly_expand_array_index_of(a, v, i = 0) =
    i >= len(a)
        ? undef
        : a[i] == v
            ? i
            : mb_poly_expand_array_index_of(a, v, i + 1);

function mb_poly_expand_scale_array(a, s) =
    [for(v = a) v * s];


// =====================
// Core polygon inset / expand
// =====================

function mb_poly_expand_ngon_edges(p, d_edge) =
    let(
        n = len(p),
        area = mb_poly_expand_signed_area(p),
        ccw = area > 0,

        e = [
            for(i = [0 : n - 1])
                mb_poly_expand_vunit(
                    mb_poly_expand_vsub(p[(i + 1) % n], p[i])
                )
        ],

        n_ccw = [
            for(i = [0 : n - 1])
                [-e[i][1], e[i][0]]
        ],

        n_in = [
            for(i = [0 : n - 1])
                ccw ? n_ccw[i] : mb_poly_expand_vmul(n_ccw[i], -1)
        ],

        shifted = [
            for(i = [0 : n - 1])
                mb_poly_expand_vadd(
                    p[i],
                    mb_poly_expand_vmul(n_in[i], d_edge[i])
                )
        ]
    )
    [
        for(i = [0 : n - 1])
            mb_poly_expand_line_intersect(
                shifted[(i - 1 + n) % n],
                e[(i - 1 + n) % n],
                shifted[i],
                e[i]
            )
    ];

function mb_poly_expand_ngon_valid(original, expanded, eps = 0.000001) =
    mb_poly_expand_same_orientation(original, expanded, eps) &&
    mb_poly_expand_valid_simple(expanded, eps);

function mb_poly_expand_ngon_edges_safe_iter(p, d_edge, lo, hi, steps, eps) =
    steps <= 0
        ? mb_poly_expand_ngon_edges(
            p,
            mb_poly_expand_scale_array(d_edge, lo)
        )
        : let(
            mid = (lo + hi) / 2,
            q = mb_poly_expand_ngon_edges(
                p,
                mb_poly_expand_scale_array(d_edge, mid)
            ),
            ok = mb_poly_expand_ngon_valid(p, q, eps)
        )
        ok
            ? mb_poly_expand_ngon_edges_safe_iter(
                p, d_edge, mid, hi, steps - 1, eps
            )
            : mb_poly_expand_ngon_edges_safe_iter(
                p, d_edge, lo, mid, steps - 1, eps
            );

function mb_poly_expand_ngon_edges_safe(
    p,
    d_edge,
    steps = 24,
    eps = 0.000001
) =
    let(q = mb_poly_expand_ngon_edges(p, d_edge))
        mb_poly_expand_ngon_valid(p, q, eps)
            ? q
            : mb_poly_expand_ngon_edges_safe_iter(
                p, d_edge, 0, 1, steps, eps
            );


// =====================
// Public prismoid plane expand
// =====================

function mb_poly_expand(pts, p, expand, mul = undef) =
    is_undef(expand) || expand == [0, 0, 0, 0, 0, 0]
        ? pts
        : let(
            sext = mb_qc_resolve(qc = expand, mul = mul, cube = true),

            // 0/1 left, 2/3 back, 4/5 right, 6/7 front
            d_edge8 = [
                is_undef(pts[1]) ? -sext[0] : -max(sext[0], sext[2]), -sext[0], // 0 -> n, 1 -> n
                is_undef(pts[3]) ? -sext[3] : -max(sext[3], sext[0]), -sext[3], // 2 -> n, 3 -> n
                is_undef(pts[5]) ? -sext[1] : -max(sext[1], sext[3]), -sext[1], // 4 -> n, 5 -> n
                is_undef(pts[7]) ? -sext[2] : -max(sext[2], sext[1]), -sext[2], // 6 -> n, 7 -> n
            ],

            d_edge89 = [
                -sext[0], -sqrt(sext[0] * sext[2]),
                -sext[3], -sqrt(sext[3] * sext[0]),
                -sext[1], -sqrt(sext[1] * sext[3]),
                -sext[2], -sqrt(sext[2] * sext[1]),
            ],

            idx = [
                for(i = [0 : 7])
                    if(pts[i] != undef)
                        i
            ],

            pc = [for(i = idx) pts[i]],
            dc = [for(i = idx) d_edge8[i]],

            qc = len(pc) >= 3
                ? mb_poly_expand_ngon_edges_safe(pc, dc)
                : [],

            q8 = [
                for(i = [0 : 7])
                    let(qi = mb_poly_expand_array_index_of(idx, i))
                    pts[i] == undef
                        ? undef
                        : let(q = qc[qi])
                            [
                                q[0],
                                q[1],
                                len(pts[i]) > 2 && !is_undef(pts[i][2])
                                    ? pts[i][2] + (p == 0 ? -1 : 1) * sext[4 + p]
                                    : undef,
                                pts[i][3]
                            ]
            ]
        )
        q8;



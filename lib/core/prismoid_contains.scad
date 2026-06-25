use <utils.scad>;

function mb_prismoid_contains(
    prismoid,
    plane,
    circle_pos,
    circle_radius,
    overhang = 0,
    touch = false,
    avoid_vertical_rounding = false
) =
    let(
        eps = 1e-6,
        p = (
            prismoid != undef &&
            is_list(prismoid) &&
            plane != undef &&
            plane >= 0 &&
            len(prismoid) > plane
        ) ? prismoid[plane] : undef,

        contour = mb_prismoid_c_rounded_contour_2d(p),
        ok = mb_prismoid_c_ok_point(circle_pos) &&
             circle_radius != undef &&
             circle_radius >= 0 &&
             len(contour) >= 3,

        oh = max(0, overhang),

        r = ok
            ? circle_radius + (
                avoid_vertical_rounding
                    ? mb_prismoid_c_plane_vertical_rounding_max(p)
                    : 0
              )
            : 0,

        inside = ok ? mb_prismoid_c_point_in_polygon(circle_pos, contour, eps) : false,

        dmin = ok ? min([
            for(i = [0 : len(contour) - 1])
            mb_prismoid_c_dist_point_segment(
                circle_pos,
                contour[i],
                contour[(i + 1) % len(contour)]
            )
        ]) : 0,

        signed_dist = inside ? dmin : -dmin,
        expanded_signed_dist = signed_dist + oh
    )
    !ok ? false :
    touch
        ? expanded_signed_dist >= -r - eps
        : expanded_signed_dist >=  r - eps;


// ============================================================
// Prismoid plane -> rounded 2D contour
// ============================================================

function mb_prismoid_c_rounded_contour_2d(plane, steps = 8, eps = 1e-6) =
    let(
        indexed = mb_prismoid_c_valid_indexed_points_2d(plane),
        n = len(indexed)
    )
    n < 3 ? [] :
    [
        for(i = [0 : n - 1])
        each mb_prismoid_c_corner_curve_2d(
            indexed[(i + n - 1) % n],
            indexed[i],
            indexed[(i + 1) % n],
            steps
        )
    ];

function mb_prismoid_c_valid_indexed_points_2d(plane) =
    plane == undef ? [] :
    [
        for(i = [0 : len(plane) - 1])
        if(mb_prismoid_c_ok_point(plane[i]))
        [i, plane[i]]
    ];

/*
function mb_prismoid_c_corner_curve_2d(Ai, Bi, Ci, steps = 8) =
    let(
        A = [Ai[1][0], Ai[1][1]],
        B = [Bi[1][0], Bi[1][1]],
        C = [Ci[1][0], Ci[1][1]],
        idx = Bi[0],

        BA = [A[0] - B[0], A[1] - B[1]],
        BC = [C[0] - B[0], C[1] - B[1]],

        la = mb_prismoid_c_norm(BA),
        lc = mb_prismoid_c_norm(BC),

        rin0  = mb_prismoid_c_xy_radius_for_edge(Bi[1], idx, BA),
        rout0 = mb_prismoid_c_xy_radius_for_edge(Bi[1], idx, BC),

        rin  = min(rin0,  la * 0.49),
        rout = min(rout0, lc * 0.49),

        Pin = la <= 0
            ? B
            : [B[0] + BA[0] / la * rin, B[1] + BA[1] / la * rin],

        Pout = lc <= 0
            ? B
            : [B[0] + BC[0] / lc * rout, B[1] + BC[1] / lc * rout]
    )
    (rin <= 0 && rout <= 0)
        ? [B]
        : [
            for(s = [0 : steps])
            let(t = s / steps)
            mb_prismoid_c_quad_bezier(Pin, B, Pout, t)
        ];
*/

function mb_prismoid_c_corner_curve_2d(Ai, Bi, Ci, steps = 12) =
    let(
        A = [Ai[1][0], Ai[1][1]],
        B = [Bi[1][0], Bi[1][1]],
        C = [Ci[1][0], Ci[1][1]],
        idx = Bi[0],

        BA = [A[0] - B[0], A[1] - B[1]],
        BC = [C[0] - B[0], C[1] - B[1]],

        la = mb_prismoid_c_norm(BA),
        lc = mb_prismoid_c_norm(BC),

        rin0  = mb_prismoid_c_xy_radius_for_edge(Bi[1], idx, BA),
        rout0 = mb_prismoid_c_xy_radius_for_edge(Bi[1], idx, BC),

        rin  = min(rin0,  la * 0.49),
        rout = min(rout0, lc * 0.49),

        u = la <= 0 ? [0, 0] : [BA[0] / la, BA[1] / la],
        v = lc <= 0 ? [0, 0] : [BC[0] / lc, BC[1] / lc],

        // Ellipsenzentrum: vom Eckpunkt entlang beider Kanten hinein
        O = [
            B[0] + u[0] * rin + v[0] * rout,
            B[1] + u[1] * rin + v[1] * rout
        ]
    )
    (rin <= 0 && rout <= 0)
        ? [B]
        : [
            for(s = [0 : steps])
            let(
                a = s / steps * 90,
                ca = cos(a),
                sa = sin(a)
            )
            [
                O[0] - v[0] * rout * ca - u[0] * rin * sa,
                O[1] - v[1] * rout * ca - u[1] * rin * sa
            ]
        ];

// ============================================================
// Radius helpers
// ============================================================

function mb_prismoid_c_xy_radius_for_edge(point, idx, edge) =
    let(
        rr = len(point) > 3 ? point[3] : undef,
        zrad = rr != undef && is_list(rr) && len(rr) > 0 ? rr[0] : undef,

        xy = zrad != undef &&
             is_list(zrad) &&
             len(zrad) > 0 &&
             zrad[0] != undef
                ? zrad[0]
                : 0,

        yx = zrad != undef &&
             is_list(zrad) &&
             len(zrad) > 1 &&
             zrad[1] != undef
                ? zrad[1]
                : xy,

        ax = abs(edge[0]),
        ay = abs(edge[1]),

        corner_group = floor(idx / 2),
        mirror = corner_group == 1 || corner_group == 3
    )
    ax >= ay
        ? (mirror ? yx : xy)
        : (mirror ? xy : yx);


// ============================================================
// Vertical rounding guard
// ============================================================

function mb_prismoid_c_plane_vertical_rounding_max(plane) =
    plane == undef ? 0 :
    max(concat(
        [0],
        [
            for(p = plane)
            if(mb_prismoid_c_ok_point(p))
            mb_prismoid_c_point_vertical_rounding_max(p)
        ]
    ));

function mb_prismoid_c_point_vertical_rounding_max(p) =
    let(
        rr = len(p) > 3 ? p[3] : undef,

        xz_pair = rr != undef && is_list(rr) && len(rr) > 1 && is_list(rr[1])
            ? rr[1]
            : undef,

        yz_pair = rr != undef && is_list(rr) && len(rr) > 2 && is_list(rr[2])
            ? rr[2]
            : undef,

        xz = xz_pair != undef && len(xz_pair) > 0 && xz_pair[0] != undef ? xz_pair[0] : 0,
        yz = yz_pair != undef && len(yz_pair) > 0 && yz_pair[0] != undef ? yz_pair[0] : 0
    )
    max(xz, yz);

function mb_prismoid_c_pair_max_undef0(v) =
    v == undef || !is_list(v)
        ? 0
        : max(concat(
            [0],
            [
                for(i = [0 : len(v) - 1])
                if(v[i] != undef)
                v[i]
            ]
        ));


// ============================================================
// Generic geometry helpers
// ============================================================

function mb_prismoid_c_quad_bezier(A, B, C, t) =
    [
        (1 - t) * (1 - t) * A[0] +
        2 * (1 - t) * t * B[0] +
        t * t * C[0],

        (1 - t) * (1 - t) * A[1] +
        2 * (1 - t) * t * B[1] +
        t * t * C[1]
    ];

function mb_prismoid_c_point_in_polygon(P, points, eps = 1e-6) =
    let(n = len(points))
    (mb_sum([
        for(i = [0 : n - 1])
        let(
            A = points[i],
            B = points[(i + 1) % n],
            hit = ((A[1] > P[1]) != (B[1] > P[1])) &&
                  (
                    P[0] <
                    (B[0] - A[0]) *
                    (P[1] - A[1]) /
                    (B[1] - A[1] + eps) +
                    A[0]
                  )
        )
        hit ? 1 : 0
    ]) % 2) == 1;

function mb_prismoid_c_dist_point_segment(P, A, B) =
    let(
        AB = [B[0] - A[0], B[1] - A[1]],
        AP = [P[0] - A[0], P[1] - A[1]],
        den = mb_prismoid_c_dot(AB, AB)
    )
    den == 0
        ? mb_prismoid_c_norm(AP)
        : let(t = mb_prismoid_c_clamp(mb_prismoid_c_dot(AP, AB) / den, 0, 1))
          mb_prismoid_c_norm([
              P[0] - (A[0] + t * AB[0]),
              P[1] - (A[1] + t * AB[1])
          ]);

function mb_prismoid_c_ok_point(p) =
    p != undef &&
    is_list(p) &&
    len(p) >= 2 &&
    p[0] != undef &&
    p[1] != undef;

function mb_prismoid_c_dot(a, b) =
    a[0] * b[0] + a[1] * b[1];

function mb_prismoid_c_norm(a) =
    sqrt(a[0] * a[0] + a[1] * a[1]);

function mb_prismoid_c_clamp(x, lo, hi) =
    x < lo ? lo : x > hi ? hi : x;
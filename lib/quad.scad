use <core/utils.scad>;

// =====================
// Hilfsfunktionen
// =====================
function mb_vadd(a,b)   = [a[0]+b[0], a[1]+b[1]];
function mb_vsub(a,b)   = [a[0]-b[0], a[1]-b[1]];
function mb_vmul(a,s)   = [a[0]*s,   a[1]*s   ];

function mb_vlen(a)     = sqrt(a[0]*a[0] + a[1]*a[1]);
function mb_vunit(a)    = let(L=mb_vlen(a)) (L==0 ? [0,0] : mb_vmul(a, 1/L));
function mb_cross2(a,b) = a[0]*b[1] - a[1]*b[0];
function mb_abs(x)      = (x<0)?-x:x;
function mb_eq(a,b,eps=1e-12) = (mb_abs(a[0]-b[0])<eps) && (mb_abs(a[1]-b[1])<eps);

// rekursive Summe der Kreuzprodukte über alle Kanten (kompatibel zu alten OpenSCADs)
function mb_cross_sum_edges(P, i=0, acc=0) =
    (i == len(P)) ? acc
                  : mb_cross_sum_edges(P, i+1, acc + mb_cross2(P[i], P[(i+1)%len(P)]));

// signierte Polygonfläche (beliebige n)
function mb_signed_area_any(P) = 0.5 * mb_cross_sum_edges(P);

// Schnittpunkt zweier Geraden: p0 + t*r  und  q0 + u*s
function mb_line_intersect(p0, r, q0, s) =
    let(den = mb_cross2(r, s))
    (abs(den) < 1e-12) ? undef
    : mb_vadd(p0, mb_vmul(r, mb_cross2(mb_vsub(q0,p0), s)/den));

// =====================
// Allgemeines n-Gon-Inset mit individueller Kantenstärke
// P: Punkte [P0..P{n-1}], d_edge[i] gehört zu Kante P[i] -> P[i+1]
// =====================
function mb_inset_ngon_edges(P, d_edge) =
    let(
        n   = len(P),
        A   = mb_signed_area_any(P),
        ccw = A > 0,

        E    = [ for (i=[0:n-1]) mb_vunit( mb_vsub(P[(i+1)%n], P[i]) ) ],
        Nccw = [ for (i=[0:n-1]) [-E[i][1], E[i][0]] ],
        N_in = [ for (i=[0:n-1]) (ccw ? Nccw[i] : mb_vmul(Nccw[i], -1)) ],
        S    = [ for (i=[0:n-1]) mb_vadd(P[i], mb_vmul(N_in[i], d_edge[i])) ]
    )
    [ for (i=[0:n-1])
        mb_line_intersect(
            S[(i-1+n)%n], E[(i-1+n)%n],
            S[i],         E[i]
        )
    ];

// =====================
// Öffentliche Funktion (dein Format) + Degeneration
// punkte:  [VorneLinks, HintenLinks, HintenRechts, VorneRechts]
// raender: [Links, Rechts, Vorne, Hinten]
// =====================
function mb_inset_quad_lrfh(punkte, borders) =
    let(
        P0 = punkte[0], P1 = punkte[1], P2 = punkte[2], P3 = punkte[3],

        raender = borders[0] == undef ? [borders, borders, borders, borders] : borders,
        // Mapping deiner Ränder -> Kanten P[i]→P[i+1]
        // 0: P0->P1 = links, 1: P1->P2 = hinten, 2: P2->P3 = rechts, 3: P3->P0 = vorne
        d_edge4 = [raender[0], raender[3], raender[1], raender[2]],

        // Degeneration (adjazente Doppelpunkte)
        is01 = mb_eq(P0,P1),
        is12 = mb_eq(P1,P2),
        is23 = mb_eq(P2,P3),
        is30 = mb_eq(P3,P0),
        no_deg = !(is01 || is12 || is23 || is30),

        // komprimierte Punktemenge + Randzuordnung für Dreieck
        Pc =  no_deg ? [P0,P1,P2,P3] :
              is01   ? [P0,P2,P3] :
              is12   ? [P0,P1,P3] :
              is23   ? [P0,P1,P2] :
                        [P3,P1,P2],

        dc =  no_deg ? d_edge4 :
              is01   ? [d_edge4[1], d_edge4[2], d_edge4[3]] :
              is12   ? [d_edge4[0], d_edge4[2], d_edge4[3]] :
              is23   ? [d_edge4[0], d_edge4[1], d_edge4[3]] :
                        [d_edge4[1], d_edge4[2], d_edge4[0]],

        // Mapping zurück auf 4 Ausgabepositionen
        map_idx = no_deg ? [0,1,2,3] :
                  is01   ? [0,0,1,2] :
                  is12   ? [0,1,1,2] :
                  is23   ? [0,1,2,2] :
                           [0,1,2,0],

        Qc = mb_inset_ngon_edges(Pc, dc),
        Q4 = [ for(i=[0:3]) Qc[ map_idx[i] ] ]
    )
    Q4;


function mb_array_index_of(a, v, i=0) =
    i >= len(a) ? undef :
    a[i] == v ? i :
    mb_array_index_of(a, v, i + 1);

// =========================
// GEOMETRY BASICS
// =========================

function mb_orient2(a, b, c) =
    (b[0] - a[0]) * (c[1] - a[1]) -
    (b[1] - a[1]) * (c[0] - a[0]);

function mb_between(a, b, c, eps = 0.000001) =
    min(a, b) - eps <= c && c <= max(a, b) + eps;

function mb_point_on_segment(a, b, p, eps = 0.000001) =
    abs(mb_orient2(a, b, p)) <= eps &&
    mb_between(a[0], b[0], p[0], eps) &&
    mb_between(a[1], b[1], p[1], eps);

// =========================
// SEGMENT INTERSECTION
// =========================

function mb_segments_intersect(a, b, c, d, eps = 0.000001) =
    let(
        o1 = mb_orient2(a, b, c),
        o2 = mb_orient2(a, b, d),
        o3 = mb_orient2(c, d, a),
        o4 = mb_orient2(c, d, b)
    )
    (
        (o1 * o2 < -eps && o3 * o4 < -eps) ||
        mb_point_on_segment(a, b, c, eps) ||
        mb_point_on_segment(a, b, d, eps) ||
        mb_point_on_segment(c, d, a, eps) ||
        mb_point_on_segment(c, d, b, eps)
    );

// =========================
// POLYGON VALIDATION
// =========================

function mb_edges_adjacent(n, i, j) =
    i == j ||
    (i + 1) % n == j ||
    (j + 1) % n == i;

function mb_poly_self_intersects_pair(p, i, j, eps) =
    let(n = len(p))
    mb_edges_adjacent(n, i, j)
        ? false
        : mb_segments_intersect(
            p[i],
            p[(i + 1) % n],
            p[j],
            p[(j + 1) % n],
            eps
        );

function mb_poly_self_intersects_j(p, i, j, eps) =
    j >= len(p)
        ? false
        : mb_poly_self_intersects_pair(p, i, j, eps)
            ? true
            : mb_poly_self_intersects_j(p, i, j + 1, eps);

function mb_poly_self_intersects_i(p, i = 0, eps = 0.000001) =
    i >= len(p)
        ? false
        : mb_poly_self_intersects_j(p, i, i + 1, eps)
            ? true
            : mb_poly_self_intersects_i(p, i + 1, eps);

function mb_poly_valid_simple(p, eps = 0.000001) =
    len(p) >= 3 && !mb_poly_self_intersects_i(p, 0, eps);

// =========================
// ORIENTATION CHECK
// =========================

function mb_poly_area2(p, i = 0, a = 0) =
    i >= len(p)
        ? a
        : mb_poly_area2(
            p,
            i + 1,
            a + p[i][0] * p[(i + 1) % len(p)][1]
              - p[(i + 1) % len(p)][0] * p[i][1]
        );

function mb_poly_same_orientation(a, b, eps = 0.000001) =
    let(aa = mb_poly_area2(a), bb = mb_poly_area2(b))
        abs(bb) > eps && ((aa > 0 && bb > 0) || (aa < 0 && bb < 0));

// =========================
// VALIDATION COMBINED
// =========================

function mb_inset_ngon_valid(p, q, eps = 0.000001) =
    mb_poly_same_orientation(p, q, eps) &&
    mb_poly_valid_simple(q, eps);

// =========================
// UTILS
// =========================

function mb_scale_array(a, s) =
    [for(v = a) v * s];

// =========================
// SAFE INSET (BINARY SEARCH)
// =========================

function mb_inset_ngon_edges_safe_iter(p, dc, lo, hi, steps, eps) =
    steps <= 0
        ? mb_inset_ngon_edges(p, mb_scale_array(dc, lo))
        : let(
            mid = (lo + hi) / 2,
            q = mb_inset_ngon_edges(p, mb_scale_array(dc, mid)),
            ok = mb_inset_ngon_valid(p, q, eps)
        )
        ok
            ? mb_inset_ngon_edges_safe_iter(p, dc, mid, hi, steps - 1, eps)
            : mb_inset_ngon_edges_safe_iter(p, dc, lo, mid, steps - 1, eps);

function mb_inset_ngon_edges_safe(p, dc, steps = 24, eps = 0.000001) =
    let(q = mb_inset_ngon_edges(p, dc))
        mb_inset_ngon_valid(p, q, eps)
            ? q
            : mb_inset_ngon_edges_safe_iter(p, dc, 0, 1, steps, eps);


function mb_prismoid_plane_expand(pts, p, expand, mul = undef) =
    is_undef(expand) || (expand == [0, 0, 0, 0, 0, 0]) ? pts :
    let(
        sext = mb_qc_resolve(qc = expand, mul = mul, cube = true),
        // 0/1 links, 2/3 hinten, 4/5 rechts, 6/7 vorne
        d_edge8 = [
            -sext[0], -sext[0],
            -sext[3], -sext[3],
            -sext[1], -sext[1],
            -sext[2], -sext[2]
        ],

        // nur vorhandene Punkte behalten
        idx = [ for(i=[0:7]) if(pts[i] != undef) i ],
        Pc  = [ for(i=idx) pts[i] ],

        dc = [ for(i=idx) d_edge8[i] ],

        Qc = len(Pc) >= 3 ? mb_inset_ngon_edges_safe(Pc, dc) : [],

        Q8 = [
            for(i=[0:7])
                let(qqx = Qc[mb_array_index_of(idx, i)])
                pts[i] == undef
                    ? undef
                    : [qqx[0], qqx[1], len(pts[i]) > 2 && !is_undef(pts[i][2]) ? (pts[i][2] + (p == 0 ? -1 : 1) * sext[4+p]) : undef, pts[i][3]]
        ]
    )
    Q8;
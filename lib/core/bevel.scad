// =======================================
// Kreis-in-konvexem-Polygon (3 oder 4 Ecken) – robust
// - touch=false: "innen" mit optionalem Überstand (overhang)
// - touch=true : true, wenn (innen) ODER (Randkontakt/Overlap, inkl. aufgeblasen um overhang)
// =======================================

function mb_circle_in_convex_quad(points, M, r, overhang=0, eps=1e-6, touch=false) =
    let(
        okM = mb_ok_point(M),
        okr = (r != undef) && (r >= 0),
        pts0 = mb_filter_ok_points(points),
        pts1 = mb_strip_consecutive_duplicates(pts0, eps),
        n    = len(pts1),
        oh   = overhang < 0 ? 0 : overhang
    )
    (!okM || !okr || n < 3) ? false
    :
    let(
        dmins = [for (i=[0:n-1]) mb_dist_point_segment(M, pts1[i], pts1[(i+1)%n])],
        dmin  = min(dmins),
        inside_poly = mb_point_in_convex_polygon(M, pts1, eps),
        fully_inside_with_overhang = inside_poly && (dmin + oh >= r - eps),
        touches_with_overhang      = (r >= (dmin - oh) - eps)
    )
    touch ? (fully_inside_with_overhang || touches_with_overhang)
          :  fully_inside_with_overhang;

// ---------------- sanitize helpers ----------------
function mb_filter_ok_points(points) =
    points == undef ? [] : [ for (p = points) if (mb_ok_point(p)) p ];

function mb_strip_consecutive_duplicates(points, eps=1e-6) =
    let(n = len(points))
    (n == 0) ? [] :
    let(p0 = (n>1 && mb_dist(points[0], points[n-1]) <= eps)
                 ? [for (i=[0:n-2]) points[i]] : points,
        m  = len(p0))
    (m == 0) ? [] :
    [ for (i = [0:m-1])
        let(prev = i==0 ? [1e99,1e99] : p0[i-1])
        if (mb_dist(p0[i], prev) > eps) p0[i]
    ];

// ---------------- geometry core ----------------
function mb_point_in_convex_polygon(P, points, eps=1e-6) =
    let(n = len(points))
    let(signs = [for (i=[0:n-1])
        mb_cross2d(points[(i+1)%n] - points[i], P - points[i])])
    (min(signs) >= -eps) || (max(signs) <= eps);

function mb_dist_point_segment(P, A, B) =
    let(AB = B - A, AP = P - A)
    let(den = mb_dot(AB, AB))
    (den == 0)
      ? mb_norm(P - A)
      : let(t = mb_clamp(mb_dot(AP, AB)/den, 0, 1))
        mb_norm(P - (A + t*AB));

// ---------------- tiny utils ----------------
function mb_ok_point(p) = (p!=undef) && is_list(p) && (len(p)>=2)
                          && (p[0]!=undef) && (p[1]!=undef);
function mb_cross2d(a,b) = a[0]*b[1] - a[1]*b[0];
function mb_dot(a,b)     = a[0]*b[0] + a[1]*b[1];
function mb_norm(a)      = sqrt(a[0]*a[0] + a[1]*a[1]);
function mb_clamp(x,lo,hi) = x<lo ? lo : (x>hi ? hi : x);
function mb_dist(a,b)    = mb_norm([a[0]-b[0], a[1]-b[1]]);

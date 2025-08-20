// =======================================
// Kreis-in-konvexem-Viereck (OpenSCAD)
// true, wenn Kreis im Viereck liegt
//   - Mittelpunkt muss im Viereck sein
//   - Kreis darf bis zu 'overhang' überstehen
// =======================================

function mb_circle_in_convex_quad(points, M, r, overhang=0.16, eps=1e-6) =
    let(
        n = len(points),
        oh = overhang < 0 ? 0 : overhang,  // negative Werte ignorieren
        // minimaler Abstand des Mittelpunkts zu den Polygonkanten (als Segmente!)
        dmins = [for (i=[0:n-1]) mb_dist_point_segment(M, points[i], points[(i+1)%n])],
        dmin  = min(dmins),
        inside_poly = mb_point_in_convex_polygon(M, points, eps)
    )
    // Bedingung: Mittelpunkt im Polygon UND
    // Kreis passt mit erlaubtem Überstand
    inside_poly && (dmin + oh >= r - eps);

// ---------------------------------------
// Punkt-in-konvexem-Polygon (Rand zählt als innen)
function mb_point_in_convex_polygon(P, points, eps=1e-6) =
    let(n = len(points))
    let(signs = [for (i=[0:n-1])
        mb_cross2d(points[(i+1)%n] - points[i], P - points[i])])
    (min(signs) >= -eps) || (max(signs) <= eps);

// ---------------------------------------
// Abstand Punkt–Segment (als Strecke!)
function mb_dist_point_segment(P, A, B) =
    let(AB = B - A, AP = P - A)
    let(den = mb_dot(AB, AB))
    (den == 0)
      ? mb_norm(P - A)                // degenerierte Kante
      : let(t = mb_clamp(mb_dot(AP, AB)/den, 0, 1))
        mb_norm(P - (A + t*AB));

// ---------------------------------------
// Helfer
function mb_cross2d(a, b) = a[0]*b[1] - a[1]*b[0];
function mb_dot(a, b)     = a[0]*b[0] + a[1]*b[1];
function mb_norm(a)       = sqrt(a[0]*a[0] + a[1]*a[1]);
function mb_clamp(x, lo, hi) = x < lo ? lo : (x > hi ? hi : x);

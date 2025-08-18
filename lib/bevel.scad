// =======================================
// Kreis-in-konvexem-Viereck (OpenSCAD)
// mit mb_-Prefix
// =======================================

// Hauptfunktion
// points ... 4 Eckpunkte [[x,y], ...] in Reihenfolge (CW oder CCW), konvex!
// M      ... Mittelpunkt [x,y]
// r      ... Radius
// strict ... wenn true: strikt innen (ohne Berührung) -> d > r
// eps    ... Toleranz
function mb_circle_in_convex_quad(points, M, r, strict=false, eps=1e-9) =
    mb_point_in_convex_polygon(M, points, eps) &&
    (strict
      ? mb_all_true([for (i = [0:len(points)-1])
          mb_dist_point_segment(M, points[i], points[(i+1)%len(points)]) >  r + eps])
      : mb_all_true([for (i = [0:len(points)-1])
          mb_dist_point_segment(M, points[i], points[(i+1)%len(points)]) >= r - eps]));

// ---------------------------------------
// Punkt-in-konvexem-Polygon
// Kriterium: Alle Kreuzprodukte haben gleiches Vorzeichen
// (Rand zählt als innen)
function mb_point_in_convex_polygon(P, points, eps=1e-9) =
    let(n = len(points))
    let(signs = [for (i=[0:n-1])
        mb_cross2d(points[(i+1)%n] - points[i], P - points[i])])
    // alle >= -eps ODER alle <= +eps
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
function mb_all_true(lst) = min([for (v=lst) v ? 1 : 0]) == 1;

// ---------------------------------------
// Beispiel (zum Testen)
/*
quad = [[0,0],[10,0],[9,7],[1,8]]; // konvex
M1 = [5,4]; r1 = 2;
M2 = [5,4]; r2 = 3;

echo("M1 in quad? ", mb_circle_in_convex_quad(quad, M1, r1));        // true/false
echo("M2 (strict) in quad? ", mb_circle_in_convex_quad(quad, M2, r2, true)); // erwartbar false
*/

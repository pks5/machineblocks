// =======================================
// Kreis-in-konvexem-Viereck (OpenSCAD)
// Modi:
//   on_border=false -> true, wenn Kreis vollständig im Viereck
//                      (mit erlaubtem Überstand 'overhang')
//   on_border=true  -> true, wenn Kreis Rand berührt/überlappt,
//                      aber NICHT vollständig im Viereck liegt
// =======================================

function mb_circle_in_convex_quad(points, M, r, on_border=false, overhang=0.16, eps=1e-9) =
    let(
        n = len(points),
        oh = overhang < 0 ? 0 : overhang,  // negative Werte ignorieren
        inside_poly = mb_point_in_convex_polygon(M, points, eps),
        dmins = [for (i=[0:n-1]) mb_dist_point_segment(M, points[i], points[(i+1)%n])],
        dmin  = min(dmins),
        // Basis: vollständig drin (Berührung erlaubt)
        fully_inside_base = inside_poly && (dmin >= r - eps),
        // Mit Überstand: dmin + overhang >= r  <=>  (r - dmin) <= overhang
        fully_inside_with_overhang = inside_poly && (dmin + oh >= r - eps),
        // Kontakt/Überschneidung (für Randmodus)
        touches_or_overlaps = (r >= dmin - eps)
    )
    on_border
      ? (touches_or_overlaps && (!fully_inside_base))
      :  fully_inside_with_overhang;

// ---------------------------------------
// Punkt-in-konvexem-Polygon (Rand zählt als innen)
function mb_point_in_convex_polygon(P, points, eps=1e-9) =
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

// ---------------------------------------
// Beispiele
/*
quad = [[0,0],[10,0],[9,7],[1,8]]; // konvex
M = [5,4];

// A) Standard (kein Überstand)
echo("voll drin r=2: ",
     mb_circle_in_convex_quad(quad, M, 2)); // true/false

// B) Mit Überstand: erlaube 0.5 Einheiten
echo("voll drin mit overhang=0.5, r=2.4: ",
     mb_circle_in_convex_quad(quad, M, 2.4, false, 0.5)); // true wenn (r-dmin) <= 0.5

// C) Randmodus: berührt/überlappt, aber nicht vollständig drin
echo("on_border r=3.0: ",
     mb_circle_in_convex_quad(quad, M, 3.0, true)); // true wenn Kontakt/Overlap & nicht voll drin
*/

// =======================================
// Kreis vs. konvexes Viereck (OpenSCAD)
// - on_border=false: "innen" mit optionalem Überstand (overhang)
// - on_border=true : true, wenn Kreis den Rand berührt ODER schneidet
//                    (innen oder außen): r >= d_min - eps
// =======================================

function mb_circle_in_convex_quad(points, M, r, on_border=false, overhang=0, eps=1e-6) =
    let(
        n   = len(points),
        oh  = overhang < 0 ? 0 : overhang,  // negative Werte ignorieren
        // minimaler Abstand des Mittelpunkts zu den Polygonkanten (als Segmente!)
        dmins = [for (i=[0:n-1]) mb_dist_point_segment(M, points[i], points[(i+1)%n])],
        dmin  = min(dmins),

        // Innen-Logik (nur für on_border=false):
        inside_poly = mb_point_in_convex_polygon(M, points, eps),
        // "vollständig drin" mit erlaubtem Überstand:
        // dmin + overhang >= r  <=>  (r - dmin) <= overhang
        fully_inside_with_overhang = inside_poly && (dmin + oh >= r - eps),

        // Randkontakt ODER Überschneidung (innen/außen)
        // genügt r >= dmin (mit Toleranz):
        touches_or_overlaps = (r >= dmin - eps)
    )
    on_border ? touches_or_overlaps
              : fully_inside_with_overhang;


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

// ---------------------------------------
// Beispiele
/*
quad = [[0,0],[10,0],[9,7],[1,8]]; // konvex
M = [5,4];

// A) Innen mit Überstand erlaubt (overhang=0.5)
echo("innen r=2.4, overhang=0.5: ",
     mb_circle_in_convex_quad(quad, M, 2.4, false, 0.5)); // true wenn (r-dmin) <= 0.5

// B) Randberührung innen/außen (auch Schnitt)
echo("on_border r=3.0: ",
     mb_circle_in_convex_quad(quad, M, 3.0, true)); // true wenn r >= dmin
echo("on_border r=0.2: ",
     mb_circle_in_convex_quad(quad, M, 0.2, true)); // false wenn r < dmin (kein Kontakt)
*/

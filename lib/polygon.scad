function approx_eq(a, b, tol=1e-6) = abs(a - b) <= tol;
function vec2_eq(u, v, tol=1e-6) = approx_eq(u[0], v[0], tol) && approx_eq(u[1], v[1], tol);

function contains_pt(acc, p, tol=1e-6, i=0) =
    i >= len(acc) ? false :
    (vec2_eq(acc[i], p, tol) ? true : contains_pt(acc, p, tol, i+1));

function unique_pts(points, tol=1e-6, i=0, acc=[]) =
    i >= len(points) ? acc :
    contains_pt(acc, points[i], tol)
        ? unique_pts(points, tol, i+1, acc)
        : unique_pts(points, tol, i+1, concat(acc, [points[i]]));

// <- hier ist der Fix mit der Comprehension
function dedupe_polygon(points, tol=1e-6) =
    let(up = unique_pts(points, tol))
    (len(up) > 1 && vec2_eq(up[0], up[len(up)-1], tol))
        ? [ for (i = [0 : len(up)-2]) up[i] ]
        : up;

module make_bevel(bevelInnerTol, resultingBaseHeight, tol=1e-6) {
    let(pts = dedupe_polygon(bevelInnerTol, tol))
    
    if (len(pts) >= 3){
        translate([0,0,-0.5 * resultingBaseHeight])
            linear_extrude(height = resultingBaseHeight)
                polygon(points = pts);
        echo (pts = pts);
    }
    else
        echo("Nicht genug eindeutige Punkte für ein Polygon: ", pts);
}

// Beispiel:
// points_demo = [[0,0],[10,0],[10,0],[10,10],[0,10],[0,0],[0,0]];
// make_bevel(points_demo, 5);

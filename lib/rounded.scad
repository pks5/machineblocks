//
// Kreis-in-abgerundetem-Rechteck-Test für OpenSCAD
// rect_pts: [[x1,y1],[x2,y2],[x3,y3],[x4,y4]] (Eckpunkte, achsenparallel, Reihenfolge egal)
// corner_r: [r_bl, r_br, r_tr, r_tl]  (Start unten links im Uhrzeigersinn)
// c:        [cx, cy]  (Mittelpunkt des Kreises)
// r:        Kreisradius
//
// Rückgabe: true/false
//

// --- Hilfsfunktionen mit Prefix ---
function mb_minx(pts) = min([for(p=pts) p[0]]);
function mb_maxx(pts) = max([for(p=pts) p[0]]);
function mb_miny(pts) = min([for(p=pts) p[1]]);
function mb_maxy(pts) = max([for(p=pts) p[1]]);
function mb_clamp(x,a,b) = x<a ? a : (x>b ? b : x);
function mb_hypot(dx,dy) = sqrt(dx*dx + dy*dy);

// Prüft, ob Punkt p in einem abgerundeten Rechteck (achsenparallel) liegt.
// bounds: [xmin, xmax, ymin, ymax]
// rr:     [r_bl, r_br, r_tr, r_tl]
function mb_point_in_rounded_rect(p, bounds, rr) =
    let(
        xmin = bounds[0],
        xmax = bounds[1],
        ymin = bounds[2],
        ymax = bounds[3],
        px = p[0], py = p[1],
        r_bl = rr[0], r_br = rr[1], r_tr = rr[2], r_tl = rr[3]
    )
    // Erst grob: außerhalb des umschreibenden Rechtecks?
    (px < xmin || px > xmax || py < ymin || py > ymax) ? false :

    // Ecke unten links
    (px < xmin + r_bl && py < ymin + r_bl) ?
        (mb_hypot(px - (xmin + r_bl), py - (ymin + r_bl)) <= r_bl) :

    // Ecke unten rechts
    (px > xmax - r_br && py < ymin + r_br) ?
        (mb_hypot(px - (xmax - r_br), py - (ymin + r_br)) <= r_br) :

    // Ecke oben rechts
    (px > xmax - r_tr && py > ymax - r_tr) ?
        (mb_hypot(px - (xmax - r_tr), py - (ymax - r_tr)) <= r_tr) :

    // Ecke oben links
    (px < xmin + r_tl && py > ymax - r_tl) ?
        (mb_hypot(px - (xmin + r_tl), py - (ymax - r_tl)) <= r_tl) :

    // Sonst in den geraden Streifen bzw. im Zentrum
    true;

// Hauptfunktion: Prüft, ob der KREIS komplett innerhalb liegt.
// Dazu erodieren wir das Rounded-Rect um r: Kanten werden um r nach innen verschoben,
// Corner-Radien werden um r reduziert (nicht unter 0).
function mb_circle_in_rounded_rect(rect_pts, corner_r, c, r) =
    let(
        xmin = mb_minx(rect_pts),
        xmax = mb_maxx(rect_pts),
        ymin = mb_miny(rect_pts),
        ymax = mb_maxy(rect_pts),

        // Erosion (Innen-Versatz)
        xmin2 = xmin + r,
        xmax2 = xmax - r,
        ymin2 = ymin + r,
        ymax2 = ymax - r,

        // reduziere Eckenradien
        rr2 = [for (ri = corner_r) max(0, ri - r)]
    )
    // Wenn der Innenbereich degeneriert, kann der Kreis nicht hineinpassen
    (xmin2 > xmax2 || ymin2 > ymax2) ? false :
    mb_point_in_rounded_rect(c, [xmin2, xmax2, ymin2, ymax2], rr2);

// ------------------------
// Beispiel (zum Testen):
// ------------------------
/*
rect = [[0,0], [80,0], [80,40], [0,40]];
cr   = [6, 12, 10, 4];
center = [20, 12];
rad    = 5;

echo(mb_circle_in_rounded_rect(rect, cr, center, rad));  // -> true/false
*/
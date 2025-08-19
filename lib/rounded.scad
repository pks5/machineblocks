//
// Kreis vs. abgerundetes Rechteck (achsenparallel) – mit on_border
// rect_pts: [[x1,y1],[x2,y2],[x3,y3],[x4,y4]]
// corner_r: [r_bl, r_br, r_tr, r_tl]  (Start unten links, im Uhrzeigersinn)
// c:        [cx, cy]
// r:        Kreisradius
// on_border:false -> vollständig innerhalb?
//           true  -> berührt/schneidet und NICHT vollständig innerhalb?
// eps:      Toleranz
//

// --- Helpers (mb_ prefix) ---
function mb_minx(pts) = min([for(p=pts) p[0]]);
function mb_maxx(pts) = max([for(p=pts) p[0]]);
function mb_miny(pts) = min([for(p=pts) p[1]]);
function mb_maxy(pts) = max([for(p=pts) p[1]]);
function mb_hypot(dx,dy) = sqrt(dx*dx + dy*dy);

// Punkt-in-rounded-rect (innen inkl. Rand)
function mb_point_in_rounded_rect(p, bounds, rr) =
    let(
        xmin=bounds[0], xmax=bounds[1], ymin=bounds[2], ymax=bounds[3],
        px=p[0], py=p[1],
        r_bl=rr[0], r_br=rr[1], r_tr=rr[2], r_tl=rr[3]
    )
    (px < xmin || px > xmax || py < ymin || py > ymax) ? false :
    (px < xmin + r_bl && py < ymin + r_bl) ?
        (mb_hypot(px-(xmin+r_bl), py-(ymin+r_bl)) <= r_bl) :
    (px > xmax - r_br && py < ymin + r_br) ?
        (mb_hypot(px-(xmax-r_br), py-(ymin+r_br)) <= r_br) :
    (px > xmax - r_tr && py > ymax - r_tr) ?
        (mb_hypot(px-(xmax-r_tr), py-(ymax-r_tr)) <= r_tr) :
    (px < xmin + r_tl && py > ymax - r_tl) ?
        (mb_hypot(px-(xmin+r_tl), py-(ymax-r_tl)) <= r_tl) :
    true;

// Erosion um r: vollständig-innen-Test
function mb_circle_inside_basic(rect_pts, corner_r, c, r) =
    let(
        xmin=mb_minx(rect_pts), xmax=mb_maxx(rect_pts),
        ymin=mb_miny(rect_pts), ymax=mb_maxy(rect_pts),
        xmin2=xmin+r, xmax2=xmax-r, ymin2=ymin+r, ymax2=ymax-r,
        rr2=[for(ri=corner_r) max(0, ri-r)]
    )
    (xmin2 > xmax2 || ymin2 > ymax2) ? false :
    mb_point_in_rounded_rect(c, [xmin2,xmax2,ymin2,ymax2], rr2);

// Abstand (außen) Mittelpunkt -> Rand (>=0), nur sinnvoll wenn Mittelpunkt außerhalb
function mb_distance_outside_to_rounded_rect(p, bounds, rr) =
    let(
        INF=1e9,
        xmin=bounds[0], xmax=bounds[1], ymin=bounds[2], ymax=bounds[3],
        px=p[0], py=p[1],
        r_bl=rr[0], r_br=rr[1], r_tr=rr[2], r_tl=rr[3],
        xb_min=xmin+r_bl, xb_max=xmax-r_br,
        xt_min=xmin+r_tl, xt_max=xmax-r_tr,
        yl_min=ymin+r_bl, yl_max=ymax-r_tl,
        yr_min=ymin+r_br, yr_max=ymax-r_tr,
        c_bl=[xmin+r_bl, ymin+r_bl],
        c_br=[xmax-r_br, ymin+r_br],
        c_tr=[xmax-r_tr, ymax-r_tr],
        c_tl=[xmin+r_tl, ymax-r_tl]
    )
    min([
        (px >= xb_min && px <= xb_max) ? abs(py - ymin) : INF, // unten
        (px >= xt_min && px <= xt_max) ? abs(py - ymax) : INF, // oben
        (py >= yl_min && py <= yl_max) ? abs(px - xmin) : INF, // links
        (py >= yr_min && py <= yr_max) ? abs(px - xmax) : INF, // rechts
        (px <= xb_min && py <= yl_min) ? (mb_hypot(px-c_bl[0], py-c_bl[1]) - r_bl) : INF,
        (px >= xb_max && py <= yr_min) ? (mb_hypot(px-c_br[0], py-c_br[1]) - r_br) : INF,
        (px >= xt_max && py >= yr_max) ? (mb_hypot(px-c_tr[0], py-c_tr[1]) - r_tr) : INF,
        (px <= xt_min && py >= yl_max) ? (mb_hypot(px-c_tl[0], py-c_tl[1]) - r_tl) : INF
    ]);

// "Clearance" (innen) Mittelpunkt -> Rand (>=0), nur sinnvoll wenn Mittelpunkt innerhalb
function mb_clearance_inside_to_rounded_rect(p, bounds, rr) =
    let(
        INF=1e9,
        xmin=bounds[0], xmax=bounds[1], ymin=bounds[2], ymax=bounds[3],
        px=p[0], py=p[1],
        r_bl=rr[0], r_br=rr[1], r_tr=rr[2], r_tl=rr[3],
        xb_min=xmin+r_bl, xb_max=xmax-r_br,
        xt_min=xmin+r_tl, xt_max=xmax-r_tr,
        yl_min=ymin+r_bl, yl_max=ymax-r_tl,
        yr_min=ymin+r_br, yr_max=ymax-r_tr,
        c_bl=[xmin+r_bl, ymin+r_bl],
        c_br=[xmax-r_br, ymin+r_br],
        c_tr=[xmax-r_tr, ymax-r_tr],
        c_tl=[xmin+r_tl, ymax-r_tl]
    )
    min([
        (px >= xb_min && px <= xb_max) ? (py - ymin) : INF,     // zu unterer Kante
        (px >= xt_min && px <= xt_max) ? (ymax - py) : INF,     // zu oberer Kante
        (py >= yl_min && py <= yl_max) ? (px - xmin) : INF,     // zu linker Kante
        (py >= yr_min && py <= yr_max) ? (xmax - px) : INF,     // zu rechter Kante
        (px < xmin + r_bl && py < ymin + r_bl) ? (r_bl - mb_hypot(px-c_bl[0], py-c_bl[1])) : INF,
        (px > xmax - r_br && py < ymin + r_br) ? (r_br - mb_hypot(px-c_br[0], py-c_br[1])) : INF,
        (px > xmax - r_tr && py > ymax - r_tr) ? (r_tr - mb_hypot(px-c_tr[0], py-c_tr[1])) : INF,
        (px < xmin + r_tl && py > ymax - r_tl) ? (r_tl - mb_hypot(px-c_tl[0], py-c_tl[1])) : INF
    ]);

// --- Hauptfunktion ---
function mb_circle_in_rounded_rect(rect_pts, corner_r, c, r, on_border=false, eps=1e-6) =
    let(
        xmin=mb_minx(rect_pts), xmax=mb_maxx(rect_pts),
        ymin=mb_miny(rect_pts), ymax=mb_maxy(rect_pts),
        bounds=[xmin,xmax,ymin,ymax],

        fully_inside = mb_circle_inside_basic(rect_pts, corner_r, c, r),
        center_inside = mb_point_in_rounded_rect(c, bounds, corner_r),

        d_out = center_inside ? 1e9
              : mb_distance_outside_to_rounded_rect(c, bounds, corner_r),

        clr_in = center_inside ? mb_clearance_inside_to_rounded_rect(c, bounds, corner_r)
                               : 1e9,

        // "berührt/ schneidet" Kriterium:
        // - wenn innen: Kreis berührt/schneidet, sobald r >= clearance (mit Toleranz)
        // - wenn außen: berührt/schneidet, sobald r >= Distanz (mit Toleranz)
        touches_or_intersects = center_inside ? (r + eps >= clr_in)
                                              : (r + eps >= d_out)
    )
    on_border ? (touches_or_intersects && !fully_inside)
              :  fully_inside;

// ------------------------
// Beispiel
// ------------------------
/*
rect = [[0,0], [80,0], [80,40], [0,40]];
cr   = [6, 12, 10, 4];

center_in  = [20,12];  r_in  = 5;    // vollständig innen
center_cut = [10,5];   r_cut = 20;   // schneidet Rand
center_out = [-2,8];   r_out = 3;    // berührt/ schneidet von außen (je nach Setup)

echo("innen:",      mb_circle_in_rounded_rect(rect, cr, center_in,  r_in));               // true
echo("border_in:",  mb_circle_in_rounded_rect(rect, cr, center_cut, r_cut, true));        // true
echo("border_out:", mb_circle_in_rounded_rect(rect, cr, center_out, r_out, true));        // true/false je nach Geometrie
*/
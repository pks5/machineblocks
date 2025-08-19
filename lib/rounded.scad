// --- Helpers ---
function mb_minx(pts) = min([for(p=pts) p[0]]);
function mb_maxx(pts) = max([for(p=pts) p[0]]);
function mb_miny(pts) = min([for(p=pts) p[1]]);
function mb_maxy(pts) = max([for(p=pts) p[1]]);
function mb_hypot(dx,dy) = sqrt(dx*dx + dy*dy);

// Index des Punktes aus rect_pts, der am nächsten zu target=[tx,ty] liegt
function mb_idx_nearest_corner(rect_pts, target) =
    let(d = [for(p=rect_pts) (p[0]-target[0])*(p[0]-target[0]) + (p[1]-target[1])*(p[1]-target[1])],
        m = min(d))
    search(m, d)[0];

// Mapping deiner Reihenfolge (FL,HL,HR,FR) -> geometrisch [BL,BR,TR,TL]
function mb_rr_from_FL_HL_HR_FR(rect_pts, corner_r) =
    let(
        xmin = mb_minx(rect_pts), xmax = mb_maxx(rect_pts),
        ymin = mb_miny(rect_pts), ymax = mb_maxy(rect_pts),
        i_bl = mb_idx_nearest_corner(rect_pts, [xmin, ymin]),
        i_br = mb_idx_nearest_corner(rect_pts, [xmax, ymin]),
        i_tr = mb_idx_nearest_corner(rect_pts, [xmax, ymax]),
        i_tl = mb_idx_nearest_corner(rect_pts, [xmin, ymax])
    )
    [ corner_r[i_bl], corner_r[i_br], corner_r[i_tr], corner_r[i_tl] ];

// Punkt-in-rounded-rect (inkl. Rand)
function mb_point_in_rounded_rect(p, bounds, rr) =
    let(
        xmin=bounds[0], xmax=bounds[1], ymin=bounds[2], ymax=bounds[3],
        px=p[0], py=p[1],
        r_bl=rr[0], r_br=rr[1], r_tr=rr[2], r_tl=rr[3]
    )
    (px < xmin || px > xmax || py < ymin || py > ymax) ? false :
    (px <= xmin + r_bl && py <= ymin + r_bl) ?
        (mb_hypot(px-(xmin+r_bl), py-(ymin+r_bl)) <= r_bl) :
    (px >= xmax - r_br && py <= ymin + r_br) ?
        (mb_hypot(px-(xmax-r_br), py-(ymin+r_br)) <= r_br) :
    (px >= xmax - r_tr && py >= ymax - r_tr) ?
        (mb_hypot(px-(xmax-r_tr), py-(ymax-r_tr)) <= r_tr) :
    (px <= xmin + r_tl && py >= ymax - r_tl) ?
        (mb_hypot(px-(xmin+r_tl), py-(ymax-r_tl)) <= r_tl) :
    true;

// Erosion um r_eff: „vollständig innen?“
function mb_circle_inside_basic(rect_pts, rr_geom, c, r_eff) =
    let(
        xmin=mb_minx(rect_pts), xmax=mb_maxx(rect_pts),
        ymin=mb_miny(rect_pts), ymax=mb_maxy(rect_pts),
        xmin2=xmin+r_eff, xmax2=xmax-r_eff, ymin2=ymin+r_eff, ymax2=ymax-r_eff,
        rr2=[for(ri=rr_geom) max(0, ri - r_eff)]
    )
    (xmin2 > xmax2 || ymin2 > ymax2) ? false :
    mb_point_in_rounded_rect(c, [xmin2,xmax2,ymin2,ymax2], rr2);

// Abstand (außen) Mittelpunkt -> Rand (>=0)
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
        c_tl=[xmin+r_tl, ymax-r_tl],

        d = min([
            (px >= xb_min && px <= xb_max) ? abs(py - ymin) : INF, // unten
            (px >= xt_min && px <= xt_max) ? abs(py - ymax) : INF, // oben
            (py >= yl_min && py <= yl_max) ? abs(px - xmin) : INF, // links
            (py >= yr_min && py <= yr_max) ? abs(px - xmax) : INF, // rechts
            (px <= xb_min && py <= yl_min) ? (mb_hypot(px-c_bl[0], py-c_bl[1]) - r_bl) : INF,
            (px >= xb_max && py <= yr_min) ? (mb_hypot(px-c_br[0], py-c_br[1]) - r_br) : INF,
            (px >= xt_max && py >= yr_max) ? (mb_hypot(px-c_tr[0], py-c_tr[1]) - r_tr) : INF,
            (px <= xt_min && py >= yl_max) ? (mb_hypot(px-c_tl[0], py-c_tl[1]) - r_tl) : INF
        ])
    )
    (d==INF ? 0 : d); // Fallback: niemals INF zurückgeben

// Clearance (innen) Mittelpunkt -> Rand (>=0)
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
        c_tl=[xmin+r_tl, ymax-r_tl],

        clr = min([
            (px >= xb_min && px <= xb_max) ? (py - ymin) : INF,     // unten
            (px >= xt_min && px <= xt_max) ? (ymax - py) : INF,     // oben
            (py >= yl_min && py <= yl_max) ? (px - xmin) : INF,     // links
            (py >= yr_min && py <= yr_max) ? (xmax - px) : INF,     // rechts
            (px <= xmin + r_bl && py <= ymin + r_bl) ? (r_bl - mb_hypot(px-c_bl[0], py-c_bl[1])) : INF,
            (px >= xmax - r_br && py <= ymin + r_br) ? (r_br - mb_hypot(px-c_br[0], py-c_br[1])) : INF,
            (px >= xmax - r_tr && py >= ymax - r_tr) ? (r_tr - mb_hypot(px-c_tr[0], py-c_tr[1])) : INF,
            (px <= xmin + r_tl && py >= ymax - r_tl) ? (r_tl - mb_hypot(px-c_tl[0], py-c_tl[1])) : INF
        ])
    )
    (clr==INF ? 0 : clr); // Fallback: niemals INF zurückgeben

// --- Hauptfunktion ---
// rect_pts & corner_r in [VorneLinks, HintenLinks, HintenRechts, VorneRechts]
// on_border=false: „vollständig innen?“ mit Kulanz tol_inside
// on_border=true : „Rand berührt/geschnitten?“ (unabhängig von tol_inside)
function mb_circle_in_rounded_rect(rect_pts, corner_r_FLHLHRFR, c, r, on_border=false, eps=1e-6, tol_inside=0) =
    let(
        xmin=mb_minx(rect_pts), xmax=mb_maxx(rect_pts),
        ymin=mb_miny(rect_pts), ymax=mb_maxy(rect_pts),
        bounds=[xmin,xmax,ymin,ymax],
        rr = mb_rr_from_FL_HL_HR_FR(rect_pts, corner_r_FLHLHRFR),

        // Innen (für on_border=false) mit Kulanz
        r_eff = max(0, r - tol_inside),
        fully_inside_lenient = mb_circle_inside_basic(rect_pts, rr, c, r_eff),

        // Unsigned Abstand zum Rand (egal ob innen/außen)
        clr_in = mb_clearance_inside_to_rounded_rect(c, bounds, rr),
        d_out  = mb_distance_outside_to_rounded_rect(c, bounds, rr),
        d = min(clr_in, d_out),

        touches_or_intersects = (r + eps >= d)
    )
    on_border ? touches_or_intersects
              : fully_inside_lenient;

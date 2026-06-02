// =========================
// Kreis vollständig in abgerundetem Rechteck?
// rect_pts & corner_r: [VorneLinks, HintenLinks, HintenRechts, VorneRechts]
// =========================

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

// Test „Kreis vollständig innen“ via Erosion um r_eff
function mb_circle_inside_basic(rect_pts, rr_geom, c, r_eff) =
    let(
        xmin=mb_minx(rect_pts), xmax=mb_maxx(rect_pts),
        ymin=mb_miny(rect_pts), ymax=mb_maxy(rect_pts),
        xmin2=xmin+r_eff, xmax2=xmax-r_eff, ymin2=ymin+r_eff, ymax2=ymax-r_eff,
        rr2=[for(ri=rr_geom) max(0, ri - r_eff)]
    )
    (xmin2 > xmax2 || ymin2 > ymax2) ? false :
    mb_point_in_rounded_rect(c, [xmin2,xmax2,ymin2,ymax2], rr2);

// --- Hauptfunktion ---
// true → Kreis liegt vollständig im abgerundeten Rechteck
// overhang: Kulanz nach innen (macht Test „großzügiger“)
function mb_circle_in_rounded_rect(rect_pts, corner_r_FLHLHRFR, c, r, overhang=0) =
    let(
        rr = mb_rr_from_FL_HL_HR_FR(rect_pts, corner_r_FLHLHRFR),
        r_eff = max(0, r - overhang)
    )
    mb_circle_inside_basic(rect_pts, rr, c, r_eff);

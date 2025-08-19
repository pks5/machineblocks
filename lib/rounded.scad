// --- Helpers (unverändert) ---
function mb_minx(pts) = min([for(p=pts) p[0]]);
function mb_maxx(pts) = max([for(p=pts) p[0]]);
function mb_miny(pts) = min([for(p=pts) p[1]]);
function mb_maxy(pts) = max([for(p=pts) p[1]]);
function mb_hypot(dx,dy) = sqrt(dx*dx + dy*dy);

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

function mb_circle_inside_basic(rect_pts, corner_r, c, r_eff) =
    let(
        xmin=mb_minx(rect_pts), xmax=mb_maxx(rect_pts),
        ymin=mb_miny(rect_pts), ymax=mb_maxy(rect_pts),
        xmin2=xmin+r_eff, xmax2=xmax-r_eff, ymin2=ymin+r_eff, ymax2=ymax-r_eff,
        rr2=[for(ri=corner_r) max(0, ri-r_eff)]
    )
    (xmin2 > xmax2 || ymin2 > ymax2) ? false :
    mb_point_in_rounded_rect(c, [xmin2,xmax2,ymin2,ymax2], rr2);

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
        (px >= xb_min && px <= xb_max) ? abs(py - ymin) : INF,
        (px >= xt_min && px <= xt_max) ? abs(py - ymax) : INF,
        (py >= yl_min && py <= yl_max) ? abs(px - xmin) : INF,
        (py >= yr_min && py <= yr_max) ? abs(px - xmax) : INF,
        (px <= xb_min && py <= yl_min) ? (mb_hypot(px-c_bl[0], py-c_bl[1]) - r_bl) : INF,
        (px >= xb_max && py <= yr_min) ? (mb_hypot(px-c_br[0], py-c_br[1]) - r_br) : INF,
        (px >= xt_max && py >= yr_max) ? (mb_hypot(px-c_tr[0], py-c_tr[1]) - r_tr) : INF,
        (px <= xt_min && py >= yl_max) ? (mb_hypot(px-c_tl[0], py-c_tl[1]) - r_tl) : INF
    ]);

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
        (px >= xb_min && px <= xb_max) ? (py - ymin) : INF,
        (px >= xt_min && px <= xt_max) ? (ymax - py) : INF,
        (py >= yl_min && py <= yl_max) ? (px - xmin) : INF,
        (py >= yr_min && py <= yr_max) ? (xmax - px) : INF,
        (px < xmin + r_bl && py < ymin + r_bl) ? (r_bl - mb_hypot(px-c_bl[0], py-c_bl[1])) : INF,
        (px > xmax - r_br && py < ymin + r_br) ? (r_br - mb_hypot(px-c_br[0], py-c_br[1])) : INF,
        (px > xmax - r_tr && py > ymax - r_tr) ? (r_tr - mb_hypot(px-c_tr[0], py-c_tr[1])) : INF,
        (px < xmin + r_tl && py > ymax - r_tl) ? (r_tl - mb_hypot(px-c_tl[0], py-c_tl[1])) : INF
    ]);

// --- Hauptfunktion (fix) ---
// on_border=false: "innen?" mit Kulanz tol_inside
// on_border=true : "berührt/schneidet und NICHT innen?" — innen hier STRIKT (ohne tol_inside)
function mb_circle_in_rounded_rect(rect_pts, corner_r, c, r, on_border=false, eps=1e-6, tol_inside=0.16) =
    let(
        xmin=mb_minx(rect_pts), xmax=mb_maxx(rect_pts),
        ymin=mb_miny(rect_pts), ymax=mb_maxy(rect_pts),
        bounds=[xmin,xmax,ymin,ymax],

        // 1) strenger Innentest (ohne Kulanz) NUR für on_border
        fully_inside_strict = mb_circle_inside_basic(rect_pts, corner_r, c, r),

        // 2) kulanter Innentest (mit tol_inside) NUR für on_border=false
        r_eff = max(0, r - tol_inside),
        fully_inside_lenient = mb_circle_inside_basic(rect_pts, corner_r, c, r_eff),

        center_inside = mb_point_in_rounded_rect(c, bounds, corner_r),
        d_out = center_inside ? 1e9 : mb_distance_outside_to_rounded_rect(c, bounds, corner_r),
        clr_in = center_inside ? mb_clearance_inside_to_rounded_rect(c, bounds, corner_r) : 1e9,

        touches_or_intersects = center_inside ? (r + eps >= clr_in)
                                              : (r + eps >= d_out)
    )
    on_border ? (touches_or_intersects && !fully_inside_strict)
              :  fully_inside_lenient;

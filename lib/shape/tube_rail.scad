use <../core/utils.scad>;
use <../core/quality.scad>;

function _mb_tube_arc_points(cx, cy, rx, ry, a0, a1, segments = 8) =
    [
        for (i = [0:segments])
            let(a = a0 + (a1 - a0) * i / segments)
                [cx + cos(a) * rx, cy + sin(a) * ry]
    ];

function _mb_tube_rr_xy(rr) =
    is_list(rr) ? [max(0, rr[0]), max(0, len(rr) > 1 ? rr[1] : rr[0])]
                : let(r = max(0, is_num(rr) ? rr : 0)) [r, r];

function _mb_tube_scale_rr(rr, mul_x, mul_y) =
    is_list(rr) ? [rr[0] * mul_x, (len(rr) > 1 ? rr[1] : rr[0]) * mul_y]
                : is_num(rr) ? rr * mul_x : 0;

function _mb_tube_rr_max_component(rr) =
    let(xy = _mb_tube_rr_xy(rr))
        max(xy[0], xy[1]);

function _mb_tube_profile_points(
    radius_inner,
    radius_outer,

    start,
    end,

    start_rounding_radius,
    end_rounding_radius,

    clamp_inner_start_thickness,
    clamp_inner_start_height,
    clamp_inner_start_offset,
    clamp_inner_start_rounding_radius,
    
    clamp_inner_end_thickness,
    clamp_inner_end_height,
    clamp_inner_end_offset,
    clamp_inner_end_rounding_radius,

    clamp_outer_start_thickness,
    clamp_outer_start_height,
    clamp_outer_start_offset,
    clamp_outer_start_rounding_radius,
    
    clamp_outer_end_thickness,
    clamp_outer_end_height,
    clamp_outer_end_offset,
    clamp_outer_end_rounding_radius,

    rounding_resolution_edge
) =
    let(
        // radius_inner may be negative (e.g. mb_rail / linear_extrude).
        // mb_tube clamps to >= 0 before calling (rotate_extrude requires x >= 0).
        radius_outer = max(radius_inner, radius_outer),
        ring_thickness = radius_outer - radius_inner,
        max_rr = radius_inner == 0 ? radius_outer : 0.5 * ring_thickness,
        end = max(start, end),
        length = end - start,
        has_inner = radius_inner != 0,

        // Clamp Outer Start
        cbos_offset = min(length, max(0, clamp_outer_start_offset)),
        cbos_height = min(length - cbos_offset, max(0, clamp_outer_start_height)),
        cbos_thickness = clamp_outer_start_thickness < 0 ? sign(clamp_outer_start_thickness) * min(ring_thickness, abs(clamp_outer_start_thickness)) : clamp_outer_start_thickness,
        cbos = cbos_height > 0 && cbos_thickness != 0,
        cbos_rr_raw = _mb_tube_rr_xy(clamp_outer_start_rounding_radius),
        cbos_rx = min(cbos_rr_raw[0], abs(cbos_thickness)),
        cbos_ry = min(cbos_rr_raw[1], cbos_height),
        cbos_round = cbos_rx > 0 && cbos_ry > 0,
        cbos_outer_radius = radius_outer + cbos_thickness,
        cbos_y_start = start + cbos_offset,
        cbos_y_end = cbos_y_start + cbos_height,
        cbos_x_rounding = cbos_outer_radius - sign(clamp_outer_start_thickness) * cbos_rx,
        cbos_y_rounding = cbos_y_start + cbos_ry,

        // Clamp Outer End
        cboe_offset = min(length - cbos_offset - cbos_height, max(0, clamp_outer_end_offset)),
        cboe_height = min(length - cbos_offset - cbos_height - cboe_offset, max(0, clamp_outer_end_height)),
        cboe_thickness = clamp_outer_end_thickness < 0 ? sign(clamp_outer_end_thickness) * min(ring_thickness, abs(clamp_outer_end_thickness)) : clamp_outer_end_thickness,
        cboe = cboe_height > 0 && cboe_thickness != 0,
        cboe_rr_raw = _mb_tube_rr_xy(clamp_outer_end_rounding_radius),
        cboe_rx = min(cboe_rr_raw[0], abs(cboe_thickness)),
        cboe_ry = min(cboe_rr_raw[1], cboe_height),
        cboe_round = cboe_rx > 0 && cboe_ry > 0,
        cboe_outer_radius = radius_outer + cboe_thickness,
        cboe_y_end = end - cboe_offset,
        cboe_y_start = cboe_y_end - cboe_height,
        cboe_x_rounding = cboe_outer_radius - sign(clamp_outer_end_thickness) * cboe_rx,
        cboe_y_rounding = cboe_y_end - cboe_ry,

        // Clamp Inner Start
        cbis_offset = min(length, max(0, clamp_inner_start_offset)),
        cbis_height = min(length - cbis_offset, max(0, clamp_inner_start_height)),
        cbis_thickness = clamp_inner_start_thickness < 0
            ? sign(clamp_inner_start_thickness) * min(ring_thickness, abs(clamp_inner_start_thickness))
            : radius_inner > 0
                ? min(radius_inner, clamp_inner_start_thickness)
                : clamp_inner_start_thickness,
        cbis = has_inner && cbis_height > 0 && cbis_thickness != 0,
        cbis_rr_raw = _mb_tube_rr_xy(clamp_inner_start_rounding_radius),
        cbis_rx = min(cbis_rr_raw[0], abs(cbis_thickness)),
        cbis_ry = min(cbis_rr_raw[1], cbis_height),
        cbis_round = cbis_rx > 0 && cbis_ry > 0,
        cbis_inner_radius = radius_inner - cbis_thickness,
        cbis_y_start = start + cbis_offset,
        cbis_y_end = cbis_y_start + cbis_height,
        cbis_x_rounding = cbis_inner_radius + sign(cbis_thickness) * cbis_rx,
        cbis_y_rounding = cbis_y_start + cbis_ry,

        // Clamp Inner End
        cbie_offset = min(length - cbis_offset - cbis_height, max(0, clamp_inner_end_offset)),
        cbie_height = min(length - cbis_offset - cbis_height - cbie_offset, max(0, clamp_inner_end_height)),
        cbie_thickness = clamp_inner_end_thickness < 0
            ? sign(clamp_inner_end_thickness) * min(ring_thickness, abs(clamp_inner_end_thickness))
            : radius_inner > 0
                ? min(radius_inner, clamp_inner_end_thickness)
                : clamp_inner_end_thickness,
        cbie = has_inner && cbie_height > 0 && cbie_thickness != 0,
        cbie_rr_raw = _mb_tube_rr_xy(clamp_inner_end_rounding_radius),
        cbie_rx = min(cbie_rr_raw[0], abs(cbie_thickness)),
        cbie_ry = min(cbie_rr_raw[1], cbie_height),
        cbie_round = cbie_rx > 0 && cbie_ry > 0,
        cbie_inner_radius = radius_inner - cbie_thickness,
        cbie_y_end = end - cbie_offset,
        cbie_y_start = cbie_y_end - cbie_height,
        cbie_x_rounding = cbie_inner_radius + sign(cbie_thickness) * cbie_rx,
        cbie_y_rounding = cbie_y_end - cbie_ry,

        // Start (number = circle; [rx, ry] = ellipsoid, like clamp rounding)
        s_rr_raw = _mb_tube_rr_xy(start_rounding_radius),
        si_avail_y = cbis ? cbis_offset : cbie ? (length - cbie_offset - cbie_height) : length,
        so_avail_y = cbos ? cbos_offset : cboe ? (length - cboe_offset - cboe_height) : length,
        si_rx = min(s_rr_raw[0], max_rr),
        si_ry = min(s_rr_raw[1], si_avail_y),
        so_rx = min(s_rr_raw[0], max_rr),
        so_ry = min(s_rr_raw[1], so_avail_y),
        si_round = si_rx > 0 && si_ry > 0,
        so_round = so_rx > 0 && so_ry > 0,
        si_x_rounding = radius_inner + si_rx,
        so_x_rounding = radius_outer - so_rx,
        si_y_rounding = start + si_ry,
        so_y_rounding = start + so_ry,

        // End
        e_rr_raw = _mb_tube_rr_xy(end_rounding_radius),
        ei_avail_y = cbie ? cbie_offset : cbis ? (length - cbis_offset - cbis_height) : length,
        eo_avail_y = cboe ? cboe_offset : cbos ? (length - cbos_offset - cbos_height) : length,
        ei_rx = min(e_rr_raw[0], max_rr),
        ei_ry = min(e_rr_raw[1], ei_avail_y),
        eo_rx = min(e_rr_raw[0], max_rr),
        eo_ry = min(e_rr_raw[1], eo_avail_y),
        ei_round = ei_rx > 0 && ei_ry > 0,
        eo_round = eo_rx > 0 && eo_ry > 0,
        ei_x_rounding = radius_inner + ei_rx,
        eo_x_rounding = radius_outer - eo_rx,
        ei_y_rounding = end - ei_ry,
        eo_y_rounding = end - eo_ry
    )
    concat(
        // Start Inner
        cbis && cbis_offset == 0 ? [] : concat(
            si_round && has_inner ? concat(
                [
                    [radius_inner, si_y_rounding]
                ],
                _mb_tube_arc_points(
                    cx = si_x_rounding,
                    cy = si_y_rounding,
                    rx = si_rx,
                    ry = si_ry,
                    a0 = -90,
                    a1 = -180,
                    segments = rounding_resolution_edge
                )
            ) : [],
            [
                [si_round && has_inner ? si_x_rounding : radius_inner, start]
            ]
        ),

        // Start Outer
        cbos && cbos_offset == 0 ? [] : concat(
            [
                [so_round ? so_x_rounding : radius_outer, start],
            ],
            so_round ? concat(
                _mb_tube_arc_points(
                    cx = so_x_rounding,
                    cy = so_y_rounding,
                    rx = so_rx,
                    ry = so_ry,
                    a0 = -90,
                    a1 = 0,
                    segments = rounding_resolution_edge
                ),
                [
                    [radius_outer, so_y_rounding]
                ]
            ) : []
        ),

        // Clamp Outer Start
        cbos ? concat(
            cbos_offset == 0 ? [] : [
                [radius_outer, cbos_y_start]
            ],
            [
                [cbos_round ? cbos_x_rounding : cbos_outer_radius, cbos_y_start],
            ],
            cbos_round ? _mb_tube_arc_points(
                cx = cbos_x_rounding,
                cy = cbos_y_rounding,
                rx = cbos_rx,
                ry = cbos_ry,
                a0 = -90,
                a1 = cbos_thickness < 0 ? -180 : 0,
                segments = rounding_resolution_edge
            ) : [],
            [
                [cbos_outer_radius, cbos_y_end],
                [radius_outer, cbos_y_end]
            ]
        ) : [],

        // Clamp Outer End
        cboe ? concat(
            [
                [radius_outer, cboe_y_start],
                [cboe_outer_radius, cboe_y_start],
                [cboe_outer_radius, cboe_round ? cboe_y_rounding : cboe_y_end]
            ],
            cboe_round ? _mb_tube_arc_points(
                cx = cboe_x_rounding,
                cy = cboe_y_rounding,
                rx = cboe_rx,
                ry = cboe_ry,
                a0 = cboe_thickness < 0 ? 180 : 0,
                a1 = 90,
                segments = rounding_resolution_edge
            ) : [],
            cboe_offset == 0 ? [] : [
                [radius_outer, cboe_y_end]
            ]
        ) : [],

        // End Outer
        cboe && cboe_offset == 0 ? [] : concat(
            eo_round ? concat(
                [
                    [radius_outer, eo_y_rounding],
                ],
                _mb_tube_arc_points(
                    cx = eo_x_rounding,
                    cy = eo_y_rounding,
                    rx = eo_rx,
                    ry = eo_ry,
                    a0 = 0,
                    a1 = 90,
                    segments = rounding_resolution_edge
                )
            ) : [],
            [
                [eo_round ? eo_x_rounding : radius_outer, end]
            ]
        ),

        // End Inner
        cbie && cbie_offset == 0 ? [] : concat(
            ei_round && has_inner ? concat(
                [
                    [ei_x_rounding, end]
                ],
                _mb_tube_arc_points(
                    cx = ei_x_rounding,
                    cy = ei_y_rounding,
                    rx = ei_rx,
                    ry = ei_ry,
                    a0 = 180,
                    a1 = 90,
                    segments = rounding_resolution_edge
                )
            ) : [],
            [
                [radius_inner, ei_round && has_inner ? ei_y_rounding : end]
            ]
        ),

        // Clamp Inner End (walk end→start; structure like Clamp Outer Start)
        cbie ? concat(
            cbie_offset == 0 ? [] : [
                [radius_inner, cbie_y_end]
            ],
            [
                [cbie_round ? cbie_x_rounding : cbie_inner_radius, cbie_y_end],
            ],
            cbie_round ? _mb_tube_arc_points(
                cx = cbie_x_rounding,
                cy = cbie_y_rounding,
                rx = cbie_rx,
                ry = cbie_ry,
                a0 = 90,
                a1 = cbie_thickness < 0 ? 0 : 180,
                segments = rounding_resolution_edge
            ) : [],
            [
                [cbie_inner_radius, cbie_y_start],
                [radius_inner, cbie_y_start]
            ]
        ) : [],

        // Clamp Inner Start (walk end→start; structure like Clamp Outer End)
        cbis ? concat(
            [
                [radius_inner, cbis_y_end],
                [cbis_inner_radius, cbis_y_end],
                [cbis_inner_radius, cbis_round ? cbis_y_rounding : cbis_y_start]
            ],
            cbis_round ? _mb_tube_arc_points(
                cx = cbis_x_rounding,
                cy = cbis_y_rounding,
                rx = cbis_rx,
                ry = cbis_ry,
                a0 = cbis_thickness < 0 ? 0 : 180,
                a1 = cbis_thickness < 0 ? -90 : 270,
                segments = rounding_resolution_edge
            ) : [],
            cbis_offset == 0 ? [] : [
                [radius_inner, cbis_y_start]
            ]
        ) : []
    );

module mb_tube(
    radius,
    length,
    rounding_radius = undef,

    clamp_inner_start = undef,
    clamp_inner_end = undef,
    
    clamp_outer_start = undef,
    clamp_outer_end = undef,

    axis = "z",
    offset = undef,
    mul = undef,
    
    quality_class_tube = "functional",
    quality_class_edge = "visual",

    quality = "normal",

    q_profile = undef,
    q_class_factors = undef,
    q_class_min_segments = undef,
    q_segment_multiplier = undef,
    q_preview_quality = undef,
    q_preview_max_mult = undef,

    color = "white",
    draw_together = false,
    debug = false
) {
    axis = mb_axis_to_int(axis);
    offset = mb_resolve_xyz(offset, default = [0, 0, 0]);
    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);
    mul_radius = mul[0];
    mul_length = mul[axis];

    start = (is_list(length) ? length[0] : is_num(length) ? -0.5 * length : 0) * mul_length; 
    end = (is_list(length) ? length[1] : is_num(length) ? 0.5 * length : 0) * mul_length;

    radius_inner = max(0, (is_list(radius) && len(radius) > 1 ? radius[0] : 0) * mul_radius);
    radius_outer = (is_list(radius) && len(radius) > 0 ? (len(radius) > 1 ? radius[1] : radius[0]) : radius) * mul_radius; 

    start_rounding_radius = _mb_tube_scale_rr(
        is_list(rounding_radius) ? rounding_radius[0] : is_num(rounding_radius) ? rounding_radius : 0,
        mul_radius,
        mul_length
    );
    end_rounding_radius = _mb_tube_scale_rr(
        is_list(rounding_radius) ? rounding_radius[1] : is_num(rounding_radius) ? rounding_radius : 0,
        mul_radius,
        mul_length
    );
    
    if((end - start) > 0 && (radius_outer - radius_inner) > 0){
        rot = mb_axis_rotate(axis);

        clamp_inner_start_thickness = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[0]) ? 0 : clamp_inner_start[0] * mul_radius;
        clamp_inner_start_height = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[1]) ? 0 : clamp_inner_start[1] * mul_length;
        clamp_inner_start_offset = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[2]) ? 0 : clamp_inner_start[2] * mul_length;
        clamp_inner_start_rounding_radius = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[3])
            ? 0
            : _mb_tube_scale_rr(clamp_inner_start[3], mul_radius, mul_length);

        clamp_inner_end_thickness = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[0]) ? 0 : clamp_inner_end[0] * mul_radius;
        clamp_inner_end_height = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[1]) ? 0 : clamp_inner_end[1] * mul_length;
        clamp_inner_end_offset = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[2]) ? 0 : clamp_inner_end[2] * mul_length;
        clamp_inner_end_rounding_radius = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[3])
            ? 0
            : _mb_tube_scale_rr(clamp_inner_end[3], mul_radius, mul_length);

        clamp_outer_start_thickness = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[0]) ? 0 : clamp_outer_start[0] * mul_radius;
        clamp_outer_start_height = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[1]) ? 0 : clamp_outer_start[1] * mul_length;
        clamp_outer_start_offset = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[2]) ? 0 : clamp_outer_start[2] * mul_length;
        clamp_outer_start_rounding_radius = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[3])
            ? 0
            : _mb_tube_scale_rr(clamp_outer_start[3], mul_radius, mul_length);

        clamp_outer_end_thickness = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[0]) ? 0 : clamp_outer_end[0] * mul_radius;
        clamp_outer_end_height = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[1]) ? 0 : clamp_outer_end[1] * mul_length;
        clamp_outer_end_offset = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[2]) ? 0 : clamp_outer_end[2] * mul_length;
        clamp_outer_end_rounding_radius = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[3])
            ? 0
            : _mb_tube_scale_rr(clamp_outer_end[3], mul_radius, mul_length);

        rounding_resolution_tube = mb_q_fn_even_for_radius(
            r = radius_outer,
            q = quality_class_tube,
            preset = quality,
            profile = q_profile,
            class_factors = q_class_factors,
            class_min_segments = q_class_min_segments,
            segment_multiplier = q_segment_multiplier,
            preview_quality = q_preview_quality,
            preview_max_mult = q_preview_max_mult
        );

        rounding_resolution_edge = mb_q_fn_even_for_radius(
            r = max(
                _mb_tube_rr_max_component(start_rounding_radius),
                _mb_tube_rr_max_component(end_rounding_radius),
                _mb_tube_rr_max_component(clamp_inner_start_rounding_radius),
                _mb_tube_rr_max_component(clamp_inner_end_rounding_radius),
                _mb_tube_rr_max_component(clamp_outer_start_rounding_radius),
                _mb_tube_rr_max_component(clamp_outer_end_rounding_radius)
            ),
            q = quality_class_edge,
            preset = quality,
            profile = q_profile,
            class_factors = q_class_factors,
            class_min_segments = q_class_min_segments,
            segment_multiplier = q_segment_multiplier,
            preview_quality = q_preview_quality,
            preview_max_mult = q_preview_max_mult
        );

        is_cylinder = radius_inner == 0 && 
            _mb_tube_rr_max_component(start_rounding_radius) == 0 && 
            _mb_tube_rr_max_component(end_rounding_radius) == 0 &&
            (clamp_inner_start_thickness == 0 || clamp_inner_start_height == 0) &&
            (clamp_inner_end_thickness == 0 || clamp_inner_end_height == 0) &&
            (clamp_outer_start_thickness == 0 || clamp_outer_start_height == 0) &&
            (clamp_outer_end_thickness == 0 || clamp_outer_end_height == 0);

        translate([offset[0] * mul[0], offset[1] * mul[1], offset[2] * mul[2]])
            rotate(rot){
                if(is_cylinder || draw_together){
                    color(draw_together || debug ? "green" : color)
                        translate([0, 0, 0.5 * (start + end)])
                            cylinder(r = radius_outer, h = (end - start), center = true, $fn = rounding_resolution_tube);
                }

                if(!is_cylinder || draw_together){
                    color(draw_together || debug ? "yellow" : color)
                        rotate_extrude(convexity = 10, $fn = rounding_resolution_tube)
                            polygon(points = _mb_tube_profile_points(
                                radius_inner = radius_inner,
                                radius_outer = radius_outer,
                                
                                start = start, 
                                end = end,
                            
                                start_rounding_radius = start_rounding_radius,
                                end_rounding_radius = end_rounding_radius,

                                clamp_inner_start_thickness = clamp_inner_start_thickness,
                                clamp_inner_start_height = clamp_inner_start_height,
                                clamp_inner_start_offset = clamp_inner_start_offset,
                                clamp_inner_start_rounding_radius = clamp_inner_start_rounding_radius,
                                
                                clamp_inner_end_thickness = clamp_inner_end_thickness,
                                clamp_inner_end_height = clamp_inner_end_height,
                                clamp_inner_end_offset = clamp_inner_end_offset,
                                clamp_inner_end_rounding_radius = clamp_inner_end_rounding_radius,

                                clamp_outer_start_thickness = clamp_outer_start_thickness,
                                clamp_outer_start_height = clamp_outer_start_height,
                                clamp_outer_start_offset = clamp_outer_start_offset,
                                clamp_outer_start_rounding_radius = clamp_outer_start_rounding_radius,
                                
                                clamp_outer_end_thickness = clamp_outer_end_thickness,
                                clamp_outer_end_height = clamp_outer_end_height,
                                clamp_outer_end_offset = clamp_outer_end_offset,
                                clamp_outer_end_rounding_radius = clamp_outer_end_rounding_radius,

                                rounding_resolution_edge = rounding_resolution_edge
                            ));
                }
            }
    }
}   

module mb_rail(
    size, 
    rounding_radius = undef,

    clamp_inner_start = undef,
    clamp_inner_end = undef,
    
    clamp_outer_start = undef,
    clamp_outer_end = undef,

    axis = "z",
    offset = undef,
    mul = undef,
    
    quality_class_tube = "functional",
    quality_class_edge = "visual",

    quality = "normal",

    q_profile = undef,
    q_class_factors = undef,
    q_class_min_segments = undef,
    q_segment_multiplier = undef,
    q_preview_quality = undef,
    q_preview_max_mult = undef,

    color = "white",
    draw_together = false,
    debug = false
) {
    axis = mb_axis_to_int(axis);
    size =  mb_cube_size_resolve(size);
    offset = mb_resolve_xyz(offset, default = [0, 0, 0]);
    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);

    dim = [
            size[1][0] - size[0][0], 
            size[1][1] - size[0][1],
            size[1][2] - size[0][2]
        ];

    tr = [
        0.5 * (size[0][0] + size[1][0]),
        0.5 * (size[0][1] + size[1][1]),
        0.5 * (size[0][2] + size[1][2])
    ];

    si = [
        dim[0] * mul[0], 
        dim[1] * mul[1], 
        dim[2] * mul[2]
    ];

    sid = axis == 0 ? 
            [
                si[2],
                si[1],
                si[0]   
            ] : 
            axis == 1 ?
            [
                si[0],
                si[2],
                si[1]    
            ] : 
            
            si;

    start = -0.5 * sid[1]; 
    end = 0.5 * sid[1];

    radius_inner = -0.5 * sid[0];
    radius_outer = 0.5 * sid[0]; 

    clamp_mul_height = axis == 0 ? mul[1] : axis == 1 ? mul[2] : mul[0];
    clamp_mul_thickness = axis == 0 ? mul[2] : axis == 1 ? mul[0] : mul[0];

    start_rounding_radius = _mb_tube_scale_rr(
        is_list(rounding_radius) ? rounding_radius[0] : is_num(rounding_radius) ? rounding_radius : 0,
        clamp_mul_thickness,
        clamp_mul_height
    );
    end_rounding_radius = _mb_tube_scale_rr(
        is_list(rounding_radius) ? rounding_radius[1] : is_num(rounding_radius) ? rounding_radius : 0,
        clamp_mul_thickness,
        clamp_mul_height
    );
    
    if((end - start) > 0 && (radius_outer - radius_inner) > 0){
        rot = mb_axis_rotate(axis);

        

        clamp_inner_start_thickness = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[0]) ? 0 : clamp_inner_start[0] * clamp_mul_thickness;
        clamp_inner_start_height = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[1]) ? 0 : clamp_inner_start[1] * clamp_mul_height;
        clamp_inner_start_offset = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[2]) ? 0 : clamp_inner_start[2] * clamp_mul_height;
        clamp_inner_start_rounding_radius = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[3])
            ? 0
            : _mb_tube_scale_rr(clamp_inner_start[3], clamp_mul_thickness, clamp_mul_height);

        clamp_inner_end_thickness = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[0]) ? 0 : clamp_inner_end[0] * clamp_mul_thickness;
        clamp_inner_end_height = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[1]) ? 0 : clamp_inner_end[1] * clamp_mul_height;
        clamp_inner_end_offset = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[2]) ? 0 : clamp_inner_end[2] * clamp_mul_height;
        clamp_inner_end_rounding_radius = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[3])
            ? 0
            : _mb_tube_scale_rr(clamp_inner_end[3], clamp_mul_thickness, clamp_mul_height);

        clamp_outer_start_thickness = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[0]) ? 0 : clamp_outer_start[0] * clamp_mul_thickness;
        clamp_outer_start_height = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[1]) ? 0 : clamp_outer_start[1] * clamp_mul_height;
        clamp_outer_start_offset = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[2]) ? 0 : clamp_outer_start[2] * clamp_mul_height;
        clamp_outer_start_rounding_radius = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[3])
            ? 0
            : _mb_tube_scale_rr(clamp_outer_start[3], clamp_mul_thickness, clamp_mul_height);

        clamp_outer_end_thickness = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[0]) ? 0 : clamp_outer_end[0] * clamp_mul_thickness;
        clamp_outer_end_height = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[1]) ? 0 : clamp_outer_end[1] * clamp_mul_height;
        clamp_outer_end_offset = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[2]) ? 0 : clamp_outer_end[2] * clamp_mul_height;
        clamp_outer_end_rounding_radius = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[3])
            ? 0
            : _mb_tube_scale_rr(clamp_outer_end[3], clamp_mul_thickness, clamp_mul_height);

        rounding_resolution_tube = mb_q_fn_even_for_radius(
            r = radius_outer,
            q = quality_class_tube,
            preset = quality,
            profile = q_profile,
            class_factors = q_class_factors,
            class_min_segments = q_class_min_segments,
            segment_multiplier = q_segment_multiplier,
            preview_quality = q_preview_quality,
            preview_max_mult = q_preview_max_mult
        );

        rounding_resolution_edge = mb_q_fn_even_for_radius(
            r = max(
                _mb_tube_rr_max_component(start_rounding_radius),
                _mb_tube_rr_max_component(end_rounding_radius),
                _mb_tube_rr_max_component(clamp_inner_start_rounding_radius),
                _mb_tube_rr_max_component(clamp_inner_end_rounding_radius),
                _mb_tube_rr_max_component(clamp_outer_start_rounding_radius),
                _mb_tube_rr_max_component(clamp_outer_end_rounding_radius)
            ),
            q = quality_class_edge,
            preset = quality,
            profile = q_profile,
            class_factors = q_class_factors,
            class_min_segments = q_class_min_segments,
            segment_multiplier = q_segment_multiplier,
            preview_quality = q_preview_quality,
            preview_max_mult = q_preview_max_mult
        );

        is_cube = radius_inner == 0 && 
            _mb_tube_rr_max_component(start_rounding_radius) == 0 && 
            _mb_tube_rr_max_component(end_rounding_radius) == 0 &&
            (clamp_inner_start_thickness == 0 || clamp_inner_start_height == 0) &&
            (clamp_inner_end_thickness == 0 || clamp_inner_end_height == 0) &&
            (clamp_outer_start_thickness == 0 || clamp_outer_start_height == 0) &&
            (clamp_outer_end_thickness == 0 || clamp_outer_end_height == 0);

        translate([
            (tr[0] + offset[0]) * mul[0],  // + axis == 2 ? 0.5 * (max(clamp_inner_start_thickness, clamp_inner_end_thickness) + max(clamp_outer_start_thickness, clamp_outer_end_thickness)) : 0
            (tr[1] + offset[1]) * mul[1], 
            (tr[2] + offset[2]) * mul[2]
        ])
            rotate(rot){
                if(is_cube || draw_together){
                    color(draw_together || debug ? "green" : color)
                        cube(size = sid, center = true);
                }

                if(!is_cube || draw_together){
                    color(draw_together || debug ? "yellow" : color)
                        linear_extrude(convexity = 10, height = sid[2], center = true)
                            polygon(points = _mb_tube_profile_points(
                                radius_inner = radius_inner,
                                radius_outer = radius_outer,
                                

                                start = start, 
                                end = end,
                            
                                start_rounding_radius = start_rounding_radius,
                                end_rounding_radius = end_rounding_radius,

                                clamp_inner_start_thickness = clamp_inner_start_thickness,
                                clamp_inner_start_height = clamp_inner_start_height,
                                clamp_inner_start_offset = clamp_inner_start_offset,
                                clamp_inner_start_rounding_radius = clamp_inner_start_rounding_radius,
                                
                                clamp_inner_end_thickness = clamp_inner_end_thickness,
                                clamp_inner_end_height = clamp_inner_end_height,
                                clamp_inner_end_offset = clamp_inner_end_offset,
                                clamp_inner_end_rounding_radius = clamp_inner_end_rounding_radius,

                                clamp_outer_start_thickness = clamp_outer_start_thickness,
                                clamp_outer_start_height = clamp_outer_start_height,
                                clamp_outer_start_offset = clamp_outer_start_offset,
                                clamp_outer_start_rounding_radius = clamp_outer_start_rounding_radius,
                                
                                clamp_outer_end_thickness = clamp_outer_end_thickness,
                                clamp_outer_end_height = clamp_outer_end_height,
                                clamp_outer_end_offset = clamp_outer_end_offset,
                                clamp_outer_end_rounding_radius = clamp_outer_end_rounding_radius,

                                rounding_resolution_edge = rounding_resolution_edge
                            ));
                }
            }
    }
}   
/*
* --------------
* START EXAMPLES
* --------------
*/

mb_rail(
    size = [[0,0,0], [1.8, 4.8, 3]],
    
    rounding_radius = [[0.9, 0.2], [0.9, 0.2]],
    axis = "z",
    offset = undef,
    mul = [8, 8, 3.2],

    clamp_inner_start = [1.5, 0.9, 1.5, [0.2, 0.9]],
    clamp_inner_end = [1.5, 0.9, 1.5, [0.2, 0.9]],
    
    clamp_outer_start = [1.5, 0.9, 1.5, [0.2, 0.9]],
    clamp_outer_end = [1.5, 0.9, 1.5, [0.2, 0.9]],
    
    draw_together = false,
    debug = true
);



use <../core/utils.scad>;
use <../core/quality.scad>;

function _mb_tube_arc_points(cx, cy, r, a0, a1, segments = 8) =
    [
        for (i = [0:segments])
            let(a = a0 + (a1 - a0) * i / segments)
                [cx + cos(a) * r, cy + sin(a) * r]
    ];

function _mb_tube_profile_points(
    start,
    start_rounding_radius,

    end,
    end_rounding_radius,

    radius_inner,
    radius_outer,

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
        radius_inner = max(0, radius_inner),
        radius_outer = max(radius_inner, radius_outer),
        ring_thickness = radius_outer - radius_inner,
        max_rr = radius_inner > 0 ? 0.5 * ring_thickness : radius_outer,
        end = max(start, end),
        length = end - start,

        // Clamp Outer Start
        cbos_offset = min(length, max(0, clamp_outer_start_offset)),
        cbos_height = min(length - cbos_offset, max(0, clamp_outer_start_height)),
        cbos_thickness = clamp_outer_start_thickness < 0 ? sign(clamp_outer_start_thickness) * min(ring_thickness, abs(clamp_outer_start_thickness)) : clamp_outer_start_thickness,
        cbos = cbos_height > 0 && cbos_thickness != 0,
        cbos_rr = min(max(0, clamp_outer_start_rounding_radius), abs(cbos_thickness), cbos_height),
        cbos_outer_radius = radius_outer + cbos_thickness,
        cbos_y_start = start + cbos_offset,
        cbos_y_end = cbos_y_start + cbos_height,
        cbos_x_rounding = cbos_outer_radius - sign(clamp_outer_start_thickness) * cbos_rr,
        cbos_y_rounding = cbos_y_start + cbos_rr,
        
        
        // Clamp Outer End
        cboe_offset = min(length - cbos_offset - cbos_height, max(0, clamp_outer_end_offset)),
        cboe_height = min(length - cbos_offset - cbos_height - cboe_offset, max(0, clamp_outer_end_height)),
        cboe_thickness = clamp_outer_end_thickness < 0 ? sign(clamp_outer_end_thickness) * min(ring_thickness, abs(clamp_outer_end_thickness)) : clamp_outer_end_thickness,
        cboe = cboe_height > 0 && cboe_thickness != 0,
        cboe_rr = min(max(0, clamp_outer_end_rounding_radius), abs(cboe_thickness), cboe_height),
        cboe_outer_radius = radius_outer + cboe_thickness,
        cboe_y_end = end - cboe_offset,
        cboe_y_start = cboe_y_end - cboe_height,
        cboe_x_rounding = cboe_outer_radius - sign(clamp_outer_end_thickness) * cboe_rr,
        cboe_y_rounding = cboe_y_end - cboe_rr,
        
        
        // Start
        si_rr = min(max(0, start_rounding_radius), max_rr, length),
        so_rr = min(max(0, start_rounding_radius), max_rr, cbos ? cbos_offset : cboe ? (length - cboe_offset - cboe_height) : length),
        si_x_rounding = radius_inner + si_rr,
        so_x_rounding = radius_outer - so_rr,
        si_y_rounding = start + si_rr,
        so_y_rounding = start + so_rr,

        // End
        ei_rr = min(max(0, end_rounding_radius), max_rr, length),
        
        eo_rr = min(max(0, end_rounding_radius), max_rr, cboe ? cboe_offset : cbos ? (length - cbos_offset - cbos_height) : length),
        ei_x_rounding = radius_inner + ei_rr,
        eo_x_rounding = radius_outer - eo_rr,
        ei_y_rounding = end - ei_rr,
        eo_y_rounding = end - eo_rr,
        
    )
    concat(
        // Start Inner
        concat(
            si_rr > 0 && radius_inner > 0 ? concat(
                [
                    [radius_inner, si_y_rounding]
                ],
                _mb_tube_arc_points(
                    cx = si_x_rounding,
                    cy = si_y_rounding,
                    r = si_rr,
                    a0 = -90,
                    a1 = -180,
                    segments = rounding_resolution_edge
                )
                
            ) : [],
            [
                [si_rr > 0 && radius_inner > 0 ? si_x_rounding : radius_inner, start]
            ]
            
        ),
        

        // Start Outer
        cbos && cbos_offset == 0 ? [] : concat(
            [
                [so_rr > 0 ? so_x_rounding : radius_outer, start],
            ],
            so_rr > 0 ? concat(
                _mb_tube_arc_points(
                    cx = so_x_rounding,
                    cy = so_y_rounding,
                    r = so_rr,
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
                [cbos_rr > 0 ? cbos_x_rounding : cbos_outer_radius, cbos_y_start],
            ],
            cbos_rr > 0 ? _mb_tube_arc_points(
                cx = cbos_x_rounding,
                cy = cbos_y_rounding,
                r = cbos_rr,
                a0 = cbos_thickness < 0 ? -90 : -90,
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
                
                [cboe_outer_radius, cboe_rr > 0 ? cboe_y_rounding : cboe_y_end]
            ],
            cboe_rr > 0 ?_mb_tube_arc_points(
                cx = cboe_x_rounding,
                cy = cboe_y_rounding,
                r = cboe_rr,
                a0 = cboe_thickness < 0 ? 180 : 0,
                a1 = cboe_thickness < 0 ? 90 : 90,
                segments = rounding_resolution_edge
            ) : [],
            cboe_offset == 0 ? [] : [
                [radius_outer, cboe_y_end]
            ]
        ) : [],

        // End Outer
        cboe && cboe_offset == 0 ? [] : concat(
            eo_rr > 0 ? concat(
                [
                    [radius_outer, eo_y_rounding],
                ],
                _mb_tube_arc_points(
                    cx = eo_x_rounding,
                    cy = eo_y_rounding,
                    r = eo_rr,
                    a0 = 0,
                    a1 = 90,
                    segments = rounding_resolution_edge
                )
            ) : [],
            [
                [eo_rr > 0 ? eo_x_rounding : radius_outer, end]
            ]
        ),

        // End Inner
        concat(
            ei_rr > 0 && radius_inner > 0 ? concat(
                [
                    [ei_x_rounding, end]
                ],
                _mb_tube_arc_points(
                    cx = ei_x_rounding,
                    cy = ei_y_rounding,
                    r = ei_rr,
                    a0 = 180,
                    a1 = 90,
                    segments = rounding_resolution_edge
                )
                
                
            ) : [],
            [
                [radius_inner, ei_rr > 0 && radius_inner > 0 ? ei_y_rounding : end]
            ]
            
        )
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
    
    rounding_resolution_tube = 64,
    rounding_resolution_edge = 8,

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

    radius_inner = (is_list(radius) && len(radius) > 1 ? radius[0] : 0) * mul_radius;
    radius_outer = (is_list(radius) && len(radius) > 0 ? (len(radius) > 1 ? radius[1] : radius[0]) : radius) * mul_radius; 

    start_rounding_radius = (is_list(rounding_radius) ? rounding_radius[0] : is_num(rounding_radius) ? rounding_radius : 0) * mul_radius;
    end_rounding_radius = (is_list(rounding_radius) ? rounding_radius[1] : is_num(rounding_radius) ? rounding_radius : 0) * mul_radius;
    
    if((end - start) > 0 && (radius_outer - radius_inner) > 0){
        rot = mb_axis_rotate(axis);

        clamp_inner_start_thickness = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[0]) ? 0 : clamp_inner_start[0] * mul_radius;
        clamp_inner_start_height = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[1]) ? 0 : clamp_inner_start[1] * mul_length;
        clamp_inner_start_offset = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[2]) ? 0 : clamp_inner_start[2] * mul_length;
        clamp_inner_start_rounding_radius = !is_list(clamp_inner_start) || is_undef(clamp_inner_start[3]) ? 0 : clamp_inner_start[3] * mul_radius;

        clamp_inner_end_thickness = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[0]) ? 0 : clamp_inner_end[0] * mul_radius;
        clamp_inner_end_height = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[1]) ? 0 : clamp_inner_end[1] * mul_length;
        clamp_inner_end_offset = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[2]) ? 0 : clamp_inner_end[2] * mul_length;
        clamp_inner_end_rounding_radius = !is_list(clamp_inner_end) || is_undef(clamp_inner_end[3]) ? 0 : clamp_inner_end[3] * mul_radius;

        clamp_outer_start_thickness = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[0]) ? 0 : clamp_outer_start[0] * mul_radius;
        clamp_outer_start_height = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[1]) ? 0 : clamp_outer_start[1] * mul_length;
        clamp_outer_start_offset = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[2]) ? 0 : clamp_outer_start[2] * mul_length;
        clamp_outer_start_rounding_radius = !is_list(clamp_outer_start) || is_undef(clamp_outer_start[3]) ? 0 : clamp_outer_start[3] * mul_radius;

        clamp_outer_end_thickness = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[0]) ? 0 : clamp_outer_end[0] * mul_radius;
        clamp_outer_end_height = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[1]) ? 0 : clamp_outer_end[1] * mul_length;
        clamp_outer_end_offset = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[2]) ? 0 : clamp_outer_end[2] * mul_length;
        clamp_outer_end_rounding_radius = !is_list(clamp_outer_end) || is_undef(clamp_outer_end[3]) ? 0 : clamp_outer_end[3] * mul_radius;

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
                clamp_inner_start_rounding_radius, 
                clamp_inner_end_rounding_radius, 
                clamp_outer_start_rounding_radius, 
                clamp_outer_end_rounding_radius
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
            start_rounding_radius == 0 && 
            end_rounding_radius == 0 &&
            (clamp_inner_start_thickness == 0 || clamp_inner_start_height == 0) &&
            (clamp_inner_end_thickness == 0 || clamp_inner_end_height == 0)
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
                                start = start, 
                                end = end,
                            
                                radius_outer = radius_outer,
                                radius_inner = radius_inner,

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

mb_tube(
    radius = [50, 60],
    length = [-40, 80],
    
    rounding_radius = 0, //[4, 12],
    axis = "z",
    offset = undef,
    mul = [8, 8, 3.2],

    clamp_inner_start = [5, 42, 10, 5],
    clamp_inner_end = [5, 42, 10, 5],
    
    clamp_outer_start = [5, 42, 10, 5],
    clamp_outer_end = [5, 42, 10, 5],
    

    rounding_resolution_tube = 64,
    rounding_resolution_edge = 8,

    draw_together = false,
    debug = true
);
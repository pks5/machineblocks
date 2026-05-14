use <../utils.scad>;

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

    clamp_start_thickness,
    clamp_start_height,
    clamp_start_offset,
    clamp_start_rounding_radius,
    
    clamp_end_thickness,
    clamp_end_height,
    clamp_end_offset,
    clamp_end_rounding_radius,

    rounding_resolution_edge
) =
    let(
        radius_inner = max(0, radius_inner),
        radius_outer = max(radius_inner, radius_outer),
        ring_thickness = radius_outer - radius_inner,
        max_rr = radius_inner > 0 ? 0.5 * ring_thickness : radius_outer,
        end = max(start, end),
        length = end - start,

        // Clamp Start
        cbs_offset = min(length, max(0, clamp_start_offset)),
        cbs_height = min(length - cbs_offset, max(0, clamp_start_height)),
        cbs_thickness = clamp_start_thickness < 0 ? sign(clamp_start_thickness) * min(ring_thickness, abs(clamp_start_thickness)) : clamp_start_thickness,
        cbs = cbs_height > 0 && cbs_thickness != 0,
        cbs_rr = min(max(0, clamp_start_rounding_radius), abs(cbs_thickness), cbs_height),
        cbs_outer_radius = radius_outer + cbs_thickness,
        cbs_y_start = start + cbs_offset,
        cbs_y_end = cbs_y_start + cbs_height,
        cbs_x_rounding = cbs_outer_radius - sign(clamp_start_thickness) * cbs_rr,
        cbs_y_rounding = cbs_y_start + cbs_rr,
        
        
        // Clamp End
        cbe_offset = min(length - cbs_offset - cbs_height, max(0, clamp_end_offset)),
        cbe_height = min(length - cbs_offset - cbs_height - cbe_offset, max(0, clamp_end_height)),
        cbe_thickness = clamp_end_thickness < 0 ? sign(clamp_end_thickness) * min(ring_thickness, abs(clamp_end_thickness)) : clamp_end_thickness,
        cbe = cbe_height > 0 && cbe_thickness != 0,
        cbe_rr = min(max(0, clamp_end_rounding_radius), abs(cbe_thickness), cbe_height),
        cbe_outer_radius = radius_outer + cbe_thickness,
        cbe_y_end = end - cbe_offset,
        cbe_y_start = cbe_y_end - cbe_height,
        cbe_x_rounding = cbe_outer_radius - sign(clamp_end_thickness) * cbe_rr,
        cbe_y_rounding = cbe_y_end - cbe_rr,
        
        
        // Start
        si_rr = min(max(0, start_rounding_radius), max_rr, length),
        so_rr = min(max(0, start_rounding_radius), max_rr, cbs ? cbs_offset : cbe ? (length - cbe_offset - cbe_height) : length),
        si_x_rounding = radius_inner + si_rr,
        so_x_rounding = radius_outer - so_rr,
        si_y_rounding = start + si_rr,
        so_y_rounding = start + so_rr,

        // End
        ei_rr = min(max(0, end_rounding_radius), max_rr, length),
        
        eo_rr = min(max(0, end_rounding_radius), max_rr, cbe ? cbe_offset : cbs ? (length - cbs_offset - cbs_height) : length),
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
        cbs && cbs_offset == 0 ? [] : concat(
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

        // Clamp Start
        cbs ? concat(
            cbs_offset == 0 ? [] : [
                [radius_outer, cbs_y_start]
            ],
            [
                [cbs_rr > 0 ? cbs_x_rounding : cbs_outer_radius, cbs_y_start],
            ],
            cbs_rr > 0 ? _mb_tube_arc_points(
                cx = cbs_x_rounding,
                cy = cbs_y_rounding,
                r = cbs_rr,
                a0 = cbs_thickness < 0 ? -90 : -90,
                a1 = cbs_thickness < 0 ? -180 : 0,
                segments = rounding_resolution_edge
            ) : [],
            [
                [cbs_outer_radius, cbs_y_end],
                [radius_outer, cbs_y_end]
            ]
        ) : [],

        // Clamp End
        cbe ? concat(
            [
                [radius_outer, cbe_y_start],
                [cbe_outer_radius, cbe_y_start],
                
                [cbe_outer_radius, cbe_rr > 0 ? cbe_y_rounding : cbe_y_end]
            ],
            cbe_rr > 0 ?_mb_tube_arc_points(
                cx = cbe_x_rounding,
                cy = cbe_y_rounding,
                r = cbe_rr,
                a0 = cbe_thickness < 0 ? 180 : 0,
                a1 = cbe_thickness < 0 ? 90 : 90,
                segments = rounding_resolution_edge
            ) : [],
            cbe_offset == 0 ? [] : [
                [radius_outer, cbe_y_end]
            ]
        ) : [],

        // End Outer
        cbe && cbe_offset == 0 ? [] : concat(
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
    
    clamp_start = undef,
    clamp_end = undef,
    
    axis = "z",
    offset = undef,
    mul = undef,
    
    rounding_resolution_tube = 64,
    rounding_resolution_edge = 8,

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
        rot = axis == 0 ? [0, 90 , 0] : axis == 1 ? [90, 0, 0] : [0, 0, 0];

        clamp_start_thickness = !is_list(clamp_start) || is_undef(clamp_start[0]) ? 0 : clamp_start[0];
        clamp_start_height = !is_list(clamp_start) || is_undef(clamp_start[1]) ? 0 : clamp_start[1];
        clamp_start_offset = !is_list(clamp_start) || is_undef(clamp_start[2]) ? 0 : clamp_start[2];
        clamp_start_rounding_radius = !is_list(clamp_start) || is_undef(clamp_start[3]) ? 0 : clamp_start[3];

        clamp_end_thickness = !is_list(clamp_end) || is_undef(clamp_end[0]) ? 0 : clamp_end[0];
        clamp_end_height = !is_list(clamp_end) || is_undef(clamp_end[1]) ? 0 : clamp_end[1];
        clamp_end_offset = !is_list(clamp_end) || is_undef(clamp_end[2]) ? 0 : clamp_end[2];
        clamp_end_rounding_radius = !is_list(clamp_end) || is_undef(clamp_end[3]) ? 0 : clamp_end[3];

        is_cylinder = radius_inner == 0 && 
            start_rounding_radius == 0 && 
            end_rounding_radius == 0 &&
            (clamp_start_thickness == 0 || clamp_start_height == 0) &&
            (clamp_end_thickness == 0 || clamp_end_height == 0);

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

                                clamp_start_thickness = clamp_start_thickness,
                                clamp_start_height = clamp_start_height,
                                clamp_start_offset = clamp_start_offset,
                                clamp_start_rounding_radius = clamp_start_rounding_radius,
                                
                                clamp_end_thickness = clamp_end_thickness,
                                clamp_end_height = clamp_end_height,
                                clamp_end_offset = clamp_end_offset,
                                clamp_end_rounding_radius = clamp_end_rounding_radius,

                                rounding_resolution_edge = rounding_resolution_edge
                            ));
                }
            }
    }
}   

mb_tube(
    radius = 20, //[10, 20],
    length = [-40, 80],
    
    rounding_radius = 0, //[4, 12],
    axis = "y",
    offset = undef,
    mul = [8, 8, 3.2],
    
    clamp_start = undef, //[25, 42, 10, 5],
    clamp_end = undef, //[25, 42, 10, 5],

    rounding_resolution_tube = 64,
    rounding_resolution_edge = 8,

    draw_together = false,
    debug = true
);
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

    radius_inner = 0,
    radius_outer,

    clamp_start_height,
    clamp_start_thickness,
    clamp_start_offset,
    clamp_start_rounding_radius,
    
    clamp_end_height,
    clamp_end_thickness,
    clamp_end_offset,
    clamp_end_rounding_radius,

    edgeRoundingResolution
) =
    let(
        radius_inner = max(0, radius_inner),
        radius_outer = max(radius_inner, radius_outer),
        max_rr = radius_inner > 0 ? 0.5*(radius_outer - radius_inner) : radius_outer,
        end = max(start, end),
        length = end - start,

        // Clamp Start
        cbs_offset = min(length, max(0, clamp_start_offset)),
        cbs_height = min(length - cbs_offset, max(0, clamp_start_height)),
        cbs_thickness = sign(clamp_start_thickness) * min(radius_outer, abs(clamp_start_thickness)),
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
        cbe_thickness = sign(clamp_end_thickness) * min(radius_outer, abs(clamp_end_thickness)),
        cbe = cbe_height > 0 && cbe_thickness != 0,
        cbe_rr = min(max(0, clamp_end_rounding_radius), abs(cbe_thickness), cbe_height),
        cbe_outer_radius = radius_outer + cbe_thickness,
        cbe_y_end = end - cbe_offset,
        cbe_y_start = cbe_y_end - cbe_height,
        cbe_x_rounding = cbe_outer_radius - sign(clamp_end_thickness) * cbe_rr,
        cbe_y_rounding = cbe_y_end - cbe_rr,
        
        
        // Start
        s_rr = min(max(0, start_rounding_radius), max_rr, cbs ? cbs_offset : cbe ? (length - cbe_offset - cbe_height) : length),
        s_x_rounding = radius_outer - s_rr,
        s_y_rounding = start + s_rr,

        // End
        e_rr = min(max(0, end_rounding_radius), max_rr, cbe ? cbe_offset : cbs ? (length - cbs_offset - cbs_height) : length),
        e_x_rounding = radius_outer - e_rr,
        e_y_rounding = end - e_rr,
        
    )
    concat(
        // Start
        concat(
            [
                [radius_inner, start],
                [s_rr > 0 ? s_x_rounding : radius_outer, start],
            ],
            s_rr > 0 ? concat(
                _mb_tube_arc_points(
                    cx = s_x_rounding,
                    cy = s_y_rounding,
                    r = s_rr,
                    a0 = -90,
                    a1 = 0,
                    segments = edgeRoundingResolution
                ),
                [
                    [radius_outer, s_y_rounding]
                ]
            ) : []
        ),

        // Clamp Start
        cbs ? concat(
            [
                [radius_outer, cbs_y_start],
                [cbs_rr > 0 ? cbs_x_rounding : cbs_outer_radius, cbs_y_start],
            ],
            cbs_rr > 0 ? _mb_tube_arc_points(
                cx = cbs_x_rounding,
                cy = cbs_y_rounding,
                r = cbs_rr,
                a0 = cbs_thickness < 0 ? -90 : -90,
                a1 = cbs_thickness < 0 ? -180 : 0,
                segments = edgeRoundingResolution
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
                segments = edgeRoundingResolution
            ) : [],
            [
                [radius_outer, cbe_y_end]
            ]
        ) : [],

        // End
        concat(
            e_rr > 0 ? concat(
                [
                    [radius_outer, e_y_rounding],
                ],
                _mb_tube_arc_points(
                    cx = e_x_rounding,
                    cy = e_y_rounding,
                    r = e_rr,
                    a0 = 0,
                    a1 = 90,
                    segments = edgeRoundingResolution
                )
            ) : [],
            [
                [e_rr > 0 ? e_x_rounding : radius_outer, end],
                [radius_inner, end],
                [radius_inner, start]
            ]
        )
    );

module mb_tube(
    length,
    radius,
    
    start_rounding_radius = 0,
    
    
    clamp_start_height = 0,
    clamp_start_thickness = 0,
    clamp_start_offset = 0,
    clamp_start_rounding_radius = 0,
    
    clamp_end_height = 0,
    clamp_end_thickness = 0,
    clamp_end_offset = 0,
    clamp_end_rounding_radius = 0,

    end_rounding_radius = 0,

    bodyRoundingResolution = 64,
    edgeRoundingResolution = 8
) {
    
    if(length > 0 && radius > 0){
        //rotate_extrude(convexity = 10, $fn = bodyRoundingResolution)
            polygon(points = _mb_tube_profile_points(
                start = -0.5 * length, 
                end = 0.5 * length,
            
                radius_outer = radius,

                start_rounding_radius = start_rounding_radius,
                end_rounding_radius = end_rounding_radius,

                clamp_start_height = clamp_start_height,
                clamp_start_thickness = clamp_start_thickness,
                clamp_start_offset = clamp_start_offset,
                clamp_start_rounding_radius = clamp_start_rounding_radius,
                
                clamp_end_height = clamp_end_height,
                clamp_end_thickness = clamp_end_thickness,
                clamp_end_offset = clamp_end_offset,
                clamp_end_rounding_radius = clamp_end_rounding_radius,

                

                edgeRoundingResolution = edgeRoundingResolution
            ));
    }
}   

mb_tube(
    length = 100,
    radius = 20,

    start_rounding_radius = 4,
    
    
    clamp_start_height = 12,
    clamp_start_thickness = -12,
    clamp_start_offset = 10,
    clamp_start_rounding_radius = 5,

    clamp_end_height = 12,
    clamp_end_thickness = -15,
    clamp_end_offset=10,
    clamp_end_rounding_radius = 4,

    end_rounding_radius = 6, 

    bodyRoundingResolution = 64,
    edgeRoundingResolution = 8
);
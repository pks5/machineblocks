module mb_stud(
    height = 1.6,
    radius,
    roundingRadius = 0,
    holeRadius = 0,
    holeClampThickness = 0,
    clampHeight = 0,
    clampThickness = 0,
    bodyRoundingResolution = 64,
    holeRoundingResolution = 16,
    edgeRoundingResolution = 8
) {
    if(holeRadius == 0){
        mb_stud_outer(
            height = height,
            radius = radius,
            roundingRadius = roundingRadius,
            clampHeight = clampHeight,
            clampThickness = clampThickness,
            bodyRoundingResolution = bodyRoundingResolution,
            edgeRoundingResolution = edgeRoundingResolution
        );
    }
    else{
        difference(){
            mb_stud_outer(
                height = height,
                radius = radius,
                roundingRadius = roundingRadius,
                clampHeight = clampHeight,
                clampThickness = clampThickness,
                bodyRoundingResolution = bodyRoundingResolution,
                edgeRoundingResolution = edgeRoundingResolution
            );
            translate([0, 0, 0.5*height])
                intersection(){
                    cube([2*(holeRadius - holeClampThickness), 2*(holeRadius - holeClampThickness), 1.1*height], center = true);
                    cylinder(center=true, 1.1*height, r = holeRadius, $fn = holeRoundingResolution);
                }
        }
    }
}

module mb_stud_outer(
    height,
    radius,
    roundingRadius,
    clampHeight = 0,
    clampThickness = 0,
    bodyRoundingResolution = 64,
    edgeRoundingResolution = 8
) {
    hasClamp = clampThickness > 0 && clampHeight > 0;
    outerR = hasClamp ? radius + clampThickness : radius;

    rr = hasClamp
        ? min(roundingRadius, outerR, height, clampHeight)
        : min(roundingRadius, radius, height);

    rotate_extrude(convexity = 10, $fn = bodyRoundingResolution)
        polygon(points = _mb_stud_profile_points(
            height = height,
            radius = radius,
            outerRadius = outerR,
            roundingRadius = rr,
            clampHeight = clampHeight,
            hasClamp = hasClamp,
            edgeRoundingResolution = edgeRoundingResolution
        ));
}

function _mb_stud_profile_points(
    height,
    radius,
    outerRadius,
    roundingRadius,
    clampHeight,
    hasClamp,
    edgeRoundingResolution
) =
    hasClamp
    ? let(
        rr = min(roundingRadius, outerRadius, height, clampHeight),
        clampBaseY = height - clampHeight,
        roundStartY = height - rr
    )
    concat(
        [
            [0, 0],
            [radius, 0],
            [radius, clampBaseY],
            [outerRadius, clampBaseY],
            [outerRadius, roundStartY]
        ],
        _mb_arc_points(
            cx = outerRadius - rr,
            cy = height - rr,
            r = rr,
            a0 = 0,
            a1 = 90,
            segments = edgeRoundingResolution
        ),
        [
            [0, height],
            [0, 0]
        ]
    )
    : let(
        rr = min(roundingRadius, radius, height),
        roundStartY = height - rr
    )
    concat(
        [
            [0, 0],
            [radius, 0],
            [radius, roundStartY]
        ],
        _mb_arc_points(
            cx = radius - rr,
            cy = height - rr,
            r = rr,
            a0 = 0,
            a1 = 90,
            segments = edgeRoundingResolution
        ),
        [
            [0, height],
            [0, 0]
        ]
    );

function _mb_arc_points(cx, cy, r, a0, a1, segments = 8) =
    [
        for (i = [0:segments])
            let(a = a0 + (a1 - a0) * i / segments)
                [cx + cos(a) * r, cy + sin(a) * r]
    ];

function _mb_tube_profile_points(
    length,
    radius,

    start_rounding_radius,
    

    clamp_start_height,
    clamp_start_thickness,
    clamp_start_offset,
    clamp_start_rounding_radius,
    
    clamp_end_height,
    clamp_end_thickness,
    clamp_end_offset,
    clamp_end_rounding_radius,

    end_rounding_radius,

    edgeRoundingResolution
) =
    let(
        l = [-0.5 * length, 0.5 * length],

        // Clamp Start
        cbs = clamp_start_height > 0 && clamp_start_thickness > 0,
        cbs_rr = min(max(0, clamp_start_rounding_radius), clamp_start_thickness, clamp_start_height),
        cbs_outer_radius = radius + clamp_start_thickness,
        cbs_y_start = l[0] + clamp_start_offset,
        cbs_y_end = cbs_y_start + clamp_start_height,
        cbs_x_rounding = cbs_outer_radius - cbs_rr,
        cbs_y_rounding = cbs_y_start + cbs_rr,
        
        
        // Clamp End
        cbe = clamp_end_height > 0 && clamp_end_thickness > 0,
        cbe_rr = min(max(0, clamp_end_rounding_radius), clamp_end_thickness, clamp_end_height),
        cbe_outer_radius = radius + clamp_end_thickness,
        
        cbe_y_end = l[1] - clamp_end_offset,
        cbe_y_start = cbe_y_end - clamp_end_height,
        
        cbe_x_rounding = cbe_outer_radius - cbe_rr,
        cbe_y_rounding = cbe_y_end - cbe_rr,
        
        
        // Start
        s_rr = min(max(0, start_rounding_radius), radius, cbs ? clamp_start_offset : cbe ? (length - clamp_end_offset - clamp_end_height) : length),
        s_x_rounding = radius - s_rr,
        s_y_rounding = l[0] + s_rr,

        // End
        e_rr = min(max(0, end_rounding_radius), radius, cbe ? clamp_end_offset : cbs ? (length - clamp_start_offset - clamp_start_height) : length),
        e_x_rounding = radius - e_rr,
        e_y_rounding = l[1] - e_rr,
        
    )
    concat(
        // Start
        concat(
            [
                [0, l[0]],
                [s_rr > 0 ? s_x_rounding : radius, l[0]],
            ],
            s_rr > 0 ? concat(
                _mb_arc_points(
                    cx = s_x_rounding,
                    cy = s_y_rounding,
                    r = s_rr,
                    a0 = -90,
                    a1 = 0,
                    segments = edgeRoundingResolution
                ),
                [
                    [radius, s_y_rounding]
                ]
            ) : []
        ),

        // Clamp Start
        cbs ? concat(
            [
                [radius, cbs_y_start],
                [cbs_rr > 0 ? cbs_x_rounding : cbs_outer_radius, cbs_y_start],
            ],
            cbs_rr > 0 ? _mb_arc_points(
                cx = cbs_x_rounding,
                cy = cbs_y_rounding,
                r = cbs_rr,
                a0 = -90,
                a1 = 0,
                segments = edgeRoundingResolution
            ) : [],
            [
                [cbs_outer_radius, cbs_y_end],
                [radius, cbs_y_end]
            ]
        ) : [],

        // Clamp End
        cbe ? concat(
            [
                [radius, cbe_y_start],
                [cbe_outer_radius, cbe_y_start],
                
                [cbe_outer_radius, cbe_rr > 0 ? cbe_y_rounding : cbe_y_end]
            ],
            cbe_rr > 0 ?_mb_arc_points(
                cx = cbe_x_rounding,
                cy = cbe_y_rounding,
                r = cbe_rr,
                a0 = 0,
                a1 = 90,
                segments = edgeRoundingResolution
            ) : [],
            [
                [radius, cbe_y_end]
            ]
        ) : [],

        // End
        concat(
            e_rr > 0 ? concat(
                [
                    [radius, e_y_rounding],
                ],
                _mb_arc_points(
                    cx = e_x_rounding,
                    cy = e_y_rounding,
                    r = e_rr,
                    a0 = 0,
                    a1 = 90,
                    segments = edgeRoundingResolution
                )
            ) : [],
            [
                [e_rr > 0 ? e_x_rounding : radius, l[1]],
                [0, l[1]],
                [0, 0]
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
    

    //rotate_extrude(convexity = 10, $fn = bodyRoundingResolution)
        polygon(points = _mb_tube_profile_points(
            length = length,
            radius = radius,

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

mb_tube(
    length = 100,
    radius = 20,

    start_rounding_radius = 4,
    
    
    clamp_start_height = 12,
    clamp_start_thickness = 12,
    clamp_start_offset = 10,
    clamp_start_rounding_radius = 5,

    clamp_end_height = 12,
    clamp_end_thickness = 15,
    clamp_end_offset=10,
    clamp_end_rounding_radius = 4,

    end_rounding_radius = 6, 

    bodyRoundingResolution = 64,
    edgeRoundingResolution = 8
);
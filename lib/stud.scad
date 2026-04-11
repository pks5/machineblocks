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
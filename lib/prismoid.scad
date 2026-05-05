use <utils.scad>;

/*
* --------------------
* START HELPER MODULES
* --------------------
*/

/**
* CORNER CUT
*/
module mb_corner_cut(size, c = [0, 0]){
    sx = size[0];
    sy = size[1];
    sz = size[2];

    x0 = -sx / 2; x1 = sx / 2;
    y0 = -sy / 2; y1 = sy / 2;
    z0 = -sz / 2; z1 = sz / 2;

    // points:
    // 0 = x- y- z-
    // 1 = x+ y- z-
    // 2 = x+ y+ z-
    // 3 = x- y+ z-
    // 4 = x- y- z+
    // 5 = x+ y- z+
    // 6 = x+ y+ z+
    // 7 = x- y+ z+
    pts = [
        [x0,y0,z0], [x1,y0,z0], [x1,y1,z0], [x0,y1,z0],
        [x0,y0,z1], [x1,y0,z1], [x1,y1,z1], [x0,y1,z1]
    ];

    missing =
        c[0] == 0 && (c[1] == 0 || c[1] == 1) ? 6 :
        c[0] == 0 && (c[1] == 2 || c[1] == 3) ? 5 :
        c[0] == 0 && (c[1] == 4 || c[1] == 5) ? 4 :
        c[0] == 0 && (c[1] == 6 || c[1] == 7) ? 7 :
        c[0] == 1 && (c[1] == 0 || c[1] == 1) ? 2 :
        c[0] == 1 && (c[1] == 2 || c[1] == 3) ? 1 :
        c[0] == 1 && (c[1] == 4 || c[1] == 5) ? 0 :
        c[0] == 1 && (c[1] == 6 || c[1] == 7) ? 3 :
        6;

    faces =
        missing == 6 ? [
            [0,3,7,4], [0,4,5,1], [0,1,2,3],
            [1,5,2], [2,7,3], [4,7,5], [2,5,7]
        ] :
        missing == 5 ? [
            [0,3,7,4], [0,1,2,3], [2,6,7,3],
            [0,4,1], [1,6,2], [4,7,6], [1,4,6]
        ] :
        missing == 4 ? [
            [0,1,2,3], [1,5,6,2], [2,6,7,3],
            [0,3,7], [0,5,1], [5,7,6], [0,7,5]
        ] :
        missing == 7 ? [
            [0,1,2,3], [0,4,5,1], [1,5,6,2],
            [0,3,4], [3,2,6], [4,6,5], [3,6,4]
        ] :
        missing == 2 ? [
            [0,3,7,4], [0,4,5,1], [4,7,6,5],
            [0,1,3], [1,5,6], [3,6,7], [1,6,3]
        ] :
        missing == 1 ? [
            [0,3,7,4], [2,6,7,3], [4,7,6,5],
            [0,4,5], [0,2,3], [2,5,6], [0,5,2]
        ] :
        missing == 0 ? [
            [1,2,3], [4,5,1], [3,7,4],
            [1,5,6,2], [2,6,7,3], [4,7,6,5], [1,3,4]
        ] :
        missing == 3 ? [
            [0,4,5,1], [1,5,6,2], [4,7,6,5],
            [0,1,2], [0,7,4], [2,6,7], [0,2,7]
        ] :
        [];

    polyhedron(points = pts, faces = faces, convexity = 4);
}

/**
* ROUNDING CORNER
*/
module mb_rounding_corner(corner = [0, 0], radius = 0, angle = [0, 0, 0, 0], resolution = 80, debug = false){
    radius = mb_resolve_xyz(xyz = radius, min_value = 0.001);
    max_rad = max(radius[0], radius[1], radius[2]);
    rad_rel = [radius[0] / max_rad, radius[1] / max_rad, radius[2] / max_rad];
    
    off_corner = mb_corner_offset(corner, radius);
    off = mb_corner_offset(corner, radius, -1);
    
    multmatrix(m = [ [1, angle[1] / 45, angle[2] / 45, 0],
                 [angle[0] / 45, 1, angle[3] / 45, 0],
                 [0, 0, 1, 0]
              ]) 
    translate(off)
        intersection(){
            translate(off_corner)
                mb_corner_cut(radius, corner);
                //cube(size = radius, center = true);

            if((radius[0] > 0.001 && radius[1] > 0.001 && radius[2] > 0.001) && (true || radius[0] != radius[1] || radius[1] != radius[2])){
                //hull()
                /*
                mb_pseudo_ellipse_ring(
                    corner = corner,
                    s = radius,
                    resolution = resolution,
                    h = 0.001
                );*/

                mb_pseudo_ellipse_ring(
                    corner = corner,
                    s=radius,
                    resolution=resolution,
                    h=0.001,
                    capWidth=0.1,
                    //capStep=0.001,
                    capThreshold=0.15
                );

                if(debug){
                    echo (m = "ellipse", radius = radius);
                }
                
            }
            else{
                scale(rad_rel)
                    sphere(r = max_rad, $fn = resolution);
                if(debug){
                    echo (m = "spehere", radius = radius);
                }
            }
        }
}

/**
* PSEUDO ELLIPSE RING
*/

function mb_pe_curvature(rx, ry, a) =
    abs(rx * ry) /
    pow(
        pow(ry * cos(a), 2) + pow(rx * sin(a), 2),
        1.5
    );

function mb_pe_adaptive_angles(
    rx, ry,
    a0, a1,
    baseStep,
    minStep,
    maxStep,
    kMax,
    angles=[]
) =
    a0 >= a1
        ? concat(angles, [a1])
        : let(
            k = mb_pe_curvature(rx, ry, a0),

            // 0..1, hohe Krümmung => nahe 1
            t = min(1, k / kMax),

            // hohe Krümmung => minStep
            // geringe Krümmung => maxStep
            step = max(
                minStep,
                min(
                    maxStep,
                    maxStep - (maxStep - minStep) * sqrt(t)
                )
            ),

            nextA = min(a0 + step, a1)
        )
        mb_pe_adaptive_angles(
            rx, ry,
            nextA, a1,
            baseStep,
            minStep,
            maxStep,
            kMax,
            concat(angles, [a0])
        );

module mb_pseudo_ellipse_ring(
    s=[40, 25, 3],
    resolution=32,
    h=3,
    center=true,
    corner = [0, 0],
    
    capWidth=18,
    capStepT=0.5,
    capThreshold=0.15
) {
    x_smallest = s[0] < s[1] && s[0] < s[2];
    y_smallest = s[1] < s[0] && s[1] < s[2];

    /*
    cn = corner[1] == 4 ? 0 :
        corner[1] == 2 ? 1 :
        corner[1] == 0 ? 2 :
        corner[1] == 6 ? 3 : 0;

   cxs = corner[0] == 0 && (corner[1] == 2 || corner[1] == 4) ? 0 :
        corner[0] == 1 && (corner[1] == 2 || corner[1] == 4) ? 1 :
        corner[0] == 1 && (corner[1] == 0 || corner[1] == 6) ? 2 :
        corner[0] == 0 && (corner[1] == 0 || corner[1] == 6) ? 3 : 0;
      //  cxs = 1; // c06, c04 => 0, c16, c14 => 1, c10, c12 => 2, c00, c02 => 3

    cys = corner[0] == 1 && (corner[1] == 4 || corner[1] == 6) ? 0 :
        corner[0] == 1 && (corner[1] == 0 || corner[1] == 2) ? 1 :
        corner[0] == 0 && (corner[1] == 0 || corner[1] == 2) ? 2 :
        corner[0] == 0 && (corner[1] == 4 || corner[1] == 6) ? 3 : 0;

       // cys = 3; // c14, c16 => 0, c10, c12 => 1, c00, c02 => 2, c04, c06 => 3

    c = x_smallest ? cxs : (y_smallest ? cys :cn);

    from = c * 90;
    to = 90 + c *90; */

    startAngle = 0; //from;
    endAngle = 360; //to;

    radius = x_smallest ? 
        [max(0.001, s[2]), max(0.001, s[1]), max(0.001, s[0])] :
        y_smallest ?
        [max(0.001, s[0]), max(0.001, s[2]), max(0.001, s[1])] :
        s;

    rot = x_smallest ? [0, 90, 0] : y_smallest ? [90, 0, 0] : [0, 0, 0];

    rx = max(0.001, radius[0] - radius[2]);
    ry = max(0.001, radius[1] - radius[2]);

    angleSpan = endAngle - startAngle;

    max_r = max(abs(rx), abs(ry));
    min_r = max(0.001, min(abs(rx), abs(ry)));

    count = max(1, ceil(resolution * abs(angleSpan) / 360));
    steps = (count > 1) ? (count - 1) : 1;

    capStep = min_r / max_r * 25;

    // adaptive Grenzen
    baseStep = 360 / resolution;
    minStep = baseStep / sqrt(max_r / min_r);
    maxStep = baseStep * 1.5;

    // maximale Krümmung liegt ungefähr am kleinen Radius-Ende
    use_xcaps = abs(rx) / max_r < capThreshold;
    use_ycaps = abs(ry) / max_r < capThreshold;

    baseAngles = use_xcaps || use_ycaps ? [
        for (i = [0 : count - 1])
            startAngle + angleSpan * i / steps
    ] : mb_pe_adaptive_angles(
        rx, ry,
        startAngle, endAngle,
        baseStep,
        minStep,
        maxStep,
        max(
            mb_pe_curvature(rx, ry, 0),
            mb_pe_curvature(rx, ry, 90),
            mb_pe_curvature(rx, ry, 180),
            mb_pe_curvature(rx, ry, 270)
        )
    );

    // Wenn rx sehr klein ist: runde Endkappen oben/unten extra sampeln
    xCaps =
        use_xcaps
            ? concat(
                mb_pe_cap_angles(90, capWidth, capStep),
                mb_pe_cap_angles(270, capWidth, capStep)
              )
            : [];

    // Wenn ry sehr klein ist: runde Endkappen links/rechts extra sampeln
    yCaps =
        use_ycaps
            ? concat(
                mb_pe_cap_angles(0, capWidth, capStep),
                mb_pe_cap_angles(180, capWidth, capStep),
                mb_pe_cap_angles(360, capWidth, capStep)
              )
            : [];

    angles = concat(
        baseAngles,
        mb_pe_filter_angles(xCaps, startAngle, endAngle),
        mb_pe_filter_angles(yCaps, startAngle, endAngle)
    );

    //hull()
    rotate(rot){
    for (a = angles) {
        p = [
            rx * cos(a),
            ry * sin(a),
            0
        ];

        tangent_angle = atan2(ry * cos(a), -rx * sin(a));

        translate(p)
            rotate([0, 0, tangent_angle])
                rotate([0, 90, 0])
                    cylinder(
                        h = h,
                        r = radius[2],
                        center = center,
                        $fn = resolution //max(8, ceil(radius[2] / max_r * resolution))
                    );
    }
    }
}

function mb_pe_cap_angles(center, width, step) =
    [for (a = [center - width : step : center + width]) a];

function mb_pe_in_angle_range(a, a0, a1) =
    a >= min(a0, a1) && a <= max(a0, a1);

function mb_pe_filter_angles(angles, a0, a1) =
    [for (a = angles) if (mb_pe_in_angle_range(a, a0, a1)) a];

/*
* ------------------
* END HELPER MODULES
* ------------------
*/

/*
* -----------
* START UTILS
* -----------
*/

/*
* CORNER UTILS
*/

function mb_corner_offset(c, r, f = 0.5) = [
    (c[1] == 0 || c[1] == 1 || c[1] == 2 || c[1] == 3 ? -1 : 1) * f * r[0],
    (c[1] == 0 || c[1] == 1 || c[1] == 6 || c[1] == 7 ? -1 : 1) * f * r[1],
    (c[0] == 0 ? -1 : 1) * f * r[2]
];

function mb_angle_from_x(p0, p1) =
    atan2(p1[1] - p0[1], p1[0] - p0[0]);

function mb_angle_from_y(p0, p1) =
    atan2(p1[0] - p0[0], p1[1] - p0[1]);

function mb_angle_from_z(p0, p1) =
    [atan2(p1[0] - p0[0], p1[2] - p0[2]), atan2(p1[1] - p0[1], p1[2] - p0[2])];    

function mb_corner_angle(corner, prev, point, next, top) = 
    let(ang_x_prev = mb_angle_from_x(point, prev),
        ang_y_prev = mb_angle_from_y(point, prev),
        
        ang_x_next = mb_angle_from_x(point, next),
        ang_y_next = mb_angle_from_y(point, next),

        ang_z = mb_angle_from_z(point, top),

        ang_x = corner[1] == 0 || corner[1] == 1 || corner[1] == 4 || corner[1] == 5 ? ang_x_prev : ang_x_next,
        ang_y = corner[1] == 0 || corner[1] == 1 || corner[1] == 4 || corner[1] == 5 ? ang_y_next : ang_y_prev
        )
            [
                corner[1] == 4 || corner[1] == 5 || corner[1] == 6 || corner[1] == 7 ? ang_x - sign(ang_x) * 180 : ang_x, 
                corner[1] == 2 || corner[1] == 3 || corner[1] == 4 || corner[1] == 5 ? ang_y - sign(ang_y) * 180: ang_y,
                
                corner[0] == 1 ? ang_z[0] - sign(ang_z[0]) * 180 : ang_z[0], 
                corner[0] == 1 ? ang_z[1] - sign(ang_z[1]) * 180 : ang_z[1]
            ];

/*
* POINT UTILS
*/

function mb_resolve_xyz(xyz, default = [0, 0, 0], min_value = undef, z_value = undef) = 
    let(r = is_list(xyz) ? 
        ([
            is_num(xyz[0]) ? xyz[0] : (is_undef(default) ? 0 : default[0]), 
            is_num(xyz[1]) ? xyz[1] : (is_undef(default) ? 0 : default[1]), 
            is_num(xyz[2]) ? xyz[2] : (is_undef(default) ? 0 : default[2])
        ]) : 
        is_num(xyz) ? [xyz, xyz, xyz] : default)
    is_undef(r) ? undef : (is_undef(min_value) ? r : [max(min_value, r[0]), max(min_value, r[1]), max(min_value, r[2])]);
    
function mb_point(shape, i = 0, j = 0) = 
    let(plane = mb_prismoid_plane(shape, i))
    mb_resolve_xyz(xyz = plane[j], default = undef);

function mb_prev_point(shape, i = 0, j = 0) = 
    let(prev_index = (j - 1 + 8) % 8,
        p = mb_point(shape = shape, i, prev_index))
    p != undef ? p : mb_prev_point(shape, i, prev_index); 

function mb_next_point(shape, i = 0, j = 0) = 
    let(p = mb_point(shape = shape, i, (j + 1) % 8))
    p != undef ? p : mb_next_point(shape, i, (j + 1) % 8); 

function mb_inv_point(shape, i = 0, j = 0) = 
    mb_point(shape, i == 0 ? 1 : 0, j);

function mb_point_distance(p1, p2) = 
    is_undef(p1) || is_undef(p2) ? undef : [p2.x - p1.x, p2.y - p1.y, p2.z - p1.z];

function mb_socket_point(point, inv_point, socket_top = undef, socket_bottom = undef, i = 0) =
    socket_bottom != undef && (i == 0) ?
                        [point[0], point[1], point[2] + socket_bottom] : 
    socket_top != undef && (i == 0) ? 
                        [inv_point[0], inv_point[1], inv_point[2] - socket_top] : 

    socket_top != undef && (i == 1) ?
                        [point[0], point[1], point[2] - socket_top] :  
    socket_bottom != undef && (i == 1) ?
                        [inv_point[0], inv_point[1], inv_point[2] + socket_bottom] : undef;            

function mb_point_radius(shape, i, j) =
    let(plane = mb_prismoid_plane(shape, i))
        plane[j] != undef ? (len(plane[j]) > 3 ? plane[j][3] : undef) : undef;

function mb_point_corner(shape, i, j) = 
    [i, j];
    /*
    let(plane = mb_prismoid_plane(shape, i),
        sl = len(plane))
    sl == 4 ? 
    [i, 2 * j] : 
    (sl == 8 ? [i, j] : undef);*/

function mb_min_max_points(shape, i = 0, j = 0, min_max = [0, 0, 0, 0, 0, 0]) =
    let ( p = mb_point(shape, i, j))
    i < len(shape) ? 
    (
        j < len(shape[i]) ? 
        mb_min_max_points(shape, i, j + 1, p == undef ? 
        min_max : 
        [
            min(min_max[0], p[0]), //min X
            min(min_max[1], p[1]), //min Y
            min(min_max[2], p[2]), //min Z
            max(min_max[3], p[0]), //max X
            max(min_max[4], p[1]), //max Y
            max(min_max[5], p[2])  //max Z
        ]) : 
        mb_min_max_points(shape, i + 1, 0, min_max)
    ) : 
    min_max;

/*
* XYZ RAD CONVERT
*/

function mb_xyz_rad(xyz_rad) = [xyz_rad[2] > 0 ? xyz_rad[2] : xyz_rad[1], xyz_rad[2] > 0 ? xyz_rad[2] : xyz_rad[0], max(xyz_rad[0], xyz_rad[1])];

function mb_xyz_rad_convert(xyz_rad) =
    is_num(xyz_rad) ? xyz_rad :
    (is_list(xyz_rad) && len(xyz_rad) == 3 && is_num(xyz_rad[0]) && is_num(xyz_rad[1]) && is_num(xyz_rad[2])) ? 
    mb_xyz_rad(xyz_rad) : 
     (is_list(xyz_rad) && len(xyz_rad) == 3 
     && (is_num(xyz_rad[0]) || (is_list(xyz_rad[0]) && len(xyz_rad[0]) == 4)) 
     && (is_num(xyz_rad[1]) || (is_list(xyz_rad[1]) && len(xyz_rad[1]) == 4)) 
     && (is_num(xyz_rad[2]) || (is_list(xyz_rad[2]) && len(xyz_rad[2]) == 4))) ? 
     [[
        mb_xyz_rad([is_list(xyz_rad[0]) ? xyz_rad[0][0] : xyz_rad[0], is_list(xyz_rad[1]) ? xyz_rad[1][0] : xyz_rad[1], is_list(xyz_rad[2]) ? xyz_rad[2][0] : xyz_rad[2]]),
        mb_xyz_rad([is_list(xyz_rad[0]) ? xyz_rad[0][1] : xyz_rad[0], is_list(xyz_rad[1]) ? xyz_rad[1][0] : xyz_rad[1], is_list(xyz_rad[2]) ? xyz_rad[2][1] : xyz_rad[2]]),
        mb_xyz_rad([is_list(xyz_rad[0]) ? xyz_rad[0][1] : xyz_rad[0], is_list(xyz_rad[1]) ? xyz_rad[1][3] : xyz_rad[1], is_list(xyz_rad[2]) ? xyz_rad[2][2] : xyz_rad[2]]),
        mb_xyz_rad([is_list(xyz_rad[0]) ? xyz_rad[0][0] : xyz_rad[0], is_list(xyz_rad[1]) ? xyz_rad[1][3] : xyz_rad[1], is_list(xyz_rad[2]) ? xyz_rad[2][3] : xyz_rad[2]])
     ],
      [
        mb_xyz_rad([is_list(xyz_rad[0]) ? xyz_rad[0][3] : xyz_rad[0], is_list(xyz_rad[1]) ? xyz_rad[1][1] : xyz_rad[1], is_list(xyz_rad[2]) ? xyz_rad[2][0] : xyz_rad[2]]),
        mb_xyz_rad([is_list(xyz_rad[0]) ? xyz_rad[0][2] : xyz_rad[0], is_list(xyz_rad[1]) ? xyz_rad[1][1] : xyz_rad[1], is_list(xyz_rad[2]) ? xyz_rad[2][1] : xyz_rad[2]]),
        mb_xyz_rad([is_list(xyz_rad[0]) ? xyz_rad[0][2] : xyz_rad[0], is_list(xyz_rad[1]) ? xyz_rad[1][2] : xyz_rad[1],is_list(xyz_rad[2]) ? xyz_rad[2][2] : xyz_rad[2]]),
        mb_xyz_rad([is_list(xyz_rad[0]) ? xyz_rad[0][3] : xyz_rad[0], is_list(xyz_rad[1]) ? xyz_rad[1][2] : xyz_rad[1], is_list(xyz_rad[2]) ? xyz_rad[2][3] : xyz_rad[2]])
        ]]
     :
    undef;

/*
* PRISMOID SHAPE
*/

function mb_prismoid_plane(shape, i) =
    let(l = len(shape))
    i > 1 ? undef : shape[l == 1 ? 0 : i];

function mb_prismoid_plane_resolve(a) =
    let(la = len(a))
    is_undef(a) || is_num(a) || is_string(a) || la == 0 ? 
        [undef, undef, undef, undef, undef, undef, undef, undef] :

    la <= 4 ?
    [
        a[0]                 , undef, 
        la > 1 ? a[1] : undef, undef, 
        la > 2 ? a[2] : undef, undef, 
        la > 3 ? a[3] : undef, undef
    ] : a;

function mb_prismoid_plane_checksum(a, i = 0) =
    (!is_list(a) || len(a) == 0)
        ? 0
        : (i >= len(a)
            ? 0
            : (a[i] != undef ? pow(2, i) : 0)
              + mb_prismoid_plane_checksum(a, i + 1)
        );

function mb_prismoid_min_points(a) =
    (a[0] != undef && a[2] != undef && a[4] != undef)
    || (a[0] != undef && a[2] != undef && a[6] != undef)
    || (a[0] != undef && a[4] != undef && a[6] != undef)
    || (a[2] != undef && a[4] != undef && a[6] != undef);

function mb_prismoid_validate(shape) = 
    len(shape) != 2 ? ["invalid_shape", len(shape)] :
    len(shape[0]) != 8 ? ["invalid_plane_length", 0, len(shape[0])] :
    len(shape[1]) != 8 ? ["invalid_plane_length", 1, len(shape[1])] :
    !mb_prismoid_min_points(shape[0])  ? ["point_missing", 0] :
    !mb_prismoid_min_points(shape[1])  ? ["point_missing", 1] :
    mb_prismoid_plane_checksum(shape[0]) != mb_prismoid_plane_checksum(shape[1]) ? ["point_mismatch"] :
    ["ok"];

function mb_prismoid_process(shape) = 
    let(min_max = mb_min_max_points(shape),
        sx = min_max[3] - min_max[0],
        sy = min_max[4] - min_max[1],
        sz = min_max[5] - min_max[2],
        cx = 0.5 * (min_max[3] + min_max[0]),
        cy = 0.5 * (min_max[4] + min_max[1]),
        cz = 0.5 * (min_max[5] + min_max[2]))
    [
        [min_max[0], min_max[1], min_max[2]], //min
        [min_max[3], min_max[4], min_max[5]], //max
        [sx, sy, sz],                             //size
        [cx, cy, cz],                             //center
        mb_prismoid_validate(shape) //validation
    ];

function mb_prismoid_shape_resolve(shape, height, radius) =
    let(s = [
            mb_prismoid_plane_resolve(mb_prismoid_plane(shape, 0)),
            mb_prismoid_plane_resolve(mb_prismoid_plane(shape, 1))
        ],
        r = mb_prismoid_radius_resolve(radius),
        ar = [
            mb_prismoid_plane_add_radius(s[0], r[0], 0, height),
            mb_prismoid_plane_add_radius(s[1], r[1], 1, height)
        ]
    )
    [
        ar[0],
        ar[1],
        mb_prismoid_process(ar)
    ];

function mb_prismoid_rplane_resolve(v) =
    is_undef(v) || is_string(v) ? 
        [for (i = [0:7]) undef] :

    is_num(v) ?
        [for (i = [0:7]) [v, v, v]] :

    len(v) == 3 && is_num(v[0]) && is_num(v[1]) && is_num(v[2]) ?
        [for (i = [0:7]) v] :

    let(l = len(v),
        ls = l < 8)
    [
        for (i = [0:7])
            mb_resolve_xyz(ls ? (i % 2 == 0 ? v[i / 2] : undef) : v[i], default = undef) //TODO check length v
    ];

function mb_prismoid_radius_resolve(radius) =
    let(full_radius = is_list(radius) && is_list(radius[0]),
        rplane = full_radius ? undef : mb_prismoid_rplane_resolve(radius))
    [
        mb_prismoid_rplane_resolve(full_radius ? mb_prismoid_plane(radius, 0) : rplane),
        mb_prismoid_rplane_resolve(full_radius ? mb_prismoid_plane(radius, 1) : rplane)
    ];

function mb_prismoid_plane_add_radius(a, b, p, height) =
    [
        for (i = [0:7])
            let(
                ai = i < len(a) ? a[i] : undef,
                bi = i < len(b) ? b[i] : undef
            )
            is_undef(ai) ? 
                undef :

            // Spezialfall: z fehlt in a, aber b vorhanden
            (!is_undef(ai[2]) ? false : !is_undef(bi)) ?
                [ai[0], ai[1], is_list(height) ? height[p] : (p == 0 ? -1 : 1) * 0.5 * height, bi] :

            // sonst a unverändert
            ai
    ];

function mb_combine_shape(shape0, shape1) = 
    [];

function mb_cube_to_prismoid(size, radius) =
    let(hw = 0.5 * size[0],
        hh = 0.5 * size[1])
    mb_prismoid_shape_resolve([[[-hw, -hh], [-hw, hh], [hw, hh], [hw, -hh]]], size[2], radius);
        

/*
* ---------
* END UTILS
* ---------
*/

/*
* ------------
* START SHAPES
* ------------
*/

/**
* PRISMOID
*/
module mb_prismoid(shape, height = undef, radius = 0, socket_top = undef, socket_bottom = undef, align = "sticky", resolution = 80, skip_resolve = false, debug = false){
    shape = skip_resolve ? shape : mb_prismoid_shape_resolve(shape, height, radius);
    
    if(debug){
        echo (shape = shape);
    }

    if(shape[2][4][0] != "ok"){
        echo(str("ERROR: ", shape[2][4][0], " / ", shape[2][4][1], " / ", shape[2][4][2]));
    }
    else{
    
        sx = shape[2][2][0];
        sy = shape[2][2][1];
        sz = shape[2][2][2];
        
        cx = shape[2][3][0];
        cy = shape[2][3][1];
        cz = shape[2][3][2];
        
        align = align == "sticky" ? "sticky" : mb_align_resolve(align);
        center = align[0] == "center" && align[1] == "center" && align[2] == "center";

        t = align == "sticky" ? 
            [0, 0, 0] :
            center ? [-cx, -cy, -cz] : [-cx + 0.5 * sx, -cy + 0.5 * sy, -cz + 0.5 * sz];

        translate(t){
            hull(){
                for(i = [0 : 1 : 1]){
                    plane = mb_prismoid_plane(shape, i);
                    for(j = [0 : 1 : len(plane) - 1]){
                        point = mb_point(shape, i, j);
                        if(point != undef){
                            corner = mb_point_corner(shape, i, j);

                            if(corner != undef){
                                rad = mb_point_radius(shape, i, j);
                                prev_point = mb_prev_point(shape, i, j);
                                next_point = mb_next_point(shape, i, j);
                                inv_point = mb_inv_point(shape, i, j);
                                inv_dis = mb_point_distance(point, inv_point);
                                
                                socket_point = mb_socket_point(point, inv_point, socket_top, socket_bottom, i);
                                angle = mb_corner_angle(corner, prev_point, point, next_point, socket_point != undef ? socket_point : inv_point);

                                if(debug){
                                    echo(level = i, corner = j, ang = angle, pp = prev_point, p = point, np = next_point, ip = inv_point, inv_dis = inv_dis);
                                }

                                translate(point) 
                                    mb_rounding_corner(corner = corner, radius = rad, angle = angle, resolution = resolution, debug = debug);

                                if(socket_point != undef){
                                    translate(socket_point) 
                                        mb_rounding_corner(corner = corner, radius = [rad[0], rad[1], 0], angle = angle, resolution = resolution, debug = debug);
                                }
                            }
                            else{
                                echo(str("Could not resolve point: [", i, ", ", j, "]"));
                            }
                        }
                    }
                }
            }
        }
    }
}

/**
* CUBE
*/
module mb_cube(size, radius = 0, xyz_rad = false, center = true, resolution = 80, debug = false){
    size = mb_resolve_xyz(xyz = size);
    rad0 = radius == 0 || radius == [0, 0, 0] || (xyz_rad && (radius == [[0,0,0,0],[0,0,0,0],[0,0,0,0]]));

    if(rad0){
        cube(size, center = center);
    }
    else{
        rad = xyz_rad ? mb_xyz_rad_convert(radius) : radius;

        mb_prismoid(shape = mb_cube_to_prismoid(size, rad), skip_resolve = true, align = center ? "center" : "start", resolution = resolution, debug = debug);
    }
}

/*
* ----------
* END SHAPES
* ----------
*/





/*
* ----------------------
* START TESTING (REMOVE)
* ----------------------
*/


*mb_pseudo_ellipse_ring(
    s=[20, 10, 10],
    resolution=100,
    h=0.2,
    capWidth=0.1,
    //capStep=0.001,
    capThreshold=0.15,
    corner = [0,6]
);





sr = [80, 10.1, 10];
corner = [1,0];


*color("#ffffff55")
mb_rounding_corner(corner = corner, radius = sr, angle = [0, 0, 0, 0], resolution = 80);



*mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-0, -50], undef, [-0, 50], undef, [40, 50], undef, [40, -50], undef]
], height = 120, socket_bottom = 20, socket_top = undef, radius = 0, resolution = 160);

*mb_prismoid(shape = [
    [[-70, -50], [-140, 0], [-70, 50], undef, [50, 40], undef, [50, -40], undef],
    
    [[-20, -30], [-70, 0], [-20, 30], undef, [20, 40], undef, [50, -40], undef]
], height = 120, socket_bottom = 20, radius = [10, 4, 6], resolution = 160, debug=true, align="sticky");

//mb_cube(center = false, size = [120, 80, 50], radius = [[5, 10, 15, 20],0,  0], xyz_rad = true);

mb_cube(debug = true, size = [120, 80, 50], radius = [[[25, 25, 0], [25, 25, 0], [25, 25, 0], [25, 25, 0]], [[25, 5, 15], [25, 5, 15], [25, 5, 15], [25, 5, 15]]]);

//mb_cube(size = [120, 80, 50]);
//color("#ffffffaa")
//cube(size = [120, 80, 50], center = true);


//mb_cube(center = false, size = [120, 80, 50]);
*mb_prismoid(shape = [
    [[-20, -30, undef, [10,10,0]], [-20, 30, undef,[10,10,0]], [50, 30,undef, [10,10,0]], [50, -30,undef, [10,10,0]]],
    [[-20, -30, undef,[10,10,0]], [-20, 30,undef, [10,10,0]], [20, 30, undef,[10,10,0]], [20, -30, undef,[10,10,0]]]
    
], height = 120, socket_top = 20, radius = 0, resolution = 160);



*mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-20, -50], undef, [-20, 50], undef, [40, 40], undef, [20, -50], undef]
], height = 120, socket_bottom = 20, socket_top = 20, radius = 0, resolution = 160, debug=true);

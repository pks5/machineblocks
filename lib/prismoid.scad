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

function mb_resolve_xyz(xyz, min_value = undef, z_value = undef) = 
    let(r = is_list(xyz) ? 
        ([is_num(xyz[0]) ? xyz[0] : 0, is_num(xyz[1]) ? xyz[1] : 0, z_value != undef ? z_value : (is_num(xyz[2]) ? xyz[2] : 0)]) : 
        is_num(xyz) ? [xyz, xyz, xyz] : [0, 0, 0])
    min_value == undef ? r : [max(min_value, r[0]), max(min_value, r[1]), max(min_value, r[2])];
    

function mb_corner_offset(c, r, f = 0.5) = [
        (c[1] == 0 || c[1] == 1 || c[1] == 2 || c[1] == 3 ? -1 : 1) * f * r[0],
        (c[1] == 0 || c[1] == 1 || c[1] == 6 || c[1] == 7 ? -1 : 1) * f * r[1],
        (c[0] == 0 ? -1 : 1) * f * r[2]
    ];

module mb_rounding_corner(corner = [0, 0], radius = 0, angle = [0, 0, 0, 0], resolution = 80){
    radius = mb_resolve_xyz(xyz = radius, min_value = 0.000001);
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

            if((radius[0] != 0 && radius[1] != 0 && radius[2] != 0) && (true || radius[0] != radius[1] || radius[1] != radius[2])){
                //hull()
                mb_pseudo_ellipse_ring(
    
                    s = radius,
                    resolution = resolution,
                    h = 0.001
                );
            }
            else{
                scale(rad_rel)
                    sphere(r = max_rad, $fn = resolution);
            }
        }
}

module mb_rect_corner(corner = [0, 0]){

}

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

function mb_point(shape, height, i = 0, j = 0) = 
    let(l = len(shape) == 1 ? 0 : i)
    shape[l][j] != undef ? mb_resolve_xyz(xyz = shape[l][j], z_value = (i == 0 ? -1 : 1) * 0.5 * height) : undef;

function mb_prev_point(shape, height, i = 0, j = 0) = 
    let(prev_index = (j - 1 + 8) % 8,
        p = mb_point(shape = shape, height, i, prev_index))
    p != undef ? p : mb_prev_point(shape, height, i, prev_index); 

function mb_next_point(shape, height, i = 0, j = 0) = 
    let(p = mb_point(shape = shape, height, i, (j + 1) % 8))
    p != undef ? p : mb_next_point(shape, height, i, (j + 1) % 8); 

function mb_inv_point(shape, height, i = 0, j = 0) = 
    mb_point(shape, height, i == 0 ? 1 : 0, j);

function mb_socket_point(point, socket, i = 0) =
    socket != undef && ((i == 0 && socket > 0) || (i == 1 && socket < 0)) ?
                        [point[0], point[1], point[2] + (socket > 0 ? 1 : -1) * socket] : undef;

function mb_point_radius(shape, i, j, radius) =
    let(l = len(shape) == 1 ? 0 : i)
        shape[l][j] != undef ? 
            (shape[l][j][2] != undef ? shape[l][j][2] : 
                (
                    is_list(radius) && is_list(radius[0]) && len(radius[0]) == len(shape[0]) ? 
                    radius[len(radius) == 1 ? 0 : i][j] :
                    is_list(radius) && len(radius) <= 2 && (is_num(radius[0]) || (is_list(radius[0]) && len(radius[0]) == 3 && is_num(radius[0][0]) && is_num(radius[0][1]) && is_num(radius[0][2]))) ?
                    radius[len(radius) == 1 ? 0 : i] : 
                    radius
                )
            ) :
              undef;

function mb_point_corner(shape, i, j) = 
    let(sl = len(shape[len(shape) == 1 ? 0 : i]))
    sl <= 4 ? 
    [i, 2 * j] : 
    ((sl <= 8 || j < 8) ? [i, j] : [i, 0]);

function mb_min_max_points(shape, height, i = 0, j = 0, min_max = [[0, 0], [0, 0]]) =
    let ( p = mb_point(shape, height, i, j))
    i < len(shape) ? (j < len(shape[i]) ? mb_min_max_points(shape, height, i, j + 1, p == undef ? min_max : [[min(min_max[0][0], p[0]), min(min_max[0][1], p[1])], [max(min_max[1][0], p[0]), max(min_max[1][1], p[1])]]) : mb_min_max_points(shape, height, i + 1, 0, min_max)) : min_max;

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


module mb_prismoid(shape, height, socket = undef, radius = 0, center = true, resolution = 80){
    min_max = mb_min_max_points(shape, height);

    sx = min_max[1][0] - min_max[0][0];
    sy = min_max[1][1] - min_max[0][1];
    tx = - 0.5 * (min_max[1][0] + min_max[0][0]);
    ty = - 0.5 * (min_max[1][1] + min_max[0][1]);
    echo(min_max = min_max, sx = sx, sy = sy, tx = tx, ty = ty);

    t = center ? [tx, ty, 0] : [tx + 0.5 * sx, ty + 0.5 * sy, 0.5 * height];

    translate(t){
        hull(){
            for(i = [0 : 1 : 1]){
                for(j = [0 : 1 : len(shape[shape[i] != undef ? i : 0]) - 1]){
                    point = mb_point(shape, height, i, j); //mb_resolve_xyz(xyz = shape[i][j], z_value = z_val);
                    if(point != undef){
                        corner = mb_point_corner(shape, i, j);
                        rad = mb_point_radius(shape, i, j, radius);
                        socket_point = mb_socket_point(point, socket, i);
                        //z_val = (i == 0 ? -1 : 1) * 0.5 * height;
                        
                        prev_point = mb_prev_point(shape, height, i, j); //mb_resolve_xyz(xyz = shape[i][(j + 8 - 2) % 8], z_value = z_val);
                        
                        next_point = mb_next_point(shape, height, i, j); //mb_resolve_xyz(xyz = shape[i][(j+2) % 8], z_value = z_val);
                        
                        //z_val_top = (i == 0 ? 1 : -1) * 0.5 * height;
                        inv_point = socket_point != undef ? socket_point : mb_inv_point(shape, height, i, j); //mb_resolve_xyz(xyz = shape[i + (i == 0 ? 1 : -1)][j], z_value = z_val_top);
                        
                        angle = mb_corner_angle(corner, prev_point, point, next_point, inv_point);

                        echo(level = i, corner = j, ang = angle, pp = prev_point, p = point, np = next_point, ip = inv_point);
                        
                        //if(j % 2 == 0){
                            translate(point) 
                                mb_rounding_corner(corner = corner, radius = rad, angle = angle, resolution = resolution);

                            if(socket_point != undef){
                                translate(socket_point) 
                                    mb_rounding_corner(corner = corner, radius = [rad[0], rad[1], 0], angle = angle, resolution = resolution);
                            }
                        //}
                    }
                }
            }
        }
    }
}

module mb_rounded_rect_ext(size, radius = 0, xyz_rad = false, center = true, resolution = 80){
    size = mb_resolve_xyz(xyz = size);
    rad = xyz_rad ? mb_xyz_rad_convert(radius) : radius;

    hw = 0.5 * size[0];
    hh = 0.5 * size[1];

    shape = [
        [[-hw, -hh], [-hw, hh], [hw, hh], [hw, -hh]]
    ];
    
    mb_prismoid(shape = shape, height = size[2], radius = rad, center = center, resolution = resolution);
}




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
    center=true
) {

    startAngle = 0;
    endAngle = 360;

    x_smallest = s[0] < s[1] && s[0] < s[2];
    y_smallest = s[1] < s[0] && s[1] < s[2];

    radius = x_smallest ? 
        [max(0.0001, s[2]), max(0.0001, s[1]), max(0.0001, s[0])] :
        y_smallest ?
        [max(0.0001, s[0]), max(0.0001, s[2]), max(0.0001, s[1])] :
        s;

    rot = x_smallest ? [0, 90, 0] : y_smallest ? [90, 0, 0] : [0, 0, 0];

    rx = radius[0] - radius[2];
    ry = radius[1] - radius[2];

    max_r = max(abs(rx), abs(ry));
    min_r = max(0.001, min(abs(rx), abs(ry)));

    // Grundauflösung für normalen Kreis
    baseStep = 360 / resolution;

    // adaptive Grenzen
    minStep = baseStep / sqrt(max_r / min_r);
    maxStep = baseStep * 1.5;

    // maximale Krümmung liegt ungefähr am kleinen Radius-Ende
    kMax = max(
        mb_pe_curvature(rx, ry, 0),
        mb_pe_curvature(rx, ry, 90),
        mb_pe_curvature(rx, ry, 180),
        mb_pe_curvature(rx, ry, 270)
    );

    angles = mb_pe_adaptive_angles(
        rx, ry,
        startAngle, endAngle,
        baseStep,
        minStep,
        maxStep,
        kMax
    );

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
                            $fn = resolution // max(8, ceil(radius[2] / max_r * resolution))
                        );
        }
    }
}



sr = [20, 12, 0];
//hull()

//rotate([90,0,0]) // y => z, z => x, x => y 
//rotate([0,90,0]) // x => z, y => x, z => y 
color("red")
hull()
mb_pseudo_ellipse_ring(
    
    s = sr,
    resolution = 100,
    h = 0.001
);

*color("#ffffff55")
mb_rounding_corner(corner = [0, 4], radius = sr, angle = [0, 0, 0, 0], resolution = 80);

//cube([64, 20, 10], center = true);


//sphere(r = 20, $fn = 100);

*mb_prismoid(shape = [
    [[-70, -50], undef, [-200, 50], undef, [50, 40], undef, [50, -90], undef],
    
    [[-70, -50], undef, [-200, 50], undef, [50, 40], undef, [50, -90], undef]
], height = 120, socket = 0, radius = 10, resolution = 160);


mb_prismoid(shape = [
    [[-70, -50], [-140, 0], [-70, 50], undef, [50, 40], undef, [50, -40], undef],
    
    [[-20, -30], [-70, 0], [-20, 30], undef, [20, 40], undef, [50, -40], undef]
], height = 120, socket = 30, radius = [10, 3, 6], resolution = 160);

*mb_rounded_rect_ext(center = false, size = [120, 80, 50], radius = [[5, 10, 15, 20],0,  0], xyz_rad = true);

*mb_rounded_rect_ext(size = [120, 80, 50], radius = [[[25, 25, 0], [25, 25, 0], [25, 25, 0], [25, 25, 0]], [[25, 5, 15], [25, 5, 15], [25, 5, 15], [25, 5, 15]]]);
//color("#ffffffaa")
//cube(size = [120, 80, 50], center = true);



*mb_prismoid(shape = [
    [[-20, -30, [10,10,0]], [-20, 30, [10,10,0]], [50, 30, [10,10,0]], [50, -30, [10,10,0]]],
    [[-20, -30, [10,10,0]], [-20, 30, [10,10,0]], [20, 30, [10,10,0]], [20, -30, [10,10,0]]]
    
], height = 120, socket = 20, radius = 0, resolution = 160, center = true);


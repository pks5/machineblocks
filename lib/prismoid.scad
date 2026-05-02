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
            scale(rad_rel)
                sphere(r = max_rad, $fn = resolution);
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



module mb_prismoid(shape, height, socket = undef, radius = 0, center = true, resolution = 80){
    hull(){
        for(i = [0 : 1 : 1]){
            for(j = [0 : 1 : 7]){
                if(shape[i][j] != undef){
                    z_val = (i == 0 ? -1 : 1) * 0.5 * height;
                    prev_point = mb_resolve_xyz(xyz = shape[i][(j + 8 - 2) % 8], z_value = z_val);
                    point = mb_resolve_xyz(xyz = shape[i][j], z_value = z_val);
                    next_point = mb_resolve_xyz(xyz = shape[i][(j+2) % 8], z_value = z_val);
                    
                    z_val_top = (i == 0 ? 1 : -1) * 0.5 * height;
                    top_point = mb_resolve_xyz(xyz = shape[i + (i == 0 ? 1 : -1)][j], z_value = z_val_top);
                    
                    angle = mb_corner_angle([i, j], prev_point, point, next_point, top_point);

                    echo(level = i, corner = j, ang = angle);
                    
                    if(j % 2 == 0){
                        translate(point) 
                            mb_rounding_corner(corner = [i, j], radius = radius, angle = angle, resolution = resolution);

                        if(socket != undef && ((i == 0 && socket > 0) || (i == 1 && socket < 0))){
                            translate([point[0], point[1], point[2] + (socket > 0 ? 1 : -1) * socket]) 
                            mb_rounding_corner(corner = [i, j], radius = 0, angle = angle, resolution = resolution);
                        }
                    }
                }
            }
        }
    }
}

module mb_rounded_rect(size, radius = 0, center = true, resolution = 80){
    size = mb_resolve_xyz(xyz = size);
    hw = 0.5 * size[0];
    hh = 0.5 * size[1];

    shape = [
        [[-hw, -hh], undef, [-hw, hh], undef, [hw, hh], undef, [hw, -hh], undef],
        [[-hw, -hh], undef, [-hw, hh], undef, [hw, hh], undef, [hw, -hh], undef]
    ];
    mb_prismoid(shape = shape, height = size[2], radius = radius, center = center, resolution = resolution);
}

*translate([300, 300, 0])
mb_prismoid(shape = [
    [[-70, -50], undef, [-200, 50], undef, [50, 40], undef, [50, -90], undef],
    
    [[-70, -50], undef, [-200, 50], undef, [50, 40], undef, [50, -90], undef]
], height = 120, socket = 0, radius = 10, resolution = 160);

translate([300, 300, 0])
*mb_prismoid(shape = [
    [[-70, -50], [-120, 0], [-70, 50], undef, [50, 40], undef, [50, -40], undef],
    
    [[-20, -30], [-60, 0], [-20, 30], undef, [20, 40], undef, [50, -40], undef]
], height = 120, socket = 0, radius = 10, resolution = 160);

mb_rounded_rect(size = [120, 80, 20], radius = 5);



mb_rounding_corner(corner = [0, 0], radius = [50,100,50], angle = [-45, 45, 0, 0], resolution = 80);


use <utils.scad>;
use <quad.scad>;
use <core/geometry.scad>;

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
    sz = max(size[2], is_undef(size[3]) ? 0 : size[3]);

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
module mb_rounding_corner(
        corner = [0, 0], 
        radius = 0, 
        angle = [0, 0, 0, 0], 
        zero = 0.001, 
        precision = 0.01, 
        resolution = 80, 
        debug = false
){
    radius = mb_resolve_quad(xyz = radius, min_value = zero);
    
    off_corner = mb_corner_offset(corner, radius);
    off = mb_corner_offset(corner, radius, -1);
    
    multmatrix(m = [ 
                    [1,             angle[1] / 45, angle[2] / 45, 0],
                    [angle[0] / 45, 1,             angle[3] / 45, 0],
                    [0,             0,             1,             0]
                   ]) 
    translate(off)
        intersection(){
            translate(off_corner)
                mb_corner_cut(radius, corner);
                
            mb_pseudo_ellipse_ring(
                //corner = corner,
                radius=radius,
                resolution=resolution,
                zero = zero,
                precision = precision
            );
        }
}

module mb_rounded_ellipse_disk_xyz(x, y, zy, zx, hs = 0.5, n = 48, zero = 0.001, resolution = 96) {
    rz = max(zx, zy);
    h = 2 * rz;

    module ellipse_cylinder(rx, ry, height) {
        if ((x >= zx) && (y >= zy)) {
            scale([rx, ry, 1])
                cylinder(h = height, r = 1, center = false, $fn = resolution);
        } else {
            min_r = 0.01;

            rx2 = max(rx, min_r);
            ry2 = max(ry, min_r);

            ix = x - rx2;
            iy = y - ry2;

            split_x = (zx == rz) && (zx > x);
            split_y = (zy == rz) && (zy > y);

            dx = split_x ? max(0, zx - ix) : 0;
            dy = split_y ? max(0, zy - iy) : 0;

            xs = split_x ? [-1, 1] : [0];
            ys = split_y ? [-1, 1] : [0];

            eps = 0.01;
            big = max(x, y, zx, zy) * 4 + 10;

            if (rx > min_r && ry > min_r && height > 0) {
                for (sx = xs)
                for (sy = ys) {
                    translate([sx * dx, sy * dy, 0])
                        intersection() {
                            scale([rx2, ry2, 1])
                                cylinder(h = height, r = 1, center = false, $fn = resolution);

                            translate([
                                sx < 0 ? -big : (sx > 0 ? -eps : -big),
                                sy < 0 ? -big : (sy > 0 ? -eps : -big),
                                -eps
                            ])
                                cube([
                                    sx == 0 ? 2 * big : big + eps,
                                    sy == 0 ? 2 * big : big + eps,
                                    height + 2 * eps
                                ], center = false);
                        }
                }
            }
        }
    }

    function inset_at(zpos, r) =
        let(d = abs(zpos))
        r == rz
            // großer Radius: durchgehend über volle Höhe
            ? r - sqrt(max(0, r*r - d*d))

            // kleiner Radius: nur oben/unten, konvex
            : d >= (rz - r)
                ? r - sqrt(max(0, r*r - pow(rz - d - r, 2)))
                : 0;

    for (i = [0 : 2*n - 1]) {
        z0 = -rz + i     * h / (2*n);
        z1 = -rz + (i+1) * h / (2*n);

        ix = inset_at(z0, zx);
        iy = inset_at(z0, zy);

        translate([0, 0, z0])
            ellipse_cylinder(
                x - ix,
                y - iy,
                hs*max(z1 - z0, zero)
            );
    }
}

/**
* PSEUDO ELLIPSE RING
*/
module mb_pseudo_ellipse_ring(
    radius=[40, 25, 3],
    zero = 0.001,
    precision = 0.01,
    resolution = 32
) {
    s = mb_resolve_quad(xyz = radius, min_value = zero, precision = precision);
    
    if((s[0] <= zero && s[1] <= zero) 
        || (s[0] <= zero && s[2] <= zero) 
        || (s[1] <= zero && s[2] <= zero)){
        // At least 2 rad are zero
        cube(size=[zero, zero, zero], center = true);
    }
    else if((s[0] <= zero || s[1] <= zero || s[2] <= zero)
        || (s[0] == s[1]) && (s[0] == s[2]) && (s[1] == s[2])){
        // One rad zero or all rad are same
        max_rad = max(s[0], s[1], s[2]);
        rad_rel = [s[0] / max_rad, s[1] / max_rad, s[2] / max_rad];
        scale(rad_rel)
            sphere(r = max_rad, $fn = resolution);    
    }
    else{
        echo(s = s);
        mb_rounded_ellipse_disk_xyz(s[0], s[1], s[2], (len(s) < 4) || is_undef(s[3]) ? s[2] : s[3], resolution = resolution);
    }
}

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
    (c[0] == 0 ? -1 : 1) * f * max(r[2], is_undef(r[3]) ? 0 : r[3])
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

function mb_point_distance(p1, p2, ab = false) = 
    is_undef(p1) || is_undef(p2) ? undef : ab ? [abs(p2.x - p1.x), abs(p2.y - p1.y), abs(p2.z - p1.z)] : [p2.x - p1.x, p2.y - p1.y, p2.z - p1.z];

function mb_point_add(p1, p2) = 
    is_undef(p1) || is_undef(p2) ? undef : [p1.x + p2.x, p1.y + p2.y, p1.z + p2.z];

function mb_socket_point(point, inv_point, socket_top = undef, socket_bottom = undef, i = 0) =
    socket_bottom > 0 && (i == 0) ?
                        [point[0], point[1], point[2] + socket_bottom] : 
    socket_top > 0 && (i == 0) ? 
                        [inv_point[0], inv_point[1], inv_point[2] - socket_top] : 

    socket_top > 0 && (i == 1) ?
                        [point[0], point[1], point[2] - socket_top] :  
    socket_bottom > 0 && (i == 1) ?
                        [inv_point[0], inv_point[1], inv_point[2] + socket_bottom] : undef;   

function mb_socket_point_bottom(point, inv_point, inv_dis, socket, i) =
    socket[0] <= 0 ? undef : (i == 0) ?
                        ((inv_dis[0] < 0 || inv_dis[1] < 0) ? [point[0], point[1], point[2] + socket[0]] : undef) : 
                        ((inv_dis[0] > 0 || inv_dis[1] > 0) ? [inv_point[0], inv_point[1], inv_point[2] + socket[0]] : undef);
    
function mb_socket_point_top(point, inv_point, inv_dis, socket, i) =
    socket[1] <= 0 ? undef : (i == 1) ?
                        ((inv_dis[0] < 0 || inv_dis[1] < 0) ? [point[0], point[1], point[2] - socket[1]] : undef) : 
                        ((inv_dis[0] > 0 || inv_dis[1] > 0) ? [inv_point[0], inv_point[1], inv_point[2] - socket[1]] : undef);            

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
* FACES
*/



/*
* PRISMOID SHAPE
*/



function mb_prismoid_plane(shape, i) =
    i > 1 ? undef : shape[(len(shape) == 1 || is_undef(shape[1])) ? 0 : i];

function mb_prismoid_plane_resolve(a) =
    let(la = is_undef(a) ? undef : len(a))
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

//TODO - 
function mb_prismoid_min_points(a) =
    (a[0] != undef && a[2] != undef && a[4] != undef)
    || (a[0] != undef && a[2] != undef && a[6] != undef)
    || (a[0] != undef && a[4] != undef && a[6] != undef)
    || (a[2] != undef && a[4] != undef && a[6] != undef);

function mb_prismoid_validate(shape) = 
    len(shape) != 2 ? ["invalid_shape", len(shape)] :
    len(shape[0]) != 8 ? ["invalid_plane_length", 0, len(shape[0])] :
    len(shape[1]) != 8 ? ["invalid_plane_length", 1, len(shape[1])] :
    //!mb_prismoid_min_points(shape[0])  ? ["point_missing", 0] :
    //!mb_prismoid_min_points(shape[1])  ? ["point_missing", 1] :
    mb_prismoid_plane_checksum(shape[0]) != mb_prismoid_plane_checksum(shape[1]) ? ["point_mismatch"] :
    ["ok"];

function mb_prismoid_process(planes, static, skip_validate = false) = 
    let(min_max = mb_min_max_points(planes),
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
        [cx, cy, cz],   //center
        static, // static data                            
        skip_validate ? ["ok"] : mb_prismoid_validate(planes) //validation
    ];

function mb_prismoid_rplane_resolve(v) =
    is_undef(v) || is_string(v) ? 
        [for (i = [0:7]) undef] :

    is_num(v) ?
        [for (i = [0:7]) [v, v, v]] :

    len(v) == 3 && is_num(v[0]) && is_num(v[1]) && is_num(v[2]) ?
        [for (i = [0:7]) v] :

    len(v) == 4 && is_num(v[0]) && is_num(v[1]) && is_num(v[2]) && is_num(v[3]) ?
        [for (i = [0:7]) v] :

    let(l = len(v),
        ls = l <= 4)
    [
        for (i = [0:7])
            mb_resolve_quad(ls ? (i % 2 == 0 ? v[i / 2] : undef) : v[i], default = undef) //TODO check length v
    ];

function mb_prismoid_aplane_resolve(v) =
    is_undef(v) || is_string(v) ? 
        [for (i = [0:7]) undef] :

    let(l = len(v),
        ls = l <= 4)
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

function mb_prismoid_plane_resolve_points(shape, i, mul = undef, add = undef, height = undef, radius = undef) =
    let(a = shape[i],
        h = is_undef(height) ? 1 : height,
        az = is_list(h) ? h[i] : (i == 0 ? -1 : 1) * 0.5 * h,
        mul = mb_resolve_quad(mul, default = [1, 1, 1, 1]))
    [
        for (j = [0:7])
            let(
                ai = j < len(a) ? a[j] : undef,
                bi = mb_resolve_quad(is_list(radius) && (j < len(radius)) ? radius[j] : undef, mul = mul, default = undef),
                ad = mb_resolve_xyz(is_undef(add) ? undef : add[j])
            )
            is_undef(ai) ? 
                undef :
            [
                (ai[0] + ad[0]) * mul[0], 
                (ai[1] + ad[1]) * mul[1], 
                ((len(ai) < 3 || is_undef(ai[2])) ? az : ai[2]) * mul[2], 
                (len(ai) < 4 || is_undef(ai[3])) && !is_undef(bi) ? 
                    bi : 
                    (len(ai) > 3 ? mb_resolve_quad(ai[3], mul = mul) : undef)
            ]
    ];

function mb_prismoid_shape_resolve(
    shape, 
    height = undef, 
    socket = undef, 
    radius = undef, 
    mul = undef, 
    add = undef, 
    expand = undef
) =
    let(
        meta_data = len(shape) > 2 && !is_undef(shape[2]) && is_list(shape[2]) ? shape[2] : undef,
        height = is_undef(height) ? (!is_undef(meta_data) && !is_undef(meta_data[0]) ? meta_data[0] : undef) : height,
        sck = is_undef(socket) ? (!is_undef(meta_data) && !is_undef(meta_data[1]) ? meta_data[1] : undef) : socket,
        radius = is_undef(radius) ? (!is_undef(meta_data) && !is_undef(meta_data[2]) ? meta_data[2] : undef) : radius,
        expand = is_undef(expand) ? (!is_undef(meta_data) && !is_undef(meta_data[3]) ? meta_data[3] : undef) : expand,
        
        mul = mb_resolve_quad(mul, default=[1,1,1,1]),
        s = [
            mb_prismoid_plane_resolve(mb_prismoid_plane(shape, 0)),
            mb_prismoid_plane_resolve(mb_prismoid_plane(shape, 1))
        ],
        a = [
            mb_prismoid_aplane_resolve(is_undef(add) ? undef : mb_prismoid_plane(add, 0)),
            mb_prismoid_aplane_resolve(is_undef(add) ? undef : mb_prismoid_plane(add, 1))
        ],
        r = mb_prismoid_radius_resolve(radius),
        ar = [
            mb_prismoid_plane_resolve_points(s, 0, mul = mul, add = a[0], height = height, radius = r[0]),
            mb_prismoid_plane_resolve_points(s, 1, mul = mul, add = a[1], height = height, radius = r[1])
        ],
        ex = is_undef(expand) ? ar : [
           mb_prismoid_plane_expand(ar[0], 0, mb_prismoid_plane(expand, 0), mul),
           mb_prismoid_plane_expand(ar[1], 1, mb_prismoid_plane(expand, 1), mul)
        ]
    )
    [
        ex[0],
        ex[1],
        undef,
        mb_prismoid_process(ex, [is_undef(sck) ? [0, 0] : [sck[0] * mul[2], sck[1] * mul[2]]])
    ];







/*
* ---------
* END UTILS
* ---------
*/

/*
* ------------
* START PUBLIC
* ------------
*/



/**
* PRISMOID
*/
module mb_prismoid(
    shape, 
    height = undef, 
    radius = undef, 
    add = undef,
    mul = undef, 
    expand = undef,
    socket = undef, 
    align = "sticky", 
    resolution = 80, 
    resolve = undef, 
    debug = false
){
    shape = resolve == true || (len(shape) < 4) || is_undef(shape[3]) ? 
        mb_prismoid_shape_resolve(shape = shape, socket = socket, height = height, radius = radius, mul = mul, add = add, expand = expand)
        : shape;
    
    if(debug){
        echo (shape = shape);
    }

    if(shape[3][5][0] != "ok"){
        echo(str("ERROR: ", shape[4][5][1]));
    }
    else{
        sck = shape[3][4][0];

        sx = shape[3][2][0];
        sy = shape[3][2][1];
        sz = shape[3][2][2];
        
        cx = shape[3][3][0];
        cy = shape[3][3][1];
        cz = shape[3][3][2];

        center_point = shape[3][3];
        off = [-cx + 0.5 * sx, -cy + 0.5 * sy, -cz + 0.5 * sz];
        
        align = align == "sticky" ? "sticky" : mb_align_resolve(align);
        center = align[0] == "center" && align[1] == "center" && align[2] == "center";

        t = align == "sticky" ? 
            [0, 0, 0] :
            center ? [-cx, -cy, -cz] : off;

        

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
                                inv_dis = mb_point_distance(mb_point_distance(center_point, point, true), mb_point_distance(center_point, inv_point, true));
                                
                                

                                socket_point_bottom = mb_socket_point_bottom(point, inv_point, inv_dis, sck, i);
                                socket_point_top = mb_socket_point_top(point, inv_point, inv_dis, sck, i);

                                angle = mb_corner_angle(corner, prev_point, point, next_point, (socket_point_bottom != undef && socket_point_top != undef) ? inv_point : (socket_point_bottom != undef ? socket_point_bottom : (socket_point_top != undef ? socket_point_top : inv_point)));

                                if(debug){
                                    echo(level = i, 
                                        corner = j, 
                                        ang = angle, 
                                        pp = prev_point, 
                                        p = point, 
                                        np = next_point, 
                                        ip = inv_point, 
                                        inv_dis = inv_dis,
                                        spt = socket_point_top,
                                        sptb = socket_point_bottom);
                                }

                                translate(point) 
                                    mb_rounding_corner(corner = corner, radius = rad, angle = angle, resolution = resolution, debug = debug);

                                if(i == 0 && socket_point_bottom != undef){
                                    translate(socket_point_bottom) 
                                        mb_rounding_corner(corner = corner, radius = [rad[0], rad[1], 0], angle = angle, resolution = resolution, debug = debug);
                                }
                                if(i == 1 && socket_point_top != undef){
                                    translate(socket_point_top) 
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



/*
* ----------
* END PUBLIC
* ----------
*/
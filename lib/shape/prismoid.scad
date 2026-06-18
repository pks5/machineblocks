use <../core/utils.scad>;
use <../core/poly_expand.scad>;
use <../core/geometry.scad>;
use <ellioct.scad>;
use <loft_poly.scad>;

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


module mb_rounding_corner(
        corner = [0, 0], 
        radius = 0, 
        angle = [0, 0, 0, 0], 
        zero = 0.001, 
        precision = 0.01, 
        resolution = 80, 
        debug = false
){
    /*
    radius = mb_corner_radius_resolve(
        corner_radius = radius, 
        min_value = zero
    );

    max_rad = mb_corner_radius_max_xyz(radius);
    
    off_corner = mb_corner_offset(corner, max_rad);
    off = mb_corner_offset(corner, max_rad, -1);

    echo(
        radius = radius,
        max_rad = max_rad,
        off_corner = off_corner,
        off = off
    );
    
    
    multmatrix(m = [ 
                    [1,             angle[1] / 45, angle[2] / 45, 0],
                    [angle[0] / 45, 1,             angle[3] / 45, 0],
                    [0,             0,             1,             0]
                   ]) 
    
    
    *translate(off)
        intersection(){
            translate(off_corner)
                mb_corner_cut(max_rad, corner);
                
            mb_corner_ellibox(
                //corner = corner,
                radius=radius,
                resolution=resolution,
                zero = zero,
                precision = precision
            );
        }*/

    s = mb_corner_radius_resolve(
        corner_radius = radius, 
        min_value = zero, 
        precision = precision
    );

    //echo (s = s);
    max_rad = mb_corner_radius_max_xyz(s);

    multmatrix(m = [ 
                    [1,             angle[1] / 45, angle[2] / 45, 0],
                    [angle[0] / 45, 1,             angle[3] / 45, 0],
                    [0,             0,             1,             0]
                   ]){ 
        if(mb_corner_radius_is_none(s, min_value = zero)){
            translate(mb_corner_offset_N(corner, max_rad, f = 0.5))
                cube(size = [zero, zero, zero], center=true);
        }
        else{
            translate(mb_corner_offset_N(corner, max_rad, f = 1))
                mb_ellibox(
                    x_y = s[0][0],
                    y_x = s[0][1],
                    x_z = s[1][0],
                    z_x = s[1][1],
                    y_z = s[2][0],
                    z_y = s[2][1],
                    corner = corner,
                    n_z = resolution,
                    n_a = resolution
                );
        }
    }
}



/**
* PSEUDO ELLIPSE RING
*/
module mb_corner_ellibox(
    radius=[40, 25, 3],
    zero = 0.001,
    precision = 0.01,
    resolution = 32
) {
    s = mb_corner_radius_resolve(
            corner_radius = radius, 
            min_value = zero, 
            precision = precision
        );
    
    if(mb_corner_radius_is_none(s, min_value = zero)){
        echo(none = s);
        // At least 2 rad are zero
        cube(size = [zero, zero, zero], center = true);
    }
    else if(mb_corner_radius_is_sphere(s)){
        echo(sphere = s);
        sphere(
            r = s[0][0],
            $fn = resolution
        );
    }
    else if(mb_corner_radius_is_ellipse_disk(s, min_value = zero)){
        echo(disk = s);
        active = mb_corner_radius_active_pair_index(raw, min_value = zero);

        if(active == 0) {
            // XY disk: [xy, yx]
            scale([s[0][0], s[0][1], zero])
                sphere(r = 1, $fn = resolution);
        }
        else if(active == 1) {
            // XZ disk: [xz, zx]
            scale([s[1][0], zero, s[1][1]])
                sphere(r = 1, $fn = resolution);
        }
        else if(active == 2) {
            // YZ disk: [yz, zy]
            scale([zero, s[2][0], s[2][1]])
                sphere(r = 1, $fn = resolution);
        }
    }
    else{
        echo(elli = s);
       
        mb_ellibox(
            x_y = s[0][0],
            y_x = s[0][1],
            x_z = s[1][0],
            z_x = s[1][1],
            y_z = s[2][0],
            z_y = s[2][1],
            n_z = resolution,
            n_a = resolution
        );
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
    (c[0] == 0 ? -1 : 1) * f * r[2]
];

function mb_corner_offset_N(c, r, f = 0.5) = [
    (c[1] == 0 || c[1] == 1 || c[1] == 2 || c[1] == 3 ? 1 : -1) * f * r[0],
    (c[1] == 0 || c[1] == 1 || c[1] == 6 || c[1] == 7 ? 1 : -1) * f * r[1],
    (c[0] == 0 ? 1 : -1) * f * r[2]
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

function mb_prev_index(shape, i = 0, j = 0) =
    let(
        plane = mb_prismoid_plane(shape, i),
        prev_index = (j - 1 + 8) % 8,
        p = plane[prev_index]
    )
    p != undef ? prev_index : mb_prev_index(shape, i, prev_index); 

function mb_next_index(shape, i = 0, j = 0) =
    let(
        plane = mb_prismoid_plane(shape, i),
        next_index = (j + 1) % 8,
        p = plane[next_index]
    )
    p != undef ? next_index : mb_next_index(shape, i, next_index); 
   
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

function mb_point_distance_length(p1, p2) =
    norm([
        p2[0] - p1[0],
        p2[1] - p1[1],
        p2[2] - p1[2]
    ]);

function mb_point_add(p1, p2) = 
    is_undef(p1) || is_undef(p2) ? undef : [p1.x + p2.x, p1.y + p2.y, p1.z + p2.z];

/*
function mb_socket_point(point, inv_point, socket_top = undef, socket_bottom = undef, i = 0) =
    socket_bottom > 0 && (i == 0) ?
                        [point[0], point[1], point[2] + socket_bottom] : 
    socket_top > 0 && (i == 0) ? 
                        [inv_point[0], inv_point[1], inv_point[2] - socket_top] : 

    socket_top > 0 && (i == 1) ?
                        [point[0], point[1], point[2] - socket_top] :  
    socket_bottom > 0 && (i == 1) ?
                        [inv_point[0], inv_point[1], inv_point[2] + socket_bottom] : undef;    */

function mb_socket_point_bottom(point, inv_point, socket, corner, slope) =
    socket[0] <= 0 ? undef : 
                        ((slope[0] > 0 || slope[1] > 0) ? ((corner[0] == 0) ? [point[0], point[1], point[2] + socket[0]] : [inv_point[0], inv_point[1], inv_point[2] + socket[0]]) : undef);
    
function mb_socket_point_top(point, inv_point, socket, corner, slope) =
    socket[1] <= 0 ? undef : 
                        ((slope[0] < 0 || slope[1] < 0) ? ((corner[0] == 1) ? [point[0], point[1], point[2] - socket[1]] : [inv_point[0], inv_point[1], inv_point[2] - socket[1]]) : undef);            

function mb_point_radius(shape, i, j) =
    let(plane = mb_prismoid_plane(shape, i))
        plane[j] != undef ? (len(plane[j]) > 3 ? plane[j][3] : undef) : undef;

function mb_inv_point_slope(corner, inv_dis) =
    [
        (corner[0] == 0 ? 1 : -1) * (corner[1] < 4 ? 1 : -1) * mb_round_prec(inv_dis[0], 0.001), 
        (corner[0] == 0 ? 1 : -1) * (corner[1] == 0 || corner[1] == 1  || corner[1] == 6 || corner[1] == 7 ? 1 : -1) * mb_round_prec(inv_dis[1], 0.001)
    ];

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
    i > 1 ? undef : shape[(len(shape) == 1 || (!is_undef(shape[0]) && is_undef(shape[1]))) ? 0 : (is_undef(shape[0]) && !is_undef(shape[1]) ? 1 : i)];

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

function mb_prismoid_complexity(shape, static) =
    static[0][0] != 0 || static[0][1] != 0 ? "complex" :
    let(
        rads = [
            for (i = [0:1])
                for (j = [0:7])
                    if(!mb_corner_radius_is_none(shape[i][j][3]))
                        1
        ]
    )
    len(rads) > 0 ? "complex" : "simple";


function mb_prismoid_validate(shape, static) = 
    len(shape) != 2 ? ["invalid_shape", len(shape)] :
    len(shape[0]) != 8 ? ["invalid_plane_length", 0, len(shape[0])] :
    len(shape[1]) != 8 ? ["invalid_plane_length", 1, len(shape[1])] :
    //!mb_prismoid_min_points(shape[0])  ? ["point_missing", 0] :
    //!mb_prismoid_min_points(shape[1])  ? ["point_missing", 1] :
    mb_prismoid_plane_checksum(shape[0]) != mb_prismoid_plane_checksum(shape[1]) ? ["plane_mismatch"] :
    ["ok", mb_prismoid_complexity(shape, static)];

function mb_prismoid_process(planes, static) = 
    let(min_max = mb_min_max_points(planes),
        sx = min_max[3] - min_max[0],
        sy = min_max[4] - min_max[1],
        sz = min_max[5] - min_max[2],
        cx = 0.5 * (min_max[3] + min_max[0]),
        cy = 0.5 * (min_max[4] + min_max[1]),
        cz = 0.5 * (min_max[5] + min_max[2]))
    [
        [min_max[0], min_max[1], min_max[2]], // 0 - min
        [min_max[3], min_max[4], min_max[5]], // 1 - max
        [sx, sy, sz],                         // 2 - size
        [cx, cy, cz],                         // 3 - center
        static,                               // 4 - static data                            
        mb_prismoid_validate(planes, static)  // 5 - validation
    ];

/**
* Resolve radius parameter plane from simple formats
*/
function mb_prismoid_simple_rad_resolve(v) =
    is_undef(v) || is_string(v) ? 
        [for (i = [0:7]) undef] :

    // r or [rxy, rxz, ryz] or [[xy, yx], [xz, zx], [yz, zy]]
    is_num(v) ||
    (
        is_list(v) 
        && len(v) == 3 
        && (is_num(v[0]) || (is_list(v[0]) && len(v[0]) == 2 && is_num(v[0][0]) && is_num(v[0][1])))
        && (is_num(v[1]) || (is_list(v[1]) && len(v[1]) == 2 && is_num(v[1][0]) && is_num(v[1][1])))   
        && (is_num(v[2]) || (is_list(v[2]) && len(v[2]) == 2 && is_num(v[2][0]) && is_num(v[2][1])))
    )
        ? [for (i = [0:7]) v] : undef;


/**
* Resolve radius parameter to planes
*/
function mb_prismoid_radius_resolve(radius) =
    let(
        rplane = mb_prismoid_simple_rad_resolve(radius)
    )
    [
        mb_prismoid_plane_resolve(is_undef(rplane) ? mb_prismoid_plane(radius, 0) : rplane),
        mb_prismoid_plane_resolve(is_undef(rplane) ? mb_prismoid_plane(radius, 1) : rplane)
    ];

/**
* Resolve add parameter plane
* TODO use mb_prismoid_plane_resolve
*/
function mb_prismoid_aplane_resolve(v) =
    is_undef(v) || is_string(v) ? 
        [for (i = [0:7]) undef] :

    let(l = len(v),
        ls = l <= 4)
    [
        for (i = [0:7])
            mb_resolve_xyz(ls ? (i % 2 == 0 ? v[i / 2] : undef) : v[i], default = undef) //TODO check length v
    ];

/**
* Builds the final shape
*/
function mb_prismoid_plane_resolve_points(shape, i, mul = undef, add = undef, height = undef, radius = undef) =
    let(a = shape[i],
        h = is_undef(height) ? 1 : height,
        az = is_list(h) ? h[i] : (i == 0 ? -1 : 1) * 0.5 * h,
        mul = mb_resolve_xyz(mul, default = [1, 1, 1]))
    [
        for (j = [0:7])
            let(
                ai = j < len(a) ? a[j] : undef,
                bi = mb_corner_radius_resolve(
                    corner_radius = is_list(radius) && (j < len(radius)) ? radius[j] : undef, 
                    mul = mul
                ),
                ad = mb_resolve_xyz(is_undef(add) ? undef : add[j])
            )
            is_undef(ai) ? 
                undef :
            [
                (ai[0] + ad[0]) * mul[0], // p.x
                (ai[1] + ad[1]) * mul[1], // p.y
                ((len(ai) < 3 || is_undef(ai[2])) ? az : ai[2]) * mul[2], // p.z
                (len(ai) < 4 || is_undef(ai[3])) && !is_undef(bi) ? 
                    bi : 
                    (len(ai) > 3 ? mb_corner_radius_resolve(corner_radius = ai[3], mul = mul) : undef)
            ]
    ];

function mb_prismoid_is_x_rad_front(prev_index) =
    prev_index == 2 || prev_index == 3 || prev_index == 6 || prev_index == 7;

function mb_prismoid_norm_rad(
    corner,
    point, 
    rad, 
    prev_index, 
    prev_rad, 
    prev_dis_len, 
    next_index, 
    next_rad, 
    next_dis_len,
    inv_rad,
    inv_dis_len,
    spb_dis,
    spt_dis
) =
    let(
        x_y = rad[0][0],
        y_x = rad[0][1],
        x_z = rad[1][0],
        z_x = rad[1][1],
        y_z = rad[2][0],
        z_y = rad[2][1],

        p_x_y = prev_rad[0][0],
        p_y_x = prev_rad[0][1],
        p_x_z = prev_rad[1][0],
        p_z_x = prev_rad[1][1],
        p_y_z = prev_rad[2][0],
        p_z_y = prev_rad[2][1],

        n_x_y = next_rad[0][0],
        n_y_x = next_rad[0][1],
        n_x_z = next_rad[1][0],
        n_z_x = next_rad[1][1],
        n_y_z = next_rad[2][0],
        n_z_y = next_rad[2][1],

        i_z_x = inv_rad[1][1],
        i_z_y = inv_rad[2][1],

        is_x_front = mb_prismoid_is_x_rad_front(corner[1]),
        is_next_x = !mb_prismoid_is_x_rad_front(next_index),
        is_prev_x = mb_prismoid_is_x_rad_front(prev_index),
        
        len_x_y = x_y + (is_x_front ? (is_next_x ? n_x_y : n_y_x) : (is_prev_x ? p_x_y : p_y_x)),
        len_y_x = y_x + (is_x_front ? (is_prev_x ? p_x_y : p_y_x) : (is_next_x ? n_x_y : n_y_x)),

        len_x_z = x_z + (is_x_front ? (is_next_x ? n_x_z : n_y_z) : (is_prev_x ? p_x_z : p_y_z)),
        len_y_z = y_z + (is_x_front ? (is_prev_x ? p_x_z : p_y_z) : (is_next_x ? n_x_z : n_y_z)),

        len_z_x = z_x + i_z_x,
        len_z_y = z_y + i_z_y,

        x_y_rel = len_x_y <= 0 ? 1 : (is_x_front ? next_dis_len : prev_dis_len) / len_x_y,
        y_x_rel = len_y_x <= 0 ? 1 : (is_x_front ? prev_dis_len : next_dis_len) / len_y_x,

        x_z_rel = len_x_z <= 0 ? 1 : (is_x_front ? next_dis_len : prev_dis_len) / len_x_z,
        y_z_rel = len_y_z <= 0 ? 1 : (is_x_front ? prev_dis_len : next_dis_len) / len_y_z,

        z_x_rel = len_z_x <= 0 ? 1 : inv_dis_len / len_z_x,
        z_y_rel = len_z_y <= 0 ? 1 : inv_dis_len / len_z_y,

        x_y_new = x_y_rel >= 1 ? x_y : x_y * x_y_rel,
        y_x_new = y_x_rel >= 1 ? y_x : y_x * y_x_rel,
        x_z_new = x_z_rel >= 1 ? x_z : x_z * x_z_rel,
        y_z_new = y_z_rel >= 1 ? y_z : y_z * y_z_rel,
        z_x_new = z_x_rel >= 1 ? z_x : z_x * z_x_rel,
        z_y_new = z_y_rel >= 1 ? z_y : z_y * z_y_rel,

        new_rad = [[x_y_new, y_x_new], [x_z_new, z_x_new], [y_z_new, z_y_new]]
    )
    [point[0], point[1], point[2], new_rad];

/**
* Normalizes the radius
* TODO implement
*/
function mb_prismoid_normalize_radius(shape, socket) =
    [
        for(i = [0 : 1 : 1])
            let(plane = mb_prismoid_plane(shape, i))
                [ 
                for(j = [0 : 1 : len(plane) - 1])
                    is_undef(plane[j]) ? undef :
                    (
                        let(
                            point = mb_point(shape, i, j),
                            rad = mb_point_radius(shape, i, j),
                            prev_index = mb_prev_index(shape, i, j),
                            prev_rad = mb_point_radius(shape, i, prev_index),
                            prev_point = mb_point(shape, i, prev_index),
                            prev_dis_len = mb_point_distance_length(point, prev_point),
                            next_index = mb_next_index(shape, i, j),
                            next_rad = mb_point_radius(shape, i, next_index),
                            next_point = mb_point(shape, i, next_index),
                            next_dis_len = mb_point_distance_length(point, next_point),
                            inv_point = mb_inv_point(shape, i, j),
                            inv_dis = mb_point_distance(point, inv_point),
                            inv_dis_len = mb_point_distance_length(point, inv_point),
                            inv_rad = mb_point_radius(shape, i == 0 ? 1 : 0, j),
                            corner = mb_point_corner(shape, i, j),
                            slope = mb_inv_point_slope(corner, inv_dis),
                            socket_point_bottom = mb_socket_point_bottom(point, inv_point, socket, corner, slope),
                            socket_point_top = mb_socket_point_top(point, inv_point, socket, corner, slope),
                            spb_dis = is_undef(socket_point_bottom) ? undef : mb_point_distance_length(point, socket_point_bottom),
                            spt_dis = is_undef(socket_point_top) ? undef : mb_point_distance_length(point, socket_point_top),
                        )
                        mb_prismoid_norm_rad(
                            corner = corner,
                            point = point, 
                            rad = rad, 
                            prev_index = prev_index, 
                            prev_rad = prev_rad, 
                            prev_dis_len = prev_dis_len,
                            next_index = next_index, 
                            next_rad = next_rad,
                            next_dis_len = next_dis_len,
                            inv_rad = inv_rad,
                            inv_dis_len = inv_dis_len,
                            spb_dis = spb_dis,
                            spt_dis = spt_dis
                        )
                    )
                ]
    ];

/**
* Recalculates the radius after expand
* TODO implement
*/
function mb_prismoid_recalc_radius(shape_before, shape_after) =
    shape_after;

/**
* Resolves the shape
*/
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
        // Metadata from shape input
        meta_data = len(shape) > 2 && !is_undef(shape[2]) && is_list(shape[2]) ? shape[2] : undef,
        height = is_undef(height) ? (!is_undef(meta_data) && !is_undef(meta_data[0]) ? meta_data[0] : undef) : height,
        sck = is_undef(socket) ? (!is_undef(meta_data) && !is_undef(meta_data[1]) ? meta_data[1] : undef) : socket,
        radius = is_undef(radius) ? (!is_undef(meta_data) && !is_undef(meta_data[2]) ? meta_data[2] : undef) : radius,
        expand = is_undef(expand) ? (!is_undef(meta_data) && !is_undef(meta_data[3]) ? meta_data[3] : undef) : expand,
        
        // Multiplier
        mul = mb_resolve_xyz(mul, default=[1, 1, 1]),

        // Socket
        socket = is_undef(sck) ? [0, 0] : [sck[0] * mul[2], sck[1] * mul[2]],
        
        // Fundamental shape resolve
        s = [
            mb_prismoid_plane_resolve(mb_prismoid_plane(shape, 0)),
            mb_prismoid_plane_resolve(mb_prismoid_plane(shape, 1))
        ],

        // Resolve Add
        // TODO make function
        a = [
            mb_prismoid_aplane_resolve(is_undef(add) ? undef : mb_prismoid_plane(add, 0)),
            mb_prismoid_aplane_resolve(is_undef(add) ? undef : mb_prismoid_plane(add, 1))
        ],
        
        // Calc points and radius
        // TODO make function
        rr = mb_prismoid_radius_resolve(radius),
        rp = [
            mb_prismoid_plane_resolve_points(s, 0, mul = mul, add = a[0], height = height, radius = rr[0]),
            mb_prismoid_plane_resolve_points(s, 1, mul = mul, add = a[1], height = height, radius = rr[1])
        ],
        ar = mb_prismoid_normalize_radius(rp, socket),

        // Calc Expand
        // TODO make function
        ex = is_undef(expand) ? ar : [
           mb_poly_expand(ar[0], 0, mb_prismoid_plane(expand, 0), mul),
           mb_poly_expand(ar[1], 1, mb_prismoid_plane(expand, 1), mul)
        ],
        rc = is_undef(expand) ? ar : mb_prismoid_recalc_radius(ar, ex),
        
        // Static data
        static = [socket]
    )
    [
        rc[0],
        rc[1],
        undef,
        mb_prismoid_process(rc, static)
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
    debug = false,
    color = "white"
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

        min_point = shape[3][0];
        center_point = shape[3][3];
        off = [-cx + 0.5 * sx, -cy + 0.5 * sy, -cz + 0.5 * sz];
        
        align = align == "sticky" ? "sticky" : mb_align_resolve(align);
        center = align[0] == "center" && align[1] == "center" && align[2] == "center";

        t = align == "sticky" ? 
            [0, 0, 0] :
            center ? [-cx, -cy, -cz] : off;

        
        color(debug ? "yellow" : color)
        translate(t){
            if(false && shape[3][5][1] == "simple"){
                echo("SIMPLE");
                %mb_loft_polyhedron([
                    mb_prismoid_plane(shape, 0),
                    mb_prismoid_plane(shape, 1)
                ]);
            }
            else{
                hull(){
                    for(i = [0 : 1 : 1]){
                        plane = mb_prismoid_plane(shape, i);
                        for(j = [0 : 1 : len(plane) - 1]){
                            point = mb_point(shape, i, j);
                            if(point != undef){

                                corner = mb_point_corner(shape, i, j);

                                if(corner != undef){
                                    
                                    rad = mb_point_radius(shape, i, j);
                                    
                                    prev_index = mb_prev_index(shape, i, j);
                                    next_index = mb_next_index(shape, i, j);
                                    
                                    
                                    prev_point = mb_point(shape, i, prev_index);
                                    next_point = mb_point(shape, i, next_index);
                                    
                                    prev_rad = mb_point_radius(shape, i, prev_index);
                                    next_rad = mb_point_radius(shape, i, next_index);
                                    
                                    //prev_point = mb_prev_point(shape, i, j);
                                    //next_point = mb_next_point(shape, i, j);
                                    inv_point = mb_inv_point(shape, i, j);
                                    inv_dis = mb_point_distance(point, inv_point);

                                    slope = mb_inv_point_slope(corner, inv_dis);
                                    
                                    socket_point_bottom = mb_socket_point_bottom(point, inv_point, sck, corner, slope);
                                    socket_point_top = mb_socket_point_top(point, inv_point, sck, corner, slope);
                                    res_inv_point = (socket_point_bottom != undef && socket_point_top != undef) 
                                                    ? inv_point 
                                                    : (socket_point_bottom != undef 
                                                        ? socket_point_bottom 
                                                        : (socket_point_top != undef ? socket_point_top : inv_point)
                                                    );

                                    angle = mb_corner_angle(corner, prev_point, point, next_point, res_inv_point);

                                    if(debug){
                                        echo(corner = corner, 
                                            ang = angle, 
                                            pi = prev_index,
                                            pp = prev_point, 
                                            ppr = prev_rad,
                                            p = point, 
                                            pr = rad,
                                            ni = next_index,
                                            np = next_point, 
                                            npr = next_rad,
                                            ip = inv_point, 
                                            inv_dis = inv_dis,
                                            slope = slope,
                                            spt = socket_point_top,
                                            sptb = socket_point_bottom);
                                    }

                                    // Draw point
                                    translate(point) 
                                        mb_rounding_corner(corner = corner, radius = rad, angle = angle, resolution = resolution, debug = debug);

                                    // Draw bottom socket point
                                    if(i == 0 && socket_point_bottom != undef){
                                        translate(socket_point_bottom) 
                                            mb_rounding_corner(corner = corner, radius = [rad[0], 0, 0], angle = angle, resolution = resolution, debug = debug);
                                    }

                                    // Draw top socket point
                                    if(i == 1 && socket_point_top != undef){
                                        translate(socket_point_top) 
                                            mb_rounding_corner(corner = corner, radius = [rad[0], 0, 0], angle = angle, resolution = resolution, debug = debug);
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
}



/*
* ----------
* END PUBLIC
* ----------
*/


/*
* --------------
* START EXAMPLES
* --------------
*/


sr = [80, 10.1, 10];
corner = [1,2];

*mb_rounding_corner(corner = corner, radius = [[0,0], [0,0], [0,0]], angle = [0, 0, 0, 0]);


*translate([0, -53, -60])
mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-0, -50], undef, [-0, 50], undef, [40, 50], undef, [40, -50], undef]
], height = 120, socket = [20, 10.4], radius = 0, debug = true);

translate([0, 300, 0])
mb_prismoid(shape = [
    [[-70, -50], [-140, 0], [-70, 50], undef, [50, 40], undef, [50, -40], undef],
    
    [[-20, -30], [-70, 0], [-20, 30], undef, [20, 40], undef, [50, -40], undef]
], height = 120, socket = [20, 0], radius = [[10, 15], 14.3, 4], debug=true, align="sticky");


*mb_prismoid(shape = [
    [[-20, -30, undef, [10,10,0]], [-20, 30, undef,[10,10,0]], [50, 30,undef, [10,10,0]], [50, -30,undef, [10,10,0]]],
    [[-20, -30, undef,[10,10,0]], [-20, 30,undef, [10,10,0]], [20, 30, undef,[10,10,0]], [20, -30, undef,[10,10,0]]]
    
], height = 120, socket = [10, 20]);



*mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-20, -50], undef, [-20, 50], undef, [40, 40], undef, [20, -50], undef]
], height = 120, socket = [10, 20], radius = 8, debug=true);

mb_prismoid(shape = [
    [
        [-20, -50, undef, [0, [20, 30], 0]], 
        undef, //[-40, -30], 
        [-20, 50, undef, [0, [20, 30], 0]], 
        undef, 
        [20, 50, undef, [0, [20, 30], 0]], 
        undef, 
        [20, -50, undef, [0, [20, 30], 0]], 
        undef
    ],
    
    [
        [-20, -50, undef, [0, [20, 20], 0]], 
        undef, //[-40, -30, undef, [[4,12], 0, 0]], 
        [-20, 50, undef, [0, [20, 20], 0]], 
        undef, 
        [20, 50, undef, [0, [20, 20], 0]], 
        undef, 
        [20, -50, undef, [0, [20, 20], 0]], 
        undef
    ]
], height = 40,  debug=true);

*mb_prismoid(shape = [
    [[-10, -50], undef, [-40, 50], undef, [60, 60], undef, [20, -50], undef],
    
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef]
], height = 40, socket = [0, 0],  debug=true);

*mb_prismoid(shape = [
    [
        [-20, -50], 
        undef, 
        [-20, 50], 
        undef, 
        [20, 50], 
        undef, 
        [20, -50], 
        undef
    ],
    
    [
        [-20, -50, undef, [0, 0, [100,15]]], 
        undef, 
        [-20, 50, undef, [0, 0,0 ]], 
        undef, 
        [20, 50, undef, [0, 0, 0]], 
        undef, 
        [20, -50, undef, [0, 0, [100,15]]], 
        undef
    ]
], height = 40,  debug=true);
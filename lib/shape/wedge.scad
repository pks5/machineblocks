use <../core/utils.scad>;

module mb_wedge(
    width = 10, 
    length = 5,
    depth = 2,
    
    dir = "z",
    face = "x-",
    offset = undef,
    mul = undef,

    color = "white",
    draw_together = false,
    debug = false
    
) {
    face = mb_face_to_int(face);
    axis = mb_face_to_axis(face);
    dir = mb_axis_to_int(dir);
    offset = mb_resolve_xyz(offset, default = [0, 0, 0]);

    // TODO: proper XYZ scale / mul
    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);

    dir_res = face <= 3 ? 2 : (dir < 0 || dir > 1 ? 0 : dir);
    
    mul_length = mul[face <= 3 ? 2 : 0];
    mul_depth = mul[face <= 3 ? 0 : 2];

    rot = (face == 1 || dir_res == 0) ? [0, 0, 180] :
        (face == 2 || dir_res == 1) ? [0, 0, 90] :
        (face == 3 || dir_res == 1) ? [0, 0, -90] : 
        [0, 0, 0];

    

    rot_tilt = //dir == 0 ? (face == 4 ? [0, -90, 180] : face == 5 ? [0, 90, 0] : [0, 0, 0]) :
                dir_res == 0 ? (face == 4 ? [0, 90, 0] : face == 5 ? [0, -90, 180] : [0, 0, 0]) :
                dir_res == 1 ? (face == 4 ? [90, 0, 180] : face == 5 ? [-90, 0, 0] : [0, 0, 0]) :
                //face == 3 ? (tilt == -1 ? [-90, 0, 0] : tilt == 1 ? [90, 0, 180] : [0, 0, 0]) :
                [0, 0, 0];

    z0 = (is_list(length) ? length[0] : is_num(length) ? -0.5 * length : 0) * mul_length; 
    z1 = (is_list(length) ? length[1] : is_num(length) ? 0.5 * length : 0) * mul_length;
    w = (width * mul[0]);
    d = (depth * mul_depth);

    tri_h = w / 2;

    //x0 = -tri_h / 2;
    //x1 =  tri_h / 2;

    x0 = -d;
    x1 = x0 + tri_h;

    y0 = -w / 2;
    y1 =  w / 2;

    points = [
        // z = -h/2
        [x0, y0, z0],
        [x0, y1, z0],
        [x1,  0, z0],

        // z = +h/2
        [x0, y0, z1],
        [x0, y1, z1],
        [x1,  0, z1]
    ];

    faces = [
        [0, 2, 1], // bottom
        [3, 4, 5], // top

        [0, 1, 4, 3],
        [1, 2, 5, 4],
        [2, 0, 3, 5]
    ];

    color(debug ? "yellow" : color)
    translate([offset[0] * mul[0], offset[1] * mul[1], offset[2] * mul[2]])
        rotate(rot_tilt)
            rotate(rot)
                polyhedron(points = points, faces = faces);
}

mb_wedge(depth = 4, width = 20, length = [-12, 28], face = "x-", tilt = -1);
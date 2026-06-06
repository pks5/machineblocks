use <../core/utils.scad>;

module mb_wedge(
    width = 10, 
    length = 5,
    depth = 2,
    

    face = "x-",
    offset = undef,
    mul = undef,

    color = "white",
    draw_together = false,
    debug = false
    
) {
    face = mb_face_to_int(face);
    axis = mb_face_to_axis(face);
    offset = mb_resolve_xyz(offset, default = [0, 0, 0]);
    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);

    mul_length = mul[axis];

    rot = face == 1 ? [0, 0, 180] :
        face == 2 ? [0, 0, 90] :
        face == 3 ? [0, 0, -90] : 
        [0, 0, 0];

    z0 = (is_list(length) ? length[0] : is_num(length) ? -0.5 * length : 0) * mul_length; 
    z1 = (is_list(length) ? length[1] : is_num(length) ? 0.5 * length : 0) * mul_length;

    tri_h = width / 2;

    //x0 = -tri_h / 2;
    //x1 =  tri_h / 2;

    x0 = -depth;
    x1 = x0 + tri_h;

    y0 = -width / 2;
    y1 =  width / 2;

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

    rotate(rot)
        polyhedron(points = points, faces = faces);
}

mb_wedge(depth = 4, width = 20, length = [-12, 28], face = 3);
use <../core/utils.scad>;

module mb_svg(
    svg_file,
    svg_size, // Grösse in mm
    size, 
    face = "z+",
    offset = undef,
    mul = [1, 1, 1],
    color = "white",
    debug = false
){
    face = mb_face_to_int(face);
    axis = mb_face_to_axis(face);
    size =  mb_cube_size_resolve(size);
    offset = mb_resolve_xyz(xyz = offset, default = [0, 0, 0]);

    dim = [
            size[1][0] - size[0][0], 
            size[1][1] - size[0][1],
            size[1][2] - size[0][2]
        ];

    tr = [
        0.5 * (size[0][0] + size[1][0]),
        0.5 * (size[0][1] + size[1][1]),
        0.5 * (size[0][2] + size[1][2])
    ];

    square_dim = axis == 0 ? 
            [
                dim[2] / 2.5,
                dim[1],
                dim[0] * 2.5   
            ] : 
            axis == 1 ?
            [
                dim[0],
                dim[2] / 2.5,
                dim[1] * 2.5    
            ] : 
            
            dim;

    si = [
        square_dim[0] * mul[0], 
        square_dim[1] * mul[1], 
        square_dim[2] * mul[2]
    ];

    sc = [
        si[0] / svg_size[0],
        si[1] / svg_size[1],
        si[2]
    ];

    echo(face = face, size = size, offset = offset, dim = dim, si= si, tr = tr);

    rot = mb_face_common(face, "x") ? [0, 90, 0] : mb_face_common(face, "y") ? [90, 0, 0] : [0, 0, 0];

    color(debug ? "green" : color)
        translate([
            (tr[0] + offset[0]) * mul[0], 
            (tr[1] + offset[1]) * mul[1], 
            (tr[2] + offset[2]) * mul[2]
        ])
        rotate(rot)
            linear_extrude(height = sc[2], center = true) {
                scale(sc)
                    translate([-0.5 * svg_size[0], -0.5 * svg_size[1], 0])
                        import(svg_file);
            }
}

/*
* Old deprecated module
*/

module mb_svg3d(file, orgWidth, orgHeight, depth, size, center = true){
    translate([0, 0, -0.5*depth])
        linear_extrude(depth) {
            scale([size, size, 0])
            translate([-0.5*orgWidth, -0.5*orgHeight, 0])
                import(file);
        }
}
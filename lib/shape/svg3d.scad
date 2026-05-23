
module mb_svg(
    svg_file,
    svg_size, // Grösse in mm
    size, 
    offset = undef,
    mul = [1, 1, 1],
    color = "white",
    debug = false
){
    size =  mb_cube_size_resolve(size);
    offset = mb_resolve_xyz(xyz = offset, default = [0, 0, 0]);

    si = [
        (size[1][0] - size[0][0]) * mul[0], 
        (size[1][1] - size[0][1]) * mul[1], 
        (size[1][2] - size[0][2]) * mul[2]
    ];

    sc = [
        si[0] / svg_size[0],
        si[1] / svg_size[1],
        si[2]
    ];

    color(debug ? "green" : color)
        translate([
            (0.5 * (size[0][0] + size[1][0]) + offset[0]) * mul[0], 
            (0.5 * (size[0][1] + size[1][1]) + offset[1]) * mul[1], 
            (0.5 * (size[0][2] + size[1][2]) + offset[2]) * mul[2]
        ])
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
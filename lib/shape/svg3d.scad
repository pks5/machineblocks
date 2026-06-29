use <../core/utils.scad>;
use <../core/quality.scad>;

module mb_svg(
    svg_file,
    svg_size, // Grösse in mm
    size, 
    face = "z+",
    offset = undef,
    mul = [1, 1, 1],
    color = "white",
    quality = "normal",

    q_profile = undef,
    q_class_factors = undef,
    q_class_min_segments = undef,
    q_segment_multiplier = undef,
    q_preview_quality = undef,
    q_preview_max_mult = undef,

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

    si = [
        dim[0] * mul[0], 
        dim[1] * mul[1], 
        dim[2] * mul[2]
    ];

    sid = axis == 0 ? 
            [
                si[2],
                si[1],
                si[0]   
            ] : 
            axis == 1 ?
            [
                si[0],
                si[2],
                si[1]    
            ] : 
            
            si;

    sc = [
        sid[0] / svg_size[0],
        sid[1] / svg_size[1],
        sid[2]
    ];

    rounding_resolution = mb_q_fn_for_size(
        max(sid[0], sid[1]),
        "visual",
        preset = quality,
        profile = q_profile,
        class_factors = q_class_factors,
        class_min_segments = q_class_min_segments,
        segment_multiplier = q_segment_multiplier,
        preview_quality = q_preview_quality,
        preview_max_mult = q_preview_max_mult
    );

    rot = mb_face_rotation(face);

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
                        import(svg_file, $fn = rounding_resolution);
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
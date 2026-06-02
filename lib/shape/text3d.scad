use <../core/utils.scad>;

module mb_text(
    text,
    height,
    text_size,
    font,
    spacing,
    align = ["center", "center"],
    rounding_resolution = 100,
    face = "z+",
    offset = undef,
    mul = [1, 1, 1],
    color = "white",
    debug = false
){
    face = mb_face_to_int(face);
    axis = mb_face_to_axis(face);
    offset = mb_resolve_xyz(xyz = offset, default = [0, 0, 0]);

    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);
    mul_radius = mul[0];
    mul_length = mul[axis];

    start = (is_list(height) ? height[0] : is_num(height) ? -0.5 * height : 0) * mul_length; 
    end = (is_list(height) ? height[1] : is_num(height) ? 0.5 * height : 0) * mul_length;

    rot = mb_face_has_common(face, "x") ? [90, 0, 90] : mb_face_has_common(face, "y") ? [90, 0, 0] : [0, 0, 0];

    color(debug ? "green" : color)
        translate([
            offset[0] * mul[0], 
            offset[1] * mul[1], 
            offset[2] * mul[2]
        ])
        rotate(rot)
            translate([0, 0, 0.5 * (start + end)])
                linear_extrude(height = end - start, center = true) {
                    text(
                        text, 
                        size = text_size, 
                        font = font, 
                        spacing = spacing, 
                        halign = align[0], 
                        valign = align[1], 
                        $fn = rounding_resolution
                    );
                }
}


module mb_text3d(text, textDepth, textSize, textFont, textSpacing, textHorizontalAlign = "center", textVerticalAlign = "center", center = true){
    translate([0,0,-0.5*textDepth])
        linear_extrude(textDepth) {
            text(text, size = textSize, font = textFont, spacing = textSpacing, halign = textHorizontalAlign, valign = textVerticalAlign, $fn = 64);
        }
}
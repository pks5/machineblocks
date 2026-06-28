use <../core/utils.scad>;
use <../core/quality.scad>;

module mb_text(
    text,
    height,
    text_size,
    font,
    spacing,
    align = ["center", "center"],
    
    face = "z+",
    offset = undef,
    mul = undef,
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
    offset = mb_resolve_xyz(xyz = offset, default = [0, 0, 0]);

    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);
    

    start = (is_list(height) ? height[0] : is_num(height) ? -0.5 * height : 0); 
    end = (is_list(height) ? height[1] : is_num(height) ? 0.5 * height : 0);

    rot = mb_face_rotation(face);

    tr = [
        axis == 0 ? 0.5 * (start + end) : 0,
        axis == 1 ? 0.5 * (start + end) : 0,
        axis == 2 ? 0.5 * (start + end) : 0
    ];

    rounding_resolution = mb_q_fn_for_size(
        text_size,
        "visual",
        preset = quality,
        profile = q_profile,
        class_factors = q_class_factors,
        class_min_segments = q_class_min_segments,
        segment_multiplier = q_segment_multiplier,
        preview_quality = q_preview_quality,
        preview_max_mult = q_preview_max_mult
    );

    color(debug ? "green" : color)
        translate([
            (tr[0] + offset[0]) * mul[0], 
            (tr[1] + offset[1]) * mul[1], 
            (tr[2] + offset[2]) * mul[2]
        ])
        rotate(rot)
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

module mb_text3d(text, textDepth, textSize, textFont, textSpacing, textHorizontalAlign = "center", textVerticalAlign = "center", center = true){
    translate([0,0,-0.5*textDepth])
        linear_extrude(textDepth) {
            text(text, size = textSize, font = textFont, spacing = textSpacing, halign = textHorizontalAlign, valign = textVerticalAlign, $fn = 64);
        }
}
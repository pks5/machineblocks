
module mb_text3d(text, textDepth, textSize, textFont, textSpacing, center = true){
    translate([0,0,-0.5*textDepth])
        linear_extrude(textDepth) {
            text(text, size = textSize, font = textFont, spacing = textSpacing, halign = "center", valign = "center", $fn = 64);
        }
}
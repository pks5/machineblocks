module mb_axis(
    gridSizeXY = 8.0,
    size = 5.0,
    thickness = 1.6,
    height = 4,
    capHeight = 0.4,
    roundingResolution = 64,
    center = true,
    alignBottom = true //Whether the brick should be always aligned on floor
){
    resultingHeight = height * gridSizeXY;

    translate([0,0, alignBottom ? 0.5 * resultingHeight : 0]){
        intersection() {
            union(){
                cube(size = [size, thickness, resultingHeight], center=true);
                cube(size = [thickness, size, resultingHeight], center=true);
            }
            union(){
                translate([0,0,0.5*resultingHeight-capHeight]) 
                    resize([size,size,2*capHeight])
                        sphere(d=size,  $fn = roundingResolution);
                cylinder(h = resultingHeight - 2 * capHeight, d = size, center=true, $fn = roundingResolution);
                translate([0,0,-0.5*resultingHeight+capHeight]) 
                    resize([size,size,2*capHeight])
                        sphere(d=size, $fn = roundingResolution);
            }
        }
    }
}
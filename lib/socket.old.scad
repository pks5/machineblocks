//TODO use shapes/mb_prism
module mb_frame_prism(l, w, h){
    translate([-0.5*l, -0.5*w, -0.5*h])
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}

module mb_socket_frame(
    frameSize = [54, 54],
    frameHeight = 4,
    screwHoleDistance = [43, 43],
    screwHoleSize = 2.2,
    slopingHeight = 6
){
    cutMultiplier = 1.1;

    translate([0, -0.5*frameSize[1] - 0.5*slopingHeight, 0])
        if(slopingHeight > 0){
            rotate([0,180,0])
                mb_frame_prism(frameSize[0], slopingHeight, frameHeight);
        }
        difference(){
            cube(size = [frameSize[0], frameSize[1], frameHeight], center = true);
            
            mb_socket_holes(
                screwHoleDepth = frameHeight,
                screwHoleDistance = screwHoleDistance,
                screwHoleSize = screwHoleSize
            );
        }
}

module mb_socket_holes(
    screwHoleDepth = 4,
    screwHoleDistance = [43, 43],
    screwHoleSize = 2.2
){
    cutMultiplier = 1.1;

    translate([-0.5 * screwHoleDistance[0], -0.5 * screwHoleDistance[1], 0])
        cylinder(r = 0.5 * screwHoleSize, h = screwHoleDepth * cutMultiplier, center = true, $fn=30);
        
    if(screwHoleDistance[0] > 0){
        translate([0.5 * screwHoleDistance[0], -0.5 * screwHoleDistance[1], 0])
            cylinder(r = 0.5 * screwHoleSize, h = screwHoleDepth * cutMultiplier, center = true, $fn=30);
    }

    if(screwHoleDistance[1] > 0){
        translate([-0.5 * screwHoleDistance[0], 0.5 * screwHoleDistance[1], 0])
            cylinder(r = 0.5 * screwHoleSize, h = screwHoleDepth * cutMultiplier, center = true, $fn=30);
        if(screwHoleDistance[0] > 0){
            translate([0.5 * screwHoleDistance[0], 0.5 * screwHoleDistance[1], 0])
                cylinder(r = 0.5 * screwHoleSize, h = screwHoleDepth * cutMultiplier, center = true, $fn=30);
        }
    }
        
}
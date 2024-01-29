include <../../lib/block.scad>;

module prism(l, w, h){
    translate([-0.5*l, -0.5*w, -0.5*h])
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
}

parts = "TOP";

wallSizeY = 7.8;
speakerSize = 46;
speakerFrameSize = 54;
speakerFrameHeight = 4;
speakerScrewHoleDistance = 43;
speakerScrewHoleSize = 2.2;
pitWallThickness = 2.6;

cutMultiplier = 1.1;

if(parts == "WALL" || parts == "ALL"){

difference(){
    union(){
        block(
            baseLayers=23,
            grid=[8,1],
            withPit = true,
            pitWallGaps= [[3,0,0]],
            screwHoles = [[0,0], [7,0]],
            knobClampThickness = 0.1
        );

        translate([0,0,0.5*75.4])
            rotate([90,0,0])
                translate([0,0,-0.5*speakerFrameHeight + 0.5*wallSizeY-pitWallThickness]){
                    translate([0,-0.5*speakerFrameSize - 0.5*6,0])
                        rotate([0,180,0])
                        prism(speakerFrameSize, 6, speakerFrameHeight);
                    difference(){
                        cube(size = [speakerFrameSize, speakerFrameSize, speakerFrameHeight], center = true);
                        translate([-0.5*speakerFrameSize + 0.5*(speakerFrameSize-speakerScrewHoleDistance),-0.5*speakerFrameSize + 0.5*(speakerFrameSize-speakerScrewHoleDistance),0])
                            cylinder(r=0.5*speakerScrewHoleSize, h=speakerFrameHeight*cutMultiplier, center = true, $fn=30);
                        translate([0.5*speakerFrameSize - 0.5*(speakerFrameSize-speakerScrewHoleDistance),-0.5*speakerFrameSize + 0.5*(speakerFrameSize-speakerScrewHoleDistance),0])
                            cylinder(r=0.5*speakerScrewHoleSize, h=speakerFrameHeight*cutMultiplier, center = true, $fn=30);
                        translate([-0.5*speakerFrameSize + 0.5*(speakerFrameSize-speakerScrewHoleDistance),0.5*speakerFrameSize - 0.5*(speakerFrameSize-speakerScrewHoleDistance),0])
                            cylinder(r=0.5*speakerScrewHoleSize, h=speakerFrameHeight*cutMultiplier, center = true, $fn=30);
                        translate([0.5*speakerFrameSize - 0.5*(speakerFrameSize-speakerScrewHoleDistance),0.5*speakerFrameSize - 0.5*(speakerFrameSize-speakerScrewHoleDistance),0])
                            cylinder(r=0.5*speakerScrewHoleSize, h=speakerFrameHeight*cutMultiplier, center = true, $fn=30);    
                    }
                }
    }

    translate([0,0,0.5*75.4])
        rotate([90,0,0])
        cylinder(r = 0.5*speakerSize, h=20, center=true, $fn=30);        
}   
}

if(parts == "TOP" || parts == "ALL"){
    translate([0,20,0])
        block(
            baseLayers=1,
            grid=[8,1],
            pitWallGaps= [[3,0,0]],
            //screwHoles = [[0,0], [7,0]],
            //screwHoleSize = 2,
            knobClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE"
        );
}

module mb_prism(l, w, h) {
    translate([-0.5*l,0, -0.5*h])
    rotate([0,0,-90])
       polyhedron(points=[
               [0,0,h],           // 0    front top corner
               [0,0,0],[w,0,0],   // 1, 2 front left & right bottom corners
               [0,l,h],           // 3    back top corner
               [0,l,0],[w,l,0]    // 4, 5 back left & right bottom corners
       ], faces=[ // points for all faces must be ordered clockwise when looking in
               [0,2,1],    // top face
               [3,4,5],    // base face
               [0,1,4,3],  // h face
               [1,2,5,4],  // w face
               [0,3,5,2],  // hypotenuse face
       ]);
}

/*
module holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight, holderPlateHeight){
    translate([0,0, 0])
        cube([holderLength, holderThickness, holderHeight], center=true);
    
    translate([0, -0.5*(holderPrismWidth-holderThickness), 0.5*(holderHeight + holderPlateHeight)])
        cube([holderLength, holderPrismWidth, holderPlateHeight], center=true);

    translate([0, 0.5*holderThickness, 0.5*(holderHeight + holderPrismHeight) + holderPlateHeight]){
        prism(holderLength, holderPrismWidth, holderPrismHeight);
    }   
    
}
*/

module mb_holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight, holderPlateHeight){
    translate([0,0, 0])
        cube([holderLength, holderThickness, holderHeight], center=true);
    
    translate([0, -0.5*(holderPrismWidth-holderThickness), 0.5*(holderHeight + holderPlateHeight)])
        cube([holderLength, holderPrismWidth, holderPlateHeight], center=true);
    
    translate([0,0.5*holderThickness, 0.5*(holderHeight)]){
        translate([0,0, holderPlateHeight + 0.5* + holderPrismHeight])
        mb_prism(holderLength, holderPrismWidth, holderPrismHeight);
        
        
        translate([0, -holderThickness , -0.125*holderPrismHeight])
            rotate([0,180,0])
                mb_prism(holderLength, holderPrismWidth-holderThickness, 0.25*holderPrismHeight);
    }   
    
}

module mb_pcb(
    pcbDimensions = [30, 20, 3],
    holderThickness = 1.2,
    
    holderLength = 8,
    holderPlateHeight = 0.2,
    platerSize = 3,
    platerHeight = 2
){    
    holderPrismHeight = 1;
    holderPrismWidth = 0.5 * holderPrismHeight + holderThickness;
    holderHeight = pcbDimensions[2] + platerHeight;

    
        translate([0, 0.5 * (pcbDimensions[1] + holderThickness), 0.5*holderHeight]){
            mb_holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight, holderPlateHeight);
        }   
        
        translate([0, -0.5 * (pcbDimensions[1] + holderThickness), 0.5*holderHeight]){
            rotate([0, 0, 180])
                mb_holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight, holderPlateHeight);
        }
        
        translate([0.5*(pcbDimensions[0] + holderThickness), 0, 0.5*holderHeight]){
            rotate([0, 0, -90])
                mb_holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight, holderPlateHeight);
        }
        
        translate([-0.5*(pcbDimensions[0] + holderThickness), 0, 0.5*holderHeight]){
            rotate([0, 0, 90]){
                mb_holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight, holderPlateHeight);
            }
        }
        
        translate([-0.5 * (pcbDimensions[0] - platerSize) - holderThickness, 0.5 * (platerSize - pcbDimensions[1]) - holderThickness, 0.5*platerHeight]){
            cube([platerSize, platerSize, platerHeight], center=true);
        }
        
        translate([0.5 * (pcbDimensions[0] - platerSize) + holderThickness, 0.5 * (platerSize - pcbDimensions[1]) - holderThickness, 0.5*platerHeight]){
            cube([platerSize, platerSize, platerHeight], center=true);
        }
        
        translate([-0.5 * (pcbDimensions[0] - platerSize) - holderThickness, -0.5 * (platerSize - pcbDimensions[1]) + holderThickness, 0.5*platerHeight]){
            cube([platerSize, platerSize, platerHeight], center=true);
        }
        
        translate([0.5 * (pcbDimensions[0] - platerSize) + holderThickness, -0.5 * (platerSize - pcbDimensions[1]) + holderThickness, 0.5*platerHeight]){
            cube([platerSize, platerSize, platerHeight], center=true);
        }
    
}
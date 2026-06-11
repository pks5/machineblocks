use <../core/utils.scad>;

module mb_clip_prism(l, w, h) {
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

module mb_clip_holder(
    clipLength, 
    clipBaseHeight, 
    clipBaseThickness, 
    clipTopSlantThickness, 
    clipTopSlantHeight, 
    clipBottomSlantHeight, 
    clipPlateHeight
){
    translate([0,0, 0])
        cube([clipLength, clipBaseThickness, clipBaseHeight], center=true);
    
    translate([0, -0.5 * (clipTopSlantThickness - clipBaseThickness), 0.5 * (clipBaseHeight + clipPlateHeight)])
        cube([clipLength, clipTopSlantThickness, clipPlateHeight], center=true);
    
    translate([0, 0.5*clipBaseThickness, 0.5 * clipBaseHeight]){
        translate([0, 0, clipPlateHeight + 0.5 * clipTopSlantHeight])
            mb_clip_prism(clipLength, clipTopSlantThickness, clipTopSlantHeight);
        
        //Bottom Prism
        translate([0, -clipBaseThickness , -0.5 * clipBottomSlantHeight])
            rotate([0,180,0])
                mb_clip_prism(clipLength, clipTopSlantThickness - clipBaseThickness, clipBottomSlantHeight);
    }   
    
}

module mb_screw_socket(socketSize, socketHeight, socketHoleSize, socketResolution = 30, holeResolution = 30){
    difference(){
        cylinder(h=socketHeight, r=0.5 * socketSize, center=true, $fn=socketResolution);
        if(socketHoleSize > 0){
            cylinder(h=socketHeight * 1.1, r=0.5*socketHoleSize, center=true, $fn=holeResolution);
        }
    }
}

module mb_pcb_screw_sockets(
    screwSocketSize = 5,
    screwSocketHoleSize = 2.2,
    screwSocketHeight = 3,
    screwSockets = []
){
    translate([0, 0, 0.5 * screwSocketHeight])
        for (a = [ 0 : 1 : len(screwSockets) - 1 ]){
            translate([screwSockets[a][0], screwSockets[a][1], 0])
                mb_screw_socket(
                    socketSize = screwSocketSize,
                    socketHeight = screwSocketHeight,
                    socketHoleSize = screwSocketHoleSize
                );
        }
}

module mb_pcb_clips(
    pcbDimensions = [30, 20, 3],
    
    clipBaseThickness = 1.2,
    clipLength = 8,
    clipPlateHeight = 0.2,
    clipTopSlantHeight = 1,
    clipBottomSlantHeight = 0.25,
    clipOverhangThickness = 0.5,
    
    pedestalSize = 3,
    pedestalHeight = 2
){    
    clipBaseHeight = pcbDimensions[2] + pedestalHeight;

    
        translate([0, 0.5 * (pcbDimensions[1] + clipBaseThickness), 0.5*clipBaseHeight]){
            mb_clip_holder(clipLength, clipBaseHeight, clipBaseThickness, clipOverhangThickness + clipBaseThickness, clipTopSlantHeight, clipBottomSlantHeight, clipPlateHeight);
        }   
        
        translate([0, -0.5 * (pcbDimensions[1] + clipBaseThickness), 0.5*clipBaseHeight]){
            rotate([0, 0, 180])
                mb_clip_holder(clipLength, clipBaseHeight, clipBaseThickness, clipOverhangThickness + clipBaseThickness, clipTopSlantHeight, clipBottomSlantHeight, clipPlateHeight);
        }
        
        translate([0.5*(pcbDimensions[0] + clipBaseThickness), 0, 0.5*clipBaseHeight]){
            rotate([0, 0, -90])
                mb_clip_holder(clipLength, clipBaseHeight, clipBaseThickness, clipOverhangThickness + clipBaseThickness, clipTopSlantHeight, clipBottomSlantHeight, clipPlateHeight);
        }
        
        translate([-0.5*(pcbDimensions[0] + clipBaseThickness), 0, 0.5*clipBaseHeight]){
            rotate([0, 0, 90]){
                mb_clip_holder(clipLength, clipBaseHeight, clipBaseThickness, clipOverhangThickness + clipBaseThickness, clipTopSlantHeight, clipBottomSlantHeight, clipPlateHeight);
            }
        }
        
        translate([-0.5 * (pcbDimensions[0] - pedestalSize) - clipBaseThickness, 0.5 * (pedestalSize - pcbDimensions[1]) - clipBaseThickness, 0.5*pedestalHeight]){
            cube([pedestalSize, pedestalSize, pedestalHeight], center=true);
        }
        
        translate([0.5 * (pcbDimensions[0] - pedestalSize) + clipBaseThickness, 0.5 * (pedestalSize - pcbDimensions[1]) - clipBaseThickness, 0.5*pedestalHeight]){
            cube([pedestalSize, pedestalSize, pedestalHeight], center=true);
        }
        
        translate([-0.5 * (pcbDimensions[0] - pedestalSize) - clipBaseThickness, -0.5 * (pedestalSize - pcbDimensions[1]) + clipBaseThickness, 0.5*pedestalHeight]){
            cube([pedestalSize, pedestalSize, pedestalHeight], center=true);
        }
        
        translate([0.5 * (pcbDimensions[0] - pedestalSize) + clipBaseThickness, -0.5 * (pedestalSize - pcbDimensions[1]) + clipBaseThickness, 0.5*pedestalHeight]){
            cube([pedestalSize, pedestalSize, pedestalHeight], center=true);
        }
    
}

module mb_pcb(
    pcb,
    dimensions,
    screw_sockets,
    screw_socket_height,
    screw_socket_size,
    screw_socket_hole_size,
    offset = undef,
    mul = undef,
    color = "white",
    debug = false
){
    offset = mb_resolve_xyz(xyz = offset, default = [0, 0, 0]);
    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);
    
    color(debug ? "yellow" : color)
    translate(mb_array_mul(offset, mul)){
        if(pcb == "clips"){
            mb_pcb_clips(
                pcbDimensions = dimensions
            );
        }
        else if(pcb == "sockets"){
            mb_pcb_screw_sockets(
                screwSockets = screw_sockets,
                screwSocketHeight = screw_socket_height * mul[2],
                screwSocketSize = screw_socket_size * mul[0],
                screwSocketHoleSize = screw_socket_hole_size * mul[0]
            );
        }
    }
}
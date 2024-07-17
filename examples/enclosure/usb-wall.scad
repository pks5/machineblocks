include <../../lib/block.scad>;
include <../../lib/socket.scad>;

parts = "ALL";

if(parts == "WALL" || parts == "ALL"){

difference(){
    union(){
        block(
        baseLayers=23,
        grid=[8,1],
        withPit = true,
        tongue=true,
        pitWallGaps= [[3,0,0]],
        screwHolesZ = [[0,0], [7,0]],
        screwHoleZSize = 2,
        screwHolesY = [[0, 2], [0, 21]],
        screwHoleYSize = 2,
        knobTongueClampThickness = 0.1,
        topPlateHeight = 2.4

        );
        
        translate([0,0.5*0.3 - 0.5*7.8 + 2.6, 32])
            rotate([90,0,0])
                mb_socket_frame(
                    frameSize = [25.2, 10],
                    frameHeight = 0.3,
                    screwHoleDistance = [17.6,0],
                    screwHoleSize = 2.9,
                    slopingHeight = 0.4
                );    
    }


    translate([0,0, 32]){
            rotate([90,0,0])
                mb_socket_holes(
                    screwHoleDepth = 30,
                    screwHoleDistance = [17.6,0],
                    screwHoleSize = 2.9
                );

        cube([9.1, 30, 4.7], center=true);
    }
}

    
}

if(parts == "TOP" || parts == "ALL"){
    translate([0,30,0])
        block(
            baseLayers=1,
            grid=[8,1],
            pitWallGaps= [[3,0,0]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleZSize = 2,
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE"
        );
}
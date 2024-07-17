include <../../lib/block.scad>;
include <../../lib/socket.scad>;

parts = "ALL";
withUsb = true;
usbY = 16;

if(parts == "WALL" || parts == "ALL"){
    difference(){
        union(){
            block(
                baseLayers=23, 
                grid=[4,1], 
                wallGapsX=[[3,0]],
                brickOffset=[0, 1.5, 0],
                withPit = true,
                tongue = true,
                pitWallGaps = [[2,0,0]],
                screwHolesZ = [[0,0], [3,0]],
                screwHoleZSize = 2,
                screwHolesY = [[0, 2], [0, 21]],
                screwHoleYSize = 2,
                knobTongueClampThickness = 0.1
            );

            block(
                baseLayers=23, 
                grid=[1, 4], 
                wallGapsY=[[3,0]], 
                brickOffset=[1.5, 0, 0],
                withPit = true,
                tongue = true,
                pitWallGaps= [[0,0,0]],
                screwHolesZ = [[0,0], [0,3]],
                screwHoleZSize = 2,
                screwHolesX = [[0, 2], [0, 21]],
                screwHoleXSize = 2,
                knobClampThickness = 0.1
            );

            translate([0,-0.5*0.3 + 0.5*8 - 2.6 + 1.5 * 8 , usbY])
                rotate([90,0,0])
                    mb_socket_frame(
                        frameSize = [25.2, 10],
                        frameHeight = 0.3,
                        screwHoleDistance = [17.6,0],
                        screwHoleSize = 2.9,
                        slopingHeight = 0.4
                    );    
        }

        translate([0,1.5 * 8, usbY]){
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
       
        translate([0,40,0]){
       
            block(
            baseLayers=1, 
            grid=[4,1], 
            wallGapsX=[[0,0]],
            brickOffset=[0, 1.5, 0],
            pitWallGaps= [[2,0,0]],
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE"
        );

        block(
            baseLayers=1, 
            grid=[1, 4], 
            wallGapsY=[[3,1]], 
            brickOffset=[-1.5, 0, 0],
            pitWallGaps= [[1,0,0]],
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = -0.1,
            baseCutoutType = "GROOVE"
        ); 
    }
}
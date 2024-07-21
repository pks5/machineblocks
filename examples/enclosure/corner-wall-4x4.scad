include <../../lib/block.scad>;
include <../../lib/socket.scad>;

parts = "ALL";
withUsb = false;
usbY = 16;

if(parts == "WALL" || parts == "ALL"){
    difference(){
        union(){
            block(
                baseLayers=23, 
                grid=[4,1], 
                wallGapsX=[[3,0]],
                brickOffset=[0, 1.5, 0],
                pit = true,
                 pitRoundingRadius=[0, 0, 1.2, 0],
                tongue = true,
                tongueRoundingRadius = [0.5, 0.5, 2.7, 0.5],
                pitWallGaps = [[2,0,0]],
                // screwHolesZ = [[0,0], [3,0]],
                // screwHoleZSize = 2,
                // screwHolesY = [[0, 2], [0, 21]],
                // screwHoleYSize = 2,
                tongueClampThickness = 0.1,
                baseRoundingRadius=[0,0,[0,0,4,0]],
                baseCutoutRoundingRadius=[0,0,2.7,0]
            );

            block(
                baseLayers=23, 
                grid=[1, 4], 
                wallGapsY=[[3,0]], 
                brickOffset=[1.5, 0, 0],
                pit = true,
                 pitRoundingRadius=[0, 0, 1.2, 0],
                tongue = true,
                tongueRoundingRadius = [0.5, 0.5, 2.7, 0.5],
                pitWallGaps= [[0,0,0]],
                // screwHolesZ = [[0,0], [0,3]],
                // screwHoleZSize = 2,
                // screwHolesX = [[0, 2], [0, 21]],
                // screwHoleXSize = 2,
                tongueClampThickness = 0.1,
                baseRoundingRadius=[0,0,[0,0,4,0]],
                baseCutoutRoundingRadius=[0,0,2.7,0]
            );

            if(withUsb){
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
        }

        if(withUsb){
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

    

    }

if(parts == "TOP" || parts == "ALL"){
       
        translate([0,40,0]){
       
            block(
            baseLayers=1, 
            grid=[4,1], 
            wallGapsX=[[3,0]],
            brickOffset=[0, 1.5, 0],
            pitWallGaps= [[2,0,0]],
             pitRoundingRadius=[0, 0, 1.2, 0],
            tongueClampThickness = 0.1,
            tongueAdjustment = 0,
           tongueRoundingRadius = [0.5, 0.5, 2.7, 0.5],
            baseCutoutType = "GROOVE",
                baseRoundingRadius=[0,0,[0,0,4,0]]
        );

        block(
            baseLayers=1, 
            grid=[1, 4], 
            wallGapsY=[[3,0]], 
            brickOffset=[1.5, 0, 0],
            pitWallGaps= [[0,0,0]],
            pitRoundingRadius=[0, 0, 1.2, 0],
            tongueClampThickness = 0.1,
            tongueAdjustment = 0,
            tongueRoundingRadius = [0.5, 0.5, 2.7, 0.5],
            baseCutoutType = "GROOVE",
                baseRoundingRadius=[0,0,[0,0,4,0]]
        ); 
    }
}
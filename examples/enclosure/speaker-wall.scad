include <../../lib/block.scad>;
include <../../lib/socket.scad>;



parts = "ALL";
mountingSide = 0;
wallHeight = 75.4 + 3.2;
wallSizeY = 7.8;
speakerSize = 46;
speakerFrameSize = [54, 54];
speakerFrameHeight = 4;
speakerScrewHoleDistance = [43, 43];
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
            screwHolesZ = [[0,0], [7,0]],
            screwHoleZSize = 2,
            screwHolesY = [[0, 2, mountingSide], [0, 21, mountingSide]],
            screwHoleYSize = 2,
            knobTongueClampThickness = 0.1
        );


        block(
            baseLayers=23,
            grid=[1,3],
            withPit = true,
            pitWallGaps= [[0,0,0]],
            screwHolesZ = [[0,0], [7,0]],
            screwHoleZSize = 2,
            screwHolesX = mountingSide == 1 ? [[0, 15, 1], [0, 17, 1], [0, 19, 1]] : [[0, 2, 1], [0, 21, 1]],
            screwHoleXSize = 2,
            screwHolesY = mountingSide == 1 ? [[0, 2, 1], [0, 21, 1], [2, 2, 1], [2, 21, 1]] : [],
            screwHoleYSize = 2,
            knobTongueClampThickness = 0.1,
            brickOffset=[3.5,1,0]
        );

        block(
            baseLayers=23,
            grid=[1,3],
            withPit = true,
            pitWallGaps= [[1,0,0]],
            screwHolesZ = [[0,0], [7,0]],
            screwHoleZSize = 2,
            screwHolesX = mountingSide == 1 ? [[0, 2, 1], [0, 21, 1]] : [[0, 15, 1], [0, 17, 1], [0, 19, 1]],
            screwHoleXSize = 2,
            screwHolesY = mountingSide == 1 ? [] : [[0, 2, 0], [0, 21, 0], [2, 2, 0], [2, 21, 0]],
            screwHoleYSize = 2,
            knobTongueClampThickness = 0.1,
            brickOffset=[-3.5,1,0]
        );

        translate([0,0.5*speakerFrameHeight - 0.5*wallSizeY + pitWallThickness,0.5 * wallHeight])
            rotate([90,0,0])
                mb_socket_frame(
                    frameSize = speakerFrameSize,
                    frameHeight = speakerFrameHeight,
                    screwHoleDistance = speakerScrewHoleDistance,
                    screwHoleSize = speakerScrewHoleSize
                );
                
    }

    translate([0,0,0.5 * wallHeight])
        rotate([90,0,0])
        cylinder(r = 0.5*speakerSize, h=20, center=true, $fn=30);
    }   
}

if(parts == "X" || parts == "ALL"){
    translate([0,60,0]){
        block(
            baseLayers=3,
            grid=[2,1],
            withPit=true,
            pitWallGaps= [[3,0,0]],
            screwHolesX=[[0,1], [1,1]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleSize = 2,
            knobTongueClampThickness = 0.1
        );
    }
}

if(parts == "TOP" || parts == "ALL"){
    translate([0,30,0]){
        block(
            baseLayers=1,
            grid=[8,1],
            pitWallGaps= [[3,0,0]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleSize = 2,
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE"
        );

        block(
            baseLayers=1,
            grid=[1,3],
            pitWallGaps= [[1,0,0]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleZSize = 2,
            screwHolesY = [[0, 2], [0, 21]],
            screwHoleYSize = 2,
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            brickOffset=[3.5,1,0]
        );

        block(
            baseLayers=1,
            grid=[1,3],
            pitWallGaps= [[1,0,0]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleZSize = 2,
            screwHolesY = [[0, 2], [0, 21]],
            screwHoleYSize = 2,
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            brickOffset=[-3.5,1,0]
        );
    }
}
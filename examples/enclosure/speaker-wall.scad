include <../../lib/block.scad>;
include <../../lib/socket.scad>;



parts = "ALL";

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
            screwHolesY = [[0, 2], [0, 21]],
            screwHoleXYSize = 2,
            knobTongueClampThickness = 0.1
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

if(parts == "TOP" || parts == "ALL"){
    translate([0,30,0])
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
}
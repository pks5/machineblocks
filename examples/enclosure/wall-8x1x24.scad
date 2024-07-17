include <../../lib/block.scad>;
include <../../lib/socket.scad>;

parts = "ALL";

if(parts == "WALL" || parts == "ALL"){
    block(
        baseLayers=23,
        grid=[8,1],
        withPit = true,
        tongue = true,
        pitWallGaps= [[3,0,0]],
        screwHolesZ = [[0,0], [7,0]],
        screwHoleZSize = 2,
        screwHolesY = [[0, 2], [0, 21]],
        screwHoleYSize = 2,
        knobTongueClampThickness = 0.1
    );

    block(
        baseLayers = 11,
        grid=[2,1],
        knobs = false,
        baseCutoutType = "NONE",
        brickOffset=[0,0,12],
        screwHolesX=[[0,9,1],[1,9,1],[0,7,1],[1,7,1],[0,5,1],[1,5,1], [0,3,1],[1,3,1],[0,1,1],[1,1,1]],
        screwHoleXSize=2.0
    );

    translate([0,0.5*(2.6-0.1),12 * 3.2 - 0.5*(8-2.6 - 0.1)])
        rotate([0,180,180])
            mb_frame_prism(8 * 2 - 0.2, 8 - 2.6 - 0.1, 8 - 2.6 - 0.1);
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
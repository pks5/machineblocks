include <../../lib/block.scad>;
include <../../lib/socket.scad>;

parts = "ALL";

if(parts == "WALL" || parts == "ALL"){
    block(
        baseLayers=23,
        grid=[8,1],
        pit = true,
        tongue = true,
        pitWallGaps= [[3,0,0]],
        // screwHolesZ = [[0,0], [7,0]],
        // screwHoleZSize = 2,
        // screwHolesY = [[0, 2], [0, 21]],
        // screwHoleYSize = 2,
        tongueClampThickness = 0.1
    );

    block(
        baseLayers = 6,
        grid=[2,2],
        knobs = [[0,1,1,1]],
        baseCutoutType = "NONE",
        brickOffset=[0,0.5,13],
        slanting=[0,0,0,-2]
        //screwHolesX=[[0,9,1],[1,9,1],[0,7,1],[1,7,1],[0,5,1],[1,5,1], [0,3,1],[1,3,1],[0,1,1],[1,1,1]],
        //screwHoleXSize=2.0
    );
}

if(parts == "TOP" || parts == "ALL"){
    translate([0,-15,0])
        block(
            baseLayers=1,
            grid=[8,1],
            pitWallGaps= [[3,0,0]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleZSize = 2,
            tongueClampThickness = 0.1,
            tongueAdjustment = 0,
            baseCutoutType = "GROOVE"
        );
}
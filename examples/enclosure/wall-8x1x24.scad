include <../../lib/block.scad>;
include <../../lib/socket.scad>;

parts = "ALL";
heightLayers = 23;
fromTop = 4;

if(parts == "WALL" || parts == "ALL"){
    block(
        baseLayers=heightLayers,
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
        brickOffset=[0,0.5, heightLayers - 6 - fromTop],
        slanting=[0,0,0,-2]
    );

    block(
        baseLayers = 1,
        grid=[2,1],
        knobs = false,
        baseCutoutType = "NONE",
        brickOffset=[0,0, heightLayers - fromTop]
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
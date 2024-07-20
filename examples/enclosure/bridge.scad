include <../../lib/block.scad>;

parts = "ALL";

if(parts == "WALL" || parts == "ALL"){
block(
    baseLayers=7,
    grid=[11,1],
    pit = true,
    tongue=true,
    pitWallGaps= [[3,0,0]],
    screwHolesY = [[0, 5], [0, 3], [0, 1]],
    screwHoleYSize = 2,
    knobTongueClampThickness = 0.1,
    baseCutoutType = "NONE",
    topPlateHeight = 1.0,
    brickOffset=[0,0.5,0],
    sideAdjustment=[-0.1,-0.1,0.1,-0.1]

);

block(
    baseLayers=7,
    grid=[11,1],
    pit = true,
    tongue=true,
    pitWallGaps= [[2,0,0]],
    screwHolesY = [[0, 5], [0, 3], [0, 1]],
    screwHoleYSize = 2,
    knobTongueClampThickness = 0.1,
    baseCutoutType = "NONE",
    topPlateHeight = 1.0,
    brickOffset=[0,-0.5,0],
    sideAdjustment=[-0.1,-0.1,-0.1,0.1]

);

}

if(parts == "TOP" || parts == "ALL"){
    translate([0,30,0]){
        block(
            baseLayers=1,
            grid=[11,1],
            pitWallGaps= [[3,0,0]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleZSize = 2,
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE",
            brickOffset=[0,0.5,0],
            sideAdjustment=[-0.1,-0.1,0.1,-0.1]
        );

        block(
            baseLayers=1,
            grid=[11,1],
            pitWallGaps= [[2,0,0]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleZSize = 2,
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE",
            brickOffset=[0,-0.5,0],
            sideAdjustment=[-0.1,-0.1,-0.1,0.1]
        );
    }
}
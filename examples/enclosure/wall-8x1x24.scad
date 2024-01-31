include <../../lib/block.scad>;

parts = "ALL";

if(parts == "WALL" || parts == "ALL"){
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
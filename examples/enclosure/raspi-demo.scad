include <../../lib/block.scad>;

//translate([0,8,0])
block(
    baseLayers=1,
    grid=[10,8],
    pillarGaps=[[1,1,7,5]],
    stabilizerExpansion = 1,
    stabilizerExpansionOffset = 0,
    screwHolesZ = [[0, 1], [9,1], [0,6], [9,6]],
    knobType = "NONE",
    withPcb=true,
    pcbDimensions=[40,30,3],
    pcbMountingType = "SCREWS",
    pcbScrewSockets = [[-25.93, 29.03], [22.83, 29.03], [-25.93, -28.97], [22.83, -28.97]],
    pcbScrewSocketHeight = 2.7,
    brickOffset=[0,1,0]
);


block(
    baseLayers=12,
    grid=[8,1],
    withPit = true,
    pitWallGaps= [[3,0,0]],
    screwHolesZ = [[0,0], [7,0]],
    brickOffset=[0,-5.5,0]
);

block(
    baseLayers=12,
    grid=[8,1],
    withPit = true,
    pitWallGaps= [[2,0,0]],
    screwHolesZ = [[0,0], [7,0]],
    brickOffset=[0,6.5,0]
);

block(
    baseLayers=12,
    grid=[1,8],
    withPit = true,
    pitWallGaps= [[0,0,0]],
    screwHolesZ = [[0,0], [7,0]],
    brickOffset=[6.5,0.5,0]
);

block(
    baseLayers=12,
    grid=[1,8],
    withPit = true,
    pitWallGaps= [[1,0,0]],
    screwHolesZ = [[0,0], [7,0]],
    brickOffset=[-6.5,0.5,0]
);

//LAN
translate([-19.12, -47, 14.05])
    mb_roundedcube([17, 48, 15.2], true, 2, "y");
                
//USB1
translate([-0.35, -47, 15.1])
    mb_roundedcube([15.8, 48, 17.3], true, 2, "y");
                
//USB2
translate([17.6, -47, 15.1])
    mb_roundedcube([15.8, 48, 17.3], true, 2, "y");
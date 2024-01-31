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
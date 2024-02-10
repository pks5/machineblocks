include <../../lib/block.scad>;

block(
    baseLayers=1,
    grid=[4,6],
    screwHolesZ = [[1, 0], [2,0], [1,5], [2,5]],
    knobType = "NONE",
    withPcb=true,
    pcbDimensions=[40,30,3],
    pcbMountingType = "SCREWS",
    pcbOffset=[0, 1,0],
    pcbScrewSockets = [[-13, -15], [13, 13], [13, -15], [-9, 13]],
    pcbScrewSocketHeight = 5.6,
    stabilizerExpansion = 1,
    stabilizerExpansionOffset = 0
);
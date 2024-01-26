include <../../lib/block.scad>;

block(
    baseLayers=1,
    grid=[6,6],
    screwHoles = [[0, 0], [5,0], [0,5], [5,5]],
    knobType = "NONE",
    withPcb=true,
    pcbDimensions=[40,30,3],
    pcbMountingType = "SCREWS",
    pcbScrewSockets = [[-13, -15], [13, 13], [13, -15], [-9, 13]],
    pcbScrewSocketHeight = 8
);
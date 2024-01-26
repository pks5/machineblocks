include <../../lib/block.scad>;

block(
    baseLayers=1,
    grid=[8,6],
    screwHoles = [[0, 0], [7,0], [0,5], [7,5]],
    knobType = "NONE",
    withPcb=true,
    pcbDimensions=[40,30,3]
);
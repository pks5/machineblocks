include <../../lib/block.scad>;

block(
    baseLayers=15,
    grid=[8,1],
    pit = true,
    tongue = true,
    pitWallGaps= [[2,0,0]],
    screwHolesZ = [[0,0], [7,0]],
    tongueClampThickness = 0.1
);
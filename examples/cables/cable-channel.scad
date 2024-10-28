include <../../lib/block.scad>;

block(
    baseLayers=3,
    grid=[4,2],
    pit = true,
    pitWallGaps= [[0,0,0], [1,0,0]],
    tongue = true,
    tongueClampThickness = 0,
    knobSize=5.1,
    pitWallThickness = 2.55 / 8
);

 translate([0,20,0])
        block(
            baseLayers=1,
            grid=[4,2],
            pitWallGaps= [[0,0,0], [1,0,0]],
            tongueClampThickness = 0,
            tongueOuterAdjustment = 0.1,
            baseCutoutType = "groove",
            knobSize=5.1,
            pitWallThickness = 2.55 / 8
        );
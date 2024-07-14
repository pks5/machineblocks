include <../../lib/block.scad>;

block(
    baseLayers=3,
    grid=[4,2],
    withPit = true,
    pitWallGaps= [[0,0,0], [1,0,0]],
    knobTongueClampThickness = 0,
    knobSize=5.1,
    pitWallThickness = 2.55
);

 translate([0,20,0])
        block(
            baseLayers=1,
            grid=[4,2],
            pitWallGaps= [[0,0,0], [1,0,0]],
            knobTongueClampThickness = 0,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE",
            knobSize=5.1,
            pitWallThickness = 2.55
        );
include <../../lib/block.scad>;

block(
    baseLayers=1,
    grid=[22,22],
    baseCutoutType = "NONE",
    knobGaps = ["NONE", [0,0,21,2], [1,0,12,1,true]],
    previewQuality = 0.4
);
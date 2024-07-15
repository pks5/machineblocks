include <../../lib/block.scad>;

block(
    baseLayers=1,
    grid=[22,22],
    baseCutoutType = "NONE",
    knobs = [true, [0,0,21,2, true], [1,0,12,1]],
    previewQuality = 0.4
);
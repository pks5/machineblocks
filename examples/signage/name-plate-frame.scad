include <../../lib/block.scad>;

block(
    baseLayers=1,
    grid=[16,17],
    baseCutoutType = "NONE",
    knobs = [[1, 1, 14, 3], [1, 5, 14, 7], [1, 9, 14, 11], [1, 13, 14, 15]],
    knobSize = 5.0,
    previewQuality = 0.4
);
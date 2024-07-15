include <../../lib/block.scad>;

block(
    baseLayers=1,
    grid=[12,16],
    baseCutoutType = "NONE",
    knobs = [[1, 1, 10, 2], [1, 4, 10, 5], [1, 7, 10, 8], [1, 10, 10, 11], [1, 13, 10, 14]],
    knobSize = 5.1,
    previewQuality = 0.4
);
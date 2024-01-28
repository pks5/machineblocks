include <../../lib/block.scad>;

block(
    baseLayers=1,
    grid=[16,16],
    screwHoles = "ALL",
    pillarGaps = "AUTO",
    stabilizerExpansion = 1,
    stabilizerExpansionOffset = 0,
    previewQuality = 0.4
);
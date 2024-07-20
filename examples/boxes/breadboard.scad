use <../../lib/block.scad>;

//Generate 6x6 Box
block(
    baseLayers = 4,
    grid = [12, 8],
    pit=true,
    pitWallThickness = [5.9/8, 4.6/8],
    baseCutoutMaxDepth=2.6,
    pitDepth = 8.8,
    knobs = false,
    heightAdjustment = 0.0 //Reduce this value if the base of the brick is too high
);
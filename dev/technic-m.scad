include <../lib/block.scad>;

/* [Hidden] */

grid = [4, 1];

block(
    baseLayers=2.5, 
    baseRoundingRadius = [0,4,0],
    baseCutoutRoundingRadius = 0,
    baseCutoutType = "none",
    holesX = true,
    holeXCentered = false,
    holeXGridOffsetZ = 1.25,
    grid=grid, 
    knobs = false
);

block(
    gridOffset=[1.5,0,0],
    baseLayers=10, 
    baseRoundingRadius = [0,4,0],
    baseCutoutRoundingRadius = 0,
    baseCutoutType = "none",
    holesX = true,
    holeXCentered = false,
    holeXGridOffsetZ = 1.25,
    holeXGridSizeZ = 2.5,
    grid=[1, 1], 
    knobs = false
);


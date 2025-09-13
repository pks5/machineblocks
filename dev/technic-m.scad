include <../lib/block.scad>;

/* [Hidden] */

grid = [1, 1];

block(
    baseLayers=1, 
    baseRoundingRadius = [0,0,[0,0,0,8]],
    baseCutoutRoundingRadius = 2,
    baseCutoutType = "classic",
    grid=grid, 
    knobType = "technic"
);


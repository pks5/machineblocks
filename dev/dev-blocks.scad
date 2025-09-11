echo(version=version());

include <../lib/block.scad>;

/* [Hidden] */

grid = [2, 1];

block(baseLayers=3, grid=grid, knobType = "technic", holesX=true);

block(baseLayers=1, grid=grid, gridOffset=[0,1,1], baseSideAdjustment=[-0.1,-0.1,0.1,-0.1]);
        
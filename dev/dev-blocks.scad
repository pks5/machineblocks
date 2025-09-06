echo(version=version());

include <../lib/block.scad>;

/* [Hidden] */

grid = [4, 2];

block(baseLayers=3, baseReliefCut = true, grid=grid, knobType = "technic", alignBottom=true);
        
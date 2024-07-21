include <../../lib/block.scad>;

block(baseLayers=3, grid=[4,2], slanting=[0,0,1,1], heightAdjustment=-0.2);

translate([-40,0,0])
block(baseLayers=3, grid=[2,2], slanting=[1,1,1,1], heightAdjustment=-0.2);

translate([60,0,0])
block(baseLayers=3, grid=[6,4], slanting=[0,0,-1,-1], heightAdjustment=-0.2);

translate([60,40,0])
block(baseLayers=3, grid=[6,4], slanting=[2,0,0,0], heightAdjustment=-0.2);

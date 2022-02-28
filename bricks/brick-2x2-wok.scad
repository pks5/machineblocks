echo(version=version());

include <../lib/block.scad>;

//2x2 Brick    
block(baseLayers=3, grid=[2,2], withKnobs=false);
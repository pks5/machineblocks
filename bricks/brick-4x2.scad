echo(version=version());

include <../lib/block-v2.scad>;

//4x2 Brick
translate([0,0,0])
    block(baseLayers=3);
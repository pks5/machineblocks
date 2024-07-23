echo(version=version());

include <../lib/block.scad>;

block(
    grid=[4,2],
    baseLayers=3,
    tubeZSize = 6.2
);
  
translate([0,50,0])
block(
    grid=[6,6],
    baseLayers=1,
    tubeZSize = 6.2
);


//translate([0, 50,0])
//    mb_rounded_block(size=[32,16,9.6], resolution=30, center=true, radius=[0,0,[4,0,0,0]]);
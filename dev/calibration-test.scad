echo(version=version());

include <../lib/block.scad>;

block(
    grid=[4,2],
    baseLayers=3,
    baseRounding=true,
    baseRoundingRadius = [0, 0, 4],
    baseCutoutRoundingRadius = 2.7, 
    sideAdjustment=0
);
  

//translate([0, 50,0])
//    mb_rounded_block(size=[32,16,9.6], resolution=30, center=true, radius=[0,0,[4,0,0,0]]);
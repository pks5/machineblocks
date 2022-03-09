echo(version=version());

include <../lib/window_block.scad>;

translate([0, 0, 38])
window_block(
    top=true, 
    brickHeight=2, 
    grid=[4,4], 
    logoText="\uf0e7",
    logoFont="Font Awesome 5 Free Solid"
);

translate([0, 0, 0])
hollowBlock(brickHeight=2, grid=[4,4], alwaysOnFloor=true, top=false);



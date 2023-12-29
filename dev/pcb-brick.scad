echo(version=version());

include <../lib/pcb_block.scad>;

translate([0, 0, 38])
pcb_block(
    top=true, 
    brickHeight=2, 
    grid=[4,4], 
    withText=true,
    text="\uf0e7",
    textFont="Font Awesome 5 Free Solid"
);

translate([0, 0, 0])
hollowBlock(brickHeight=2, grid=[4,4], alwaysOnFloor=true, top=false);



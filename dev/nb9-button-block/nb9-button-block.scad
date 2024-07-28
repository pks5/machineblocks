echo(version=version());

include <../../lib/hollow_block.scad>;

hollowBlock(
    blockHeight=57.5, 
    withInnerWallFilled=true, 
    knobs=[true, [1,1,4,4, true]], 
    grid=[6,6]
);
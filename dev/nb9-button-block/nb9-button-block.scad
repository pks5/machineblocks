echo(version=version());

include <../../lib/hollow_block.scad>;

hollowBlock(blockHeight=57.5, withInnerWallFilled=true, withKnobs=true, knobGaps=[[1,1,4,4]], grid=[6,6]);
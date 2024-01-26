echo(version=version());

include <../../lib/block.scad>;

width = 16;
height = 14;
rounding=2;

mb_roundedcube([width, width, height], true, rounding, "y");
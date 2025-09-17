echo(version=version());

include <../../lib/block.scad>;

width = 15.8;
height = 17.3;
rounding=2;

mb_roundedcube([width, width, height], true, rounding, "y");
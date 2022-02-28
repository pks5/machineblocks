echo(version=version());

include <../../lib/block-v2.scad>;

width = 16;
height = 14;
rounding=2;

roundedcube([width, width, height], true, rounding, "y");
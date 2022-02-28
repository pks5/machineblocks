echo(version=version());

include <../../lib/block-v2.scad>;

width = 15.8;
height = 17.3;
rounding=2;

roundedcube([width, width, height], true, rounding, "y");
echo(version=version());

include <../../lib/block.scad>;

width = 17;
height = 15.2;
rounding=2;

roundedcube([width, width, height], true, rounding, "y");
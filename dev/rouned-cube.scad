echo(version=version());

include <../lib/block-v2.scad>;

width = 21;
height = 4;

roundedcube([width, width, height], true, 2, "y");
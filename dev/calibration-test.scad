echo(version=version());

include <../lib/block-v2.scad>;

color("red")
    translate([10, 10, 0])
        block(grid=[6,6], adjustSizeX=0, adjustSizeY=0, zHolesOuterSize = 6.45, knobSize=4.95);


      
  
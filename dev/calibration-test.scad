echo(version=version());

include <../lib/block.scad>;

color("red")
    translate([10, 10, 0])
        block(grid=[6,6], adjustSize=[0,0,0,0], zHolesOuterSize = 6.45, knobSize=4.95);


      
  
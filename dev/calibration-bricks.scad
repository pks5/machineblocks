echo(version=version());

include <../lib/block-v2.scad>;

color("yellow")
    translate([-10, -10, 0])
        block(grid=[1,1]);
       
color("green")
    translate([-10, 10, 0])
        block(grid=[1,4]);

color("red")
    translate([10, 10, 0])
        block(grid=[4,4], withKnobsFilled=true);
        
color("blue")
    translate([10, -20, 0])
        block(grid=[4,2], withKnobsFilled=true);        


      
  
echo(version=version());

include <../lib/block-v2.scad>;

color("yellow")
    translate([-20, -20, 0])
        block(baseLayers=3, grid=[2,1], withXHoles=true, withKnobsFilled=false);
       
color("green")
    translate([20, -20, 0])
        block(baseLayers=3, grid=[1,4]);

color("red")
    translate([30, -60, 0])
        block(baseLayers=3, grid=[2,2], withKnobsFilled=true);
        
color("blue")
    translate([-30, -60, 0])
        block(baseLayers=3, grid=[4,2], withKnobsFilled=true);        

color("magenta")
    translate([50, -20, 0])
        block(baseLayers=3, grid=[1,3], withYHoles=true, withKnobsFilled=false);
      
  
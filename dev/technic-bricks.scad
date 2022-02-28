echo(version=version());

include <../lib/block-v2.scad>;

color("yellow")
    translate([-20, -10, 0])
        block(baseLayers=3, grid=[2,1], withXHoles=true, withKnobsFilled=false);
       
color("blue")
    translate([-30, -36, 0])
        block(grid=[4,2], withKnobsFilled=true, withZHoles = true);        

color("magenta")
    translate([-30, -70, 0])
        block(baseLayers=3, grid=[1,3], withYHoles=true, withKnobsFilled=false);
      
  
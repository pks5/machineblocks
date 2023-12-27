/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Technic Bricks
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/block-v2.scad>;

color("yellow")
    translate([-20, -10, 0])
        block(baseLayers=3, grid=[2,1], withXHoles=true, withKnobsFilled=false);
       
color("blue")
    translate([-30, -26, 0])
        block(grid=[4,2], withKnobsFilled=true, withZHoles = true);        

color("magenta")
    translate([-30, -50, 0])
        block(baseLayers=3, grid=[1,3], withYHoles=true, withKnobsFilled=false);
        
color("orange")
    translate([-30, -80, 0])
        block(baseLayers=3, grid=[2,4], withYHoles=true, withKnobsFilled=false);
        
color("silver")
    translate([-30, -110, 0])
        block(baseLayers=3, grid=[2,3], withZHoles=true, withYHoles=true, withKnobsFilled=false);
      
  
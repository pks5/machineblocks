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
    translate([0, -10, 0])
        block(baseLayers=3, grid=[2,1], withXHoles=true, withKnobsFilled=false);
       
color("blue")
    translate([0, -26, 0])
        block(grid=[4,2], withKnobsFilled=true, withZHoles = true);        

color("magenta")
    translate([0, -50, 0])
        block(baseLayers=3, grid=[1,3], withYHoles=true, withKnobsFilled=false);
        
translate([0, -80, 0])
        block(baseLayers=3, grid=[2,4], withYHoles=true, withKnobsFilled=false);
        

translate([0, -110, 0])
    block(baseLayers=3, grid=[2,3], withZHoles=true, withYHoles=true, withKnobsFilled=false);
      
  
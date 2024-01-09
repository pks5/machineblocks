/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Test Bricks
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
    translate([-37, -20, 0])
        block(baseLayers=3, grid=[2,1], withHolesX=true, knobsFilled=false);

       
color("green")
    translate([20, -20, 0])
        block(baseLayers=3, grid=[1,4]);
     
color("green")
    translate([30, -20, 0])
        block(baseLayers=3, grid=[1,1]);
 
color("red")
    translate([30, -60, 0])
        block(baseLayers=3, grid=[2,2], knobsFilled=true);
 
 color("blue")
    translate([-30, -60, 0])
        block(baseLayers=3, grid=[4,2], knobsFilled=true);     
        
        
color("white")
    translate([-30, -90, 0])
        block(withHolesZ=true, grid=[4,2], knobsFilled=true, helperStartZ=0);
  

/*  
color("magenta")
    translate([50, -20, 0])
        block(baseLayers=3, grid=[1,3], withHolesY=true, xyHolesInsetDepth = 0.5, knobsFilled=false);
*/
      

     

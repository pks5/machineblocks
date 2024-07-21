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

include <../../lib/block.scad>;


color("yellow")
    translate([-37, -20, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "TECHNIC");

       
color("green")
    translate([20, -20, 0])
        block(baseLayers=3, grid=[1,4]);
     
color("green")
    translate([30, -20, 0])
        block(baseLayers=3, grid=[1,1]);
 
color("red")
    translate([30, -60, 0])
        block(baseLayers=3, grid=[2,2]);
 
 color("blue")
    translate([-30, -60, 0])
        block(baseLayers=3, grid=[4,2]);     
        
        
color("white")
    translate([-30, -90, 0])
        block(holesZ=true, grid=[4,2], helperStartZ=0);
  

/*  
color("magenta")
    translate([50, -20, 0])
        block(baseLayers=3, grid=[1,3], holesY=true, xyHolesInsetDepth = 0.5, knobType = "TECHNIC");
*/
      

     

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

include <../../lib/block.scad>;

color("yellow")
    translate([0, -10, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "TECHNIC");
       
color("blue")
    translate([0, -26, 0])
        block(grid=[4,2], holesZ = true);        

color("magenta")
    translate([0, -50, 0])
        block(baseLayers=3, grid=[1,3], holesY=true, knobType = "TECHNIC");
        
translate([0, -80, 0])
        block(baseLayers=3, grid=[2,4], holesY=true, knobType = "TECHNIC");
        

translate([0, -110, 0])
    block(baseLayers=3, grid=[2,3], holesZ=true, holesY=true, knobType = "TECHNIC");

color("green")
    translate([20, -110, 0])
        block(baseLayers=9, grid=[1,6], holesY=true, knobType = "TECHNIC");

color("green")
    translate([-50, -110, 0])
        block(baseLayers=9, grid=[6,1], holesX=[[0,0,2,1]], knobType = "TECHNIC");        
      
  
/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Basic Brick Set without knobs
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/block.scad>;

//4x2 Plate
translate([10,10,0])
    block(withKnobs=false);

//4x2 Brick
translate([10,30,0])
    block(baseLayers=3, withKnobs=false);
    
//2x2 Brick    
color("blue")
    translate([-30,30,0])
        block(baseLayers=3, grid=[2,2], withKnobs=false);

//2x2 Plate
color("blue")
    translate([-30,10,0])
        block(grid=[2,2], withKnobs=false);

//6x4 Plate        
color("red")
    translate([20, -35, 0])
        block(grid=[6,4], withKnobs=false);

//6x6 Plate
color("red")
    translate([20, -90, 0])
        block(grid=[6,6], withKnobs=false);
        
//4x4 Plate
color("red")
    translate([75, -35, 0])
        block(grid=[4,4], withKnobs=false);        

//6x1 Brick        
color("green")
    translate([-40, -10, 0])
        block(baseLayers=3, grid=[6,1], withKnobs=false);

//4x1 Brick        
color("green")
    translate([-40, -20, 0])
        block(baseLayers=3, grid=[4,1], withKnobs=false);

//2x1 Brick
color("green")
    translate([-40, -30, 0])
        block(baseLayers=3, grid=[2,1], withKnobs=false);

//1x1 Brick        
color("green")
    translate([-40, -40, 0])
        block(baseLayers=3, grid=[1,1], withKnobs=false);

//1x1 Plate        
color("green")
    translate([-40, -50, 0])
        block(grid=[1,1], withKnobs=false);

//2x1 Plate
color("green")
    translate([-40, -60, 0])
        block(grid=[2,1], withKnobs=false);

//4x1 Plate        
color("green")
    translate([-40, -70, 0])
        block(grid=[4,1], withKnobs=false);

//6x1 Plate
color("green")
    translate([-40, -80, 0])
        block(grid=[6,1], withKnobs=false);
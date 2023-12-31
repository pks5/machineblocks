/**
* MachineBlocks Basic Brick Set
* https://machineblocks.com 
*
* Copyright (c) 2022 Jan P. Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

//Include the MachineBlocks library
include <../../lib/block-v2.scad>;

//4x2 Plate
translate([10,10,0])
    block();

//4x2 Brick
translate([10,30,0])
    block(baseLayers=3);
    
//2x2 Brick    
translate([-30,30,0])
    block(baseLayers=3, grid=[2,2]);

//2x2 Plate
translate([-30,10,0])
    block(grid=[2,2]);

//6x4 Plate        
translate([20, -20, 0])
    block(grid=[6,4]);

//6x6 Plate
translate([20, -70, 0])
    block(grid=[6,6]);
        
//4x4 Plate
translate([70, -20, 0])
    block(grid=[4,4]);        

//6x1 Brick        
translate([-40, -10, 0])
    block(baseLayers=3, grid=[6,1]);

//4x1 Brick        
translate([-40, -20, 0])
    block(baseLayers=3, grid=[4,1]);

//2x1 Brick
translate([-40, -30, 0])
    block(baseLayers=3, grid=[2,1]);

//1x1 Brick        
translate([-40, -40, 0])
    block(baseLayers=3, grid=[1,1]);

//1x1 Plate        
translate([-40, -50, 0])
    block(grid=[1,1]);

//2x1 Plate
translate([-40, -60, 0])
    block(grid=[2,1]);

//4x1 Plate        
translate([-40, -70, 0])
    block(grid=[4,1]);

//6x1 Plate
translate([-40, -80, 0])
    block(grid=[6,1]);
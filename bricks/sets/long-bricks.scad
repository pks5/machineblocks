/**
* MachineBlocks Long Bricks Set
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

translate([10, -10, 0])
    block(baseLayers=3, grid=[8,2]);
        
translate([10, -30, 0])
    block(baseLayers=3, grid=[10,2]);

translate([10, -50, 0])
    block(baseLayers=3, grid=[12,2]);

translate([10, -70, 0])
    block(baseLayers=3, grid=[16,2]);

translate([10, -90, 0])
    block(baseLayers=3, grid=[20,2]);
        
translate([10, 10, 0])
    block(baseLayers=3, grid=[8,1]);
        
translate([10, 20, 0])
    block(baseLayers=3, grid=[10,1]);

translate([10, 30, 0])
    block(baseLayers=3, grid=[12,1]);

translate([10, 40, 0])
    block(baseLayers=3, grid=[16,1]);

translate([10, 50, 0])
    block(baseLayers=3, grid=[20,1]);        

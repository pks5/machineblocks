/**
* MachineBlocks Long Plates without knobs
* https://machineblocks.com 
*
* Copyright (c) 2022 Jan P. Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

//Include the MachineBlocks library
echo(version=version());

include <../../lib/block.scad>;

translate([10, -10, 0])
    block(grid=[8,2], knobType="NONE");
        
translate([10, -30, 0])
    block(grid=[10,2], knobType="NONE");

translate([10, -50, 0])
    block(grid=[12,2], knobType="NONE");

translate([10, -70, 0])
    block(grid=[16,2], knobType="NONE");

translate([10, -90, 0])
    block(grid=[20,2], knobType="NONE");
        
translate([10, 10, 0])
    block(grid=[8,1], knobType="NONE");
        
translate([10, 20, 0])
    block(grid=[10,1], knobType="NONE");

translate([10, 30, 0])
    block(grid=[12,1], knobType="NONE");

translate([10, 40, 0])
    block(grid=[16,1], knobType="NONE");

translate([10, 50, 0])
    block(grid=[20,1], knobType="NONE");        

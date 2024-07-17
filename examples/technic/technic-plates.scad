/**
* MachineBlocks Technic Plates
* https://machineblocks.com 
*
* Copyright (c) 2022 Jan P. Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

//Include the MachineBlocks library
include <../../lib/block.scad>;

translate([10, -20, 0])
    block(
        grid=[4,2], 
        holesZ = true
    );

translate([10, -40, 0])
    block(
        grid=[6,2], 
        holesZ = true
    );
 
translate([10, -60, 0])
    block(
        grid=[8,2], 
        holesZ = true
    );

translate([10, -80, 0])
    block(
        grid=[10,2], 
        holesZ = true
    );
  
translate([10, -100, 0])
    block(
        grid=[12,2], 
        holesZ = true
    );
    
translate([10, -120, 0])
    block(
        grid=[16,2], 
        holesZ = true
    );

translate([10, -140, 0])
    block(
        grid=[20,2], 
        holesZ = true
    );

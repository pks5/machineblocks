/**
* MachineBlocks Brick 2x2
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

//Generate 2x2 Brick    
block(
    baseLayers=3, 
    grid=[2,2]
);
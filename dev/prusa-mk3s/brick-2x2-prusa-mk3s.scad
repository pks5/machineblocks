/**
* MachineBlocks Brick 4x2
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

//Generate 4x2 Brick
block(
    grid=[2,2],
    baseHeightAdjustment=-0.2
);
/**
* MachineBlocks Brick 8x2 without knobs
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

//Generate the brick
block(
    baseLayers=3, 
    grid=[8,2], 
    withKnobs=false
);
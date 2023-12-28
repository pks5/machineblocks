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

//Include the library
include <../../lib/block-v2.scad>;

//Generate 4x2 Brick
block(grid=[4,2], baseLayers=3, wallGapsX=[[0, 0]]);
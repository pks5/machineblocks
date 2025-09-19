/**
* MachineBlocks Brick 4x2 with text or symbols
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

//Generate the brick
block(
    baseLayers=6, 
    grid=[4,4], 
    textSize=6, 
    textSide=5,
    baseSideAdjustment=[0,0,0,0],
    text="\uf004\uf004\uf004", 
    textFont="Font Awesome 6 Free Solid", 
    textDepth=0.7, 
    textSpacing=1.1,
    alignBottom=false,
    knobs=[true, [0,1,3,2,true]]
); 

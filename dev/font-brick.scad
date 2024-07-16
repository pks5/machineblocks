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
include <../lib/block.scad>;

//Generate the brick
block(
    baseLayers=6, 
    grid=[4,4], 
    knobs=false,
    withText=true, 
    textSize=6, 
    textSide=5,
    sideAdjustment=[0,0,0,0],
    text="\uf1e2\ue4dc\uf714", 
    textFont="Font Awesome 6 Free Solid", 
    textDepth=0.7, 
    textSpacing=1
); 

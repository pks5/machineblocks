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
include <../lib/block-v2.scad>;

//Generate the brick
block(
    baseLayers=3, 
    grid=[4,2], 
    withText=true, 
    textSize=6, 
    text="\uf1e2\ue4dc\uf714", 
    textFont="Font Awesome 6 Free Solid", 
    textDepth=0.7, 
    textSpacing=1
); 

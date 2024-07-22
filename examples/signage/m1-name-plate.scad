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


block(
    grid=[14,3], 
    knobs=false,
    wallThickness=1.4,
    textSize=12, 
    textSide=5,
    sideAdjustment=[0,0,0,0],
    text="Ibrahim Cakir", 
    textFont="DinPro Medium", 
    textDepth=0.8, 
    textSpacing=1.1
);



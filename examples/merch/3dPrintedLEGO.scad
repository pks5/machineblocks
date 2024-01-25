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
    grid=[3,2], 
    knobType="NONE",
    withText=true, 
    textSize=7, 
    textSide=5,
    sideAdjustment=[0,0,0,0],
    text="3D", 
    textFont="RBNo3.1 Black", 
    textDepth=0.6, 
    textSpacing=1.1
); 

translate([0, -20, 0])
block(
    grid=[7,2], 
    knobType="NONE",
    withText=true, 
    textSize=7, 
    textSide=5,
    sideAdjustment=[0,0,0,0],
    text="PRINTED", 
    textFont="RBNo3.1 Black", 
    textDepth=0.6, 
    textSpacing=1.1
); 

translate([0, -40, 0])
block(
    grid=[4,2], 
    knobType="NONE",
    withText=true, 
    textSize=7, 
    textSide=5,
    sideAdjustment=[0,0,0,0],
    text="LEGO", 
    textFont="RBNo3.1 Black", 
    textDepth=0.6, 
    textSpacing=1.1
); 

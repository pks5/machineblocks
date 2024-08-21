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
    knobs=false,
    textSize=6.0, 
    textSide=5,
    baseSideAdjustment=[0,0,0,0],
    text="Print", 
    textFont="RBNo3.1 Black", 
    textDepth=0.8, 
    textSpacing=1
); 

translate([0, -20, 0])
block(
    grid=[7,2], 
    knobs=false,
    textSize=6.0, 
    textSide=5,
    baseSideAdjustment=[0,0,0,0],
    text="Your Own", 
    textFont="RBNo3.1 Black", 
    textDepth=0.8, 
    textSpacing=1
); 

translate([0, -40, 0])
block(
    grid=[5,2], 
    knobs=false,
    textSize=6.0, 
    textSide=5,
    baseSideAdjustment=[0,0,0,0],
    text="Bricks", 
    textFont="RBNo3.1 Black", 
    textDepth=0.8, 
    textSpacing=1
); 

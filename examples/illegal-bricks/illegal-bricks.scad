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

//Plate with centered knob
block(
    grid=[2,2],
    knobsCentered = true,
    knobType = "TECHNIC",
    knobSize=5,
    heightAdjustment=-0.2
);

//Cross
translate([24, 0, 0])
union(){
    block(
        grid=[3,1], 
        wallGapsX=[[1,2]],
        knobSize=5,
        heightAdjustment=-0.2
    );

    block(
        grid=[1, 3], 
        wallGapsY=[[1,2]],
        knobSize=5,
        heightAdjustment=-0.2
    );    
}

//Plate with hole
translate([56, 0, 0])
union(){
    block(
        grid=[1, 4], 
        wallGapsY=[[0,1], [3,1]],
        knobSize=5,
        heightAdjustment=-0.2,
        brickOffset=[-1.5,0,0]
    );  

    block(
        grid=[4,1], 
        wallGapsX=[[0,0], [3,0]],
        knobSize=5,
        heightAdjustment=-0.2,
        brickOffset=[0,1.5,0]
    );

    block(
        grid=[1, 4], 
        wallGapsY=[[0,0], [3,0]],
        knobSize=5,
        heightAdjustment=-0.2,
        brickOffset=[1.5,0,0]
    );    

    block(
        grid=[4,1], 
        wallGapsX=[[0,1], [3,1]],
        knobSize=5,
        heightAdjustment=-0.2,
        brickOffset=[0,-1.5,0]
    );
}
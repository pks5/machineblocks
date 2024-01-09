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
include <../../lib/block-v2.scad>;

block(
    grid=[2,2],
    knobsCentered = true,
    knobsFilled = false,
    knobSize=5,
    heightAdjustment=-0.2
);

translate([30, 0, 0])
    difference(){
        union(){
            block(
                grid=[4,4],
                knobSize=5,
                heightAdjustment=-0.2
            );
            block(
                grid=[2,2],
                baseSolid=true,
                withKnobs=false,
                sideAdjustment=[1,1,1,1],
                heightAdjustment=-0.2
            );   
        }

        block(
            grid=[2,2],
            baseLayers=6,
            alwaysOnFloor=false,
            baseSolid=true,
            withKnobs=false,
            sideAdjustment=[0.2,0.2,0.2,0.2]
        );
    }

translate([64, 0, 0])
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
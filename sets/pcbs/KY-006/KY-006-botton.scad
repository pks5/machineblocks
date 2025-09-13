/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Block for KY-006 module (bottom)
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../lib/pcb_block.scad>;

withTop=false;
withBottom=true;


if(withBottom){
    translate([-30, 0, 0]){
        pcb_block(top=false, brickHeight=2, grid=[3,4], pcbY=19.5, pcbX=15.5, pins=[-1,0,0]);
    }
}

if(withTop){
    translate([30, 0, 0]){
        pcb_block(top=true, brickHeight=2, grid=[3,4]);
    }
}
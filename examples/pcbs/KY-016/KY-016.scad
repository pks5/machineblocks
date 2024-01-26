/**
* Machine Blocks
* https://makermaker.me/machineblocks 
*
* Block for KY-016 module
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../lib/pcb_block.scad>;

pcb_block(
    top=true, 
    grid=[3,4], 
    brickHeight=2, 
    withText=true,
    text="\uf0eb",
    textFont="Font Awesome 6 Free Solid"
);

translate([-25, 0, 0]){
    pcb_block(
        top=false, 
        grid=[3,4], 
        pcbY=19.2, 
        pcbX=15.5, 
        pins=[0,0,0,0]
    );
}
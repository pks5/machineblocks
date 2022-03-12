/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Block for KY-016 module (bottom)
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/pcb_block.scad>;

translate([-30, 0, 0]){
    pcb_block(top=false, grid=[3,4], pcbY=19.2, pcbX=15.5, pins=[0,-1,-1,-1], withPinHoleSupport=true);
}
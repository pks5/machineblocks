/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Block for KY-002 module (bottom)
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../lib/pcb_block.scad>;

pcb_block(top=false, brickHeight=2, grid=[3,6], pcbY=30.5, pcbX=15.3, pins=[0,0,0,0]);

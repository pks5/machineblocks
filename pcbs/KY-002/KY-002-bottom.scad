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

include <../../lib/window_block.scad>;

window_block(top=false, brickHeight=2, grid=[3,4], pcbY=20, pcbX=15.5, pins=[-1,0,0]);

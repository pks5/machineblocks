/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Block for KY-016 module (top)
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/pcb_block.scad>;

pcb_block(
    top=true, 
    grid=[3,4], 
    brickHeight=2, 
    withText=true,
    text="\uf0eb",
    textFont="Font Awesome 5 Free Solid"
);
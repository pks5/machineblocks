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

include <../../lib/window_block.scad>;

translate([30, 0, 0]){
    window_block(top=true, grid=[3,4], brickHeight=2, logoText="\uf0eb",
    logoFont="Font Awesome 5 Free Solid");
}
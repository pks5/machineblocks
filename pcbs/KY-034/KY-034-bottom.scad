/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Block for KY-034 module (bottom)
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/window_block.scad>;

translate([-30, 0, 0]){
    window_block(top=false, 
            grid=[3,4], 
            pcbY=19.7, 
            pcbX=17.1, 
            pins=[0,0,0]
    );
}
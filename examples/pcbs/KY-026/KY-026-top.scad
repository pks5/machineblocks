/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Block for KY-002 module (top)
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../lib/pcb_block.scad>;

difference(){
    pcb_block(
        top=true, 
        brickHeight=3, 
        grid=[3,6],
        withText=true, 
        text="\uf06d",
        textFont="Font Awesome 6 Free Solid",
        textSize=7,
            textDepth=-4,
    textOffsetVertical=-2.5
    );

    translate([0,-20.9,11]){
        rotate([90,0,0])
            cylinder(h=4, r=3.5);
    }
}

translate([0.6,-23.9,6.52]){
    cube([0.6,1.5,8.15]);
}
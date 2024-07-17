/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Raspberry Pi Camera Case Top
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../../../lib/shapes.scad>;
use <../../pcbs/lib/hollow_block.scad>;

floorHeight = 3.8;
topPlateHeight = 1.3;
brickHeight = 4;

difference(){
    hollowBlock(
        brickHeight=brickHeight, 
        floorHeight=floorHeight, 
        topPlateHeight=topPlateHeight,
        top=true,
        center=true,
        alignBottom=true,
        grid=[2,4],
        withText=true,
        textSide=4,
        text="\uf030",
        textFont="Font Awesome 5 Free Solid"
    );
    
    translate([5, 0, 6.25]){
        mb_roundedcube([18, 18, 2.5], true, 1, "x");
    }
    
    translate([-5, 0, 21.5]){
        rotate([0, 90,0]){
            cylinder(h=10, r=0.5 * 5, center=true, $fn=15);
        }
    }
    
    translate([-8, 0, 21.5]){
        rotate([0, 90,0]){
            cylinder(h=1, r=0.5 * 6, center=true, $fn=15);
        }
    }
}

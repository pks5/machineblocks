/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Raspberry Pi Camera Case Bottom
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/hollow_block.scad>;

floorHeight = 3.8;
topPlateHeight = 1.3;
brickHeight = 4;

difference(){
    union(){
        hollowBlock(
            brickHeight=brickHeight, 
            floorHeight=floorHeight, 
            topPlateHeight=topPlateHeight,
            innerWallHeight=1.2, 
            withInnerWallFilled=true, 
            top=false,
            center=true, 
            alwaysOnFloor=true,
            grid=[2,4]
        );
        
        translate([-5.5,0,20.25]){
            cube([1.5, 25.5, 30.5], true);  
        }
        
        translate([-1.75,0,8.15]){
            cube([6, 25.5, 6.3], true);  
        }
        
        translate([-2.75,-10.6,23.4]){
            cube([4, 4.3, 24.2], true);  
        }
        
        translate([-2.75,10.6,23.4]){
            cube([4, 4.3, 24.2], true);  
        }
    };
    
    translate([0,0,21.5]){
        rotate([0, 90,0]){
            cylinder(h=17.9, r=0.5 * 8, center=true, $fn=15);
        }
    }
    
    translate([4.2,-10.6,21]){
        rotate([0, 90,0]){
            cylinder(h=17.9, r=0.5 * 2.2, center=true, $fn=15);
        }
    }
    
    translate([4.2,-10.6,33.35]){
        rotate([0, 90,0]){
            cylinder(h=17.9, r=0.5 * 2.2, center=true, $fn=15);
        }
    }
    
    translate([4.2,10.6,21]){
        rotate([0, 90,0]){
            cylinder(h=17.9, r=0.5 * 2.2, center=true, $fn=15);
        }
    }
    
    translate([4.2,10.6,33.35]){
        rotate([0, 90,0]){
            cylinder(h=17.9, r=0.5 * 2.2, center=true, $fn=15);
        }
    }
};
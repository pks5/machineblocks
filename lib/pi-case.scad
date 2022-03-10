/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Raspberry Pi Case Body Lib
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <./block-v2.scad>;
include <./prism.scad>;

baseSideLength=8;
brickHeight = 3;
blockHeight = 28.40;
floorHeight = 3.1;
lidHeight = 3;
lidHeightTolerance = 0.1;
grid = [8, 12];
halfGrid=[8, 0.5*grid[1]];
plateHeight = 0.6;
wallThickness = 2;
wallY1Thickness = 3;

wallInset = 1;
doubleThinWallThickness = 2*(wallThickness - wallInset);

adjustSizeX = 0;
adjustSizeY = 0;

finalObjectSizeX = (halfGrid[0] * baseSideLength) + adjustSizeX;
finalObjectSizeY = 2* ((halfGrid[1] * baseSideLength) + adjustSizeY);

module foot(footX, footY, withHole){
    footSize = 6;
    footHoleSize = 2.2;
    footSizeZ = 2.2;
    
    translate([footX, footY, 0.5*footSizeZ]){
        difference(){
            cylinder(h=footSizeZ, r1=0.5*footSize, r2=0.5*footSize, center=true, $fn=20);
            if(withHole){
                cylinder(h=footSizeZ + 0.1, r1=0.5*footHoleSize, r2=0.5*footHoleSize, center=true, $fn=20);
            }
        }
    }
}

module pi_case_body(){
    //Body
    translate([0, 0, 0.5*blockHeight]){
        union(){
            difference(){
                union(){
                    translate([0, 0.25 * finalObjectSizeY, 0]){
                    //Body block with base holes
                        block(baseHeight=blockHeight, baseSideLength=baseSideLength, plateHeight=blockHeight - (floorHeight - plateHeight), grid=halfGrid, withKnobs=false, center=true, adjustSizeX=adjustSizeX, adjustSizeY=adjustSizeY);
                    }
                    
                    translate([0, -0.25 * finalObjectSizeY, 0]){
                    //Body block with base holes
                        block(baseHeight=blockHeight, baseSideLength=baseSideLength, plateHeight=blockHeight - (floorHeight - plateHeight), grid=halfGrid, withKnobs=false, center=true, adjustSizeX=adjustSizeX, adjustSizeY=adjustSizeY);
                    }
                    
                    
                }
                
                //Cut hole for lid
                translate([0, 0, 0.5*blockHeight]){
                    cube([finalObjectSizeX-doubleThinWallThickness, finalObjectSizeY-doubleThinWallThickness, 2*(lidHeight + lidHeightTolerance)], center=true);
                }
                
                //Cut hole for contents
                difference(){
                    translate([0, 0.5 * (wallY1Thickness - wallThickness), 0.5*blockHeight]){
                        cube([finalObjectSizeX - 2*wallThickness, finalObjectSizeY - (wallThickness + wallY1Thickness), 2*(blockHeight - floorHeight)], center=true);
                    }
                    //Memory Card Additional Wall
                    //TODO create variables
                    translate([0, 44, -0.5*blockHeight+10.6]){
                        cube([18, 4 , 15], center=true);
                    }
                }
                
                
                //LAN
                //TODO create variables
                translate([-19.12, 0, -0.5*blockHeight]){
                    union(){
                        translate([0, -47, 14.05])
                            roundedcube([17, 17, 15.2], true, 2, "y");
                        translate([0, -42.5, 25])
                            cube([17, 7, 10], center=true);
                    }
                }
                
                //USB1
                //TODO create variables
                translate([-0.35, 0, -0.5*blockHeight]){
                    union(){
                        translate([0, -47, 15.1])
                            roundedcube([15.8, 15.8, 17.3], true, 2, "y");
                        translate([0, -42.5, 25])
                            cube([15.8, 7, 8], center=true);
                    }
                }
                
                //USB2
                //TODO create variables
                translate([17.6, 0, -0.5*blockHeight]){
                    union(){
                        translate([0, -47, 15.1])
                            roundedcube([15.8, 15.8, 17.3], true, 2, "y");
                        translate([0, -42.5, 25])
                            cube([15.8, 7, 8], center=true);
                    }
                }
                
                //Audio
                //TODO create variables
                translate([-31, -13.07, -0.5*blockHeight + 9.4]){
                    rotate([0, -90, 180])
                        cylinder(h=2.7, r1=0.5*7.1, r2=0.5*7.1, center=true, $fn=20);
                }
                
                //USB Power
                //TODO create variables
                translate([-31, 32.6, -0.5*blockHeight + 7.8]){
                    union(){
                        rotate([0, -90, 180])
                            cylinder(h=2.7, r1=0.5*4.1, r2=0.5*4.1, center=true, $fn=20);
                        translate([0, -5.17, 0])
                            rotate([0, -90, 180])
                                cylinder(h=2.7, r1=0.5*4.1, r2=0.5*4.1, center=true, $fn=20);
                        translate([0, -2.56, 0])
                            cube([2.7, 5.1, 4.1], center=true);
                    }
                }
                
                //HDMI
                //TODO create variables
                translate([-31, 8.56, -0.5*blockHeight + 10.75]){
                    union(){
                        color("green")
                        roundedcube([2.7, 16.6, 5.5], true, 1.3, "x");
                        translate([0, 0, -2.2])
                            color("blue")
                        
                            roundedcube([2.7, 13.48, 3.5], true, 1.2, "x");
                    }
                }
                
                //MemoryCard
                //TODO create variables
                translate([0, 0, -0.5*blockHeight]){
                    union(){
                        translate([0, 49.5, 10.1])
                            roundedcube([16, 13.5, 14], true, 2, "y");
                        translate([0, 42, 15.6])
                            cube([16, 1.5 + 0.05, 3], center=true);
                        translate([-1.5, 42, 4.6])
                            cube([11.6, 1.5 + 0.05, 3], center=true);
                    }
                }
                
            }
            
            //Feet
            //TODO create variables
            color("red")
            translate([0, 0, -0.5*blockHeight+floorHeight]){
                foot(-25.93, 37.03, true);
                foot(22.83, 37.03, true);
                foot(-25.93, -20.97, true);
                foot(22.83, -20.97, true);
                foot(-12, 0, false);
                foot(16.83, 0, false);
            }
            
            //Holders for PI Hats
            color("green")
            translate([-29, -20.78, -0.5*blockHeight+15.7]){
                rotate([0,180,90])
                    prism(6.5, 2, 2);
                translate([0,0,1.5])
                cube([2, 6.5, 1], center=true);
            }
            
            color("green")
            translate([-29, 38.12, -0.5*blockHeight+15.7]){
                rotate([0,180,90])
                    prism(6.5, 2, 2);
                translate([0,0,1.5])
                cube([2, 6.5, 1], center=true);
            }
            
            //Memory Card Gap Filler
            //TODO create variables
            color("red")
            translate([0, 41, -0.5*blockHeight+3.5]){
                cube([18, 2 , 0.8], center=true);
            }
            
            
        }
    }
}

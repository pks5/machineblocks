/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Raspberry Pi Case Lid Lib
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../../../lib/roundedcube.scad>;
use <../../../lib/block.scad>;

baseSideLength=8;
lidHeight = 3;
lidHeightTolerance = 0.1;
lidSpacing = 0.3;
grid = [8, 12];
halfGrid=[8, 0.5*grid[1]];

wallThickness = 2;
wallY1Thickness = 3;

wallInset = 1;
innerWallHeight=2;
knobSize=5;
knobHeight = 1.9;

lidHoleHeight=3;

cutSpace=1;

adjustSizeX = 0;
adjustSizeY = 0;

finalObjectSizeX = (halfGrid[0] * baseSideLength) + adjustSizeX;
finalObjectSizeY = 2* ((halfGrid[1] * baseSideLength) + adjustSizeY);

doubleThinWallThickness = 2*(wallThickness - wallInset);
totalLidHeight = lidHeight + knobHeight;

innerWallHolderHeight = 0.6;
innerWallHolderThickness = 0.1;

roundingRadius = 0.25;
roundingResolution = 15;
knobsFilled=true;


module pi_case_lid(
    knobGaps = []
){
    //Lid
    
    translate([0, 0, 0*(0.5 * totalLidHeight + innerWallHeight)]){
        color("red")
        difference(){
            union(){
                difference(){
                    //Lid block with knobs
                    block(baseHeight = lidHeight, baseSolid=true, grid=grid, withKnobs=true, knobsFilled=knobsFilled, knobSize=knobSize, knobGaps=knobGaps, sideAdjustment=[adjustSizeX, adjustSizeX, adjustSizeY, adjustSizeY], center=true, alwaysOnFloor=false);
                    
                    //Cut border to fit as lid
                    difference(){
                        cube([finalObjectSizeX+cutSpace, finalObjectSizeY+cutSpace, 2*totalLidHeight], center=true);
                        cube([finalObjectSizeX-doubleThinWallThickness, finalObjectSizeY-doubleThinWallThickness, 2*totalLidHeight+cutSpace], center=true);
                    };
                };
                
                translate([0, 0.5 * (wallY1Thickness - wallThickness), -0.5 * (totalLidHeight + innerWallHeight)]){
                    cube([finalObjectSizeX-2*wallThickness, finalObjectSizeY - (wallThickness + wallY1Thickness), innerWallHeight], center=true);
                    roundedcube_simple(size = [finalObjectSizeX-2*wallThickness + 2*innerWallHolderThickness, finalObjectSizeY - (wallThickness + wallY1Thickness) + 2*innerWallHolderThickness, innerWallHolderHeight], 
                                        center = true, 
                                        radius=roundingRadius, 
                                        resolution=roundingResolution); 
                }
                /*
                translate([0, (wallY1Thickness - wallThickness), -0.5 * (totalLidHeight + innerWallHeight)]){
                    difference(){
                        cube([finalObjectSizeX-2*wallThickness, finalObjectSizeY-2*wallThickness-1, innerWallHeight], center=true);
                        cube([finalObjectSizeX-3*wallThickness, finalObjectSizeY-3*wallThickness-1, innerWallHeight+cutSpace], center=true);
                    }
                }
                */
            }
            translate([0, 0.5 * (wallY1Thickness - wallThickness), -0.5 * (totalLidHeight) - innerWallHeight]){
                cube([finalObjectSizeX-4*wallThickness, finalObjectSizeY - 2*(wallThickness + wallY1Thickness), 2*lidHoleHeight], center=true);
            }
        }
    }
}
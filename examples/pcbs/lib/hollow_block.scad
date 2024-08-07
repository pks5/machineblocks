/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Hollow Block
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../../../lib/shapes.scad>;
use <../../../lib/block.scad>;

module hollowBlock(
grid = [6,6],
top = true,
center=true,
alignBottom=false,
gridSizeXY=8,
adjustSizeX = -0.2,
adjustSizeY = -0.2,
topPlateHelperThickness = 0.5,
topPlateHelperHeight = 0.2,
floorHeight = 3.5,
floorHeightTolerance=0.2,
topPlateHeight = 0.6,
knobHeight = 1.8,
baseHeight = 3.1,
brickHeight = 2,
blockHeight = 0,
wallThickness = 1.5,
outerWallThickness = 0.7,
wallThicknessTolerance = 0.2,
innerWallHeight=4,
innerWallThickness = 0.6,
innerWallHolderHeight = 0.6,
innerWallHolderThickness = 0.20,
roundingRadius = 0.25,
roundingResolution = 15,
withInnerWallFilled = false,
withBarrier = false,
barrierTolerance = 0.2,
barrierHeight = 1,
barrierThickness=1,
knobType = "classic",
knobs=true,
blockMinWallThickness=1.4,
baseClampThickness=0.2,
textFont="Font Awesome 5 Free Regular",
text="",
textSize=7,
textSide=1,
textDepth=0.5,
textSpacing=1,
textOffset=[0,0]
){
    resultingBlockHeight = blockHeight > 0 ? blockHeight : (brickHeight * baseHeight * 3);
    totalTopHeight = resultingBlockHeight; //knobType != "none" ? resultingBlockHeight+knobHeight : resultingBlockHeight;
    totalBottomHeight = floorHeight + innerWallHeight;
    
    finalObjectSizeX = (grid[0] * gridSizeXY) + adjustSizeX;
    finalObjectSizeY = (grid[1] * gridSizeXY) + adjustSizeY;
    
    doubleWallThickness = 2 * wallThickness;
    
    innerX = finalObjectSizeX - doubleWallThickness;
    innerY = finalObjectSizeY - doubleWallThickness;
    innerZ = resultingBlockHeight - wallThickness;
    
    topX = finalObjectSizeX - 2*outerWallThickness;
    topY = finalObjectSizeY - 2*outerWallThickness;
    
    innerWallX = innerX - 2 * wallThicknessTolerance;
    innerWallY = innerY - 2 * wallThicknessTolerance;

    bottomSizeX = finalObjectSizeX - 2*(outerWallThickness + wallThicknessTolerance);
    bottomSizeY = finalObjectSizeY - 2*(outerWallThickness + wallThicknessTolerance);
    
    
    
    if(!top){
        onFloorZ = 0.5*floorHeight;
        translateBottom = center ? [0, 0, alignBottom ? onFloorZ : 0.5 * (floorHeight - totalBottomHeight)] : [-0.5 * bottomSizeX, -0.5 * bottomSizeY, onFloorZ];
        
        //Bottom
        color("orange")
        translate(translateBottom){
            union(){
                difference(){
                    block(
                        baseHeight=floorHeight, 
                        topPlateHeight=topPlateHeight, 
                        grid=grid, 
                        knobs=false,  
                        wallThickness=blockMinWallThickness, 
                        baseClampThickness=baseClampThickness, 
                        baseSideAdjustment=[adjustSizeX, adjustSizeX, adjustSizeY, adjustSizeY], 
                        center=true, 
                        alignBottom=false
                    );
                    
                    difference(){
                        cube([finalObjectSizeX + 1, finalObjectSizeY + 1, floorHeight + 1], center=true);
                        cube([bottomSizeX, bottomSizeY, floorHeight + 2], center=true);
                    };
                };
                
                if(innerWallHeight > 0){
                    //Inner wall
                    translate([0, 0, 0.5 * (floorHeight+innerWallHeight)]){
                        difference(){
                            union(){
                                cube([innerWallX, innerWallY, innerWallHeight], center=true);
                                
                               // translate([0,0,-0.25*innerWallHeight])
                                    mb_roundedcube_simple(
                                        size = [innerWallX + 2*innerWallHolderThickness, innerWallY + 2*innerWallHolderThickness,  innerWallHolderHeight], 
                                        center = true, 
                                        radius=roundingRadius, 
                                        resolution=roundingResolution
                                    );
                               
                               translate([0,0,0.5*(innerWallHeight-innerWallHolderHeight)])
                                    mb_roundedcube_simple(
                                        size = [innerWallX + 2*innerWallHolderThickness, innerWallY + 2*innerWallHolderThickness,  innerWallHolderHeight], 
                                        center = true, 
                                        radius=roundingRadius, 
                                        resolution=roundingResolution
                                    ); 
                            };
                            if(!withInnerWallFilled){
                                cube([innerWallX - 2*innerWallThickness, innerWallY - 2*innerWallThickness, innerWallHeight+1], center=true);
                            }
                        }
                    }
                }
                
                
            }
        }
    }

    if(top){
        translateTop = center ? [0, 0, alignBottom ? 0 : -0.5*totalTopHeight] : [-0.5 * finalObjectSizeX, -0.5 * finalObjectSizeY, 0];
        
        echo(resultingBlockHeight=resultingBlockHeight, translateTop=translateTop, totalTopHeight=totalTopHeight);
        
        //Top
        translate(translateTop){
            union(){
                difference(){
                    translate([0, 0, 0.5*totalTopHeight])
                        block(
                            baseHeight = resultingBlockHeight, 
                            wallThickness=blockMinWallThickness, 
                            baseClampThickness=baseClampThickness, 
                            baseCutoutType = "none", 
                            grid=grid, 
                            knobType=knobType, 
                            knobHeight=knobHeight,
                            knobs=knobs, 
                            baseSideAdjustment=[adjustSizeX, adjustSizeX, adjustSizeY, adjustSizeY], 
                            center=true,
                            textFont=textFont,
                            text=text,
                            textSize=textSize,
                            textSide=textSide,
                            textDepth=textDepth,
                            textSpacing=textSpacing,
                            textOffset=textOffset, 
                            alignBottom=false
                        );
                    
                    cube([innerX, innerY, 2*innerZ], center=true);
                    cube([topX, topY, 2*(floorHeight + floorHeightTolerance)], center=true);
                    
                    
                }
                
                if(withBarrier){
                    translate([0, 0, floorHeight + floorHeightTolerance + innerWallHeight + barrierTolerance + 0.5 * barrierHeight]){
                        color("red")
                        difference() {
                            cube([innerX, innerY, barrierHeight], center = true);
                            cube([innerX - 2*barrierThickness, innerY - 2*barrierThickness, barrierHeight*1.1], center = true);
                        };
                    }
                }
                
                //Plate Helper
                translate([0, 0, innerZ - 0.5 * topPlateHelperHeight]){
                    difference() {
                        cube([innerX, innerY, topPlateHelperHeight], center = true);
                        cube([innerX - 2*topPlateHelperThickness, innerY - 2*topPlateHelperThickness, topPlateHelperHeight*1.1], center = true);
                    };
                    
                }
                
                
            }
        }
    }
}
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

include <./block-v2.scad>;

module hollowBlock(
grid = [6,6],
top = true,
center=true,
alwaysOnFloor=false,
baseSideLength=8,
adjustSizeX = -0.2,
adjustSizeY = -0.2,
plateHelperThickness = 0.5,
plateHelperHeight = 0.2,
floorHeight = 3.5,
floorHeightTolerance=0.2,
plateHeight = 0.6,
knobHeight = 2,
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
withKnobs=true,
withKnobsFilled=true,
knobGaps=[],
blockMinWallThickness=1.4,
blockMaxWallThickness=1.6,
withText=false,
textFont="Font Awesome 5 Free Regular",
text="\uf0eb",
textSize=7,
textSide=1,
textDepth=0.5
){
    
    resultingBlockHeight = blockHeight > 0 ? blockHeight : (brickHeight * baseHeight * 3);
    totalTopHeight = withKnobs ? resultingBlockHeight+knobHeight : resultingBlockHeight;
    totalBottomHeight = floorHeight + innerWallHeight;
    
    finalObjectSizeX = (grid[0] * baseSideLength) + adjustSizeX;
    finalObjectSizeY = (grid[1] * baseSideLength) + adjustSizeY;
    
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
        translateBottom = center ? [0, 0, alwaysOnFloor ? onFloorZ : 0.5 * (floorHeight - totalBottomHeight)] : [-0.5 * bottomSizeX, -0.5 * bottomSizeY, onFloorZ];
        
        //Bottom
        color("orange")
        translate(translateBottom){
            union(){
                difference(){
                    block(baseHeight=floorHeight, plateHeight=plateHeight, grid=grid, withKnobs=false,  minWallThickness=blockMinWallThickness, maxWallThickness=blockMaxWallThickness, adjustSizeX=adjustSizeX, adjustSizeY=adjustSizeY, center=true);
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
                                    roundedcube_simple(size = [innerWallX + 2*innerWallHolderThickness, innerWallY + 2*innerWallHolderThickness,  innerWallHolderHeight], center = true, radius=roundingRadius, resolution=roundingResolution);
                               
                               translate([0,0,0.5*(innerWallHeight-innerWallHolderHeight)])
                                    roundedcube_simple(size = [innerWallX + 2*innerWallHolderThickness, innerWallY + 2*innerWallHolderThickness,  innerWallHolderHeight], center = true, radius=roundingRadius, resolution=roundingResolution); 
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
        translateTop = center ? [0, 0, alwaysOnFloor ? 0 : -0.5*totalTopHeight] : [-0.5 * finalObjectSizeX, -0.5 * finalObjectSizeY, 0];
        
        //Top
        translate(translateTop){
            union(){
                difference(){
                    translate([0, 0, 0.5*totalTopHeight])
                        block(
                            baseHeight = resultingBlockHeight, 
                            minWallThickness=blockMinWallThickness, 
                            maxWallThickness=blockMaxWallThickness, 
                            withBaseHoles=false, 
                            grid=grid, 
                            withKnobs=withKnobs,
                            withKnobsFilled=withKnobsFilled, 
                            knobGaps=knobGaps, 
                            adjustSizeX=adjustSizeX, 
                            adjustSizeY=adjustSizeY, 
                            center=true,
                            withText=withText,
                            textFont=textFont,
                            text=text,
                            textSize=textSize,
                            textSide=textSide,
                            textDepth=textDepth
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
                translate([0, 0, innerZ - 0.5 * plateHelperHeight]){
                    difference() {
                        cube([innerX, innerY, plateHelperHeight], center = true);
                        cube([innerX - 2*plateHelperThickness, innerY - 2*plateHelperThickness, plateHelperHeight*1.1], center = true);
                    };
                    
                }
                
                
            }
        }
    }
}
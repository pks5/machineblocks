/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Hollow Block with Window on side
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <./hollow_block.scad>;

module prism(l, w, h) {
    translate([-0.5*l,0, -0.5*h])
    rotate([0,0,-90])
       polyhedron(points=[
               [0,0,h],           // 0    front top corner
               [0,0,0],[w,0,0],   // 1, 2 front left & right bottom corners
               [0,l,h],           // 3    back top corner
               [0,l,0],[w,l,0]    // 4, 5 back left & right bottom corners
       ], faces=[ // points for all faces must be ordered clockwise when looking in
               [0,2,1],    // top face
               [3,4,5],    // base face
               [0,1,4,3],  // h face
               [1,2,5,4],  // w face
               [0,3,5,2],  // hypotenuse face
       ]);
}

module holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight){
    translate([0,0,-0.5*holderPrismHeight])
        cube([holderLength, holderThickness, holderHeight - holderPrismHeight], center=true);
    
    translate([0,0.5*holderThickness, 0.5*(holderHeight-holderPrismHeight)]){
        prism(holderLength, holderPrismWidth, holderPrismHeight);
        
        translate([0,-2*(holderPrismWidth-holderThickness),-0.625*holderPrismHeight])
            rotate([0,180,0])
                prism(holderLength, holderPrismWidth-holderThickness, 0.25*holderPrismHeight);
    }   
    
}

module plug_support(x, y, plugWidth, plugTolerance, plugSupportColumnWidth){
    translate([x,y,0])
        //cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4, center=true, $fn=20);
        cube([plugSupportColumnWidth, plugSupportColumnWidth, 1.3*(plugWidth+plugTolerance)], center=true);
}

module pcb_block(
top=false,
grid=[4,4],

baseSideLength=8,
brickHeight = 3,
adjustSizeX = -0.2,
adjustSizeY = -0.2,

withKnobs=true,
withKnobsFilled=true,

floorHeight = 3.5,
wallThickness = 1.5,
innerWallHeight=4,
innerWallThickness = 0.6,
outerWallThickness = 0.7,
wallThicknessTolerance = 0.2,

windowHeight=15,
windowWidth=15,
windowOverlap=1,
windowHelperHeight=0.4,

bedSupportWidth=4.5,

holderLength=8,
holderThickness=1.2,
holderTipRadius=0.5,
holderGap=6,
holderOffsetX=0,
holderOffsetY=0,
withPcbHolders=true,
platerSize=3,
platerHeight=2,
pcbHeight=3,
pcbY=20,
pcbX=16.5,
pcbTolerance=0.2,
pinHeight=5.3,
pins=[0,-1,-1,-1],
withPlugSupport=true,
plugSupportGap=1.4,
plugSupportColumnWidth=0.4,
plugWidth=2.8,
plugDepth=7.3,
plugTolerance=0.2,
plugBorderSize=0.5,
plugBorderDepth=0.5,

stablerSize=2,
stablerThickness=1,

withText=false,
textFont="Font Awesome 5 Free Regular",
text="\uf0eb",
textSize=7,
textSide=1,
textDepth=0.5,
textSpacing=1,
textOffsetZ=-0.1
){

    finalObjectSizeX = (grid[0] * baseSideLength) + adjustSizeX;
    finalObjectSizeY = (grid[1] * baseSideLength) + adjustSizeY;

    windowThickness = wallThickness + wallThicknessTolerance;
    windowThicknessBottom = outerWallThickness + wallThicknessTolerance;
    
    stablerStartY=0.5 * finalObjectSizeY - windowThickness - innerWallThickness;
    
    holderPrismHeight = 2*holderTipRadius;
    holderPrismWidth = 0.5 * (holderPrismHeight) + holderThickness;
    holderHeight=pcbHeight + 2*holderPrismHeight;
    holderStartY=0.5 * finalObjectSizeY - plugDepth - holderThickness + holderOffsetY;
    
    finalWindowWidth=windowWidth-2*wallThicknessTolerance;
    finalWindowHeight=windowHeight-wallThicknessTolerance;
    
    finalPcbX = pcbX + pcbTolerance;
    finalPcbY = pcbY + pcbTolerance;

    if(top){
        difference(){
            hollowBlock(
                brickHeight=brickHeight, 
                grid=grid, 
                alwaysOnFloor=true, 
                center=true,
                top=true, 
                withKnobs=withKnobs, 
                withKnobsFilled=withKnobsFilled,
                withText = withText,
                textFont = textFont,
                text = text,
                textSize = textSize,
                textSide=textSide,
                textDepth = textDepth,
                textSpacing = textSpacing,
                textOffsetZ = textOffsetZ
            );
            
            //Window
            translate([0, 0.5 * finalObjectSizeY, 0.5 * windowHeight]){
                cube([windowWidth, 4.5, windowHeight], center=true);
            }
            
            
        }
        
        translate([0, 0.5 * (finalObjectSizeY-wallThickness), 0.5 * (windowHeight + windowHelperHeight)]){
            cube([windowWidth, wallThickness, windowHelperHeight], center=true);
        }
        
        translate([0, 0.5 * (finalObjectSizeY-wallThickness), 0.5 * windowHelperHeight]){
            cube([windowWidth, bedSupportWidth, windowHelperHeight], center=true);
        }
        
        translate([0, 0, 0.5 * windowHelperHeight]){
            cube([finalObjectSizeX - 2*outerWallThickness, bedSupportWidth, windowHelperHeight], center=true);
        }
        
        xTemp = 0.5 * sqrt(2) * windowWidth; 
        translate([0.5*(windowWidth - xTemp  + 0.75*windowHelperHeight), 0.5 * (finalObjectSizeY-wallThickness), 0.5 *(windowHeight + windowHeight - xTemp + 0.75*windowHelperHeight)]){
            rotate([0, 45,0])
                cube([windowWidth, wallThickness, windowHelperHeight], center=true);
        }
        translate([-0.5*(windowWidth - xTemp  + 0.75*windowHelperHeight), 0.5 * (finalObjectSizeY-wallThickness), 0.5 *(windowHeight + windowHeight - xTemp  + 0.75*windowHelperHeight)]){
            rotate([0, -45,0])
                cube([windowWidth, wallThickness, windowHelperHeight], center=true);
        }
    }

    if(!top){
        
        hollowBlock(brickHeight=brickHeight, grid=grid, alwaysOnFloor=true, top=false);
        difference(){
            //color("red")
            translate([0, 0.5 * (finalObjectSizeY - windowThickness), 0.5*(finalWindowHeight + floorHeight)]){
                    translate([0,-0.5 * (plugDepth - windowThickness),0])
                        color("blue")
                        cube([finalWindowWidth, plugDepth, finalWindowHeight - floorHeight], center=true);
                
                    translate([0, 0.5 * (windowThickness - windowThicknessBottom), -0.5*finalWindowHeight])
                        color("green")
                        cube([finalWindowWidth, windowThicknessBottom, floorHeight], center=true);
                
                    translate([0, - 0.5*(windowThickness + innerWallThickness), 0.5 * (windowOverlap + innerWallHeight)])
                        color("magenta")
                        cube([finalWindowWidth + 2*windowOverlap, innerWallThickness, finalWindowHeight - floorHeight - innerWallHeight + windowOverlap], center=true);
            }
            
            //Pins
            union(){
                translate([-0.5*(len(pins)-1)*plugWidth, 0.5 * (finalObjectSizeY - windowThickness - innerWallThickness), floorHeight + pcbHeight + pinHeight]){
                    for (a = [ 0 : 1 : len(pins) - 1 ]){
                        translate([a*plugWidth,0,pins[a]*0.25*plugWidth]){
                            translate([0,-0.5 * (plugDepth - windowThickness),0])
                                cube([plugWidth+plugTolerance, 1.1*(plugDepth), plugWidth+plugTolerance], center=true);
                            
                            color("orange")
                            translate([0,0.5*windowThickness + innerWallThickness,0])
                                cube([plugWidth+plugTolerance+plugBorderSize, 2*plugBorderDepth, plugWidth+plugTolerance+plugBorderSize], center=true);
                        }
                    }    
                }
            }
        }
        
        if(withPlugSupport){
            supportRowCount = 5;//floor(plugDepth / (plugSupportColumnWidth + plugSupportGap)) + 1;
            plugSupportGap = 0.25 * (plugDepth - plugBorderDepth - supportRowCount * plugSupportColumnWidth) + plugSupportColumnWidth;
            supportStartY = 0.5*(windowThickness + innerWallThickness - plugSupportColumnWidth - plugBorderDepth);
            translate([-0.5*(len(pins)-1)*plugWidth, 0.5 * (finalObjectSizeY - windowThickness - innerWallThickness), floorHeight + pcbHeight + pinHeight]){
                for (a = [ 0 : 1 : len(pins) - 1 ]){
                    translate([a*plugWidth,0,pins[a]*0.25*plugWidth]){
                         if((a > 0) && (pins[a] < pins[a-1])){
                            rotate([0,-20,0]){
                                for (s = [ 0 : 1 : supportRowCount-1 ]){
                                    plug_support(-0.2, supportStartY - s*plugSupportGap, plugWidth, plugTolerance, plugSupportColumnWidth);
                                }
                            }
                         }
                         
                         if( ( (a==0) || (pins[a-1] <= pins[a])) && ((a+1 == len(pins)) || (pins[a+1] <= pins[a])) ){
                             for (s = [ 0 : 1 : supportRowCount-1 ]){
                               plug_support(-0.2, supportStartY - s*plugSupportGap, plugWidth, plugTolerance, plugSupportColumnWidth);
                             }
                         }
                         
                         if((a < len(pins)-1) && (pins[a+1] > pins[a])){
                            rotate([0,20,0]){
                                for (s = [ 0 : 1 : supportRowCount-1 ]){
                                    plug_support(0.2, supportStartY - s*plugSupportGap, plugWidth, plugTolerance, plugSupportColumnWidth);
                                }
                                
                            }
                        } 
                    }
                }    
            }
        }
        
        if(withPcbHolders){
            color("green")
            translate([0, 0, floorHeight]){
                translate([0, holderStartY + 0.5 * holderThickness, 0.5*holderHeight]){
                    holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight);
                }   
                
                translate([0, holderStartY - finalPcbY - 0.5 * holderThickness, 0.5*holderHeight]){
                    rotate([0,0,180])
                        holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight);
                }
                
                translate([0.5*(finalPcbX + holderThickness), holderStartY - 0.5*finalPcbY, 0.5*holderHeight]){
                    rotate([0,0,-90])
                        holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight);
                }
                
                translate([-0.5*(finalPcbX + holderThickness), holderStartY - 0.5*finalPcbY, 0.5*holderHeight]){
                    rotate([0,0, 90]){
                        holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight);
                    }
                }
                
                translate([-0.5*finalPcbX + (0.5*platerSize-holderThickness), holderStartY - (0.5*platerSize-holderThickness), 0.5*platerHeight]){
                    cube([platerSize, platerSize, platerHeight], center=true);
                }
                
                translate([+0.5*finalPcbX - (0.5*platerSize-holderThickness), holderStartY - (0.5*platerSize-holderThickness), 0.5*platerHeight]){
                    cube([platerSize, platerSize, platerHeight], center=true);
                }
                
                translate([-0.5*finalPcbX + (0.5*platerSize-holderThickness), holderStartY  - finalPcbY + (0.5*platerSize-holderThickness), 0.5*platerHeight]){
                    cube([platerSize, platerSize, platerHeight], center=true);
                }
                
                translate([0.5*finalPcbX - (0.5*platerSize-holderThickness), holderStartY  - finalPcbY + (0.5*platerSize-holderThickness), 0.5*platerHeight]){
                    cube([platerSize, platerSize, platerHeight], center=true);
                }
            }
        }
        
    }
}
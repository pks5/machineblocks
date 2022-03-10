/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Hollow Block with Window on side
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial 4.0 International
* https://creativecommons.org/licenses/by-nc/4.0/legalcode
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

module window_block(
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

holderLength=8,
holderThickness=1,
holderTipRadius=0.5,
holderGap=3,
withPcbHolders=true,
platerSize=3,
platerHeight=2,
pcbHeight=3,
pcbY=20,
pcbX=16.5,
pinHeight=5.3,
pins=[0,-1,-1,-1],
withPinHoleSupport=true,
plugWidth=2.8,
plugTolerance=0.2,
plugBorderSize=0.5,
plugBorderDepth=0.5,

stablerSize=2,
stablerThickness=1,

withLogo=true,
logoFont="Font Awesome 5 Free Regular",
logoText="\uf0eb",
logoSize=7,
logoDepth=0.5
){

    finalObjectSizeX = (grid[0] * baseSideLength) + adjustSizeX;
    finalObjectSizeY = (grid[1] * baseSideLength) + adjustSizeY;

    windowThickness = wallThickness + wallThicknessTolerance;
    windowThicknessBottom = outerWallThickness + wallThicknessTolerance;

    holderPrismHeight = 2*holderTipRadius;
    holderPrismWidth = 0.5 * (holderPrismHeight) + holderThickness;
    holderHeight=pcbHeight + 2*holderPrismHeight;
    holderStartY=0.5 * finalObjectSizeY - windowThickness - innerWallThickness - holderGap;
    stablerStartY=0.5 * finalObjectSizeY - windowThickness - innerWallThickness;

    finalWindowWidth=windowWidth-2*wallThicknessTolerance;
    finalWindowHeight=windowHeight-wallThicknessTolerance;

    if(top){
        difference(){
            hollowBlock(
                brickHeight=brickHeight, 
                grid=grid, 
                alwaysOnFloor=true, 
                top=true, 
                withKnobs=withKnobs, 
                withKnobsFilled=withKnobsFilled,
                withLogo = withLogo,
                logoFont = logoFont,
                logoText = logoText,
                logoSize = logoSize,
                logoDepth = logoDepth
            );
            
            //Window
            translate([0, 0.5 * finalObjectSizeY, 0]){
                cube([windowWidth, 4.5, 2*windowHeight], center=true);
            }
        }
    }

    if(!top){
        
        hollowBlock(brickHeight=brickHeight, grid=grid, alwaysOnFloor=true, top=false);
        difference(){
            color("red")
            translate([0, 0.5 * (finalObjectSizeY - windowThickness), 0.5*(finalWindowHeight + floorHeight)]){
                    translate([0,-1,0])
                        cube([finalWindowWidth, windowThickness+2, finalWindowHeight - floorHeight], center=true);
                
                    translate([0, 0.5 * (windowThickness - windowThicknessBottom), -0.5*finalWindowHeight])
                        cube([finalWindowWidth, windowThicknessBottom, floorHeight], center=true);
                
                    translate([0, - 0.5*(windowThickness + innerWallThickness), 0.5 * (windowOverlap + innerWallHeight)])
                        cube([finalWindowWidth + 2*windowOverlap, innerWallThickness, finalWindowHeight - floorHeight - innerWallHeight + windowOverlap], center=true);
            }
            
            //Pins
            union(){
                translate([-0.5*(len(pins)-1)*plugWidth, 0.5 * (finalObjectSizeY - windowThickness - innerWallThickness), floorHeight + pcbHeight + pinHeight]){
                    for (a = [ 0 : 1 : len(pins) - 1 ]){
                        translate([a*plugWidth,0,pins[a]*0.5*plugWidth]){
                            translate([0,-1,0])
                                cube([plugWidth+plugTolerance, 1.1*(windowThickness + innerWallThickness + 2), plugWidth+plugTolerance], center=true);
                            
                            color("orange")
                            translate([0,0.5*windowThickness + innerWallThickness,0])
                                cube([plugWidth+plugTolerance+plugBorderSize, 2*plugBorderDepth, plugWidth+plugTolerance+plugBorderSize], center=true);
                        }
                    }    
                }
            }
        }
        
        if(withPinHoleSupport){
            translate([-0.5*(len(pins)-1)*plugWidth, 0.5 * (finalObjectSizeY - windowThickness - innerWallThickness), floorHeight + pcbHeight + pinHeight]){
                for (a = [ 0 : 1 : len(pins) - 1 ]){
                    translate([a*plugWidth,0,pins[a]*0.5*plugWidth]){
                         if((a > 0) && (pins[a] < pins[a-1])){
                            rotate([0,-20,0]){
                                translate([-0.2,-2.1,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4, center=true, $fn=20);
                                translate([-0.2,-0.75,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4, center=true, $fn=20);
                                translate([-0.2,0.5,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4, center=true, $fn=20);
                                
                            }
                         }
                         
                         if((a == 0) || (pins[a] == pins[a-1])){
                             translate([-0.2,-2.1,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4, center=true, $fn=20);
                             translate([-0.2,-0.75,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4, center=true, $fn=20);
                             translate([-0.2,0.5,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4, center=true, $fn=20);
                         }
                         
                         if((a < len(pins)-1) && (pins[a+1] > pins[a])){
                            rotate([0,20,0]){
                                translate([0.2,-2.1,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4,center=true, $fn=20);
                                translate([0.2,-0.75,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4, center=true, $fn=20);
                                translate([0.2,0.5,0])
                                    cylinder(h=1.3*(plugWidth+plugTolerance), r1=0.3, r2=0.4,center=true, $fn=20);
                                
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
                
                translate([0, holderStartY - pcbY - 0.5 * holderThickness, 0.5*holderHeight]){
                    rotate([0,0,180])
                        holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight);
                }
                
                translate([0.5*(pcbX + holderThickness), holderStartY - 0.5*pcbY, 0.5*holderHeight]){
                    rotate([0,0,-90])
                        holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight);
                }
                
                translate([-0.5*(pcbX + holderThickness), holderStartY - 0.5*pcbY, 0.5*holderHeight]){
                    rotate([0,0, 90]){
                        holder(holderLength, holderHeight, holderThickness, holderPrismWidth, holderPrismHeight);
                    }
                }
                
                translate([-0.5*pcbX + (0.5*platerSize-holderThickness), holderStartY - (0.5*platerSize-holderThickness), 0.5*platerHeight]){
                    cube([platerSize, platerSize, platerHeight], center=true);
                }
                
                translate([+0.5*pcbX - (0.5*platerSize-holderThickness), holderStartY - (0.5*platerSize-holderThickness), 0.5*platerHeight]){
                    cube([platerSize, platerSize, platerHeight], center=true);
                }
                
                translate([-0.5*pcbX + (0.5*platerSize-holderThickness), holderStartY  - pcbY + (0.5*platerSize-holderThickness), 0.5*platerHeight]){
                    cube([platerSize, platerSize, platerHeight], center=true);
                }
                
                translate([0.5*pcbX - (0.5*platerSize-holderThickness), holderStartY  - pcbY + (0.5*platerSize-holderThickness), 0.5*platerHeight]){
                    cube([platerSize, platerSize, platerHeight], center=true);
                }
                
                /*
                translate([-0.5*(finalWindowWidth)+windowOverlap, stablerStartY - (0.5*stablerThickness), 0.5*(finalWindowHeight - floorHeight + windowOverlap)]){
                    color("cyan")
                    cube([stablerSize, stablerThickness, finalWindowHeight - floorHeight + windowOverlap], center=true);
                }
                
                translate([0.5*(finalWindowWidth)-windowOverlap, stablerStartY - (0.5*stablerThickness), 0.5*(finalWindowHeight - floorHeight + windowOverlap)]){
                    color("cyan")
                    cube([stablerSize, stablerThickness, finalWindowHeight - floorHeight + windowOverlap], center=true);
                }
                */
            }
        }
        
    }
}
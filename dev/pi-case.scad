echo(version=version());

include <../lib/block-v2.scad>;

baseSideLength=8;
brickHeight = 3;
blockHeight = 28.40;
floorHeight = 3.1;
lidHeight = 3;
lidHeightTolerance = 0.1;
lidSpacing = 0.3;
grid = [8, 12];
halfGrid=[8, 0.5*grid[1]];
plateHeight = 0.6;
wallThickness = 2;
wallY1Thickness = 3;

wallInset = 1;
innerWallHeight=2;
knobSize=5;
knobHeight = 1.9;
knobGaps=[[2,4,5,10],[1,3,4,8], [0,4,0,8]];
lidHoleRadius=2;
drawDistance = 20;
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
withWindow=false;
withKnobsFilled=true;

resultingKnobGaps = knobGaps;//withWindow ? knobGaps : [];

plugWidth=2.6;
plugTolerance=0.1;
plugBorderSize=0.5;
plugBorderDepth=0.5;

showHelpers=false;

module pins(pins=[0,-1,0,0]){
    union(){
        translate([0.5*(plugWidth+plugTolerance),-0.5*(plugWidth+plugTolerance),0])
        for (a = [ 0 : 1 : len(pins) - 1 ]){
            translate([a*plugWidth,pins[a]*0.5*plugWidth,0]){
                color("green")
                cube([plugWidth+plugTolerance, plugWidth+plugTolerance,1.1*(lidHeight+innerWallHeight)], center=true);
                
                color("orange")
                translate([0,0,0.5*(lidHeight+innerWallHeight)])
                    cube([plugWidth+plugTolerance+plugBorderSize, plugWidth+plugTolerance+plugBorderSize,2*plugBorderDepth], center=true);
            }
        }    
    }
}

module helpers(){
    color("purple")
        translate([7.25,-1.5, 0])
            cube([14.5, 3, 2.2], center=true);
    
    
    color("purple")
        translate([1,-10.5, 0])
            cube([2, 21, 2.2], center=true);
    
    color("blue")
    translate([1,-26.5, 0])
            cube([2, 53, 2.1], center=true);
    
    color("yellow")
    translate([7.25,-26.5, 0])
            cube([14.5, 53, 2], center=true);
    
    color("green")
    translate([13.25,-26.5, 0])
            cube([26.5, 53, 1.8], center=true);
    
    color("magenta")
    translate([11,-17.25, 0])
            cube([22, 34.5, 1.9], center=true);
    
    color("purple")
        translate([3.5,-29, 0])
            cube([7, 58, 1.6], center=true);
}

module pin_holes(){
    
    gpioX = 39.5;
    gpioY = 0;
    
    gpioHeight = 5.5;
    gpioWidth = 57.5;
    
    analogX = 12.8;
    analogY = -1.8;
    analogGap = 0.8;
    
    digitalGap = 0.55;
    digital1X = 0.8;
    digital1Y = -(1.5*plugWidth+plugTolerance+0.55) - 14.6;
    echo(digital1Y); //-19.15
    
    digital2X = 13;
    digital2Y = -14.6;
    
    digital3X = 25.3;
    digital3Y = digital2Y;
    
    
    serialX = digital3X;
    serialY = -56.1;
    
    mosiX = 5.4;
    mosiY = serialY;
    
    //GPIO
    translate([gpioX, gpioY, 0])
        translate([0.5*gpioHeight,-0.5*gpioWidth, 0])
            cube([gpioHeight, gpioWidth, 1.1*(lidHeight+innerWallHeight)], center=true);
    
    //Analog
    translate([analogX, analogY, 0]){
        
            for (a = [ 0 : 1 : 4 ]){
                translate([a * (1.5*plugWidth+2*plugTolerance + analogGap), 0, 0])
                    translate([0,-4*(plugWidth+plugTolerance),0])
                        rotate([0,0,90])
                            pins([0,0,-1,0]);
            
            }
    }
    
    //Digital 1
    translate([digital1X, digital1Y,0]){
        for (a = [ 0 : 1 : 7 ]){
            translate([0, -a * (1.5*plugWidth+plugTolerance+digitalGap), 0])
                pins();
        }
    }
    
    //Digital 1
    translate([digital2X, digital2Y, 0]){
        for (a = [ 0 : 1 : 8 ]){
            translate([0, -a * (1.5*plugWidth+plugTolerance+digitalGap), 0])
                pins();
        }
    }
    
    //Digital 1
    translate([digital3X, digital3Y, 0]){
        for (a = [ 0 : 1 : 8 ]){
            translate([0, -a * (1.5*plugWidth+plugTolerance+digitalGap), 0])
                pins();
        }
    }
    
    //Serial
    translate([serialX, serialY, 0]){
        pins([0,-1,-1,0]);
    }
    
    //Mosi
    translate([mosiX, mosiY, 0]){
        pins([0,-1,-1,0,-1,-1,0]);
    }
}

module foot(footX, footY, withHole){
    footSize = 6;
    footHoleSize = 2.2;
    footSizeZ = 2.2;
    
    translate([footX, footY, 0.5*footSizeZ]){
        difference(){
            cylinder(h=footSizeZ, r1=0.5*footSize, r2=0.5*footSize, center=true, $fn=20);
            if(withHole){
                cylinder(h=footSizeZ + cutSpace, r1=0.5*footHoleSize, r2=0.5*footHoleSize, center=true, $fn=20);
            }
        }
    }
}

module body(){
    //Body
    translate([-0.5 * (finalObjectSizeX + drawDistance), 0, 0.5*blockHeight]){
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
                        cube([finalObjectSizeX - 2*wallThickness, finalObjectSizeY - (wallThickness + wallY1Thickness), 2*(blockHeight - floorHeight) + cutSpace], center=true);
                    }
                    //Memory Card Additional Wall
                    translate([0, 44.75, -0.5*blockHeight+10.6]){
                        cube([18, 2.5 , 15], center=true);
                    }
                }
                
                
                //LAN
                translate([-19.12, 0, -0.5*blockHeight]){
                    union(){
                        translate([0, -47, 14.05])
                            roundedcube([17, 17, 15.2], true, 2, "y");
                        translate([0, -42.5, 25])
                            cube([17, 7, 10], center=true);
                    }
                }
                
                //USB1
                translate([-0.35, 0, -0.5*blockHeight]){
                    union(){
                        translate([0, -47, 15.1])
                            roundedcube([15.8, 15.8, 17.3], true, 2, "y");
                        translate([0, -42.5, 25])
                            cube([15.8, 7, 8], center=true);
                    }
                }
                
                //USB2
                translate([17.6, 0, -0.5*blockHeight]){
                    union(){
                        translate([0, -47, 15.1])
                            roundedcube([15.8, 15.8, 17.3], true, 2, "y");
                        translate([0, -42.5, 25])
                            cube([15.8, 7, 8], center=true);
                    }
                }
                
                //Audio
                translate([-31, -13.07, -0.5*blockHeight + 9.93]){
                    rotate([0, -90, 180])
                        cylinder(h=2.7, r1=0.5*7.1, r2=0.5*7.1, center=true, $fn=20);
                }
                
                //USB Power
                translate([-31, 32.6, -0.5*blockHeight + 8.32]){
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
                translate([-31, 8.56, -0.5*blockHeight + 11.05]){
                    union(){
                        color("green")
                        roundedcube([2.7, 16.6, 5.97], true, 1.3, "x");
                        translate([0, 0, -2.7])
                            color("blue")
                        
                            roundedcube([2.7, 13.48, 3.5], true, 1.2, "x");
                    }
                }
                
                //MemoryCard
                translate([0, 0, -0.5*blockHeight]){
                    union(){
                        translate([0, 49.5, 10.1])
                            roundedcube([16, 9, 14], true, 2, "y");
                        translate([0, 44.25, 15.6])
                            cube([16, 1.5 + 0.05, 3], center=true);
                        translate([0, 44.25, 4.6])
                            cube([16, 1.5 + 0.05, 3], center=true);
                    }
                }
                
            }
            
            //Feet
            color("red")
            translate([0, 0, -0.5*blockHeight+floorHeight]){
                foot(-25.93, 37.03, true);
                foot(22.83, 37.03, true);
                foot(-25.93, -20.97, true);
                foot(22.83, -20.97, true);
                foot(-12, 0, false);
                foot(16.83, 0, false);
            }
            
            
            
            //Memory Card Gap Filler
            color("red")
            translate([0, 41, -0.5*blockHeight+3.5]){
                cube([18, 2 , 0.8], center=true);
            }
            
            
        }
    }
}


module lid(){
    //Lid
    
    translate([0.5 * (finalObjectSizeX + drawDistance), 0, 0*(0.5 * totalLidHeight + innerWallHeight)]){
        difference(){
            color("red")
            union(){
                difference(){
                    //Lid block with knobs
                    block(baseHeight = lidHeight, withBaseHoles=false, grid=grid, withKnobs=true, withKnobsFilled=withKnobsFilled, knobSize=knobSize, knobGaps=resultingKnobGaps, adjustSizeX=adjustSizeX, adjustSizeY=adjustSizeY, center=true);
                    
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
            
            if(withWindow){
                //Hole for GPIO Shield
                translate([-0.5*baseSideLength, baseSideLength, - 0.5*knobHeight])
                    roundedcube([6*baseSideLength, 8*baseSideLength, totalLidHeight+innerWallHeight+cutSpace], true, lidHoleRadius, "z");
            }
            else{
                translate([-3.5*baseSideLength, 5*baseSideLength, -innerWallHeight])
                    pin_holes();
                
                //translate([3*baseSideLength+-0.5, baseSideLength, innerWallHeight-1])
                //    cube([1, 8*baseSideLength, 2], center=true);
                //translate([0, -3*baseSideLength+0.5, innerWallHeight-1])
                //            cube([6*baseSideLength, 1, 2], center=true);
            }
            
            
        }
        
        
        
        if(showHelpers){
            translate([-3.5*baseSideLength, 5*baseSideLength, -innerWallHeight]){
                helpers();
            }   
            
            
        }
    }
}

objectX = 0;

body();
translate([-objectX - drawDistance, 0, -innerWallHeight - lidHeight + blockHeight]){
    //lid();
}
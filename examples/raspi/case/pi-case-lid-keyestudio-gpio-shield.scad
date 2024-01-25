/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Raspberry Pi Case Lid for Keyestudio GPIO Shield
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../lib/pi_case_lid.scad>;

baseSideLength=8;
brickHeight = 3;
blockHeight = 28.40;
floorHeight = 3.1;
lidHeight = 3;
lidHeightTolerance = 0.1;
lidSpacing = 0.3;
grid = [8, 12];
halfGrid=[8, 0.5*grid[1]];
topPlateHeight = 0.6;
wallThickness = 2;
wallY1Thickness = 3;

wallInset = 1;
innerWallHeight=2;
knobSize=5;
knobHeight = 1.9;

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
withPlugs=true;
knobsFilled=true;
resultingKnobGaps = withWindow ? [[0,3,6,10]] : (withPlugs ? [[2,4,5,10],[1,3,4,8], [0,4,0,8]] : []);

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




module lid(){
    //Lid
    
    
        difference(){
            pi_case_lid(knobGaps = [[2,4,5,10],[1,3,4,8], [0,4,0,8]]);
            
           translate([-3.5*baseSideLength, 5*baseSideLength, -innerWallHeight])
               pin_holes();
        }
        
         
        
        if(showHelpers){
            translate([-3.5*baseSideLength, 5*baseSideLength, innerWallHeight]){
                helpers();
            }   
        }
    
}

lid();
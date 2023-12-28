/**
* MachineBlocks Block Base Module
* https://machineblocks.com 
*
* Copyright (c) 2022 Jan P. Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <roundedcube.scad>;
include <roundedcube_simple.scad>;

module torus(r1,r2, resolution = 50){
    rotate_extrude(convexity = 10, $fn = resolution)
        translate([0.5*(r2 - r1), 0, 0])
            circle(r = 0.5*r1, $fn = resolution);
}


module block(
        withBaseHoles = true,
        withKnobs = true,
        
        
        withHullRounding = true,
        
        withBaseHoleGaps = false,
        maxBaseHoleNonGap = 2,
        middleBaseHoleGapLimit = 10,
        
        xyHolesOuterSize = 6.5,
        xyHolesInnerSize = 5.1,
        xyHolesInsetSize = 6.2,
        xyHolesInsetDepth = 0.9,
        withXHoles = false,
        withYHoles = false,
        withZHoles = false,
        withPillars = true,
        zHolesOuterSize = 6.5,
        zHolesInnerSize = 5.1,
        zHolesHolderOuterSize = 5.1,
        zHolesHolderInnerSize = 4.9,
        holeResolution = 30,
        
        baseHeight = 3.2,
        defaultBaseHeight = 3.2,
        baseLayers = 1,
        baseSideLength = 8,
        
        brimHeight=1,
        brimThickness = 1.6,
        
        plateHeight = 0.6,
        plateOffset = 0,
        withPlateHelper=true,
        plateHelperThickness = 0.4,
        plateHelperHeight = 0.2,
        wallThickness = 1.2,
        upperWallThickness = 2.65,
        wallGapsX = [],
        wallGapsY = [],
        
        middlePinSize = 3.2,
        helperOffset=0.2,
        withHelpers = true,
        helperHeight = 0.4,
        helperThickness = 0.8,
        grid = [4, 2],
        adjustSize = [-0.1, -0.1, -0.1, -0.1],
        brickOffset = [0, 0, 0],
        withKnobsFilled = true,
        withBaseRounding = true,
        knobSize = 5,
        knobHeight = 1.9,
        knobHoleSize = 3.3,
        knobHolderSize = 3,
        knobResolution = 30,
        knobGaps = [],
        roundingRadius = 0.1,
        roundingResolution = 15,
        withText=false,
        textFont="Font Awesome 5 Free Regular",
        text="\uf0eb",
        textSize=7,
        textDepth=0.5,
        textSide=1,
        textOffsetZ=-0.1,
        textSpacing=1,
        cutOffset=0.2,
        cutMultiplier=1.1,
        center = true,
        alwaysOnFloor = true){
            
    knobRoundingHeight = 0.25 * (knobSize - knobHoleSize);        
    knobCylinderHeight = knobHeight - knobRoundingHeight;

    objectSizeX = baseSideLength * grid[0];
    objectSizeY = baseSideLength * grid[1];
            
    objectSizeXAdjusted = objectSizeX + adjustSize[0] + adjustSize[1];
    objectSizeYAdjusted = objectSizeY + adjustSize[2] + adjustSize[3];
    
    resultingBaseHeight = baseLayers * baseHeight;
    baseHoleDepth = withBaseHoles ? resultingBaseHeight - plateHeight - plateOffset : 0;
            
    startX = 0;
    midX = floor(0.5 * grid[0] - 1);
    endX = grid[0] - 1;
    
    startY = 0;
    midY = floor(0.5 * grid[1] - 1);
    endY = grid[1] - 1;
            
    mid = [midX, midY];
    
    offsetX = 0.5 * (grid[0] - 1);
    offsetY = 0.5 * (grid[1] - 1);
    
    drawKnobs = withKnobs;
    resultingPlateHeight = withBaseHoles ? plateHeight : resultingBaseHeight;        
    totalHeight = resultingBaseHeight + (drawKnobs ? knobHeight : 0);  

    xyHolesZ = 0;
    xyzHolesY = 0;
    xyzHolesX = 0;
    
    centerX = 0;
    centerY = 0;
    centerZ = drawKnobs ? -0.5 * knobHeight : 0;    
    
    
    posZBaseHoles = -0.5 * (totalHeight - baseHoleDepth);        
    posZPlate = posZBaseHoles + 0.5 * (resultingBaseHeight - plateOffset) ;
    posZKnobs = centerZ + 0.5 * (resultingBaseHeight + knobCylinderHeight); 
    
    roundingApply = withBaseHoles ? (drawKnobs ? "all" : "zmin") : (drawKnobs ? "zmax" : "z");
    
    brickOffsetX = brickOffset[0] * baseSideLength + (center ? 0 : -0.5*objectSizeX + objectSizeXAdjusted);
    brickOffsetY = brickOffset[1] * baseSideLength + (center ? 0 : -0.5*objectSizeY + objectSizeYAdjusted);
    brickOffsetZ = brickOffset[2] * defaultBaseHeight + (!center || alwaysOnFloor ? 0.5 * totalHeight : 0);
    
    echo (baseHoleDepth=baseHoleDepth, posZPlate=posZPlate, totalHeight = totalHeight, resultingPlateHeight=resultingPlateHeight, posZKnobs=posZKnobs, knobHeight = knobHeight);
            
    function posX(a) = (a - offsetX) * baseSideLength;
    function posY(b) = (b - offsetY) * baseSideLength;
    
    function isCornerZone(value, i) = (value < maxBaseHoleNonGap) || (value >= grid[i] - (maxBaseHoleNonGap + 1)); 
    function isMiddleZone(value, i) = (grid[i] >= middleBaseHoleGapLimit) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (grid[i] >= middleBaseHoleGapLimit) && (value == mid[i]);
    
    function drawCornerPillar(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddlePillar(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawPillar(a, b) = !withBaseHoleGaps || withZHoles || ((a%2==0) && (b%2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawKnob(a, b, i) = (i >= len(knobGaps)) || (((a < knobGaps[i][0]) || (b < knobGaps[i][1]) || (a > knobGaps[i][2]) || (b > knobGaps[i][3])) && drawKnob(a, b, i+1)); 
    
    function drawWallGapX(a, side, i) = (i < len(wallGapsX)) && ((wallGapsX[i][0] == a && (side == wallGapsX[i][1] || wallGapsX[i][1] == 2)) || drawWallGapX(a, side, i+1)); 
    
    function drawWallGapY(a, side, i) = (i < len(wallGapsY)) && ((wallGapsY[i][0] == a && (side == wallGapsY[i][1] || wallGapsY[i][1] == 2)) || drawWallGapY(a, side, i+1)); 
    
    translate([brickOffsetX, brickOffsetY, brickOffsetZ]){
        union(){
            
            //Base
            difference(){
                intersection(){
                    union(){
                        if(withBaseHoles){
                            
                            
                            //Plate Helper
                            if(withPlateHelper){
                                union(){
                                    translate([centerX - 0.5*(objectSizeX - 2*wallThickness - plateHelperThickness), centerY, posZPlate - 0.5 * (plateHeight + plateHelperHeight)]){
                                        cube([plateHelperThickness, objectSizeY - 2*wallThickness, plateHelperHeight], center = true);
                                    }
                                    translate([centerX + 0.5*(objectSizeX - 2*wallThickness - plateHelperThickness), centerY, posZPlate - 0.5 * (plateHeight + plateHelperHeight)]){
                                        cube([plateHelperThickness, objectSizeY - 2*wallThickness, plateHelperHeight], center = true);
                                    }    
                                    translate([centerX, centerY - 0.5*(objectSizeY - 2*wallThickness - plateHelperThickness), posZPlate - 0.5 * (plateHeight + plateHelperHeight + helperOffset)]){
                                        cube([objectSizeX - 2*wallThickness, plateHelperThickness, plateHelperHeight + helperOffset], center = true);
                                    }
                                    translate([centerX, centerY + 0.5*(objectSizeY - 2*wallThickness - plateHelperThickness), posZPlate - 0.5 * (plateHeight + plateHelperHeight + helperOffset)]){
                                        cube([objectSizeX - 2*wallThickness, plateHelperThickness, plateHelperHeight + helperOffset], center = true);
                                    } 
                                }
                            }
                    
                
                            //Helpers
                            if(withHelpers){ // && !withXHoles && !withYHoles){ 
                                translate([0, 0, posZPlate - 0.5 * (plateHeight + helperHeight)]){
                                    difference(){
                                        union(){
                                            //Helpers X
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                translate([posX(a + 0.5), xyzHolesY, -0.5 * helperOffset]){ 
                                                    cube([helperThickness, objectSizeY - 2*wallThickness, helperHeight+helperOffset], center = true);
                                                }
                                            }
                                            
                                            //Helpers Y
                                            for (b = [ startY : 1 : endY - 1 ]){
                                               translate([xyzHolesX, posY(b + 0.5), 0]){
                                                    cube([objectSizeX - 2*wallThickness, helperThickness, helperHeight], center = true);
                                                };
                                            }
                                        }
                                        if(withPillars){
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                for (b = [ startY : 1 : endY - 1 ]){
                                                   if(drawPillar(a, b)){
                                                        //TODO more precise cut height
                                                        translate([posX(a + 0.5), posY(b + 0.5), -0.5 * helperOffset]){
                                                            cylinder(h=cutMultiplier * (helperHeight+helperOffset), r=0.5 * zHolesOuterSize*0.9, center=true, $fn=holeResolution);
                                                        };
                                                   }
                                                }   
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if(withPillars){
                                //Middle Pin X
                                if(endY == 0){
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        translate([posX(a + 0.5), xyzHolesY, posZBaseHoles]){
                                            cylinder(h=baseHoleDepth, r=0.5 * middlePinSize, center=true, $fn=holeResolution);
                                        };
                                    }
                                }
                                
                                //Middle Pin Y
                                if(endX == 0){
                                    for (b = [ startY : 1 : endY - 1 ]){
                                        translate([xyzHolesX, posY(b + 0.5), posZBaseHoles]){
                                            cylinder(h=baseHoleDepth, r=0.5 * middlePinSize, center=true, $fn=holeResolution);
                                        };
                                    }
                                }
                            }
                        
                            //X-Holes Outer
                            if(withXHoles){
                                for (a = [ startX : 1 : endX - 1 ]){
                                    translate([posX(a + 0.5), xyzHolesY, xyHolesZ]){
                                        rotate([90, 0, 0]){ 
                                            cylinder(h=objectSizeY, r=0.5 * xyHolesOuterSize, center=true, $fn=holeResolution);
                                        }
                                    };
                                }
                            }
                            
                            //Y-Holes Outer
                            if(withYHoles){
                                for (b = [ startY : 1 : endY - 1 ]){
                                    translate([xyzHolesX, posY(b + 0.5), xyHolesZ]){
                                        rotate([0, 90, 0]){ 
                                            cylinder(h=objectSizeX, r=0.5 * xyHolesOuterSize, center=true, $fn=holeResolution);
                                        };
                                    };
                                }
                            }
                            
                            
                            if(withZHoles){
                                //Z-Holes Outer
                                for (a = [ startX : 1 : endX - 1 ]){
                                    for (b = [ startY : 1 : endY - 1 ]){
                                       translate([posX(a + 0.5), posY(b + 0.5), posZBaseHoles]){
                                            cylinder(h=baseHoleDepth, r=0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                        };
                                    }   
                                }
                            }
                            else if(withPillars){
                                //Pillars with holes
                                for (a = [ startX : 1 : endX - 1 ]){
                                    for (b = [ startY : 1 : endY - 1 ]){
                                        if(drawPillar(a, b)){
                                            translate([posX(a + 0.5), posY(b+0.5), posZBaseHoles]){
                                                difference(){
                                                    cylinder(h=baseHoleDepth, r=0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                                    
                                                    intersection(){
                                                        cylinder(h=baseHoleDepth*cutMultiplier, r=0.5 * zHolesHolderOuterSize, center=true, $fn=holeResolution);
                                                        cube([zHolesHolderInnerSize, zHolesHolderInnerSize, baseHoleDepth*cutMultiplier], center=true);
                                                    };
                                                }
                                            };
                                        }
                                    }
                                }
                            }
                            
                            
                            //Base Holes 
                            translate([0, 0, centerZ]){ 
                                difference() {
                                    translate([0.5*(adjustSize[1] - adjustSize[0]), 0.5*(adjustSize[3] - adjustSize[2]), 0]){
                                        cube([objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], center = true);
                                    }
                                    
                                    if(plateOffset > 0){
                                        color("green")
                                        translate([0, 0, 0.5*(resultingBaseHeight - plateOffset) + 0.5 * cutOffset])
                                            cube([objectSizeX - 2*upperWallThickness, objectSizeY - 2*upperWallThickness, plateOffset + cutOffset], center = true);
                                    }
                                    
                                    union(){
                                        color("red")
                                        translate([0, 0, 0.5*(brimHeight - (plateOffset > 0 ? plateOffset : 0) - plateHeight) ])
                                            cube([objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness, resultingBaseHeight - (plateOffset > 0 ? plateOffset : 0) - plateHeight - brimHeight], center = true);    
                                    
                                        for (a = [ startX : 1 : endX ]){
                                            for (side = [ 0 : 1 : 1 ]){
                                                if(drawWallGapX(a, side, 0)){
                                                    translate([posX(a), 0.5*(adjustSize[3] - adjustSize[2]) + (side - 0.5)*objectSizeYAdjusted, posZBaseHoles - centerZ]){
                                                         difference(){
                                                            translate([0, 0, -0.5 * cutOffset])
                                                                cube([baseSideLength-2*wallThickness+0.01, 2*(brimThickness + adjustSize[2 + side]+0.01), baseHoleDepth + cutOffset], center=true); 
                                                             
                                                            
                                                            
                                                                translate([-0.5*(baseSideLength-2*wallThickness), 0, -0.5*(baseHoleDepth - brimHeight) - 0.5 * cutOffset]) 
                                                                    cube([2*(brimThickness-wallThickness), 2*(brimThickness+adjustSize[2 + side])*cutMultiplier, brimHeight+cutOffset+0.01], center=true);
                                                            
                                                            
                                                                translate([0.5*(baseSideLength-2*wallThickness), 0, -0.5*(baseHoleDepth - brimHeight) - 0.5 * cutOffset]) 
                                                                    cube([2*(brimThickness-wallThickness), 2*(brimThickness+adjustSize[2 + side])*cutMultiplier, brimHeight+cutOffset+0.01], center=true);
                                                            
                                                            
                                                         }  
                                                    }
                                                }
                                            }
                                        }
                                        
                                        
                                        for (b = [ startY : 1 : endY ]){
                                            for (side = [ 0 : 1 : 1 ]){
                                                if(drawWallGapY(b, side, 0)){
                                                    translate([0.5*(adjustSize[1] - adjustSize[0]) + (side-0.5)*objectSizeXAdjusted, posY(b), posZBaseHoles - centerZ]){
                                                        difference(){
                                                            translate([0, 0, -0.5 * cutOffset])
                                                                cube([2*(brimThickness+ adjustSize[side]+0.01), baseSideLength-2*wallThickness+0.01, baseHoleDepth + cutOffset], center=true);   
                                                            
                                                            
                                                            
                                                                translate([0, -0.5*(baseSideLength-2*wallThickness), -0.5*(baseHoleDepth - brimHeight) - 0.5 * cutOffset]) 
                                                                    cube([2*(brimThickness+adjustSize[side])*cutMultiplier, 2*(brimThickness-wallThickness), brimHeight + cutOffset+0.01], center=true);
                                                            
                                                            
                                                                translate([0, 0.5*(baseSideLength-2*wallThickness), -0.5*(baseHoleDepth - brimHeight) - 0.5 * cutOffset]) 
                                                                    cube([2*(brimThickness+adjustSize[side])*cutMultiplier, 2*(brimThickness-wallThickness), brimHeight + cutOffset+0.01], center=true);
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    color("blue")
                                    translate([0, 0, 0.5*(brimHeight - resultingBaseHeight)])
                                        cube([objectSizeX - 2*brimThickness, objectSizeY - 2*brimThickness, brimHeight*cutMultiplier], center = true);
                                
                                }
                                
                                
                            }
                            
                            
                            
                            
                            /*
                            translate([centerX, centerY, posZPlate]){
                                //Plate
                                color("red")
                                cube([objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness, resultingPlateHeight], center = true);
                            };*/
                        }
                        else{
                            //Draw a solid block
                            translate([0.5*(adjustSize[1] - adjustSize[0]), 0.5*(adjustSize[3] - adjustSize[2]), centerZ]){ 
                                cube([objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], center = true);
                            }
                        }
                        //End withBaseHoles
                        
                        
                        

                    };
                    //End union
    
                    if(withHullRounding){
                        //Hull with rounding
                        translate([0.5*(adjustSize[1] - adjustSize[0]), 0.5*(adjustSize[3] - adjustSize[2]), centerZ]){
                            if(withBaseHoles && drawKnobs){
                                roundedcube_simple(size = [objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], 
                                            center = true, 
                                            radius=roundingRadius, 
                                            resolution=roundingResolution);    
                            }
                            else{
                                roundedcube(size = [objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], 
                                            center = true, 
                                            radius=roundingRadius, 
                                            apply_to=roundingApply,
                                            resolution=roundingResolution);
                            }
                        };
                    }
                }
                //End intersection
                
                //XHoles
                if(withXHoles){
                    for (a = [ startX : 1 : endX - 1 ]){
                        translate([posX(a + 0.5), xyzHolesY, xyHolesZ]){
                            rotate([90, 0, 0]){ 
                                cylinder(h=objectSizeY*cutMultiplier, r=0.5 * xyHolesInnerSize, center=true, $fn=holeResolution);
                                
                                translate([0, 0, 0.5 * objectSizeY])
                                    cylinder(h=2*xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                                translate([0, 0, -0.5 * objectSizeY])
                                    cylinder(h=2*xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                            };
                        };
                    }
                }
                
                //YHoles
                if(withYHoles){
                    for (b = [ startY : 1 : endY - 1 ]){
                        translate([xyzHolesX, posY(b + 0.5), xyHolesZ]){
                            rotate([0, 90, 0]){ 
                                cylinder(h=objectSizeX*cutMultiplier, r=0.5 * xyHolesInnerSize, center=true, $fn=holeResolution);
                                
                                translate([0, 0, 0.5 * objectSizeX])
                                    cylinder(h=2*xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                                translate([0, 0, -0.5 * objectSizeX])
                                    cylinder(h=2*xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                            };
                        };
                    }
                }
                
                //ZHoles
                if(withZHoles){
                    for (a = [ startX : 1 : endX - 1 ]){
                        for (b = [ startY : 1 : endY - 1 ]){
                            translate([posX(a + 0.5), posY(b+0.5), centerZ]){
                                cylinder(h=resultingBaseHeight*cutMultiplier, r=0.5 * zHolesInnerSize, center=true, $fn=holeResolution);
                            };
                        }
                    }
                }
                
                if(withText){
                    color("red")
                    if(textSide>2){
                        translate([centerX + (textSide%2 == 1 ? 1 : -1) * (-0.5 * objectSizeX) - textDepth, centerY, centerZ + textOffsetZ])
                        rotate([90,0,90])
                            linear_extrude(2*textDepth) {
                                text(text, size = textSize, font = textFont, spacing = textSpacing, halign = "center", valign = "center", $fn = 64);
                            }
                    }
                    else{
                        translate([centerX, centerY + (textSide%2 == 1 ? 1 : -1) * (-0.5 * objectSizeY) + textDepth, centerZ + textOffsetZ])
                            rotate([90,0,0])
                                linear_extrude(2*textDepth) {
                                    text(text, size = textSize, font = textFont, spacing = textSpacing, halign = "center", valign = "center", $fn = 64);
                                }
                    }
                }
            };
            //End difference
            
            
            //With knobs
            if(drawKnobs){
                if(plateOffset == 0){
                    for (a = [ startX : 1 : endX ]){
                        for (b = [ startY : 1 : endY ]){
                            if(drawKnob(a,b, 0)){
                                translate([posX(a), posY(b), posZKnobs]){ 
                                    //Knob Cylinder
                                    if(withKnobsFilled){
                                        cylinder(h=knobCylinderHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);
                                        
                                        translate([0, 0, 0.5 * knobHeight]){ 
                                           cylinder(h=knobRoundingHeight, r=knobHoleSize / 2 + knobRoundingHeight, center=true, $fn=knobResolution);
                                        };
                                    }
                                    else{
                                        difference(){
                                            cylinder(h=knobCylinderHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);
                                            intersection(){
                                                cylinder(h=knobCylinderHeight * cutMultiplier, r=0.5 * knobHoleSize, center=true, $fn=knobResolution);
                                                cube([knobHolderSize, knobHolderSize, knobCylinderHeight*cutMultiplier], center=true);
                                            }
                                        };
                                    }
                                    
                                    //Knob Rounding
                                    translate([0, 0, 0.5 * knobCylinderHeight]){ 
                                        torus(2 * knobRoundingHeight, knobSize, knobResolution);
                                    };
                                };
                            }
                        }
                    }
                }
                else{
                    knobRectX = posX(endX) - posX(startX) + knobSize;
                    knobRectY = posY(endY) - posY(startY) + knobSize;
                    translate([0, 0, posZKnobs + 0.5*knobRoundingHeight]){ 
                        difference(){
                            roundedcube(size=[knobRectX, knobRectY, knobHeight], 
                                            center = true, 
                                            radius=0.5, 
                                            apply_to="z",
                                            resolution=roundingResolution);
                            cube([knobRectX - 0.5*knobSize, knobRectY - 0.5*knobSize, knobHeight*cutMultiplier], center=true);
                        }
                    }
                }
            } //End drawKnobs
            
        } //End union
        
    } //End translate brick offset

} // End module block    

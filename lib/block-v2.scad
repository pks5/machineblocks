/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Building Block Module
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
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
        
        middlePinSize = 3.2,
        helperOffset=0.2,
        withHelpers = true,
        helperHeight = 0.4,
        helperThickness = 0.8,
        grid = [4, 2],
        adjustSizeX = -0.2,
        adjustSizeY = -0.2,
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
        center = true,
        alwaysOnFloor = true){
            
    knobRoundingHeight = 0.25 * (knobSize - knobHoleSize);        
    knobCylinderHeight = knobHeight - knobRoundingHeight;

    objectSizeX = baseSideLength * grid[0] + adjustSizeX;
    objectSizeY = baseSideLength * grid[1] + adjustSizeY;
    
    resultingBaseHeight = baseLayers * baseHeight;
    baseHoleDepth = withBaseHoles ? resultingBaseHeight - plateHeight - plateOffset : 0;
            
    startX = 0;
    midX = floor(0.5 * grid[0] - 1);
    endX = grid[0] - 1;
    
    startY = 0;
    midY = floor(0.5 * grid[1] - 1);
    endY = grid[1] - 1;
            
    mid = [midX, midY];
    
    offsetX = center ? 0.5 * (grid[0] - 1) : -0.5;
    offsetY = center ? 0.5 * (grid[1] - 1) : -0.5;
    
    drawKnobs = withKnobs && plateOffset == 0;
    resultingPlateHeight = withBaseHoles ? plateHeight : resultingBaseHeight;        
    totalHeight = resultingBaseHeight + (drawKnobs ? knobHeight : 0);        
    
    
    posZBaseHoles = withBaseHoles ? (center ? -0.5 * (totalHeight - baseHoleDepth) : 0.5 * baseHoleDepth) : 0;        
    posZPlate = posZBaseHoles + (withBaseHoles ? 0.5 * resultingBaseHeight : (center ? -0.5 * (totalHeight - resultingPlateHeight) : 0.5 * resultingPlateHeight)) - 0.5*plateOffset ;
    posZKnobs = posZPlate + 0.5 * (resultingPlateHeight + knobCylinderHeight);

    roundingApply = withBaseHoles ? (drawKnobs ? "all" : "zmin") : (drawKnobs ? "zmax" : "z");
    translateRoundingZ = center && drawKnobs ? -0.5 * knobHeight : 0;
    
    xyHolesZ = center ? 0 : (3 * defaultBaseHeight + knobHeight) / 2;
    xyzHolesY = center ? 0 : objectSizeY / 2;
    xyzHolesX = center ? 0 : objectSizeX / 2;
    
    centerX = center ? 0 : 0.5 * objectSizeX;
    centerY = center ? 0 : 0.5 * objectSizeY;
    centerZ = center ? (drawKnobs ? -0.5 * knobHeight : 0) : resultingBaseHeight / 2;
    
    //zHolesZ = withZHoles ? centerZ : posZBaseHoles;
    //zHolesHeight = withZHoles ? resultingBaseHeight : baseHoleDepth;
    
    brickOffsetZ = brickOffset[2] * defaultBaseHeight + (center && alwaysOnFloor ? 0.5 * totalHeight : 0);
    
    echo (baseHoleDepth=baseHoleDepth, posZPlate=posZPlate, totalHeight = totalHeight, resultingPlateHeight=resultingPlateHeight, posZKnobs=posZKnobs, knobHeight = knobHeight);
            
    function posX(a) = (a - offsetX) * baseSideLength + 0.5*adjustSizeX;
    function posY(b) = (b - offsetY) * baseSideLength + 0.5*adjustSizeY;
    
    function isCornerZone(value, i) = (value < maxBaseHoleNonGap) || (value >= grid[i] - (maxBaseHoleNonGap + 1)); 
    function isMiddleZone(value, i) = (grid[i] >= middleBaseHoleGapLimit) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (grid[i] >= middleBaseHoleGapLimit) && (value == mid[i]);
    
    function drawCornerZHole(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddleZHole(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawZHole(a, b) = !withBaseHoleGaps || withZHoles || ((a%2==0) && (b%2 == 0)) || drawCornerZHole(a, b) || drawMiddleZHole(a, b); 
    
    function drawKnob(a, b, i) = (i >= len(knobGaps)) || (((a < knobGaps[i][0]) || (b < knobGaps[i][1]) || (a > knobGaps[i][2]) || (b > knobGaps[i][3])) && drawKnob(a, b, i+1)); 
    
    translate([brickOffset[0] * baseSideLength, brickOffset[1] * baseSideLength, brickOffsetZ]){
        union(){
            
            //Base
            difference(){
                intersection(){
                    union(){
                        
                        
                        
                        if(withBaseHoles){
                            
                            
                            //Base Holes 
                            translate([centerX, centerY, centerZ]){ 
                                difference() {
                                    color("green")
                                    cube([objectSizeX, objectSizeY, resultingBaseHeight], center = true);
                                    if(wallThickness == brimThickness){
                                        cube([objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness, resultingBaseHeight*1.1], center = true);
                                    }
                                    else{
                                        translate([0, 0, brimHeight])
                                            cube([objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness, resultingBaseHeight], center = true);
                                        
                                        translate([0, 0, 0.5*(brimHeight - resultingBaseHeight)])
                                            cube([objectSizeX - 2*brimThickness, objectSizeY - 2*brimThickness, brimHeight + 0.1], center = true);
                                    }
                                };
                            }
                            
                            //Plate Helper
                            if(withPlateHelper){
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
                                                   if(drawZHole(a, b)){
                                                        //TODO more precise cut height
                                                        translate([posX(a + 0.5), posY(b + 0.5), -0.5 * helperOffset]){
                                                            cylinder(h=1.1 * (helperHeight+helperOffset), r=0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                                        };
                                                   }
                                                }   
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
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
                                       if(drawZHole(a, b)){
                                            translate([posX(a + 0.5), posY(b + 0.5), posZBaseHoles]){
                                                cylinder(h=baseHoleDepth, r=0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                            };
                                       }
                                    }   
                                }
                            }
                            else if(withPillars){
                                //Pillars with holes
                                for (a = [ startX : 1 : endX - 1 ]){
                                    for (b = [ startY : 1 : endY - 1 ]){
                                        if(drawZHole(a, b)){
                                            translate([posX(a + 0.5),posY(b+0.5),posZBaseHoles]){
                                                difference(){
                                                    cylinder(h=baseHoleDepth, r=0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                                    
                                                    intersection(){
                                                        cylinder(h=baseHoleDepth*1.1, r=0.5 * zHolesHolderOuterSize, center=true, $fn=holeResolution);
                                                        cube([zHolesHolderInnerSize, zHolesHolderInnerSize, baseHoleDepth*1.1], center=true);
                                                    };
                                                }
                                            };
                                        }
                                    }
                                }
                            }
                        }
                        //End withBaseHoles
                        
                        
                        translate([centerX, centerY, posZPlate]){
                            //Plate
                            color("red")
                            cube([objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness, resultingPlateHeight], center = true);
                        };

                    };
                    //End union
    
                    if(withHullRounding){
                        //Hull with rounding
                        translate([0, 0, translateRoundingZ]){
                            if(withBaseHoles && drawKnobs){
                                roundedcube_simple(size = [objectSizeX, objectSizeY, resultingBaseHeight], 
                                            center = center, 
                                            radius=roundingRadius, 
                                            resolution=roundingResolution);    
                            }
                            else{
                                roundedcube(size = [objectSizeX, objectSizeY, resultingBaseHeight], 
                                            center = center, 
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
                                cylinder(h=objectSizeY*1.1, r=0.5 * xyHolesInnerSize, center=true, $fn=holeResolution);
                                
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
                                cylinder(h=objectSizeX*1.1, r=0.5 * xyHolesInnerSize, center=true, $fn=holeResolution);
                                
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
                            if(drawZHole(a, b)){
                                translate([posX(a + 0.5), posY(b+0.5), centerZ]){
                                    cylinder(h=resultingBaseHeight*1.1, r=0.5 * zHolesInnerSize, center=true, $fn=holeResolution);
                                };
                            }
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
                                            cylinder(h=knobCylinderHeight * 1.1, r=0.5 * knobHoleSize, center=true, $fn=knobResolution);
                                            cube([knobHolderSize, knobHolderSize, knobCylinderHeight*1.1], center=true);
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
            } //End drawKnobs
            
        } //End union
        
    } //End translate brick offset

} // End module block    

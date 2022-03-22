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
include <brick-hollow.scad>;

module torus(r1,r2, resolution = 50){
    rotate_extrude(convexity = 10, $fn = resolution)
        translate([0.5*(r2 - r1), 0, 0])
            circle(r = 0.5*r1, $fn = resolution);
}


module block(
        withBaseHoles = true,
        withKnobs = true,
        withXHoles = false,
        withBaseHoleGaps = false,
        maxBaseHoleNonGap = 2,
        middleBaseHoleGapLimit = 10,
        xyHolesOuterSize = 6.5,
        xyHolesInnerSize = 5.1,
        xyHolesInsetSize = 6.2,
        xyHolesInsetDepth = 0.9,
        withYHoles = false,
        withZHoles = false,
        zHolesOuterSize = 6.45,
        zHolesInnerSize = 5.1,
        zHolesHolderOuterSize = 5.5,
        zHolesHolderInnerSize = 5.2,
        holeResolution = 30,
        baseHeight = 3.1,
        baseLayers = 1,
        baseSideLength = 8,
        plateHeight = 0.6,
        plateHelperThickness = 0.5,
        plateHelperHeight = 0.2,
        minWallThickness = 1.2,
        maxWallThickness = 1.6,
        middlePinSize = 3.2,
        withHelpers = true,
        helperHeight = 1.5,
        helperThickness = 0.9,
        grid = [4, 2],
        adjustSizeX = -0.2,
        adjustSizeY = -0.2,
        withKnobsFilled = true,
        withBaseRounding = true,
        knobSize = 4.95,
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
        center = false){
            
    knobRoundingHeight = 0.25 * (knobSize - knobHoleSize);        
    knobCylinderHeight = knobHeight - knobRoundingHeight;

    objectSizeX = baseSideLength * grid[0] + adjustSizeX;
    objectSizeY = baseSideLength * grid[1] + adjustSizeY;
    
    resultingBaseHeight = baseLayers * baseHeight;
    baseHoleDepth = withBaseHoles ? resultingBaseHeight - plateHeight : 0;
            
    startX = 0;
    midX = floor(0.5 * grid[0] - 1);
    endX = grid[0] - 1;
    
    startY = 0;
    midY = floor(0.5 * grid[1] - 1);
    endY = grid[1] - 1;
            
    mid = [midX, midY];
    
    offsetX = center ? 0.5 * (grid[0] - 1) : -0.5;
    offsetY = center ? 0.5 * (grid[1] - 1) : -0.5;
    
    resultingPlateHeight = withBaseHoles ? plateHeight : resultingBaseHeight;        
    totalHeight = resultingBaseHeight + (withKnobs ? knobHeight : 0);        
    
    posZBaseHoles = withBaseHoles ? (center ? -0.5 * (totalHeight - baseHoleDepth) : 0.5 * baseHoleDepth) : 0;        
    posZPlate = posZBaseHoles + (withBaseHoles ? 0.5 * resultingBaseHeight : (center ? -0.5 * (totalHeight - resultingPlateHeight) : 0.5 * resultingPlateHeight));
    posZKnobs = posZPlate + 0.5 * (resultingPlateHeight + knobCylinderHeight);

    roundingApply = withBaseHoles ? (withKnobs ? "all" : "zmin") : (withKnobs ? "zmax" : "z");
    translateRoundingZ = center && withKnobs ? -0.5 * knobHeight : 0; //0.001;
    
    xyHolesZ = center ? 0 : (resultingBaseHeight + knobHeight) / 2;
    xyzHolesY = center ? 0 : objectSizeY / 2;
    xyzHolesX = center ? 0 : objectSizeX / 2;
    
    centerX = center ? 0 : 0.5 * objectSizeX;
    centerY = center ? 0 : 0.5 * objectSizeY;
    centerZ = center && withKnobs ? -0.5 * knobHeight : resultingBaseHeight / 2;
    
    zHolesZ = withZHoles ? centerZ : posZBaseHoles;
    zHolesHeight = withZHoles ? resultingBaseHeight : baseHoleDepth;
            
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
    
    union(){
        
        //Base
        difference(){
            intersection(){
                union(){
                    
                    translate([centerX, centerY, posZPlate]){
                        //Plate
                        cube([objectSizeX, objectSizeY, resultingPlateHeight], center = true);
                    };
                    
                    if(withBaseHoles){
                        
                        
                        //Base Holes 
                        translate([centerX, centerY, posZBaseHoles]){ 
                            difference() {
                                cube([objectSizeX, objectSizeY, baseHoleDepth], center = true);
                                if(minWallThickness == maxWallThickness){
                                    cube([objectSizeX - 2*minWallThickness, objectSizeY - 2*minWallThickness, baseHoleDepth*1.1], center = true);
                                }
                                else{
                                    brickHollow(
                                        height=baseHoleDepth, 
                                        minSize=[objectSizeX - 2*maxWallThickness, objectSizeY - 2*maxWallThickness], 
                                        maxSize=[objectSizeX - 2*minWallThickness, objectSizeY - 2*minWallThickness],
                                        center=true
                                    );
                                }
                            };
                        }
                        
                        //Plate Helper
                        translate([centerX, centerY, posZPlate - 0.5 * (plateHeight + plateHelperHeight)]){
                            difference() {
                                cube([objectSizeX - 2*minWallThickness, objectSizeY - 2*minWallThickness, plateHelperHeight], center = true);
                                cube([objectSizeX - 2*(minWallThickness + plateHelperThickness), objectSizeY - 2*(minWallThickness + plateHelperThickness), plateHelperHeight*1.1], center = true);
                            };
                        }
                
            
                        //Helpers
                        if(withHelpers && !withXHoles && !withYHoles){ 
                            //Helpers X
                            for (a = [ startX : 1 : endX - 1 ]){
                                translate([posX(a + 0.5), xyzHolesY, posZPlate - 0.5 * (plateHeight + helperHeight)]){ 
                                    cube([helperThickness, objectSizeY, helperHeight], center = true);
                                }
                            }
                            
                            //Helpers Y
                            for (b = [ startY : 1 : endY - 1 ]){
                               translate([xyzHolesX, posY(b + 0.5), posZPlate - 0.5 * (plateHeight + helperHeight)]){
                                    cube([objectSizeX, helperThickness, helperHeight], center = true);
                                };
                            }
                        }
                        
                        
                        //Middle Pin X
                        if(endY == 0){
                            for (a = [ startX : 1 : endX - 1 ]){
                                translate([posX(a + 0.5), xyzHolesY, posZBaseHoles]){
                                    cylinder(h=zHolesHeight, r=0.5 * middlePinSize, center=true, $fn=holeResolution);
                                };
                            }
                        }
                        
                        //Middle Pin Y
                        if(endX == 0){
                            for (b = [ startY : 1 : endY - 1 ]){
                                translate([xyzHolesX, posY(b + 0.5), posZBaseHoles]){
                                    cylinder(h=zHolesHeight, r=0.5 * middlePinSize, center=true, $fn=holeResolution);
                                };
                            }
                        }
                    
                        //XHoles outer
                        if(withXHoles){
                            for (a = [ startX : 1 : endX - 1 ]){
                                translate([posX(a + 0.5), xyzHolesY, xyHolesZ]){
                                    rotate([90, 0, 0]){ 
                                        cylinder(h=objectSizeY, r=0.5 * xyHolesOuterSize, center=true, $fn=holeResolution);
                                    }
                                };
                            }
                        }
                        
                        //YHoles outer
                        if(withYHoles){
                            for (b = [ startY : 1 : endY - 1 ]){
                                translate([xyzHolesX, posY(b + 0.5), xyHolesZ]){
                                    rotate([0, 90, 0]){ 
                                        cylinder(h=objectSizeX, r=0.5 * xyHolesOuterSize, center=true, $fn=holeResolution);
                                    };
                                };
                            }
                        }
                        
                        //Z Holes outer
                        if(withZHoles){
                            for (a = [ startX : 1 : endX - 1 ]){
                                for (b = [ startY : 1 : endY - 1 ]){
                                   if(drawZHole(a, b)){
                                        translate([posX(a + 0.5), posY(b + 0.5), zHolesZ]){
                                            cylinder(h=zHolesHeight, r=0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                        };
                                   }
                                }   
                            }
                        }
                    }
                    //End withBaseHoles
                    
                    
                    

                };
                //End union

                //Hull with rounding
                translate([0, 0, translateRoundingZ]){
                    if(withBaseHoles && withKnobs){
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
            //End intersection
            
            //XHoles
            if(withXHoles){
                for (a = [ startX : 1 : endX - 1 ]){
                    translate([posX(a + 0.5),xyzHolesY,xyHolesZ]){
                        rotate([90,0,0]){ 
                            cylinder(h=objectSizeY*1.1, r=0.5 * xyHolesInnerSize, center=true, $fn=holeResolution);
                            
                            translate([0,0, 0.5 * (objectSizeY - xyHolesInsetDepth)])
                                cylinder(h=xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                            translate([0,0, - 0.5 * (objectSizeY - xyHolesInsetDepth)])
                                cylinder(h=xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                        };
                    };
                }
            }
            
            //YHoles
            if(withYHoles){
                for (b = [ startY : 1 : endY - 1 ]){
                    translate([xyzHolesX,posY(b + 0.5),xyHolesZ]){
                        rotate([0,90,0]){ 
                            cylinder(h=objectSizeX*1.1, r=0.5 * xyHolesInnerSize, center=true, $fn=holeResolution);
                            
                            translate([0,0, 0.5 * (objectSizeX - xyHolesInsetDepth)])
                                cylinder(h=xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                            translate([0,0, - 0.5 * (objectSizeX - xyHolesInsetDepth)])
                                cylinder(h=xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                        };
                    };
                }
            }
            
            //ZHoles
            if(withBaseHoles || withZHoles){
                for (a = [ startX : 1 : endX - 1 ]){
                    for (b = [ startY : 1 : endY - 1 ]){
                        if(drawZHole(a, b)){
                            translate([posX(a + 0.5),posY(b+0.5),zHolesZ]){
                                if(withZHoles){
                                    cylinder(h=zHolesHeight, r=0.5 * zHolesInnerSize, center=true, $fn=holeResolution);
                                }
                                else{
                                    cylinder(h=zHolesHeight, r=0.99 * 0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                }
                            };
                        }
                    }
                }
            }
            
            if(withText){
                color("red")
                if(textSide>2){
                    translate([centerX + (textSide%2 == 1 ? 1 : -1) * (-0.5 * objectSizeX) - textDepth, centerY, centerZ])
                    rotate([90,0,90])
                        linear_extrude(2*textDepth) {
                            text(text, size = textSize, font = textFont, halign = "center", valign = "center", $fn = 64);
                        }
                }
                else{
                    translate([centerX, centerY + (textSide%2 == 1 ? 1 : -1) * (-0.5 * objectSizeY) + textDepth, centerZ])
                        rotate([90,0,0])
                            linear_extrude(2*textDepth) {
                                text(text, size = textSize, font = textFont, halign = "center", valign = "center", $fn = 64);
                            }
                }
            }
        };
        //End difference
        
        
        
        //ZHoles with holders
        if(withBaseHoles && !withZHoles){
            for (a = [ startX : 1 : endX - 1 ]){
                for (b = [ startY : 1 : endY - 1 ]){
                    if(drawZHole(a, b)){
                        translate([posX(a + 0.5),posY(b+0.5),zHolesZ]){
                            difference(){
                                cylinder(h=zHolesHeight, r=0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                
                                intersection(){
                                    cylinder(h=zHolesHeight*1.1, r=0.5 * zHolesHolderOuterSize, center=true, $fn=holeResolution);
                                    cube([zHolesHolderInnerSize, zHolesHolderInnerSize, zHolesHeight*1.1], center=true);
                                };
                            }
                        };
                    }
                }
            }
        }
        
        
        
        //With knobs
        if(withKnobs){
            for (a = [ startX : 1 : endX ]){
                for (b = [ startY : 1 : endY ]){
                    if(drawKnob(a,b, 0)){
                        
                        translate([posX(a), posY(b), posZKnobs]){ 
                            //Knob Cylinder
                            //union(){
                                if(withKnobsFilled){
                                    cylinder(h=knobCylinderHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);
                                    
                                    translate([0, 0, 0.5 * knobHeight]){ 
                                       cylinder(h=knobRoundingHeight, r=knobHoleSize / 2 + knobRoundingHeight, center=true, $fn=knobResolution);
                                    };
                                }
                                else{
                                    /*
                                    difference(){
                                        cylinder(h=knobCylinderHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);
                                        cylinder(h=knobCylinderHeight * 1.1, r=0.5 * knobHoleSize, center=true, $fn=knobResolution);
                                    };
                                    
                                    //Holder for small poles
                                    intersection(){
                                        cylinder(h=knobCylinderHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);
                                        difference(){
                                            cube([knobSize, knobSize, knobCylinderHeight], center=true);
                                            cube([knobHoleSize-knobHolderSize, knobHoleSize-knobHolderSize, knobCylinderHeight*1.1], center=true);
                                        };
                                    };
                                    */
                                    
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
                            //};
                            //End union
                            
                        };
                    }
                }
            }
        }
        //End with knobs
    }
    //End union

}    

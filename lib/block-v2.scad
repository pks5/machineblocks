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
        baseLayers = 1,
        grid = [1, 1],
        baseSideLength = 8,
        adjustSize = [-0.1, -0.1, -0.1, -0.1],
        brickOffset = [0, 0, 0],
        baseHeight = 3.2,
        defaultBaseHeight = 3.2,
        maxBaseHoleDepth = 9,
        withBaseHoles = true,

        withBaseRounding = true,
        baseRoundingRadius = 0.1,
        roundingResolution = 15,

        withPillarGaps = false,
        maxBaseHoleNonGap = 2,
        middleBaseHoleGapLimit = 10,
        
        withXHoles = false,
        withYHoles = false,
        withZHoles = false,
        withPillars = true,
        
        xyHolesOuterSize = 6.5,
        xyHolesInnerSize = 5.1,
        xyHolesInsetSize = 6.2,
        xyHolesInsetDepth = 0.9,
        zHolesOuterSize = 6.5,
        zHolesInnerSize = 5.1,
        zHolesHolderOuterSize = 5.1,
        zHolesHolderInnerSize = 4.9,
        holeResolution = 30,
        middlePinSize = 3.2,
        
        plateHeight = 0.6,
        wallThickness = 1.2,
        brimHeight=1.0,
        brimThickness = 1.6,
        
        withCavity=false,
        cavityDepth = 0,
        cavityWallThickness = 2.6,
        
        wallGapsX = [],
        wallGapsY = [],
        
        withPlateHelper=true,
        plateHelperThickness = 0.4,
        plateHelperHeight = 0.2,
        plateHelperOffset=0.2,
        
        withPillarHelpers = true,
        pillarHelpersOffset=0.2,
        pillarHelpersHeight = 0.4,
        pillarHelpersThickness = 0.8,
        
        withAdhesionHelpers = false,
        adhesionHelpersHeight = 0.2,
        adhesionHelpersThickness = 0.4,
        
        withKnobs = true,
        withKnobsFilled = true,
        knobSize = 5,
        knobHeight = 1.9,
        knobHoleSize = 3.3,
        knobHolderSize = 3,
        knobResolution = 30,
        knobGaps = [],
        cavityKnobWallThickness = 1.2,
        cavityKnobWallTolerance = 0.1,
        
        
        
        withText=false,
        textFont="Helvetica Bold",
        text="Hi",
        textSize=4,
        textDepth=0.6,
        textSide=1,
        textOffsetZ=-0.1,
        textSpacing=1,
        
        center = true,
        alwaysOnFloor = true,
        centerIncludeAdjustment = false){
            
    cutOffset=0.2;
    cutMultiplier=1.1;
    cutTolerance=0.01;
            
    knobRoundingHeight = 0.25 * (knobSize - knobHoleSize);        
    knobCylinderHeight = knobHeight - knobRoundingHeight;

    objectSizeX = baseSideLength * grid[0];
    objectSizeY = baseSideLength * grid[1];
            
    objectSizeXAdjusted = objectSizeX + adjustSize[0] + adjustSize[1];
    objectSizeYAdjusted = objectSizeY + adjustSize[2] + adjustSize[3];
    
    resultingBaseHeight = baseLayers * baseHeight;
    totalHeight = resultingBaseHeight + (withKnobs ? knobHeight : 0);  
    
    defaultBaseHoleDepth = defaultBaseHeight - plateHeight;
    resultingPlateOffset = withCavity ? (cavityDepth > 0 ? cavityDepth : (withBaseHoles ? (resultingBaseHeight - defaultBaseHeight) : (resultingBaseHeight - plateHeight))) : 0;
    
    calculatedBaseHoleDepth = resultingBaseHeight - plateHeight - resultingPlateOffset;        
    resultingPlateHeight = plateHeight + ((maxBaseHoleDepth > 0 && (calculatedBaseHoleDepth > maxBaseHoleDepth)) ? (calculatedBaseHoleDepth - maxBaseHoleDepth) : 0);
    baseHoleDepth = withBaseHoles ? ((maxBaseHoleDepth > 0 && (calculatedBaseHoleDepth > maxBaseHoleDepth)) ? maxBaseHoleDepth : calculatedBaseHoleDepth) : 0;
    
    
    //Grid
    startX = 0;
    midX = floor(0.5 * grid[0] - 1);
    endX = grid[0] - 1;
    
    startY = 0;
    midY = floor(0.5 * grid[1] - 1);
    endY = grid[1] - 1;
            
    mid = [midX, midY];
    
    offsetX = 0.5 * (grid[0] - 1);
    offsetY = 0.5 * (grid[1] - 1);
    
    //Calculate Z Positions
    centerZ = withKnobs ? -0.5 * knobHeight : 0;    
    posZBaseHoles = -0.5 * (totalHeight - baseHoleDepth);        
    posZPlate = posZBaseHoles + 0.5 * (resultingBaseHeight - resultingPlateOffset) ;
    posZKnobs = centerZ + 0.5 * (resultingBaseHeight + knobCylinderHeight); 
    xyHolesZ = -0.5 * totalHeight + 0.5 * (3 * defaultBaseHeight + knobHeight);
    
    roundingApply = withBaseHoles ? (withKnobs ? "all" : "zmin") : (withKnobs ? "zmax" : "z");
    
    //Calculate Brick Offset
    brickOffsetX = brickOffset[0] * baseSideLength + (center ? (centerIncludeAdjustment ? 0.5*(objectSizeXAdjusted - objectSizeX) : 0) : -0.5*objectSizeX + objectSizeXAdjusted);
    brickOffsetY = brickOffset[1] * baseSideLength + (center ? (centerIncludeAdjustment ? 0.5*(objectSizeYAdjusted - objectSizeY) : 0) : -0.5*objectSizeY + objectSizeYAdjusted);
    brickOffsetZ = brickOffset[2] * defaultBaseHeight + (!center || alwaysOnFloor ? 0.5 * totalHeight : 0);
    
    function posX(a) = (a - offsetX) * baseSideLength;
    function posY(b) = (b - offsetY) * baseSideLength;
    
    function isCornerZone(value, i) = (value < maxBaseHoleNonGap) || (value >= grid[i] - (maxBaseHoleNonGap + 1)); 
    function isMiddleZone(value, i) = (grid[i] >= middleBaseHoleGapLimit) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (grid[i] >= middleBaseHoleGapLimit) && (value == mid[i]);
    
    function drawCornerPillar(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddlePillar(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawPillar(a, b) = !withPillarGaps || withZHoles || ((a%2==0) && (b%2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawKnob(a, b, i) = (i >= len(knobGaps)) || (((a < knobGaps[i][0]) || (b < knobGaps[i][1]) || (a > knobGaps[i][2]) || (b > knobGaps[i][3])) && drawKnob(a, b, i+1)); 
    
    function drawWallGapX(a, side, i) = (i < len(wallGapsX)) && ((wallGapsX[i][0] == a && (side == wallGapsX[i][1] || wallGapsX[i][1] == 2)) || drawWallGapX(a, side, i+1)); 
    
    function drawWallGapY(a, side, i) = (i < len(wallGapsY)) && ((wallGapsY[i][0] == a && (side == wallGapsY[i][1] || wallGapsY[i][1] == 2)) || drawWallGapY(a, side, i+1)); 
    
    function pillarHelpersXHeight(a) = pillarHelpersHeight + (!withXHoles && (baseHoleDepth > defaultBaseHoleDepth) && (((grid[0] > 3) && (a%2 == 1)) || (grid[1] == 1)) ? baseHoleDepth - defaultBaseHoleDepth : 0);
    
    function pillarHelpersYHeight(b) = pillarHelpersHeight + (!withYHoles && (baseHoleDepth > defaultBaseHoleDepth) && (((grid[1] > 3) && (b%2 == 1)) || (grid[0] == 1)) ? baseHoleDepth - defaultBaseHoleDepth : 0);
    
    translate([brickOffsetX, brickOffsetY, brickOffsetZ]){
        union(){
            
            //Base
            difference(){
                intersection(){
                    union(){
                        if(withBaseHoles){
                            /*
                            * Adhesion Helpers
                            */
                            if(withAdhesionHelpers){
                                color([0.753, 0.224, 0.169]) //c0392b
                                translate([0, 0, 0.5 * (adhesionHelpersHeight - totalHeight)]){
                                    difference(){
                                        union(){
                                            //Helpers X
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                translate([posX(a + 0.5), 0, 0]){ 
                                                    cube([adhesionHelpersThickness, objectSizeY - 2*wallThickness, adhesionHelpersHeight], center = true);
                                                }
                                            }
                                            
                                            //Helpers Y
                                            for (b = [ startY : 1 : endY - 1 ]){
                                               translate([0, posY(b + 0.5), 0]){
                                                    cube([objectSizeX - 2*wallThickness, adhesionHelpersThickness, adhesionHelpersHeight], center = true);
                                                };
                                            }
                                        }
                                        
                                        if(withPillars){
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                for (b = [ startY : 1 : endY - 1 ]){
                                                   if(drawPillar(a, b)){
                                                        translate([posX(a + 0.5), posY(b + 0.5), 0]){
                                                            cylinder(h=cutMultiplier * (adhesionHelpersHeight), r=0.5 * zHolesOuterSize - cutTolerance, center=true, $fn=holeResolution);
                                                        };
                                                   }
                                                }   
                                            }
                                        }
                                    }
                                }
                            }
                                
                            /*
                            * Plate Helper
                            */
                            if(withPlateHelper){
                                color([0.906, 0.298, 0.235]) //e74c3c
                                union(){
                                    translate([-0.5*(objectSizeX - 2*wallThickness - plateHelperThickness), 0, posZPlate - 0.5 * (resultingPlateHeight + plateHelperHeight)]){
                                        cube([plateHelperThickness, objectSizeY - 2*wallThickness, plateHelperHeight], center = true);
                                    }
                                    translate([0.5*(objectSizeX - 2*wallThickness - plateHelperThickness), 0, posZPlate - 0.5 * (resultingPlateHeight + plateHelperHeight)]){
                                        cube([plateHelperThickness, objectSizeY - 2*wallThickness, plateHelperHeight], center = true);
                                    }    
                                    translate([0, -0.5*(objectSizeY - 2*wallThickness - plateHelperThickness), posZPlate - 0.5 * (resultingPlateHeight + plateHelperHeight + plateHelperOffset)]){
                                        cube([objectSizeX - 2*wallThickness, plateHelperThickness, plateHelperHeight + plateHelperOffset], center = true);
                                    }
                                    translate([0, 0.5*(objectSizeY - 2*wallThickness - plateHelperThickness), posZPlate - 0.5 * (resultingPlateHeight + plateHelperHeight + plateHelperOffset)]){
                                        cube([objectSizeX - 2*wallThickness, plateHelperThickness, plateHelperHeight + plateHelperOffset], center = true);
                                    } 
                                }
                            }
                    
                
                            /*
                            * Pillar Helpers
                            */
                            if(withPillarHelpers){
                                color([0.753, 0.224, 0.169]) //c0392b
                                
                                    difference(){
                                        union(){
                                            //Helpers X
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                translate([posX(a + 0.5), 0, posZPlate - 0.5 * (resultingPlateHeight + pillarHelpersXHeight(a) + pillarHelpersOffset)]){ 
                                                    cube([pillarHelpersThickness, objectSizeY - 2*wallThickness, pillarHelpersXHeight(a)+pillarHelpersOffset], center = true);
                                                }
                                            }
                                            
                                            //Helpers Y
                                            for (b = [ startY : 1 : endY - 1 ]){
                                               translate([0, posY(b + 0.5), posZPlate - 0.5 * (resultingPlateHeight + pillarHelpersYHeight(b))]){
                                                    cube([objectSizeX - 2*wallThickness, pillarHelpersThickness, pillarHelpersYHeight(b)], center = true);
                                                };
                                            }
                                        }
                                        if(withPillars){
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                for (b = [ startY : 1 : endY - 1 ]){
                                                   if(drawPillar(a, b)){
                                                        translate([posX(a + 0.5), posY(b + 0.5), 0]){
                                                            cylinder(h=cutMultiplier * totalHeight, r=0.5 * zHolesOuterSize - cutTolerance, center=true, $fn=holeResolution);
                                                        };
                                                   }
                                                }   
                                            }
                                        }
                                    
                                }
                            }
                            
                            /*
                            * Middle Pins
                            */
                            if(withPillars){
                                //Middle Pin X
                                if(endY == 0){
                                    color([0.953, 0.612, 0.071]) //f39c12
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        translate([posX(a + 0.5), 0, posZBaseHoles]){
                                            cylinder(h=baseHoleDepth, r=0.5 * middlePinSize, center=true, $fn=holeResolution);
                                        };
                                    }
                                }
                                
                                //Middle Pin Y
                                if(endX == 0){
                                    color([0.953, 0.612, 0.071]) //f39c12
                                    for (b = [ startY : 1 : endY - 1 ]){
                                        translate([0, posY(b + 0.5), posZBaseHoles]){
                                            cylinder(h=baseHoleDepth, r=0.5 * middlePinSize, center=true, $fn=holeResolution);
                                        };
                                    }
                                }
                            }
                        
                            //X-Holes Outer
                            if(withXHoles){
                                color([0.953, 0.612, 0.071]) //f39c12
                                for (a = [ startX : 1 : endX - 1 ]){
                                    translate([posX(a + 0.5), 0, xyHolesZ]){
                                        rotate([90, 0, 0]){ 
                                            cylinder(h=objectSizeY, r=0.5 * xyHolesOuterSize, center=true, $fn=holeResolution);
                                        }
                                    };
                                }
                            }
                            
                            //Y-Holes Outer
                            if(withYHoles){
                                color([0.953, 0.612, 0.071]) //f39c12
                                for (b = [ startY : 1 : endY - 1 ]){
                                    translate([0, posY(b + 0.5), xyHolesZ]){
                                        rotate([0, 90, 0]){ 
                                            cylinder(h=objectSizeX, r=0.5 * xyHolesOuterSize, center=true, $fn=holeResolution);
                                        };
                                    };
                                }
                            }
                            
                            /*
                            * Pillars / Z-Holes Outer
                            */
                            color([0.953, 0.612, 0.071]) //f39c12
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
                            
                            /*
                            * Base
                            */
                            translate([0, 0, centerZ]){ 
                                difference() {
                                    /*
                                    * Base Block
                                    */
                                    translate([0.5*(adjustSize[1] - adjustSize[0]), 0.5*(adjustSize[3] - adjustSize[2]), 0]){
                                        color([0.945, 0.769, 0.059]) //f1c40f
                                        cube([objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], center = true);
                                    }
                                    
                                    /*
                                    * Cavity
                                    */
                                    if(withCavity){
                                        color([0.827, 0.329, 0]) //d35400
                                        translate([0, 0, 0.5*(resultingBaseHeight - resultingPlateOffset) + 0.5 * cutOffset])
                                            cube([objectSizeX - 2*cavityWallThickness, objectSizeY - 2*cavityWallThickness, resultingPlateOffset + cutOffset], center = true);
                                    }
                                    
                                    /*
                                    * Bottom Hole
                                    */
                                    color([0.953, 0.612, 0.071]) //f39c12
                                    translate([0, 0, 0.5*(brimHeight - (withCavity ? resultingPlateOffset : 0) - resultingPlateHeight) ])
                                        cube([objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness, resultingBaseHeight - (withCavity ? resultingPlateOffset : 0) - resultingPlateHeight - brimHeight], center = true);    
                                
                                    /*
                                    * Wall Gaps X
                                    */
                                    color([0.608, 0.349, 0.714]) //9b59b6
                                    for (a = [ startX : 1 : endX ]){
                                        for (side = [ 0 : 1 : 1 ]){
                                            if(drawWallGapX(a, side, 0)){
                                                translate([posX(a), 0.5*(adjustSize[3] - adjustSize[2]) + (side - 0.5)*objectSizeYAdjusted, posZBaseHoles - centerZ]){
                                                     difference(){
                                                        translate([0, 0, -0.5 * cutOffset])
                                                            cube([baseSideLength-2*wallThickness+cutTolerance, 2*(brimThickness + adjustSize[2 + side]+cutTolerance), baseHoleDepth + cutOffset], center=true); 
                                                         
                                                            translate([-0.5*(baseSideLength-2*wallThickness), 0, -0.5*(baseHoleDepth - brimHeight) - 0.5 * cutOffset]) 
                                                                cube([2*(brimThickness-wallThickness), 2*(brimThickness+adjustSize[2 + side])*cutMultiplier, brimHeight+cutOffset+cutTolerance], center=true);
                                                        
                                                        
                                                            translate([0.5*(baseSideLength-2*wallThickness), 0, -0.5*(baseHoleDepth - brimHeight) - 0.5 * cutOffset]) 
                                                                cube([2*(brimThickness-wallThickness), 2*(brimThickness+adjustSize[2 + side])*cutMultiplier, brimHeight+cutOffset+cutTolerance], center=true);
                                                     }  
                                                }
                                            }
                                        }
                                    }
                                    
                                    /*
                                    * Wall Gaps Y
                                    */
                                    color([0.608, 0.349, 0.714]) //9b59b6
                                    for (b = [ startY : 1 : endY ]){
                                        for (side = [ 0 : 1 : 1 ]){
                                            if(drawWallGapY(b, side, 0)){
                                                translate([0.5*(adjustSize[1] - adjustSize[0]) + (side-0.5)*objectSizeXAdjusted, posY(b), posZBaseHoles - centerZ]){
                                                    difference(){
                                                        translate([0, 0, -0.5 * cutOffset])
                                                            cube([2*(brimThickness+ adjustSize[side]+cutTolerance), baseSideLength-2*wallThickness+cutTolerance, baseHoleDepth + cutOffset], center=true);   
                                                        
                                                            translate([0, -0.5*(baseSideLength-2*wallThickness), -0.5*(baseHoleDepth - brimHeight) - 0.5 * cutOffset]) 
                                                                cube([2*(brimThickness+adjustSize[side])*cutMultiplier, 2*(brimThickness-wallThickness), brimHeight + cutOffset+cutTolerance], center=true);
                                                        
                                                            translate([0, 0.5*(baseSideLength-2*wallThickness), -0.5*(baseHoleDepth - brimHeight) - 0.5 * cutOffset]) 
                                                                cube([2*(brimThickness+adjustSize[side])*cutMultiplier, 2*(brimThickness-wallThickness), brimHeight + cutOffset+cutTolerance], center=true);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    /*
                                    * Brim
                                    */
                                    color([0.902, 0.494, 0.133]) //e67e22
                                    translate([0, 0, 0.5*(brimHeight - resultingBaseHeight)])
                                        cube([objectSizeX - 2*brimThickness, objectSizeY - 2*brimThickness, brimHeight*cutMultiplier], center = true);
                                }
                                
                                
                            }
                        }
                        else{
                            /*
                            * Solid Base Block
                            */
                            translate([0.5*(adjustSize[1] - adjustSize[0]), 0.5*(adjustSize[3] - adjustSize[2]), centerZ]){ 
                                difference(){
                                    color([0.945, 0.769, 0.059]) //f1c40f
                                    cube([objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], center = true);
                                    
                                    /*
                                    * Cavity
                                    */
                                    if(withCavity){
                                        color([0.827, 0.329, 0]) //d35400
                                        translate([0, 0, 0.5*(resultingBaseHeight - resultingPlateOffset) + 0.5 * cutOffset])
                                            cube([objectSizeX - 2*cavityWallThickness, objectSizeY - 2*cavityWallThickness, resultingPlateOffset + cutOffset], center = true);
                                    }
                                }
                            }
                        }
                        //End withBaseHoles
                        
                        
                        

                    };
                    //End union
    
                    /*
                    * Cut Rounded Hull
                    */
                    if(withBaseRounding){
                        //Hull with rounding
                        color([0.945, 0.769, 0.059]) //f1c40f
                        translate([0.5*(adjustSize[1] - adjustSize[0]), 0.5*(adjustSize[3] - adjustSize[2]), centerZ]){
                            if(withBaseHoles && withKnobs){
                                roundedcube_simple(size = [objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], 
                                            center = true, 
                                            radius=baseRoundingRadius, 
                                            resolution=roundingResolution);    
                            }
                            else{
                                roundedcube(size = [objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], 
                                            center = true, 
                                            radius=baseRoundingRadius, 
                                            apply_to=roundingApply,
                                            resolution=roundingResolution);
                            }
                        };
                    }
                }
                //End intersection
                
                //Cut X-Holes
                if(withXHoles){
                    color([0.945, 0.769, 0.059]) //f1c40f
                    for (a = [ startX : 1 : endX - 1 ]){
                        translate([posX(a + 0.5), 0, xyHolesZ]){
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
                
                //Cut Y-Holes
                if(withYHoles){
                    color([0.945, 0.769, 0.059]) //f1c40f
                    for (b = [ startY : 1 : endY - 1 ]){
                        translate([0, posY(b + 0.5), xyHolesZ]){
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
                
                //Cut Z-Holes
                if(withZHoles){
                    color([0.945, 0.769, 0.059]) //f1c40f
                    for (a = [ startX : 1 : endX - 1 ]){
                        for (b = [ startY : 1 : endY - 1 ]){
                            translate([posX(a + 0.5), posY(b+0.5), centerZ]){
                                cylinder(h=resultingBaseHeight*cutMultiplier, r=0.5 * zHolesInnerSize, center=true, $fn=holeResolution);
                            };
                        }
                    }
                }
                
                /*
                * Text
                */
                if(withText){
                    color([0.173, 0.243, 0.314]) //2c3e50
                    if(textSide>2){
                        translate([(textSide%2 == 1 ? 1 : -1) * (-0.5 * objectSizeX) - textDepth, 0, centerZ + textOffsetZ])
                        rotate([90,0,90])
                            linear_extrude(2*textDepth) {
                                text(text, size = textSize, font = textFont, spacing = textSpacing, halign = "center", valign = "center", $fn = 64);
                            }
                    }
                    else{
                        translate([0, (textSide%2 == 1 ? 1 : -1) * (-0.5 * objectSizeY) + textDepth, centerZ + textOffsetZ])
                            rotate([90,0,0])
                                linear_extrude(2*textDepth) {
                                    text(text, size = textSize, font = textFont, spacing = textSpacing, halign = "center", valign = "center", $fn = 64);
                                }
                    }
                }
            };
            //End difference
            
            
            //With knobs
            if(withKnobs){
                color([0.945, 0.769, 0.059]) //f1c40f
                if(!withCavity){
                    /*
                    * Normal knobs
                    */
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
                    /*
                    * Draw Big Knob if plateOffset is greater than zero
                    */
                    knobRectX = posX(endX) - posX(startX) + knobSize - 2*cavityKnobWallTolerance;
                    knobRectY = posY(endY) - posY(startY) + knobSize - 2*cavityKnobWallTolerance;
                    translate([0, 0, posZKnobs + 0.5*knobRoundingHeight]){ 
                        difference(){
                            roundedcube(size=[knobRectX, knobRectY, knobHeight], 
                                            center = true, 
                                            radius=0.5, 
                                            apply_to="z",
                                            resolution=roundingResolution);
                            cube([knobRectX - 2*cavityKnobWallThickness, knobRectY - 2*cavityKnobWallThickness, knobHeight*cutMultiplier], center=true);
                        }
                    }
                }
            } //End withKnobs
            
        } //End union
        
    } //End translate brick offset

} // End module block    

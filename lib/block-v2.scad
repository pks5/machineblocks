/**
* MachineBlocks Block module to create STL models of LEGO compatible bricks and enclosures optimized for 3D printing
* https://machineblocks.com 
*
* Copyright (c) 2022 Jan P. Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

include <roundedcube.scad>;
include <base.scad>;
include <torus.scad>;
include <text3d.scad>;

module block(
        baseLayers = 1,
        grid = [1, 1],
        baseSideLength = 8.0,
        sideAdjustment = -0.1,
        brickOffset = [0, 0, 0],
        baseHeight = 3.2,
        defaultBaseHeight = 3.2,
        heightAdjustment=0.0,
        maxBaseHoleDepth = 9.0,
        withBaseHoles = true,

        baseRounding="all",
        baseRoundingRadius = 0.1,
        roundingResolution = 15,

        withPillarGaps = false,
        maxPillarNonGap = 2,
        middlePillarGapLimit = 10,
        
        withXHoles = false,
        withYHoles = false,
        withZHoles = false,
        withPillars = true,
        
        xyHoleOuterSize = 6.5,
        xyHoleInnerSize = 5.1,
        xyHoleInsetSize = 6.2,
        xyHoleInsetDepth = 0.9,
        zHoleOuterSize = 6.5,
        zHoleInnerSize = 5.1,
        pillarHolderOuterSize = 5.1,
        pillarHolderInnerSize = 4.9,
        holeResolution = 30,
        middlePinSize = 3.2,
        
        plateHeight = 0.6,
        wallThickness = 1.2,
        clampSkirtHeight=1,
        clampSkirtThickness = 0.4,
        
        withCavity=false,
        cavityDepth = 0,
        cavityWallThickness = 2.6,
        
        wallGapsX = [],
        wallGapsY = [],
        
        withPlateHelpers=true,
        plateHelperOffset=0.2,
        plateHelperHeight = 0.2,
        plateHelperThickness = 0.4,
        
        withPillarHelpers = true,
        pillarHelperOffset=0.2,
        pillarHelperHeight = 0.4,
        pillarHelperThickness = 0.8,
        
        withAdhesionHelpers = false,
        adhesionHelperHeight = 0.2,
        adhesionHelperThickness = 0.4,
        
        withKnobs = true,
        withKnobsFilled = true,
        withKnobsCentered = false,
        knobSize = 4.9,
        knobHeight = 1.8,
        knobHoleSize = 3.3,
        knobHolderSize = 3,
        knobResolution = 30,
        knobGaps = [],
        cavityTongueThickness = 1.2,
        cavityTongueSpacing = 0.1,
        
        
        
        withText=false,
        textFont="Helvetica Bold",
        text="Hi",
        textSize=4,
        textDepth=-0.6,
        textSide=0,
        textOffsetZ=-0.1,
        textSpacing=1,
        
        center = true,
        alwaysOnFloor = true,
        alignWithAdjustment = false){
            
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;
       
    sAdjustment = sideAdjustment[0] == undef ? [sideAdjustment, sideAdjustment, sideAdjustment, sideAdjustment] : (len(sideAdjustment) == 2 ? [sideAdjustment[0], sideAdjustment[0], sideAdjustment[1], sideAdjustment[1]] : sideAdjustment);
         
    knobRoundingHeight = 0.25 * (knobSize - knobHoleSize);        
    knobCylinderHeight = knobHeight - knobRoundingHeight;

    objectSizeX = baseSideLength * grid[0];
    objectSizeY = baseSideLength * grid[1];
            
    objectSizeXAdjusted = objectSizeX + sAdjustment[0] + sAdjustment[1];
    objectSizeYAdjusted = objectSizeY + sAdjustment[2] + sAdjustment[3];
    
    resultingBaseHeight = baseLayers * baseHeight + heightAdjustment;
    totalHeight = resultingBaseHeight + (withKnobs ? knobHeight : 0);  
    
    defaultBaseHoleDepth = defaultBaseHeight + plateHeight;
    resultingPlateOffset = withCavity ? (cavityDepth > 0 ? cavityDepth : (withBaseHoles ? (resultingBaseHeight - defaultBaseHeight) : (resultingBaseHeight - plateHeight))) : 0;
    
    calculatedBaseHoleDepth = resultingBaseHeight - plateHeight - resultingPlateOffset;        
    resultingPlateHeight = plateHeight + ((maxBaseHoleDepth > 0 && (calculatedBaseHoleDepth > maxBaseHoleDepth)) ? (calculatedBaseHoleDepth - maxBaseHoleDepth) : 0);
    baseHoleDepth = withBaseHoles ? ((maxBaseHoleDepth > 0 && (calculatedBaseHoleDepth > maxBaseHoleDepth)) ? maxBaseHoleDepth : calculatedBaseHoleDepth) : 0;
    
    wallThicknessClampSkirt = wallThickness + clampSkirtThickness;
    
    echo(baseHeight = resultingBaseHeight, cavityDepth = resultingPlateOffset, plateHeight = resultingPlateHeight, baseHoleDepth = baseHoleDepth);
    
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
    posZPlate = posZBaseHoles + 0.5 * (resultingBaseHeight - resultingPlateOffset);
    posZKnobs = centerZ + 0.5 * (resultingBaseHeight + knobCylinderHeight); 
    xyHolesZ = -0.5 * totalHeight + 0.5 * (3 * defaultBaseHeight + knobHeight); //TODO absolute value for xy-holes z-position?
    
    echo(centerZ = centerZ, posZBaseHoles = posZBaseHoles, posZPlate = posZPlate, posZKnobs = posZKnobs, xyHolesZ = xyHolesZ);
    
    //Calculate Brick Offset
    brickOffsetX = brickOffset[0] * baseSideLength + (center ? (alignWithAdjustment ? 0.5*(objectSizeXAdjusted - objectSizeX) : 0) : (alignWithAdjustment ?  0.5*objectSizeXAdjusted : 0.5*objectSizeX));
    brickOffsetY = brickOffset[1] * baseSideLength + (center ? (alignWithAdjustment ? 0.5*(objectSizeYAdjusted - objectSizeY) : 0) : (alignWithAdjustment ?  0.5*objectSizeYAdjusted : 0.5*objectSizeY));
    brickOffsetZ = brickOffset[2] * defaultBaseHeight + (!center || alwaysOnFloor ? 0.5 * totalHeight : 0);
    
    function posX(a) = (a - offsetX) * baseSideLength;
    function posY(b) = (b - offsetY) * baseSideLength;
    
    function isCornerZone(value, i) = (value < maxPillarNonGap) || (value >= grid[i] - (maxPillarNonGap + 1)); 
    function isMiddleZone(value, i) = (grid[i] >= middlePillarGapLimit) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (grid[i] >= middlePillarGapLimit) && (value == mid[i]);
    
    function drawCornerPillar(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddlePillar(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawPillar(a, b) = !withPillarGaps || withZHoles || ((a%2==0) && (b%2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawKnob(a, b, i) = (i >= len(knobGaps)) || (((a < knobGaps[i][0]) || (b < knobGaps[i][1]) || (a > knobGaps[i][2]) || (b > knobGaps[i][3])) && drawKnob(a, b, i+1)); 
    
    function drawWallGapX(a, side, i) = (i < len(wallGapsX)) ? ((wallGapsX[i][0] == a && (side == wallGapsX[i][1] || wallGapsX[i][1] == 2)) ? (wallGapsX[i][2] == undef ? 1 : wallGapsX[i][2]) : drawWallGapX(a, side, i+1)) : 0; 
    
    function drawWallGapY(a, side, i) = (i < len(wallGapsY)) ? ((wallGapsY[i][0] == a && (side == wallGapsY[i][1] || wallGapsY[i][1] == 2)) ? (wallGapsY[i][2] == undef ? 1 : wallGapsY[i][2]) : drawWallGapY(a, side, i+1)) : 0; 
    
    function pillarHelpersXHeight(a) = pillarHelperHeight + (!withXHoles && (baseHoleDepth > defaultBaseHoleDepth) && (((grid[0] > 3) && (a%2 == 1)) || (grid[1] == 1)) ? baseHoleDepth - defaultBaseHoleDepth : 0);
    
    function pillarHelpersYHeight(b) = pillarHelperHeight + (!withYHoles && (baseHoleDepth > defaultBaseHoleDepth) && (((grid[1] > 3) && (b%2 == 1)) || (grid[0] == 1)) ? baseHoleDepth - defaultBaseHoleDepth : 0);
    
    function sideX(side) = 0.5 * (sAdjustment[1] - sAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sAdjustment[3] - sAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;
    function sideZ(side) = centerZ + (side - 0.5) * resultingBaseHeight;
    
    textX = textSide < 2 ? ((textDepth > 0 ? (textSide - 0.5) * textDepth : 0) + sideX(textSide)) : 0;
    textY = (textSide > 1 && textSide < 4) ? ((textDepth > 0 ? (textSide - 2 - 0.5) * textDepth : 0) + sideY(textSide - 2)) : (textSide > 3 && textSide < 6 ? textOffsetZ : 0);
    textZ = (textSide > 3 && textSide < 6) ? ((textDepth > 0 ? (textSide - 4 - 0.5) * textDepth : 0) + sideZ(textSide - 4)) : textOffsetZ;
    textRotations = [[90, 0, -90], [90, 0, 90], [90, 0, 0], [90, 0, 180], [0, 180, 180], [0, 0, 0]];
    
    translate([brickOffsetX, brickOffsetY, brickOffsetZ]){
        
        union(){
            //Base
            difference(){
                
                if(withBaseHoles){
                    union(){
                        /*
                        * Adhesion Helpers
                        */
                        if(withAdhesionHelpers){
                            color([0.753, 0.224, 0.169]) //c0392b
                            translate([0, 0, 0.5 * (adhesionHelperHeight - totalHeight)]){
                                difference(){
                                    union(){
                                        //Helpers X
                                        for (a = [ startX : 1 : endX - 1 ]){
                                            translate([posX(a + 0.5), 0, 0]){ 
                                                cube([adhesionHelperThickness, objectSizeY - 2*wallThickness, adhesionHelperHeight], center = true);
                                            }
                                        }
                                        
                                        //Helpers Y
                                        for (b = [ startY : 1 : endY - 1 ]){
                                           translate([0, posY(b + 0.5), 0]){
                                                cube([objectSizeX - 2*wallThickness, adhesionHelperThickness, adhesionHelperHeight], center = true);
                                            };
                                        }
                                    }
                                    
                                    if(withPillars){
                                        for (a = [ startX : 1 : endX - 1 ]){
                                            for (b = [ startY : 1 : endY - 1 ]){
                                               if(drawPillar(a, b)){
                                                    translate([posX(a + 0.5), posY(b + 0.5), 0]){
                                                        cylinder(h=cutMultiplier * (adhesionHelperHeight), r=0.5 * zHoleOuterSize - cutTolerance, center=true, $fn=holeResolution);
                                                    };
                                               }
                                            }   
                                        }
                                    }
                                }
                            }
                        }
                            
                        /*
                        * Plate Helpers
                        */
                        if(withPlateHelpers){
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
                                        translate([posX(a + 0.5), 0, posZPlate - 0.5 * (resultingPlateHeight + pillarHelpersXHeight(a) + pillarHelperOffset)]){ 
                                            cube([pillarHelperThickness, objectSizeY - 2*wallThickness, pillarHelpersXHeight(a)+pillarHelperOffset], center = true);
                                        }
                                    }
                                    
                                    //Helpers Y
                                    for (b = [ startY : 1 : endY - 1 ]){
                                       translate([0, posY(b + 0.5), posZPlate - 0.5 * (resultingPlateHeight + pillarHelpersYHeight(b))]){
                                            cube([objectSizeX - 2*wallThickness, pillarHelperThickness, pillarHelpersYHeight(b)], center = true);
                                        };
                                    }
                                }
                                if(withPillars){
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        for (b = [ startY : 1 : endY - 1 ]){
                                           if(drawPillar(a, b)){
                                                translate([posX(a + 0.5), posY(b + 0.5), 0]){
                                                    cylinder(h=cutMultiplier * totalHeight, r=0.5 * zHoleOuterSize - cutTolerance, center=true, $fn=holeResolution);
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
                                        cylinder(h=objectSizeY, r=0.5 * xyHoleOuterSize, center=true, $fn=holeResolution);
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
                                        cylinder(h=objectSizeX, r=0.5 * xyHoleOuterSize, center=true, $fn=holeResolution);
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
                                        cylinder(h=baseHoleDepth, r=0.5 * zHoleOuterSize, center=true, $fn=holeResolution);
                                    };
                                }   
                            }
                        }
                        else if(withPillars){
                            //Pillars with holes
                            for (a = [ startX : 1 : endX - 1 ]){
                                for (b = [ startY : 1 : endY - 1 ]){
                                    if(drawPillar(a, b)){
                                        translate([posX(a + 0.5), posY(b + 0.5), posZBaseHoles]){
                                            difference(){
                                                cylinder(h=baseHoleDepth, r=0.5 * zHoleOuterSize, center=true, $fn=holeResolution);
                                                
                                                intersection(){
                                                    cylinder(h=baseHoleDepth*cutMultiplier, r=0.5 * pillarHolderOuterSize, center=true, $fn=holeResolution);
                                                    cube([pillarHolderInnerSize, pillarHolderInnerSize, baseHoleDepth*cutMultiplier], center=true);
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
                                translate([0.5*(sAdjustment[1] - sAdjustment[0]), 0.5*(sAdjustment[3] - sAdjustment[2]), 0]){
                                    color([0.945, 0.769, 0.059]) //f1c40f
                                    //cube([objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], center = true);
                                    
                                    base(size=[objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], baseRounding=baseRounding, roundingRadius=baseRoundingRadius, roundingResolution=roundingResolution, center = true);
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
                                translate([0, 0, 0.5*(clampSkirtHeight - (withCavity ? resultingPlateOffset : 0) - resultingPlateHeight) ])
                                    cube([objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness, resultingBaseHeight - (withCavity ? resultingPlateOffset : 0) - resultingPlateHeight - clampSkirtHeight], center = true);    
                            
                                /*
                                * Wall Gaps X
                                */
                                color([0.608, 0.349, 0.714]) //9b59b6
                                for (a = [ startX : 1 : endX ]){
                                    for (side = [ 0 : 1 : 1 ]){
                                        gapLength = drawWallGapX(a, side, 0);
                                        if(gapLength > 0){
                                            translate([posX(a + 0.5*(gapLength-1)), sideY(side), posZBaseHoles - centerZ]){
                                                 difference(){
                                                    translate([0, 0, -0.5 * cutOffset])
                                                        cube([gapLength*baseSideLength - 2*wallThickness + cutTolerance, 2 * (wallThicknessClampSkirt + sAdjustment[2 + side] + cutTolerance), baseHoleDepth + cutOffset], center=true); 
                                                     
                                                        translate([-0.5 * (gapLength*baseSideLength - 2*wallThickness), 0, -0.5 * (baseHoleDepth - clampSkirtHeight) - 0.5 * cutOffset]) 
                                                            cube([2*clampSkirtThickness, 2*(wallThicknessClampSkirt + sAdjustment[2 + side]) * cutMultiplier, clampSkirtHeight + cutOffset + cutTolerance], center=true);
                                                    
                                                    
                                                        translate([0.5 * (gapLength*baseSideLength - 2*wallThickness), 0, -0.5 * (baseHoleDepth - clampSkirtHeight) - 0.5 * cutOffset]) 
                                                            cube([2*clampSkirtThickness, 2*(wallThicknessClampSkirt + sAdjustment[2 + side]) * cutMultiplier, clampSkirtHeight + cutOffset + cutTolerance], center=true);
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
                                        gapLength = drawWallGapY(b, side, 0);
                                        if(gapLength > 0){
                                            translate([sideX(side), posY(b + 0.5*(gapLength-1)), posZBaseHoles - centerZ]){
                                                difference(){
                                                    translate([0, 0, -0.5 * cutOffset])
                                                        cube([2 * (wallThicknessClampSkirt + sAdjustment[side] + cutTolerance), gapLength*baseSideLength - 2 * wallThickness + cutTolerance, baseHoleDepth + cutOffset], center=true);   
                                                    
                                                        translate([0, -0.5 * (gapLength*baseSideLength - 2 * wallThickness), -0.5 * (baseHoleDepth - clampSkirtHeight) - 0.5 * cutOffset]) 
                                                            cube([2*(wallThicknessClampSkirt + sAdjustment[side]) * cutMultiplier, 2 * clampSkirtThickness, clampSkirtHeight + cutOffset + cutTolerance], center=true);
                                                    
                                                        translate([0, 0.5 * (gapLength*baseSideLength - 2 * wallThickness), -0.5 * (baseHoleDepth - clampSkirtHeight) - 0.5 * cutOffset]) 
                                                            cube([2 * (wallThicknessClampSkirt + sAdjustment[side]) * cutMultiplier, 2 * clampSkirtThickness, clampSkirtHeight + cutOffset + cutTolerance], center=true);
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                /*
                                * Clamp Skirt
                                */
                                color([0.902, 0.494, 0.133]) //e67e22
                                translate([0, 0, 0.5*(clampSkirtHeight - resultingBaseHeight)])
                                    cube([objectSizeX - 2 * wallThicknessClampSkirt, objectSizeY - 2 * wallThicknessClampSkirt, clampSkirtHeight * cutMultiplier], center = true);
                            }
                        }
                    } //End union
                }
                else{
                    /*
                    * Solid Base Block
                    */
                    translate([0.5*(sAdjustment[1] - sAdjustment[0]), 0.5*(sAdjustment[3] - sAdjustment[2]), centerZ]){ 
                        difference(){
                            color([0.945, 0.769, 0.059]) //f1c40f
                            //cube([objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], center = true);
                            base(size=[objectSizeXAdjusted, objectSizeYAdjusted, resultingBaseHeight], baseRounding=baseRounding, roundingRadius=baseRoundingRadius, roundingResolution=roundingResolution, center = true);
                            
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
               
                
                //Cut X-Holes
                if(withXHoles){
                    color([0.945, 0.769, 0.059]) //f1c40f
                    for (a = [ startX : 1 : endX - 1 ]){
                        translate([posX(a + 0.5), 0, xyHolesZ]){
                            rotate([90, 0, 0]){ 
                                cylinder(h=objectSizeY*cutMultiplier, r=0.5 * xyHoleInnerSize, center=true, $fn=holeResolution);
                                
                                translate([0, 0, 0.5 * objectSizeY])
                                    cylinder(h=2*xyHoleInsetDepth, r=0.5 * xyHoleInsetSize, center=true, $fn=holeResolution);
                                translate([0, 0, -0.5 * objectSizeY])
                                    cylinder(h=2*xyHoleInsetDepth, r=0.5 * xyHoleInsetSize, center=true, $fn=holeResolution);
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
                                cylinder(h=objectSizeX*cutMultiplier, r=0.5 * xyHoleInnerSize, center=true, $fn=holeResolution);
                                
                                translate([0, 0, 0.5 * objectSizeX])
                                    cylinder(h=2*xyHoleInsetDepth, r=0.5 * xyHoleInsetSize, center=true, $fn=holeResolution);
                                translate([0, 0, -0.5 * objectSizeX])
                                    cylinder(h=2*xyHoleInsetDepth, r=0.5 * xyHoleInsetSize, center=true, $fn=holeResolution);
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
                                cylinder(h=resultingBaseHeight*cutMultiplier, r=0.5 * zHoleInnerSize, center=true, $fn=holeResolution);
                            };
                        }
                    }
                }
           
                /*
                * Text Cut
                */
                if(withText && textDepth < 0){
                    color([0.173, 0.243, 0.314]) //2c3e50
                        translate([textX, textY, textZ])
                            rotate(textRotations[textSide])
                                text3d(
                                    text = text,
                                    textDepth = 2*abs(textDepth),
                                    textSize = textSize,
                                    textFont = textFont,
                                    textSpacing = textSpacing,
                                    center = true
                                );
                }
            } //End difference
            
            /*
            * Text
            */
            if(withText && textDepth > 0){
                color([0.173, 0.243, 0.314]) //2c3e50
                    translate([textX, textY, textZ])
                        rotate(textRotations[textSide])
                            text3d(
                                text = text,
                                textDepth = textDepth,
                                textSize = textSize,
                                textFont = textFont,
                                textSpacing = textSpacing,
                                center = true
                            );
            }
            
            //With knobs
            if(withKnobs){
                color([0.945, 0.769, 0.059]) //f1c40f
                if(!withCavity){
                    /*
                    * Normal knobs
                    */
                    knobEndX = endX - (withKnobsCentered ? 1 : 0);
                    knobEndY = endY - (withKnobsCentered ? 1 : 0);
                    posOffset = withKnobsCentered ? 0.5 : 0;
                    
                    for (a = [ startX : 1 : knobEndX ]){
                        for (b = [ startY : 1 : knobEndY ]){
                            if(drawKnob(a,b, 0)){
                                translate([posX(a + posOffset), posY(b + posOffset), posZKnobs]){ 
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
                    knobRectX = posX(endX) - posX(startX) + knobSize - 2*cavityTongueSpacing;
                    knobRectY = posY(endY) - posY(startY) + knobSize - 2*cavityTongueSpacing;
                    translate([0, 0, posZKnobs + 0.5*knobRoundingHeight]){ 
                        difference(){
                            roundedcube(size=[knobRectX, knobRectY, knobHeight], 
                                            center = true, 
                                            radius=0.5, 
                                            apply_to="z",
                                            resolution=roundingResolution);
                            cube([knobRectX - 2*cavityTongueThickness, knobRectY - 2*cavityTongueThickness, knobHeight*cutMultiplier], center=true);
                        }
                    }
                }
            } //End withKnobs
            
        } //End union
        
    } //End translate brick offset

} // End module block    

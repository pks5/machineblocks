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

use <roundedcube.scad>;
use <base.scad>;
use <torus.scad>;
use <text3d.scad>;
use <svg3d.scad>;

module block(
        //Grid
        grid = [1, 1],

        //Base
        baseSideLength = 8.0,
        baseHeight = 3.2,
        baseHeightOriginal = 3.2,
        baseLayers = 1,
        baseCutoutType = "CLASSIC",
        baseCutoutMinDepth = 2.2,
        baseCutoutMaxDepth = 9.0,
        baseClampHeight = 0.8,
        baseClampThickness = 0.5,
        baseRounding = "all",
        baseRoundingRadius = 0.1,
        baseRoundingResolution = 15,

        //Base Adjustment
        sideAdjustment = -0.1,
        heightAdjustment = 0.0,

        //Walls
        wallThickness = 1.2,
        wallGapsX = [],
        wallGapsY = [],
        
        //Top Plate
        topPlateHeight = 0.6,
        withTopPlateHelpers = true,
        topPlateHelperOffset = 0.2,
        topPlateHelperHeight = 0.2,
        topPlateHelperThickness = 0.4,

        //Stabilizers
        withStabilizerGrid = true,
        stabilizerGridOffset = 0.2,
        stabilizerGridHeight = 0.4,
        stabilizerGridThickness = 0.8,
        stabilizerExpansion = 2,
        
        //Pillars: Tubes and Pins
        withPillars = true,
        withPillarGaps = false, //TODDO rename to withTubeGaps?
        maxPillarNonGap = 2, //TODO find better name
        middlePillarGapLimit = 10, //TODO find better name
        
        //Pins (little tubes for blocks with 1 brick side length)
        pinSize = 3.2,
        pinClampThickness = 0.1,

        //Tubes
        tubeXYSize = 6.5,
        tubeZSize = 6.5,
        tubeHoleClampThickness = 0.1,
        tubeClampThickness = 0.1,

        //Holes
        withHolesX = false,
        withHolesY = false,
        holeXYSize = 5.1,
        holeXYInsetSize = 6.2,
        holeXYInsetDepth = 0.9,
        withHolesZ = false,
        holeZSize = 5.1,
        holeResolution = 30,
        
        //Knobs
        withKnobs = true, //TODO integrate into knobType (AUTO, CLASSIC, TECHNIC, TONGUE, NONE)
        knobType = "AUTO",
        knobCentered = false,
        knobSize = 5.0,
        knobHeight = 1.8,
        knobClampHeight = 0.8,
        knobClampThickness = 0.1,
        knobHoleSize = 3.5,
        knobRounding = 0.1,
        knobHoleClampThickness = 0.1,
        knobResolution = 30,
        knobGaps = [],
        knobTongueThickness = 1.2,
        knobTongueAdjustment = -0.1,

        //Pit
        withPit=false,
        pitDepth = 0,
        pitWallThickness = 2.6,
        pitWallGaps = [],
        
        //Text
        withText = false,
        textFont = "Liberation Sans",
        text = "SCAD",
        textSize = 4,
        textDepth = -0.6,
        textSide = 0,
        textOffset = [0, 0],
        textSpacing = 1,

        //SVG
        withSvg = false,
        svgFile = "",
        svgDimensions = [100, 100],
        svgDepth = 0.4,
        svgScale = 1,
        svgSide = 5,
        svgOffset = [0, 0],

        //Alignment
        brickOffset = [0, 0, 0],
        center = true,
        alwaysOnFloor = true,
        alignWithAdjustment = false,
        
        //Adhesion Helpers
        withAdhesionHelpers = false,
        adhesionHelperHeight = 0.2,
        adhesionHelperThickness = 0.4){
            
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;
       
    //Side Adjustment
    sAdjustment = sideAdjustment[0] == undef ? [sideAdjustment, sideAdjustment, sideAdjustment, sideAdjustment] : (len(sideAdjustment) == 2 ? [sideAdjustment[0], sideAdjustment[0], sideAdjustment[1], sideAdjustment[1]] : sideAdjustment);

    //Object Size     
    objectSizeX = baseSideLength * grid[0];
    objectSizeY = baseSideLength * grid[1];

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSizeX + sAdjustment[0] + sAdjustment[1];
    objectSizeYAdjusted = objectSizeY + sAdjustment[2] + sAdjustment[3];
    
    //Base Height
    resultingBaseHeight = baseLayers * baseHeight + heightAdjustment;
    totalHeight = resultingBaseHeight + (withKnobs ? knobHeight : 0); 

    //Calculate Brick Offset
    brickOffsetX = brickOffset[0] * baseSideLength + (center ? (alignWithAdjustment ? 0.5*(objectSizeXAdjusted - objectSizeX) : 0) : (alignWithAdjustment ?  0.5*objectSizeXAdjusted : 0.5*objectSizeX));
    brickOffsetY = brickOffset[1] * baseSideLength + (center ? (alignWithAdjustment ? 0.5*(objectSizeYAdjusted - objectSizeY) : 0) : (alignWithAdjustment ?  0.5*objectSizeYAdjusted : 0.5*objectSizeY));
    brickOffsetZ = brickOffset[2] * baseHeightOriginal + (!center || alwaysOnFloor ? 0.5 * totalHeight : 0); 
    
    //Base Cutout and Pit Depth
    originalBaseCutoutDepth = baseHeightOriginal + topPlateHeight;
    resultingPitDepth = withPit ? (pitDepth > 0 ? pitDepth : (resultingBaseHeight - topPlateHeight - (baseCutoutType == "NONE" ? 0 : baseCutoutMinDepth))) : 0;
    pWallThickness = pitWallThickness[0] == undef 
                ? [pitWallThickness, pitWallThickness, pitWallThickness, pitWallThickness] 
                : (len(pitWallThickness) == 2 ? [pitWallThickness[0], pitWallThickness[0], pitWallThickness[1], pitWallThickness[1]] : pitWallThickness);
    pitSizeX = objectSizeX - pWallThickness[0] - pWallThickness[1];
    pitSizeY = objectSizeY - pWallThickness[2] - pWallThickness[3];

    calculatedBaseCutoutDepth = resultingBaseHeight - topPlateHeight - resultingPitDepth;        
    resultingTopPlateHeight = topPlateHeight + ((baseCutoutMaxDepth > 0 && (calculatedBaseCutoutDepth > baseCutoutMaxDepth)) ? (calculatedBaseCutoutDepth - baseCutoutMaxDepth) : 0);
    baseCutoutDepth = baseCutoutType == "NONE" ? 0 : ((baseCutoutMaxDepth > 0 && (calculatedBaseCutoutDepth > baseCutoutMaxDepth)) ? baseCutoutMaxDepth : calculatedBaseCutoutDepth);
    
    baseClampWallThickness = wallThickness + baseClampThickness;
    
    

    echo(
        baseHeight = resultingBaseHeight, 
        topPlateHeight = resultingTopPlateHeight, 
        baseCutoutDepth = baseCutoutDepth,
        pitDepth = resultingPitDepth, 
        knobHeight = knobHeight,
        wallThickness = wallThickness,
        baseClampWallThickness = baseClampWallThickness
    );
    
    //Calculate Z Positions
    centerZ = withKnobs ? -0.5 * knobHeight : 0;    
    baseCutoutZ = -0.5 * (totalHeight - baseCutoutDepth);        
    topPlateZ = baseCutoutZ + 0.5 * (resultingBaseHeight - resultingPitDepth);
    knobsZ = centerZ + 0.5 * (resultingBaseHeight + knobHeight); 
    xyHolesZ = -0.5 * totalHeight + 0.5 * (3 * baseHeightOriginal + knobHeight); //TODO absolute value for xy-holes z-position?
    
    echo(
        centerZ = centerZ, 
        baseCutoutZ = baseCutoutZ, 
        topPlateZ = topPlateZ, 
        knobsZ = knobsZ, 
        xyHolesZ = xyHolesZ
    );
    
    //Decorator Rotations
    decoratorRotations = [[90, 0, -90], [90, 0, 90], [90, 0, 0], [90, 0, 180], [0, 180, 180], [0, 0, 0]];
    
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

    /*
    * START Functions
    */
    function posX(a) = (a - offsetX) * baseSideLength;
    function posY(b) = (b - offsetY) * baseSideLength;
    
    function isCornerZone(value, i) = (value < maxPillarNonGap) || (value >= grid[i] - (maxPillarNonGap + 1)); 
    function isMiddleZone(value, i) = (grid[i] >= middlePillarGapLimit) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (grid[i] >= middlePillarGapLimit) && (value == mid[i]);
    
    function drawCornerPillar(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddlePillar(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawPillar(a, b) = !withPillarGaps || withHolesZ || ((a%2==0) && (b%2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawKnob(a, b, i) = (i >= len(knobGaps)) || (((a < knobGaps[i][0]) || (b < knobGaps[i][1]) || (a > knobGaps[i][2]) || (b > knobGaps[i][3])) && drawKnob(a, b, i+1)); 
    
    function drawWallGapX(a, side, i) = (i < len(wallGapsX)) ? ((wallGapsX[i][0] == a && (side == wallGapsX[i][1] || wallGapsX[i][1] == 2)) ? (wallGapsX[i][2] == undef ? 1 : wallGapsX[i][2]) : drawWallGapX(a, side, i+1)) : 0; 
    
    function drawWallGapY(a, side, i) = (i < len(wallGapsY)) ? ((wallGapsY[i][0] == a && (side == wallGapsY[i][1] || wallGapsY[i][1] == 2)) ? (wallGapsY[i][2] == undef ? 1 : wallGapsY[i][2]) : drawWallGapY(a, side, i+1)) : 0; 
    
    function stabilizersXHeight(a) = stabilizerGridHeight + (stabilizerExpansion > 0 && !withHolesX && (baseCutoutDepth > originalBaseCutoutDepth) && (((grid[0] > stabilizerExpansion+1) && ((a%stabilizerExpansion) == (stabilizerExpansion-1))) || (grid[1] == 1)) ? baseCutoutDepth - originalBaseCutoutDepth : 0);
    
    function stabilizersYHeight(b) = stabilizerGridHeight + (stabilizerExpansion > 0 && !withHolesY && (baseCutoutDepth > originalBaseCutoutDepth) && (((grid[1] > stabilizerExpansion+1) && ((b%stabilizerExpansion) == (stabilizerExpansion-1))) || (grid[0] == 1)) ? baseCutoutDepth - originalBaseCutoutDepth : 0);
    
    function sideX(side) = 0.5 * (sAdjustment[1] - sAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sAdjustment[3] - sAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;
    function sideZ(side) = centerZ + (side - 0.5) * resultingBaseHeight;

    function decoratorX(side, depth, offsetHorizontal) = side < 2 ? ((depth > 0 ? (side - 0.5) * depth : 0) + sideX(side)) : offsetHorizontal;
    function decoratorY(side, depth, offsetVertical) = (side > 1 && side < 4) ? ((depth > 0 ? (side - 2 - 0.5) * depth : 0) + sideY(side - 2)) : (side > 3 && side < 6 ? offsetVertical : 0);
    function decoratorZ(side, depth, offsetVertical) = (side > 3 && side < 6) ? ((depth > 0 ? (side - 4 - 0.5) * depth : 0) + sideZ(side - 4)) : centerZ + offsetVertical;
    /*
    * END Functions
    */

    knobRectX = posX(endX) - posX(startX) + knobSize;
    knobRectY = posY(endY) - posY(startY) + knobSize;

    translate([brickOffsetX, brickOffsetY, brickOffsetZ]){
        difference(){
            union(){
                if(baseCutoutType == "CLASSIC"){
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
                                                        cylinder(h=cutMultiplier * (adhesionHelperHeight), r=0.5 * tubeZSize - cutTolerance, center=true, $fn=holeResolution);
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
                        if(withTopPlateHelpers){
                            color([0.906, 0.298, 0.235]) //e74c3c
                            union(){
                                translate([-0.5*(objectSizeX - 2*wallThickness - topPlateHelperThickness), 0, topPlateZ - 0.5 * (resultingTopPlateHeight + topPlateHelperHeight)]){
                                    cube([topPlateHelperThickness, objectSizeY - 2*wallThickness, topPlateHelperHeight], center = true);
                                }
                                translate([0.5*(objectSizeX - 2*wallThickness - topPlateHelperThickness), 0, topPlateZ - 0.5 * (resultingTopPlateHeight + topPlateHelperHeight)]){
                                    cube([topPlateHelperThickness, objectSizeY - 2*wallThickness, topPlateHelperHeight], center = true);
                                }    
                                translate([0, -0.5*(objectSizeY - 2*wallThickness - topPlateHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + topPlateHelperHeight + topPlateHelperOffset)]){
                                    cube([objectSizeX - 2*wallThickness, topPlateHelperThickness, topPlateHelperHeight + topPlateHelperOffset], center = true);
                                }
                                translate([0, 0.5*(objectSizeY - 2*wallThickness - topPlateHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + topPlateHelperHeight + topPlateHelperOffset)]){
                                    cube([objectSizeX - 2*wallThickness, topPlateHelperThickness, topPlateHelperHeight + topPlateHelperOffset], center = true);
                                } 
                            }
                        }
                
            
                        /*
                        * Stabilizers
                        */
                        if(withStabilizerGrid){
                            color([0.753, 0.224, 0.169]) //c0392b
                            difference(){
                                union(){
                                    //Helpers X
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        translate([posX(a + 0.5), 0, topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersXHeight(a) + stabilizerGridOffset)]){ 
                                            cube([stabilizerGridThickness, objectSizeY - 2*wallThickness, stabilizersXHeight(a)+stabilizerGridOffset], center = true);
                                        }
                                    }
                                    
                                    //Helpers Y
                                    for (b = [ startY : 1 : endY - 1 ]){
                                    translate([0, posY(b + 0.5), topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersYHeight(b))]){
                                            cube([objectSizeX - 2*wallThickness, stabilizerGridThickness, stabilizersYHeight(b)], center = true);
                                        };
                                    }
                                }
                                if(withPillars){
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        for (b = [ startY : 1 : endY - 1 ]){
                                        if(drawPillar(a, b)){
                                                translate([posX(a + 0.5), posY(b + 0.5), 0]){
                                                    cylinder(h=cutMultiplier * totalHeight, r=0.5 * tubeZSize - cutTolerance, center=true, $fn=holeResolution);
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
                                    translate([posX(a + 0.5), 0, baseCutoutZ]){
                                        translate([0, 0, 0.5* baseClampHeight])
                                            cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * pinSize, center=true, $fn=holeResolution);
                                        translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                            cylinder(h=baseClampHeight, r=0.5 * pinSize + pinClampThickness, center=true, $fn=holeResolution);
                                    };
                                }
                            }
                            
                            //Middle Pin Y
                            if(endX == 0){
                                color([0.953, 0.612, 0.071]) //f39c12
                                for (b = [ startY : 1 : endY - 1 ]){
                                    translate([0, posY(b + 0.5), baseCutoutZ]){
                                        translate([0, 0, 0.5* baseClampHeight])
                                            cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * pinSize, center=true, $fn=holeResolution);
                                        translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                            cylinder(h=baseClampHeight, r=0.5 * pinSize + pinClampThickness, center=true, $fn=holeResolution);
                                    };
                                }
                            }
                        }
                    
                        //X-Holes Outer
                        if(withHolesX){
                            color([0.953, 0.612, 0.071]) //f39c12
                            for (a = [ startX : 1 : endX - 1 ]){
                                translate([posX(a + 0.5), 0, xyHolesZ]){
                                    rotate([90, 0, 0]){ 
                                        cylinder(h=objectSizeY - 2*wallThickness, r=0.5 * tubeXYSize, center=true, $fn=holeResolution);
                                    }
                                };
                            }
                        }
                        
                        //Y-Holes Outer
                        if(withHolesY){
                            color([0.953, 0.612, 0.071]) //f39c12
                            for (b = [ startY : 1 : endY - 1 ]){
                                translate([0, posY(b + 0.5), xyHolesZ]){
                                    rotate([0, 90, 0]){ 
                                        cylinder(h=objectSizeX - 2*wallThickness, r=0.5 * tubeXYSize, center=true, $fn=holeResolution);
                                    };
                                };
                            }
                        }
                        
                        /*
                        * Tubes / Z-Holes Outer
                        */
                        color([0.953, 0.612, 0.071]) //f39c12
                        if(withHolesZ){
                            //Z-Holes Outer
                            for (a = [ startX : 1 : endX - 1 ]){
                                for (b = [ startY : 1 : endY - 1 ]){
                                    translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ]){
                                        translate([0, 0, 0.5* baseClampHeight])
                                            cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * tubeZSize, center=true, $fn=holeResolution);
                                        translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                            cylinder(h=baseClampHeight, r=0.5 * tubeZSize + tubeClampThickness, center=true, $fn=holeResolution);
                                    };
                                }   
                            }
                        }
                        else if(withPillars){
                            //Tubes with holes
                            for (a = [ startX : 1 : endX - 1 ]){
                                for (b = [ startY : 1 : endY - 1 ]){
                                    if(drawPillar(a, b)){
                                        translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ]){
                                            difference(){
                                                union(){
                                                    translate([0, 0, 0.5* baseClampHeight])
                                                        cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * tubeZSize, center=true, $fn=holeResolution);
                                                    translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                                        cylinder(h=baseClampHeight, r=0.5 * tubeZSize + tubeClampThickness, center=true, $fn=holeResolution);
                                                }
                                                intersection(){
                                                    cylinder(h=baseCutoutDepth*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=holeResolution);
                                                    cube([holeZSize-2*tubeHoleClampThickness, holeZSize-2*tubeHoleClampThickness, baseCutoutDepth*cutMultiplier], center=true);
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
                                color([0.945, 0.769, 0.059]) //f1c40f
                                base(
                                    objectSize = [objectSizeX, objectSizeY],
                                    height = resultingBaseHeight,
                                    sideAdjustment = sAdjustment,
                                    baseRounding = baseRounding, 
                                    roundingRadius = baseRoundingRadius, 
                                    roundingResolution = baseRoundingResolution,
                                    withPit = withPit,
                                    pitDepth = resultingPitDepth,
                                    pitWallThickness = pWallThickness,
                                    pitWallGaps = pitWallGaps
                                );
                                
                                /*
                                * Bottom Hole
                                */
                                color([0.953, 0.612, 0.071]) //f39c12
                                translate([0, 0, 0.5*(baseClampHeight - (withPit ? resultingPitDepth : 0) - resultingTopPlateHeight) ])
                                    cube([objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness, resultingBaseHeight - (withPit ? resultingPitDepth : 0) - resultingTopPlateHeight - baseClampHeight], center = true);    
                            
                                /*
                                * Wall Gaps X
                                */
                                color([0.608, 0.349, 0.714]) //9b59b6
                                for (a = [ startX : 1 : endX ]){
                                    for (side = [ 0 : 1 : 1 ]){
                                        gapLength = drawWallGapX(a, side, 0);
                                        if(gapLength > 0){
                                            translate([posX(a + 0.5*(gapLength-1)), sideY(side), baseCutoutZ - centerZ]){
                                                difference(){
                                                    translate([0, 0, -0.5 * cutOffset])
                                                        cube([gapLength*baseSideLength - 2*wallThickness + cutTolerance, 2 * (baseClampWallThickness + sAdjustment[2 + side] + cutTolerance), baseCutoutDepth + cutOffset], center=true); 
                                                    
                                                        translate([-0.5 * (gapLength*baseSideLength - 2*wallThickness), 0, -0.5 * (baseCutoutDepth - baseClampHeight) - 0.5 * cutOffset]) 
                                                            cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, baseClampHeight + cutOffset + cutTolerance], center=true);
                                                    
                                                    
                                                        translate([0.5 * (gapLength*baseSideLength - 2*wallThickness), 0, -0.5 * (baseCutoutDepth - baseClampHeight) - 0.5 * cutOffset]) 
                                                            cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, baseClampHeight + cutOffset + cutTolerance], center=true);
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
                                            translate([sideX(side), posY(b + 0.5*(gapLength-1)), baseCutoutZ - centerZ]){
                                                difference(){
                                                    translate([0, 0, -0.5 * cutOffset])
                                                        cube([2 * (baseClampWallThickness + sAdjustment[side] + cutTolerance), gapLength*baseSideLength - 2 * wallThickness + cutTolerance, baseCutoutDepth + cutOffset], center=true);   
                                                    
                                                        translate([0, -0.5 * (gapLength*baseSideLength - 2 * wallThickness), -0.5 * (baseCutoutDepth - baseClampHeight) - 0.5 * cutOffset]) 
                                                            cube([2*(baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, baseClampHeight + cutOffset + cutTolerance], center=true);
                                                    
                                                        translate([0, 0.5 * (gapLength*baseSideLength - 2 * wallThickness), -0.5 * (baseCutoutDepth - baseClampHeight) - 0.5 * cutOffset]) 
                                                            cube([2 * (baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, baseClampHeight + cutOffset + cutTolerance], center=true);
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                /*
                                * Clamp Skirt
                                */
                                color([0.902, 0.494, 0.133]) //e67e22
                                translate([0, 0, 0.5*(baseClampHeight - resultingBaseHeight)])
                                    cube([objectSizeX - 2 * baseClampWallThickness, objectSizeY - 2 * baseClampWallThickness, baseClampHeight * cutMultiplier], center = true);
                            }
                        }
                    } //End union
                }
                else{
                    /*
                    * Solid Base Block
                    */
                    translate([0, 0, centerZ]){ 
                        color([0.945, 0.769, 0.059]) //f1c40f
                            base(
                                objectSize = [objectSizeX, objectSizeY],
                                height = resultingBaseHeight,
                                sideAdjustment = sAdjustment,
                                baseRounding = baseRounding, 
                                roundingRadius = baseRoundingRadius, 
                                roundingResolution = baseRoundingResolution,
                                withPit = withPit,
                                pitDepth = resultingPitDepth,
                                pitWallThickness = pWallThickness,
                                pitWallGaps = pitWallGaps
                            );
                    }
                }
                //End baseCutoutType
                
                /*
                * Text
                */
                if(withText && textDepth > 0){
                    color([0.173, 0.243, 0.314]) //2c3e50
                        translate([decoratorX(textSide, textDepth, textOffset[0]), decoratorY(textSide, textDepth, textOffset[1]), decoratorZ(textSide, textDepth, textOffset[1])])
                            rotate(decoratorRotations[textSide])
                                text3d(
                                    text = text,
                                    textDepth = textDepth,
                                    textSize = textSize,
                                    textFont = textFont,
                                    textSpacing = textSpacing,
                                    center = true
                                );
                }

                /*
                * SVG
                */
                if(withSvg && svgDepth > 0){
                    color([0.173, 0.243, 0.314]) //2c3e50
                        translate([decoratorX(svgSide, svgDepth, svgOffset[0]), decoratorY(svgSide, svgDepth, svgOffset[1]), decoratorZ(svgSide, svgDepth, svgOffset[1])])
                            rotate(decoratorRotations[svgSide])
                                svg3d(
                                    file = svgFile,
                                    orgWidth = svgDimensions[0],
                                    orgHeight = svgDimensions[1],
                                    depth = svgDepth,
                                    size = svgScale,
                                    center = true
                                );
                }
                
                //With knobs
                if(withKnobs){
                    /*
                    * Classic Knobs
                    */
                    color([0.945, 0.769, 0.059]) //f1c40f
                    if((knobType == "AUTO" && !withPit) || knobType == "CLASSIC" || knobType == "TECHNIC"){
                        /*
                        * Normal knobs
                        */
                        knobEndX = endX - (knobCentered ? 1 : 0);
                        knobEndY = endY - (knobCentered ? 1 : 0);
                        posOffset = knobCentered ? 0.5 : 0;
                        
                        for (a = [ startX : 1 : knobEndX ]){
                            for (b = [ startY : 1 : knobEndY ]){
                                if(drawKnob(a,b, 0)){
                                    translate([posX(a + posOffset), posY(b + posOffset), knobsZ]){ 
                                        difference(){
                                            union(){
                                                translate([0, 0, -0.5 * (knobRounding + knobClampHeight)])
                                                    cylinder(h=knobHeight - knobClampHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);

                                                translate([0, 0, 0.5 * knobClampHeight])
                                                    cylinder(h=knobClampHeight, r=0.5 * knobSize + knobClampThickness, center=true, $fn=knobResolution);
                                                
                                                translate([0, 0, 0.5 * (knobHeight - knobRounding)])
                                                    cylinder(h=knobRounding, r=0.5 * knobSize + knobClampThickness - knobRounding, center=true, $fn=knobResolution);
                                            }
                                            
                                            if(knobType == "TECHNIC"){
                                                intersection(){
                                                    cube([knobHoleSize - 2*knobHoleClampThickness, knobHoleSize - 2*knobHoleClampThickness, knobHeight*cutMultiplier], center=true);
                                                    cylinder(h=knobHeight * cutMultiplier, r=0.5 * knobHoleSize, center=true, $fn=knobResolution);
                                                }
                                            }
                                        }
                                        
                                        //Knob Rounding
                                        translate([0, 0, 0.5 * knobHeight - knobRounding]){ 
                                            torus(2 * knobRounding, knobSize + 2*knobClampThickness, knobResolution);
                                        };
                                    };
                                }
                            }
                        }
                    }

                    /*
                    * Knob Tongue
                    */
                    color([0.945, 0.769, 0.059]) //f1c40f
                    if((knobType == "AUTO" && withPit) || knobType == "TONGUE"){
                        /*
                        * Draw Big Knob if plateOffset is greater than zero
                        */
                        
                        translate([0, 0, knobsZ]){ 
                            difference(){
                                roundedcube(size=[knobRectX + 2*knobTongueAdjustment, knobRectY + 2*knobTongueAdjustment, knobHeight], 
                                                center = true, 
                                                radius=knobRounding, 
                                                apply_to="z",
                                                resolution=knobResolution);
                                cube([knobRectX - 2*knobTongueThickness - 2*knobTongueAdjustment, knobRectY - 2*knobTongueThickness - 2*knobTongueAdjustment, knobHeight*cutMultiplier], center=true);
                            }
                        }
                    }
                } //End withKnobs
                
            } //End union

            //Cut X-Holes
            if(withHolesX){
                color([0.945, 0.769, 0.059]) //f1c40f
                for (a = [ startX : 1 : endX - 1 ]){
                    translate([posX(a + 0.5), 0, xyHolesZ]){
                        rotate([90, 0, 0]){ 
                            cylinder(h=objectSizeY*cutMultiplier, r=0.5 * holeXYSize, center=true, $fn=holeResolution);
                            
                            translate([0, 0, 0.5 * objectSizeY])
                                cylinder(h=2*holeXYInsetDepth, r=0.5 * holeXYInsetSize, center=true, $fn=holeResolution);
                            translate([0, 0, -0.5 * objectSizeY])
                                cylinder(h=2*holeXYInsetDepth, r=0.5 * holeXYInsetSize, center=true, $fn=holeResolution);
                        };
                    };
                }
            }
            
            //Cut Y-Holes
            if(withHolesY){
                color([0.945, 0.769, 0.059]) //f1c40f
                for (b = [ startY : 1 : endY - 1 ]){
                    translate([0, posY(b + 0.5), xyHolesZ]){
                        rotate([0, 90, 0]){ 
                            cylinder(h=objectSizeX*cutMultiplier, r=0.5 * holeXYSize, center=true, $fn=holeResolution);
                            
                            translate([0, 0, 0.5 * objectSizeX])
                                cylinder(h=2*holeXYInsetDepth, r=0.5 * holeXYInsetSize, center=true, $fn=holeResolution);
                            translate([0, 0, -0.5 * objectSizeX])
                                cylinder(h=2*holeXYInsetDepth, r=0.5 * holeXYInsetSize, center=true, $fn=holeResolution);
                        };
                    };
                }
            }
            
            //Cut Z-Holes
            if(withHolesZ){
                color([0.945, 0.769, 0.059]) //f1c40f
                for (a = [ startX : 1 : endX - 1 ]){
                    for (b = [ startY : 1 : endY - 1 ]){
                        translate([posX(a + 0.5), posY(b+0.5), centerZ]){
                            cylinder(h=resultingBaseHeight*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=holeResolution);
                        };
                    }
                }
            }
        
            /*
            * Text Cutout
            */
            if(withText && textDepth < 0){
                color([0.173, 0.243, 0.314]) //2c3e50
                    translate([decoratorX(textSide, textDepth, textOffset[0]), decoratorY(textSide, textDepth, textOffset[1]), decoratorZ(textSide, textDepth, textOffset[1])])
                        rotate(decoratorRotations[textSide])
                            text3d(
                                text = text,
                                textDepth = 2 * abs(textDepth),
                                textSize = textSize,
                                textFont = textFont,
                                textSpacing = textSpacing,
                                center = true
                            );
            }

            /*
            * SVG Cutout
            */
            if(withSvg && svgDepth < 0){
                color([0.173, 0.243, 0.314]) //2c3e50
                    translate([decoratorX(svgSide, svgDepth, svgOffset[0]), decoratorY(svgSide, svgDepth, svgOffset[1]), decoratorZ(svgSide, svgDepth, svgOffset[1])])
                        rotate(decoratorRotations[svgSide])
                            svg3d(
                                file = svgFile,
                                orgWidth = svgDimensions[0],
                                orgHeight = svgDimensions[1],
                                depth = 2 * abs(svgDepth),
                                size = svgScale,
                                center = true
                            );
            }

            /*
            * Cut pitWallGaps / knobTongueGaps
            */
            if((knobType == "AUTO" && withPit) || knobType == "TONGUE"){
                for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                    gap = pitWallGaps[gapIndex];
                    cutHeight = resultingPitDepth + (withKnobs ? knobHeight : 0);
                    if(gap[0] < 2){
                        translate([sideX(gap[0]), -0.5 * (gap[2] - gap[1]), topPlateZ + 0.5*(topPlateHeight + cutHeight + cutOffset)])
                            cube([2*pWallThickness[gap[0]]*cutMultiplier, pitSizeY - gap[1] - gap[2], cutHeight + cutOffset], center = true);
                    }  
                    else{
                        translate([-0.5 * (gap[2] - gap[1]), sideY(gap[0] - 2), topPlateZ + 0.5*(topPlateHeight + cutHeight + cutOffset)])
                            cube([pitSizeX - gap[1] - gap[2] , 2*pWallThickness[gap[0]]*cutMultiplier, cutHeight + cutOffset], center = true);     
                    } 
                }
            }

            /*
            * Cut Groove
            */
            if(baseCutoutType == "GROOVE"){
                translate([0, 0, sideZ(0)]){ 
                    difference(){
                        cube(size=[knobRectX + 2*knobTongueAdjustment, knobRectY + 2*knobTongueAdjustment, 2*baseCutoutMinDepth], 
                                        center = true);
                        cube([knobRectX - 2*knobTongueThickness  - 2*knobTongueAdjustment, knobRectY - 2*knobTongueThickness - 2*knobTongueAdjustment, 2*baseCutoutMinDepth*cutMultiplier], center=true);

                        /*
                        * Cut knobGrooveGaps
                        */
                        for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                            gap = pitWallGaps[gapIndex];
                            if(gap[0] < 2){
                                translate([(-0.5 + gap[0]) * (knobRectX - knobTongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                    cube([knobTongueThickness*cutMultiplier, pitSizeY - gap[1] - gap[2], 2*baseCutoutMinDepth*cutMultiplier], center = true);
                            }  
                            else{
                                translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - knobTongueThickness), 0])
                                    cube([pitSizeX - gap[1] - gap[2] , knobTongueThickness*cutMultiplier, 2*baseCutoutMinDepth*cutMultiplier], center = true);     
                            } 
                        }   
                    }
                }   
            }
        }
        
    } //End translate brick offset

} // End module block    

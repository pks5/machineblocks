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

use <shapes.scad>;
use <base.scad>;
use <text3d.scad>;
use <svg3d.scad>;
use <pcb.scad>;

module block(
        //Grid
        grid = [1, 1],

        //Base
        baseSideLength = 8.0,
        baseHeight = 3.2,
        baseHeightOriginal = 3.2,
        baseLayers = 1,
        baseCutoutType = "CLASSIC",
        baseCutoutMinDepth = 2.6,
        baseCutoutMaxDepth = 9.0,
        baseClampHeight = 0.8,
        baseClampThickness = 0.1,
        baseRounding = "all",
        baseRoundingRadius = 0.1,
        baseRoundingResolution = 15,

        //Base Adjustment
        sideAdjustment = -0.1,
        heightAdjustment = 0.0,

        //Walls
        wallThickness = 1.6,
        wallGapsX = [],
        wallGapsY = [],
        
        //Top Plate
        topPlateHeight = 0.6,
        withTopPlateHelpers = true,
        topPlateHelperOffset = 0.2,
        topPlateHelperHeight = 0.2,
        topPlateHelperThickness = 0.4,

        //Slanting
        slanting = [0,0,0,0],
        slantingLowerHeight = 2,

        //Stabilizers
        withStabilizerGrid = true,
        stabilizerGridOffset = 0.2,
        stabilizerGridHeight = 0.4,
        stabilizerGridThickness = 0.8,
        stabilizerExpansion = 2,
        stabilizerExpansionOffset = 1.8,
        
        //Pillars: Tubes and Pins
        withPillars = true,
        pillarResolution = 30,
        pillarGaps = [],
        maxPillarNonGap = 2, //TODO find better name
        middlePillarGapLimit = 10, //TODO find better name
        
        //Pins (little tubes for blocks with 1 brick side length)
        pinSize = 3.2,
        pinClampThickness = 0.1,

        //Tubes
        tubeXYSize = 6.4,
        tubeZSize = 6.4,
        tubeHoleClampThickness = 0.1,
        tubeClampThickness = 0.1,

        //Holes
        withHolesX = false,
        withHolesY = false,
        holeXYSize = 5.1,
        holeXYInsetSize = 6.2,
        holeXYInsetDepth = 0.9,

        holesZ = false,
        holeZSize = 5.1,
        holeResolution = 30,
        
        //Knobs
        knobs = true,
        knobType = "CLASSIC",
        knobCentered = false,
        knobSize = 5.0,
        knobHeight = 1.8,
        knobHeightOriginal = 1.8,
        knobClampHeight = 0.8,
        knobClampThickness = 0,
        knobHoleSize = 3.5,
        knobHoleClampThickness = 0.1,
        knobRounding = 0.1,
        knobResolution = 30,
        
        //Tongue
        tongue = false,
        tongueHeight = 1.8,
        tongueKnobSize = 5.0,
        knobTongueThickness = 1.1, //Rename to tongueThickness
        knobTongueAdjustment = -0.1, //Rename to tongueAdjustment
        tongueClampHeight = 0.8,
        knobTongueClampThickness = 0, //Rename to tongueClampThickness
        knobGrooveDepth = 2.6, //Rename to tongueGrooveDepth
        
        //Pit
        withPit=false,
        pitDepth = 0,
        pitWallThickness = 0.333,
        pitKnobs=true,
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

        //Screw Holes
        screwHolesZ = [],
        screwHoleZSize = 2.3,
        screwHoleZHelperThickness = 0.8,
        screwHoleZHelperOffset = 0.2,
        screwHoleZHelperHeight = 0.2,

        screwHolesX = [],
        screwHoleXSize = 2.1,
        screwHoleXDepth = 4,

        screwHolesY = [],
        screwHoleYSize = 2.1,
        screwHoleYDepth = 4,

        //PCB
        withPcb=false,
        pcbMountingType = "CLIPS",
        pcbDimensions = [20, 30, 3],
        pcbOffset = [0, 0],
        pcbScrewSocketSize = 5,
        pcbScrewSocketHoleSize = 2.2,
        pcbScrewSocketHeight = 3,
        pcbScrewSockets = [],
        
        //Alignment
        brickOffset = [0, 0, 0],
        center = true,
        alwaysOnFloor = true,
        alignWithAdjustment = false,
        
        //Adhesion Helpers
        withAdhesionHelpers = false,
        adhesionHelperHeight = 0.2,
        adhesionHelperThickness = 0.4,
        
        //Preview
        previewQuality = 1
        ){
            
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

    knobsPresent = knobs != false;
    
    //Base Height
    resultingBaseHeight = baseLayers * baseHeight + heightAdjustment;
    totalHeight = resultingBaseHeight + (knobsPresent ? knobHeight : 0); 

    //Calculate Brick Offset
    brickOffsetX = brickOffset[0] * baseSideLength + (center ? (alignWithAdjustment ? 0.5*(objectSizeXAdjusted - objectSizeX) : 0) : (alignWithAdjustment ?  0.5*objectSizeXAdjusted : 0.5*objectSizeX));
    brickOffsetY = brickOffset[1] * baseSideLength + (center ? (alignWithAdjustment ? 0.5*(objectSizeYAdjusted - objectSizeY) : 0) : (alignWithAdjustment ?  0.5*objectSizeYAdjusted : 0.5*objectSizeY));
    brickOffsetZ = brickOffset[2] * baseHeightOriginal + (!center || alwaysOnFloor ? 0.5 * resultingBaseHeight : (knobsPresent ? -0.5 * knobHeight : 0)); 
    
    //Base Cutout and Pit Depth
    resultingPitDepth = withPit ? (pitDepth > 0 ? pitDepth : (resultingBaseHeight - topPlateHeight - (baseCutoutType == "NONE" ? 0 : baseCutoutMinDepth))) : 0;
    pWallThickness = withPit ? (pitWallThickness[0] == undef 
                ? [pitWallThickness, pitWallThickness, pitWallThickness, pitWallThickness] 
                : (len(pitWallThickness) == 2 ? [pitWallThickness[0], pitWallThickness[0], pitWallThickness[1], pitWallThickness[1]] : pitWallThickness)) : [0,0,0,0];
    pitSizeX = objectSizeX - (pWallThickness[0] + pWallThickness[1]) * baseSideLength;
    pitSizeY = objectSizeY - (pWallThickness[2] + pWallThickness[3]) * baseSideLength;

    calculatedBaseCutoutDepth = resultingBaseHeight - topPlateHeight - resultingPitDepth;        
    resultingTopPlateHeight = topPlateHeight + ((baseCutoutMaxDepth > 0 && (calculatedBaseCutoutDepth > baseCutoutMaxDepth)) ? (calculatedBaseCutoutDepth - baseCutoutMaxDepth) : 0);
    baseCutoutDepth = baseCutoutType == "NONE" ? 0 : ((baseCutoutMaxDepth > 0 && (calculatedBaseCutoutDepth > baseCutoutMaxDepth)) ? baseCutoutMaxDepth : calculatedBaseCutoutDepth);
    
    baseClampWallThickness = wallThickness + baseClampThickness;
    
    

    echo(
        baseHeight = resultingBaseHeight, 
        totalHeight = totalHeight,
        size = [objectSizeX, objectSizeY],
        sizeAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted],
        topPlateHeight = resultingTopPlateHeight, 
        baseCutoutDepth = baseCutoutDepth,
        pitDepth = resultingPitDepth, 
        knobHeight = knobHeight,
        wallThickness = wallThickness,
        baseClampWallThickness = baseClampWallThickness
    );
    
    //Calculate Z Positions
       
    baseCutoutZ = -0.5 * (resultingBaseHeight - baseCutoutDepth);        
    topPlateZ = baseCutoutZ + 0.5 * (resultingBaseHeight - resultingPitDepth);
    xyHolesZ = -0.5 * resultingBaseHeight + 0.5 * (3 * baseHeightOriginal + knobHeightOriginal); //TODO absolute value for xy-holes z-position?
    xyScrewHolesZ = 0.5 * resultingBaseHeight + 0.5 * baseHeightOriginal;
    pitFloorZ = 0.5 * resultingBaseHeight - resultingPitDepth;

    echo(
        baseCutoutZ = baseCutoutZ, 
        topPlateZ = topPlateZ, 
        xyHolesZ = xyHolesZ,
        xyScrewHolesZ = xyScrewHolesZ
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
    
    function drawPillarAuto(a, b) = ((a % 2==0) && (b % 2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawPillarG(a, b, i) = (i >= len(pillarGaps)) || (((a < pillarGaps[i][0]) || (b < pillarGaps[i][1]) || (a > pillarGaps[i][2]) || (b > pillarGaps[i][3])) && drawPillarG(a, b, i+1)); 
    
    function drawPillar(a, b, i) = !drawHoleZ(a,b) && ((pillarGaps == "AUTO" && drawPillarAuto(a, b)) || (pillarGaps != "AUTO" && drawPillarG(a, b, i)));

    function inRect(a, b, rect) = (a >= rect[0]) && (b >= rect[1]) && (a <= rect[2]) && (b <= rect[3]);

    function drawGridItem(items, a, b, i, prev) = (items[0] == undef ? items : ((i >= len(items)) ? prev : drawGridItem(items, a, b, i+1, items[i][0] == undef ? items[i] : (inRect(a, b, items[i]) ? (items[i][4] == true ? false : true) : prev))));

    function drawKnob(a, b) = ((a >= slanting[0]) && (a < grid[0] - slanting[1]) && (b >= slanting[2]) && (b < grid[1] - slanting[3])) 
                                && (inPit(a, b) || (a < floor(pWallThickness[0])) || (a > grid[0] - floor(pWallThickness[1]) - 1) || (b < floor(pWallThickness[2])) || (b > grid[1] - floor(pWallThickness[3]) - 1)  )
                                    && drawGridItem(knobs, a, b, 0, false); 

    function inPit(a,b) = (a >= ceil(pWallThickness[0])) && (a < grid[0] - ceil(pWallThickness[1])) && (b >= ceil(pWallThickness[2])) && (b < grid[1] - ceil(pWallThickness[3]));                                

    function knobZ(a, b) = inPit(a, b) ? (pitFloorZ + 0.5 * knobHeight) : 0.5 * (resultingBaseHeight + knobHeight);

    function drawHoleZ(a, b) = drawGridItem(holesZ, a, b, 0, false); 
    
    function drawWallGapX(a, side, i) = (i < len(wallGapsX)) ? ((wallGapsX[i][0] == a && (side == wallGapsX[i][1] || wallGapsX[i][1] == 2)) ? (wallGapsX[i][2] == undef ? 1 : wallGapsX[i][2]) : drawWallGapX(a, side, i+1)) : 0; 
    
    function drawWallGapY(a, side, i) = (i < len(wallGapsY)) ? ((wallGapsY[i][0] == a && (side == wallGapsY[i][1] || wallGapsY[i][1] == 2)) ? (wallGapsY[i][2] == undef ? 1 : wallGapsY[i][2]) : drawWallGapY(a, side, i+1)) : 0; 
    
    function stabilizersXHeight(a) = stabilizerGridHeight + stabilizerGridOffset + (stabilizerExpansion > 0 && !withHolesX && (((grid[0] > stabilizerExpansion + 1) && ((a % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[1] == 1)) ? max(baseCutoutDepth - stabilizerExpansionOffset - stabilizerGridHeight - stabilizerGridOffset, 0) : 0);
    
    function stabilizersYHeight(b) = stabilizerGridHeight + (stabilizerExpansion > 0 && !withHolesY && (((grid[1] > stabilizerExpansion + 1) && ((b % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[0] == 1)) ? max(baseCutoutDepth - stabilizerExpansionOffset - stabilizerGridHeight, 0) : 0);
    
    function drawScrewHole(a, b, i) = screwHolesZ == "ALL" || ((i < len(screwHolesZ)) && ( (a == screwHolesZ[i][0] && b == screwHolesZ[i][1]) || drawScrewHole(a, b, i+1)));

    function sideX(side) = 0.5 * (sAdjustment[1] - sAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sAdjustment[3] - sAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;
    function sideZ(side) = (side - 0.5) * resultingBaseHeight;

    function decoratorX(side, depth, offsetHorizontal) = side < 2 ? ((depth > 0 ? (side - 0.5) * depth : 0) + sideX(side)) : offsetHorizontal;
    function decoratorY(side, depth, offsetVertical) = (side > 1 && side < 4) ? ((depth > 0 ? (side - 2 - 0.5) * depth : 0) + sideY(side - 2)) : (side > 3 && side < 6 ? offsetVertical : 0);
    function decoratorZ(side, depth, offsetVertical) = (side > 3 && side < 6) ? ((depth > 0 ? (side - 4 - 0.5) * depth : 0) + sideZ(side - 4)) : offsetVertical;
    /*
    * END Functions
    */

    knobRectX = posX(endX) - posX(startX) + tongueKnobSize;
    knobRectY = posY(endY) - posY(startY) + tongueKnobSize;

    translate([brickOffsetX, brickOffsetY, brickOffsetZ]){
        difference(){
            union(){
                if(baseCutoutType == "CLASSIC"){
                    union(){
                        intersection(){
                            union(){
                                /*
                                * Adhesion Helpers
                                */
                                if(withAdhesionHelpers){
                                    color([0.753, 0.224, 0.169]) //c0392b
                                    translate([0, 0, 0.5 * (adhesionHelperHeight - resultingBaseHeight)]){
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
                                            
                                            /*
                                            * Cut TubeZ Area
                                            */
                                            if(withPillars){
                                                for (a = [ startX : 1 : endX - 1 ]){
                                                    for (b = [ startY : 1 : endY - 1 ]){
                                                        if(drawPillar(a, b, 0)){
                                                            translate([posX(a + 0.5), posY(b + 0.5), 0]){
                                                                cylinder(h=cutMultiplier * (adhesionHelperHeight), r=0.5 * tubeZSize - cutTolerance, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
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
                                    difference(){
                                        union(){
                                            //Helpers X
                                            color([0.753, 0.224, 0.169]) //c0392b
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                translate([posX(a + 0.5), 0, topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersXHeight(a))]){ 
                                                    cube([stabilizerGridThickness, objectSizeY - 2*wallThickness, stabilizersXHeight(a)], center = true);
                                                }
                                            }
                                            
                                            //Helpers Y
                                            color([0.753, 0.224, 0.169]) //c0392b
                                            for (b = [ startY : 1 : endY - 1 ]){
                                            translate([0, posY(b + 0.5), topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersYHeight(b))]){
                                                    cube([objectSizeX - 2*wallThickness, stabilizerGridThickness, stabilizersYHeight(b)], center = true);
                                                };
                                            }

                                            /*
                                            * Screw Hole Helpers
                                            */
                                            for (a = [ startX : 1 : endX ]){
                                                for (b = [ startY : 1 : endY ]){
                                                    if(drawScrewHole(a, b, 0)){
                                                        translate([posX(a), posY(b)-0.5*(screwHoleZSize + screwHoleZHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight + screwHoleZHelperOffset)])
                                                            cube([baseSideLength - stabilizerGridThickness, screwHoleZHelperThickness, screwHoleZHelperHeight + screwHoleZHelperOffset], center = true);
                                                        translate([posX(a), posY(b)+0.5*(screwHoleZSize + screwHoleZHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight + screwHoleZHelperOffset)])
                                                            cube([baseSideLength - stabilizerGridThickness, screwHoleZHelperThickness, screwHoleZHelperHeight + screwHoleZHelperOffset], center = true);    
                                                        translate([posX(a)-0.5*(screwHoleZSize + screwHoleZHelperThickness), posY(b), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight)])
                                                            cube([screwHoleZHelperThickness, baseSideLength - stabilizerGridThickness, screwHoleZHelperHeight], center = true);
                                                        translate([posX(a)+0.5*(screwHoleZSize + screwHoleZHelperThickness), posY(b), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight)])
                                                            cube([screwHoleZHelperThickness, baseSideLength - stabilizerGridThickness, screwHoleZHelperHeight], center = true);    
                                                    } 
                                                }
                                            }
                                        }

                                        /*
                                        * Cut TubeZ area
                                        */
                                        if(withPillars){
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                for (b = [ startY : 1 : endY - 1 ]){
                                                    if(drawPillar(a, b, 0)){
                                                            translate([posX(a + 0.5), posY(b + 0.5), 0]){
                                                                cylinder(h=cutMultiplier * resultingBaseHeight, r=0.5 * tubeZSize - cutTolerance, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
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
                                                    cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * pinSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                                    cylinder(h=baseClampHeight, r=0.5 * pinSize + pinClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                            };
                                        }
                                    }
                                    
                                    //Middle Pin Y
                                    if(endX == 0){
                                        color([0.953, 0.612, 0.071]) //f39c12
                                        for (b = [ startY : 1 : endY - 1 ]){
                                            translate([0, posY(b + 0.5), baseCutoutZ]){
                                                translate([0, 0, 0.5* baseClampHeight])
                                                    cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * pinSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                                    cylinder(h=baseClampHeight, r=0.5 * pinSize + pinClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
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
                                                cylinder(h=objectSizeY - 2*wallThickness, r=0.5 * tubeXYSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
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
                                                cylinder(h=objectSizeX - 2*wallThickness, r=0.5 * tubeXYSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                            };
                                        };
                                    }
                                }
                                
                                /*
                                * Z-Holes Outer
                                */
                                color([0.953, 0.612, 0.071]) //f39c12
                                for (a = [ startX : 1 : endX - 1 ]){
                                    for (b = [ startY : 1 : endY - 1 ]){
                                        if(drawHoleZ(a, b)){
                                            translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ]){
                                                translate([0, 0, 0.5* baseClampHeight])
                                                    cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * tubeZSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                                    cylinder(h=baseClampHeight, r=0.5 * tubeZSize + tubeClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                            };
                                        }
                                    }   
                                }
                                
                                
                                if(withPillars){
                                    //Tubes with holes
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        for (b = [ startY : 1 : endY - 1 ]){
                                            if(drawPillar(a, b, 0)){
                                                translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ]){
                                                    difference(){
                                                        union(){
                                                            translate([0, 0, 0.5* baseClampHeight])
                                                                cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * tubeZSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                            translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                                                cylinder(h=baseClampHeight, r=0.5 * tubeZSize + tubeClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                        }
                                                        //Cut Tube inner
                                                        intersection(){
                                                            cylinder(h=baseCutoutDepth*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                                                            cube([holeZSize-2*tubeHoleClampThickness, holeZSize-2*tubeHoleClampThickness, baseCutoutDepth*cutMultiplier], center=true);
                                                        };
                                                    }
                                                };
                                            }
                                        }
                                    }
                                }
                            } //End Union of tubes, helpers, etc

                            //Cut off overlapping parts of tubes
                            if(slanting[0] + slanting[1] + slanting[2] + slanting[3] > 0){
                                mb_base_cutout(
                                    grid = grid,
                                    baseSideLength = baseSideLength,
                                    objectSize = [objectSizeX, objectSizeY],
                                    baseHeight = resultingBaseHeight,
                                    sideAdjustment = sAdjustment,
                                    wallThickness = wallThickness,
                                    topPlateHeight = resultingTopPlateHeight,
                                    baseClampHeight = baseClampHeight,
                                    baseClampThickness = baseClampThickness,
                                    withPit = withPit,
                                    pitDepth = resultingPitDepth,
                                    slanting = slanting,
                                    slantingLowerHeight = slantingLowerHeight
                                );
                            }
                        } //End interception (for slanting only)
                        
                        /*
                        * Base
                        */
                        
                        difference() {
                            /*
                            * Base Block
                            */
                            color([0.945, 0.769, 0.059]) //f1c40f
                            mb_base(
                                grid = grid,
                                baseSideLength = baseSideLength,
                                objectSize = [objectSizeX, objectSizeY],
                                height = resultingBaseHeight,
                                sideAdjustment = sAdjustment,
                                baseRounding = baseRounding, 
                                roundingRadius = baseRoundingRadius, 
                                roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                withPit = withPit,
                                pitDepth = resultingPitDepth,
                                pitWallThickness = pWallThickness,
                                pitWallGaps = pitWallGaps,
                                slanting = slanting,
                                slantingLowerHeight = slantingLowerHeight
                            );

                            mb_base_cutout(
                                grid = grid,
                                baseSideLength = baseSideLength,
                                objectSize = [objectSizeX, objectSizeY],
                                baseHeight = resultingBaseHeight,
                                sideAdjustment = sAdjustment,
                                wallThickness = wallThickness,
                                topPlateHeight = resultingTopPlateHeight,
                                baseClampHeight = baseClampHeight,
                                baseClampThickness = baseClampThickness,
                                withPit = withPit,
                                pitDepth = resultingPitDepth,
                                slanting = slanting,
                                slantingLowerHeight = slantingLowerHeight
                            );
                            
                            /*
                            * Wall Gaps X
                            */
                            color([0.608, 0.349, 0.714]) //9b59b6
                            for (a = [ startX : 1 : endX ]){
                                for (side = [ 0 : 1 : 1 ]){
                                    gapLength = drawWallGapX(a, side, 0);
                                    if(gapLength > 0){
                                        translate([posX(a + 0.5*(gapLength-1)), sideY(side), baseCutoutZ]){
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
                                        translate([sideX(side), posY(b + 0.5*(gapLength-1)), baseCutoutZ]){
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
                        }
                        
                    } //End union
                }
                else{
                    /*
                    * Solid Base Block
                    */
                    color([0.945, 0.769, 0.059]) //f1c40f
                        mb_base(
                            grid = grid,
                            baseSideLength = baseSideLength,
                            objectSize = [objectSizeX, objectSizeY],
                            height = resultingBaseHeight,
                            sideAdjustment = sAdjustment,
                            baseRounding = baseRounding, 
                            roundingRadius = baseRoundingRadius, 
                            roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                            withPit = withPit,
                            pitDepth = resultingPitDepth,
                            pitWallThickness = pWallThickness,
                            pitWallGaps = pitWallGaps,
                            slanting = slanting,
                            slantingLowerHeight = slantingLowerHeight
                        );
                }
                //End baseCutoutType
                
                /*
                * Text
                */
                if(withText && textDepth > 0){
                    color([0.173, 0.243, 0.314]) //2c3e50
                        translate([decoratorX(textSide, textDepth, textOffset[0]), decoratorY(textSide, textDepth, textOffset[1]), decoratorZ(textSide, textDepth, textOffset[1])])
                            rotate(decoratorRotations[textSide])
                                mb_text3d(
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
                                mb_svg3d(
                                    file = svgFile,
                                    orgWidth = svgDimensions[0],
                                    orgHeight = svgDimensions[1],
                                    depth = svgDepth,
                                    size = svgScale,
                                    center = true
                                );
                }
                
                /*
                * Classic Knobs
                */
                color([0.945, 0.769, 0.059]) //f1c40f
                if(knobs != false){
                    /*
                    * Normal knobs
                    */
                    knobEndX = endX - (knobCentered ? 1 : 0);
                    knobEndY = endY - (knobCentered ? 1 : 0);
                    posOffset = knobCentered ? 0.5 : 0;
                    
                    for (a = [ startX : 1 : knobEndX ]){
                        for (b = [ startY : 1 : knobEndY ]){
                            if(drawKnob(a,b)){
                                translate([posX(a + posOffset), posY(b + posOffset), knobZ(a, b)]){ 
                                    difference(){
                                        union(){
                                            translate([0, 0, -0.5 * (knobRounding + knobClampHeight)])
                                                cylinder(h=knobHeight - knobRounding - knobClampHeight, r=0.5 * knobSize, center=true, $fn=($preview ? previewQuality : 1) * knobResolution);

                                            
                                            translate([0, 0, 0.5 * (knobHeight - knobClampHeight) - knobRounding ])
                                                cylinder(h=knobClampHeight, r=0.5 * knobSize + knobClampThickness, center=true, $fn=($preview ? previewQuality : 1) * knobResolution);
                                            
                                            translate([0, 0, 0.5 * (knobHeight - knobRounding)])
                                                cylinder(h=knobRounding, r=0.5 * knobSize + knobClampThickness - knobRounding, center=true, $fn=($preview ? previewQuality : 1) * knobResolution);
                                        }
                                        
                                        if(knobType == "TECHNIC"){
                                            intersection(){
                                                cube([knobHoleSize - 2*knobHoleClampThickness, knobHoleSize - 2*knobHoleClampThickness, knobHeight*cutMultiplier], center=true);
                                                cylinder(h=knobHeight * cutMultiplier, r=0.5 * knobHoleSize, center=true, $fn=($preview ? previewQuality : 1) * knobResolution);
                                            }
                                        }
                                    }
                                    
                                    //Knob Rounding
                                    translate([0, 0, 0.5 * knobHeight - knobRounding]){ 
                                        mb_torus(
                                            circleRadius = knobRounding, 
                                            torusRadius = 0.5 * knobSize + knobClampThickness, 
                                            circleResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                            torusResolution = ($preview ? previewQuality : 1) * knobResolution
                                        );
                                    };
                                };
                            }
                        }
                    }
                }

                /*
                * Tongue
                */
                color([0.945, 0.769, 0.059]) //f1c40f
                if(tongue){
                    translate([0, 0, 0.5 * (resultingBaseHeight + tongueHeight)]){ 
                        difference(){
                            union(){
                                translate([0, 0, -0.5 * tongueClampHeight]){
                                    difference(){
                                            mb_roundedcube(size=[knobRectX + 2*knobTongueAdjustment, knobRectY + 2*knobTongueAdjustment, tongueHeight - tongueClampHeight], 
                                                        center = true, 
                                                        radius=knobRounding, 
                                                        apply_to="z",
                                                        resolution=($preview ? previewQuality : 1) * knobResolution);
                                        cube([knobRectX - 2*knobTongueThickness, knobRectY - 2*knobTongueThickness, (tongueHeight - tongueClampHeight)*cutMultiplier], center=true);

                                        /*
                                        * Cut knobGrooveGaps
                                        */
                                        if(withPit){
                                            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                                gap = pitWallGaps[gapIndex];
                                                if(gap[0] < 2){
                                                    translate([(-0.5 + gap[0]) * (knobRectX - knobTongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                                        cube([knobTongueThickness*cutMultiplier, pitSizeY - gap[1] - gap[2], (tongueHeight - tongueClampHeight)*cutMultiplier], center = true);
                                                }  
                                                else{
                                                    translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - knobTongueThickness), 0])
                                                        cube([pitSizeX - gap[1] - gap[2] , knobTongueThickness*cutMultiplier, (tongueHeight - tongueClampHeight)*cutMultiplier], center = true);     
                                                } 
                                            }  
                                        }
                                    }
                                }

                                //Tongue Clamp
                                translate([0, 0, 0.5 * (tongueHeight-tongueClampHeight)]){    
                                    difference(){       
                                        mb_roundedcube(size=[knobRectX + 2*knobTongueClampThickness + 2*knobTongueAdjustment, knobRectY + 2*knobTongueClampThickness + 2*knobTongueAdjustment, tongueClampHeight], 
                                                        center = true, 
                                                        radius=knobRounding, 
                                                        apply_to="z",
                                                        resolution=($preview ? previewQuality : 1) * knobResolution);
                                        cube([knobRectX - 2*knobTongueThickness - 2*knobTongueClampThickness, knobRectY - 2*knobTongueThickness - 2*knobTongueClampThickness, tongueClampHeight*cutMultiplier], center=true);
                                    
                                        /*
                                        * Cut knobGrooveGaps
                                        */
                                        if(withPit){
                                            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                                gap = pitWallGaps[gapIndex];
                                                if(gap[0] < 2){
                                                    translate([(-0.5 + gap[0]) * (knobRectX - knobTongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                                        cube([(knobTongueThickness + 2*knobTongueClampThickness)*cutMultiplier, pitSizeY - gap[1] - gap[2]- 2*knobTongueClampThickness, tongueClampHeight*cutMultiplier], center = true);
                                                }  
                                                else{
                                                    translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - knobTongueThickness), 0])
                                                        cube([pitSizeX - gap[1] - gap[2] - 2*knobTongueClampThickness , (knobTongueThickness + 2*knobTongueClampThickness)*cutMultiplier, tongueClampHeight*cutMultiplier], center = true);     
                                                } 
                                            }  
                                        }
                                    }
                                }
                            }

                            
                        }
                    }
                }

                //PCB
                if(withPcb){
                    translate([pcbOffset[0], pcbOffset[1], topPlateZ + 0.5*topPlateHeight]){
                        if(pcbMountingType == "CLIPS"){
                            mb_pcb_clips(
                                pcbDimensions = pcbDimensions
                            );
                        }
                        if(pcbMountingType == "SCREWS"){
                            mb_pcb_screw_sockets(
                                screwSockets = pcbScrewSockets,
                                screwSocketHeight = pcbScrewSocketHeight,
                                screwSocketSize = pcbScrewSocketSize,
                                screwSocketHoleSize = pcbScrewSocketHoleSize
                            );
                        }
                    }
                }
            } //End union

            //Cut X-Holes
            if(withHolesX){
                color([0.945, 0.769, 0.059]) //f1c40f
                for (a = [ startX : 1 : endX - 1 ]){
                    translate([posX(a + 0.5), 0, xyHolesZ]){
                        rotate([90, 0, 0]){ 
                            cylinder(h=objectSizeY*cutMultiplier, r=0.5 * holeXYSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                            
                            translate([0, 0, 0.5 * objectSizeY])
                                cylinder(h=2*holeXYInsetDepth, r=0.5 * holeXYInsetSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                            translate([0, 0, -0.5 * objectSizeY])
                                cylinder(h=2*holeXYInsetDepth, r=0.5 * holeXYInsetSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
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
                            cylinder(h=objectSizeX*cutMultiplier, r=0.5 * holeXYSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                            
                            translate([0, 0, 0.5 * objectSizeX])
                                cylinder(h=2*holeXYInsetDepth, r=0.5 * holeXYInsetSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                            translate([0, 0, -0.5 * objectSizeX])
                                cylinder(h=2*holeXYInsetDepth, r=0.5 * holeXYInsetSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                        };
                    };
                }
            }
            
            //Cut Z-Holes
            color([0.945, 0.769, 0.059]) //f1c40f
            for (a = [ startX : 1 : endX - 1 ]){
                for (b = [ startY : 1 : endY - 1 ]){
                    if(drawHoleZ(a, b)){
                        translate([posX(a + 0.5), posY(b+0.5), 0]){
                            cylinder(h=resultingBaseHeight*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
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
                            mb_text3d(
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
                            mb_svg3d(
                                file = svgFile,
                                orgWidth = svgDimensions[0],
                                orgHeight = svgDimensions[1],
                                depth = 2 * abs(svgDepth),
                                size = svgScale,
                                center = true
                            );
            }

            /*
            * Screw Holes Z
            */
            if(withStabilizerGrid || (baseCutoutType == "NONE") || (baseCutoutType == "GROOVE")){
                for (a = [ startX : 1 : endX ]){
                    for (b = [ startY : 1 : endY ]){
                        if(drawScrewHole(a, b, 0)){
                            translate([posX(a), posY(b), 0])
                                cylinder(h = totalHeight*cutMultiplier, r = 0.5*screwHoleZSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                        } 
                    }
                }
            }

            /*
            * Screw Holes X
            */
            for (b = [ 0 : 1 : len(screwHolesX) - 1]){
                for (s = [ 0 : 1 : 1]){
                    if(screwHolesX[b][2] == undef || screwHolesX[b][2] == s){
                        translate([posX(screwHolesX[b][0]), sideY(s) + (0.5 - s)*(screwHoleXDepth - cutOffset), xyScrewHolesZ + screwHolesX[b][1] * baseHeightOriginal])
                            rotate([90, 0, 0])
                                cylinder(h = screwHoleXDepth + cutOffset, r = 0.5*screwHoleXSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                    }
                }
            }

            /*
            * Screw Holes Y
            */
            for (b = [ 0 : 1 : len(screwHolesY) - 1]){
                for (s = [ 0 : 1 : 1]){
                    if(screwHolesY[b][2] == undef || screwHolesY[b][2] == s){
                        translate([sideX(s) + (0.5 - s)*(screwHoleYDepth - cutOffset), posY(screwHolesY[b][0]), xyScrewHolesZ + screwHolesY[b][1] * baseHeightOriginal])
                            rotate([0, 90, 0])
                                cylinder(h = screwHoleYDepth + cutOffset, r = 0.5*screwHoleYSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                    }
                }
            }

            /*
            * Cut Groove
            */
            if(baseCutoutType == "GROOVE"){
                translate([0, 0, sideZ(0) + 0.5*knobGrooveDepth]){ 
                    difference(){
                        union(){
                            translate([0, 0, -0.5 * tongueClampHeight]){
                                difference(){
                                    cube(size=[knobRectX + 2*knobTongueAdjustment, knobRectY + 2*knobTongueAdjustment, knobGrooveDepth - tongueClampHeight + 2*cutOffset], center = true);
                                    cube([knobRectX - 2*knobTongueThickness, knobRectY - 2*knobTongueThickness, (knobGrooveDepth - tongueClampHeight + 2*cutOffset)*cutMultiplier], center=true);
                                    /*
                                    * Cut knobGrooveGaps
                                    */
                                    for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                        gap = pitWallGaps[gapIndex];
                                        if(gap[0] < 2){
                                            translate([(-0.5 + gap[0]) * (knobRectX - knobTongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                                cube([knobTongueThickness*cutMultiplier, pitSizeY - gap[1] - gap[2], (knobGrooveDepth - tongueClampHeight + 2*cutOffset)*cutMultiplier], center = true);
                                        }  
                                        else{
                                            translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - knobTongueThickness), 0])
                                                cube([pitSizeX - gap[1] - gap[2] , knobTongueThickness*cutMultiplier, (knobGrooveDepth - tongueClampHeight + 2*cutOffset)*cutMultiplier], center = true);     
                                        } 
                                    }   
                                }
                            }
                            //Top Part with clamp
                            translate([0, 0, 0.5 * (knobGrooveDepth - tongueClampHeight)]){    
                                difference(){       
                                    cube(size=[knobRectX + 2*knobTongueClampThickness + 2*knobTongueAdjustment, knobRectY + 2*knobTongueClampThickness + 2*knobTongueAdjustment, tongueClampHeight], center = true);
                                    cube([knobRectX - 2*knobTongueThickness - 2*knobTongueClampThickness, knobRectY - 2*knobTongueThickness - 2*knobTongueClampThickness, tongueClampHeight*cutMultiplier], center=true);
                                    /*
                                    * Cut knobGrooveGaps
                                    */
                                    for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                        gap = pitWallGaps[gapIndex];
                                        if(gap[0] < 2){
                                            translate([(-0.5 + gap[0]) * (knobRectX - knobTongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                                cube([(knobTongueThickness + 2*knobTongueClampThickness)*cutMultiplier, pitSizeY - gap[1] - gap[2]- 2*knobTongueClampThickness, tongueClampHeight*cutMultiplier], center = true);
                                        }  
                                        else{
                                            translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - knobTongueThickness), 0])
                                                cube([pitSizeX - gap[1] - gap[2] - 2*knobTongueClampThickness , (knobTongueThickness + 2*knobTongueClampThickness)*cutMultiplier, tongueClampHeight*cutMultiplier], center = true);     
                                        } 
                                    }   
                                }
                            }
                        }

                        

                        
                    }

                    /*
                    * Wall Gaps X
                    */
                    color([0.608, 0.349, 0.714]) //9b59b6
                    for (a = [ startX : 1 : endX ]){
                        for (side = [ 0 : 1 : 1 ]){
                            gapLength = drawWallGapX(a, side, 0);
                            if(gapLength > 0){
                                translate([posX(a + 0.5*(gapLength-1)), sideY(side), -0.5 * cutOffset])
                                    cube([gapLength*baseSideLength - (objectSizeX - (knobRectX + 2*knobTongueAdjustment)) + cutTolerance, (objectSizeY - (knobRectY + 2*knobTongueAdjustment) + sAdjustment[2 + side] + cutTolerance), knobGrooveDepth + cutOffset], center=true); 
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
                                translate([sideX(side), posY(b + 0.5*(gapLength-1)), -0.5 * cutOffset])
                                        cube([(objectSizeX - (knobRectX + 2*knobTongueAdjustment) + sAdjustment[side] + cutTolerance), gapLength*baseSideLength - (objectSizeY - (knobRectY + 2*knobTongueAdjustment)) + cutTolerance, knobGrooveDepth + cutOffset], center=true);   
                            }
                        }
                    }
                }   
            }
        }

        
    } //End translate brick offset

} // End module block    

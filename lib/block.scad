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
        gridSizeXY = 8.0, //mm
        gridSizeZ = 3.2, //mm
        gridOffset = [0, 0, 0], //Multipliers of gridSizeXY and gridSizeZ
        
        //Base
        baseHeight = 3.2, //mm
        baseLayers = 1,
        baseCutoutType = "classic",
        baseCutoutMinDepth = 2.4, //mm
        baseCutoutMaxDepth = 9.0, //mm
        baseClampHeight = 0.8, //mm
        baseClampThickness = 0.1, //mm
        baseRoundingRadius = 0.0, //e.g. 4 or [4, 4, 4] or [4, [4, 4, 4, 4], [4,4,4,4]]
        baseCutoutRoundingRadius = 0.0, //e.g 2.7 or [2.7, 2.7, 2.7, 2.7] 
        baseRoundingResolution = 30,
        
        //Base Adjustment
        baseSideAdjustment = -0.1, //mm
        baseHeightAdjustment = 0.0, //mm

        //Walls
        wallThickness = 1.5, //mm
        wallGapsX = [],
        wallGapsY = [],
        
        //Top Plate
        topPlateHeight = 0.8, //mm
        topPlateHelpers = true,
        topPlateHelperOffset = 0.2, //mm
        topPlateHelperHeight = 0.2, //mm
        topPlateHelperThickness = 0.4, //mm

        //Slanting
        slanting = false,
        slantingLowerHeight = 2, //mm

        //Stabilizers
        stabilizerGrid = true,
        stabilizerGridOffset = 0.2, //mm
        stabilizerGridHeight = 0.8, //mm
        stabilizerGridThickness = 0.8, //mm
        stabilizerExpansion = 2,
        stabilizerExpansionOffset = 1.8, //mm
        
        //Pillars: Tubes and Pins
        pillars = true,
        pillarResolution = 30,
        pillarGapCornerLength = 2,
        pillarGapMiddle = 10,
        
        //Pins (little tubes for blocks with 1 brick side length)
        pinSize = 3.2, //mm
        pinClampThickness = 0.1, //mm

        //Tubes
        tubeXSize = 6.4, //mm
        tubeYSize = 6.4, //mm
        tubeZSize = 6.4, //mm
        tubeHoleClampThickness = 0.1, //mm
        tubeClampThickness = 0.1, //mm

        //Holes
        holesX = false,
        holesY = false,
        
        holeXSize = 5.1, //mm
        holeXInsetThickness = 0.55, //mm
        holeXInsetDepth = 0.9, //mm
        holeXGridOffsetZ = 1.75, //Multiplier of gridSizeZ
        holeXGridSizeZ = 3, //Multiplier of gridSizeZ
        holeXTopMargin = 0.8, //mm

        holeYSize = 5.1, //mm
        holeYInsetThickness = 0.55, //mm
        holeYInsetDepth = 0.9, //mm
        holeYGridOffsetZ = 1.75, //Multiplier of gridSizeZ
        holeYGridSizeZ = 3, //Multiplier of gridSizeZ
        holeYTopMargin = 0.8, //mm

        holesZ = false,
        holeZSize = 5.1, //mm
        holeResolution = 30,
        
        //Knobs
        knobs = true,
        knobType = "classic",
        knobCentered = false,
        knobSize = 5.0, //mm
        knobHeight = 1.8, //mm
        knobClampHeight = 0.8, //mm
        knobClampThickness = 0.0, //mm
        knobHoleSize = 3.5, //mm
        knobHoleClampThickness = 0.1, //mm
        knobRounding = 0.1, //mm
        knobResolution = 30,
        
        //Tongue
        tongue = false,
        tongueHeight = 1.8, //mm
        tongueKnobSize = 5.0, //mm
        tongueRoundingRadius = 0.0, //mm, e.g 3.4 or [3.4, 3.4, 3.4, 3.4] 
        tongueThickness = 1.1, //mm
        tongueAdjustment = -0.1, //mm
        tongueClampHeight = 0.8, //mm
        tongueClampThickness = 0.0, //mm
        tongueGrooveDepth = 2.4, //mm
        
        //Pit
        pit=false,
        pitRoundingRadius = 0.0, //e.g 2.7 or [2.7, 2.7, 2.7, 2.7]  
        pitDepth = 0.0, //mm
        pitWallThickness = 0.333, //Format: 0.333 or [0.333, 0.333, 0.333, 0.333], Multipliers of gridSizeXY
        pitKnobs=true,
        pitWallGaps = [],
        
        //Text
        text = "",
        textSide = 0, //Side
        textDepth = -0.6, //mm
        textFont = "Liberation Sans",
        textSize = 4,
        textSpacing = 1,
        textVerticalAlign = "center",
        textHorizontalAlign = "center",
        textOffset = [0, 0], //Multipliers of gridSizeXY and gridSizeZ depending on side

        //SVG
        svg = "",
        svgSide = 5, //Side
        svgDepth = 0.4, //mm
        svgDimensions = [100, 100],
        svgScale = 1,
        svgOffset = [0, 0], //Multipliers of gridSizeXY and gridSizeZ depending on side

        //Screw Holes
        screwHolesZ = [],
        screwHoleZSize = 2.3, //mm
        screwHoleZHelperThickness = 0.8, //mm
        screwHoleZHelperOffset = 0.2, //mm
        screwHoleZHelperHeight = 0.2, //mm

        screwHolesX = [],
        screwHoleXSize = 2.1, //mm
        screwHoleXDepth = 4, //mm

        screwHolesY = [],
        screwHoleYSize = 2.1, //mm
        screwHoleYDepth = 4, //mm

        //PCB
        pcb=false,
        pcbMountingType = "clips",
        pcbDimensions = [20, 30, 3], //mm
        pcbOffset = [0, 0], //Multipliers of gridSizeXY
        pcbScrewSocketSize = 5, //mm
        pcbScrewSocketHoleSize = 2.2, //mm
        pcbScrewSocketHeight = 3, //mm
        pcbScrewSockets = [],
        
        //Alignment
        center = true,
        alignBottom = true, //Whether the brick should be always aligned on floor
        alignIgnoreAdjustment = true, //Whether baseSideAdjustment should be ignored when aligning the brick
        
        //Adhesion Helpers
        adhesionHelpers = false,
        adhesionHelperHeight = 0.2, //mm
        adhesionHelperThickness = 0.4, //mm
        
        //Preview
        previewQuality = 1 //Between 0.0 and 1.0
        ){
            
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;
       
    //Side Adjustment
    sAdjustment = baseSideAdjustment[0] == undef ? [baseSideAdjustment, baseSideAdjustment, baseSideAdjustment, baseSideAdjustment] : (len(baseSideAdjustment) == 2 ? [baseSideAdjustment[0], baseSideAdjustment[0], baseSideAdjustment[1], baseSideAdjustment[1]] : baseSideAdjustment);

    //Object Size     
    objectSizeX = gridSizeXY * grid[0];
    objectSizeY = gridSizeXY * grid[1];

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSizeX + sAdjustment[0] + sAdjustment[1];
    objectSizeYAdjusted = objectSizeY + sAdjustment[2] + sAdjustment[3];

    //Base Height
    resultingBaseHeight = baseLayers * baseHeight + baseHeightAdjustment;

    //Calculate Brick Offset
    gridOffsetX = gridOffset[0] * gridSizeXY + (center ? (alignIgnoreAdjustment ? 0 : 0.5*(objectSizeXAdjusted - objectSizeX)) : (alignIgnoreAdjustment ?  0.5*objectSizeX : 0.5*objectSizeXAdjusted));
    gridOffsetY = gridOffset[1] * gridSizeXY + (center ? (alignIgnoreAdjustment ? 0 : 0.5*(objectSizeYAdjusted - objectSizeY)) : (alignIgnoreAdjustment ?  0.5*objectSizeY : 0.5*objectSizeYAdjusted));
    gridOffsetZ = gridOffset[2] * gridSizeZ + (!center || alignBottom ? 0.5 * resultingBaseHeight : 0); 
    
    //Base Cutout and Pit Depth
    resultingPitDepth = pit ? (pitDepth > 0 ? pitDepth : (resultingBaseHeight - topPlateHeight - (baseCutoutType == "none" ? 0 : baseCutoutMinDepth))) : 0;
    pWallThickness = pitWallThickness[0] == undef 
                ? [pitWallThickness, pitWallThickness, pitWallThickness, pitWallThickness] 
                : (len(pitWallThickness) == 2 ? [pitWallThickness[0], pitWallThickness[0], pitWallThickness[1], pitWallThickness[1]] : pitWallThickness);
    pitSizeX = objectSizeX - (pWallThickness[0] + pWallThickness[1]) * gridSizeXY;
    pitSizeY = objectSizeY - (pWallThickness[2] + pWallThickness[3]) * gridSizeXY;

    calculatedBaseCutoutDepth = resultingBaseHeight - topPlateHeight - resultingPitDepth;        
    resultingTopPlateHeight = topPlateHeight + ((baseCutoutMaxDepth > 0 && (calculatedBaseCutoutDepth > baseCutoutMaxDepth)) ? (calculatedBaseCutoutDepth - baseCutoutMaxDepth) : 0);
    baseCutoutDepth = baseCutoutType == "none" ? 0 : ((baseCutoutMaxDepth > 0 && (calculatedBaseCutoutDepth > baseCutoutMaxDepth)) ? baseCutoutMaxDepth : calculatedBaseCutoutDepth);
    
    baseClampWallThickness = wallThickness + baseClampThickness;
    
    //Calculate Z Positions
    baseCutoutZ = -0.5 * (resultingBaseHeight - baseCutoutDepth);        
    topPlateZ = baseCutoutZ + 0.5 * (resultingBaseHeight - resultingPitDepth);
    xyScrewHolesZ = -0.5 * resultingBaseHeight + 0.5 * gridSizeZ;
    pitFloorZ = 0.5 * resultingBaseHeight - resultingPitDepth;

    //Holes XY
    holeXBottomMargin = holeXGridOffsetZ*gridSizeZ - 0.5*(holeXSize + 2*holeXInsetThickness);
    holeXMaxRows = ceil((resultingBaseHeight - holeXBottomMargin - holeXTopMargin) / (holeXGridSizeZ*gridSizeZ)); 

    holeYBottomMargin = holeYGridOffsetZ*gridSizeZ - 0.5*(holeYSize + 2*holeYInsetThickness);
    holeYMaxRows = ceil((resultingBaseHeight - holeYBottomMargin - holeYTopMargin) / (holeYGridSizeZ*gridSizeZ)); 

    echo(
        grid=grid,
        baseHeight = resultingBaseHeight, 
        heightWithKnobs = resultingBaseHeight + knobHeight,
        size = [objectSizeX, objectSizeY],
        sizeAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted],
        topPlateHeight = resultingTopPlateHeight, 
        baseCutoutDepth = baseCutoutDepth,
        pitDepth = resultingPitDepth, 
        knobHeight = knobHeight,
        wallThickness = wallThickness,
        baseClampWallThickness = baseClampWallThickness,
        baseCutoutZ = baseCutoutZ, 
        topPlateZ = topPlateZ, 
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
    function isEmptyString(s) = (s == undef) || len(s) == 0;

    function posX(a) = (a - offsetX) * gridSizeXY;
    function posY(b) = (b - offsetY) * gridSizeXY;

    function inGridArea(a, b, rect) = (a >= rect[0]) && (b >= rect[1]) && (a <= rect[2]) && (b <= rect[3]); //[x0, y0, x1, y1]

    function slanting(s, inv) = inv ? (s > 0 ? 0 : abs(s)) : (s < 0 ? 0 : s);
    function inSlantedArea(a, b, inv) = (slanting != false) && !inGridArea(a, b, [slanting(slanting[0], inv), slanting(slanting[2], inv), grid[0] - slanting(slanting[1], inv) - (inv ? 2 : 1), grid[1] - slanting(slanting[3], inv) - (inv ? 2 : 1)]);

    function drawGridItem(items, a, b, i, prev) = (items[0] == undef ? items : ((i >= len(items)) ? prev : drawGridItem(items, a, b, i+1, items[i][0] == undef ? items[i] : (inGridArea(a, b, items[i]) ? (items[i][4] == true ? false : true) : prev))));

    function isCornerZone(value, i) = (value < pillarGapCornerLength) || (value >= grid[i] - (pillarGapCornerLength + 1)); 
    function isMiddleZone(value, i) = (grid[i] >= pillarGapMiddle) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (grid[i] >= pillarGapMiddle) && (value == mid[i]);
    
    function drawCornerPillar(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddlePillar(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawPillarAuto(a, b) = ((a % 2==0) && (b % 2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawPillar(a, b) = !drawHoleZ(a, b) 
                                && !inSlantedArea(a, b, true) 
                                && ((pillars == "AUTO" && drawPillarAuto(a, b)) || (pillars != "AUTO" && drawGridItem(pillars, a, b, 0, false)));

    function drawKnob(a, b) = !inSlantedArea(a, b, false) 
                                && (!pit || (inPit(a, b) ? pitKnobs : ((a < floor(pWallThickness[0])) || (a > grid[0] - floor(pWallThickness[1]) - 1) || (b < floor(pWallThickness[2])) || (b > grid[1] - floor(pWallThickness[3]) - 1)) ) )
                                    && drawGridItem(knobs, a, b, 0, false); 

    function inPit(a,b) = pit && (a >= ceil(pWallThickness[0])) && (a < grid[0] - ceil(pWallThickness[1])) && (b >= ceil(pWallThickness[2])) && (b < grid[1] - ceil(pWallThickness[3]));                                

    function knobZ(a, b) = inPit(a, b) ? (pitFloorZ + 0.5 * knobHeight) : 0.5 * (resultingBaseHeight + knobHeight);

    function drawHoleX(a, b) = drawGridItem(holesX, a, b, 0, false); 
    function drawHoleY(a, b) = drawGridItem(holesY, a, b, 0, false); 
    function drawHoleZ(a, b) = drawGridItem(holesZ, a, b, 0, false); 
    
    function drawWallGapX(a, side, i) = (i < len(wallGapsX)) ? ((wallGapsX[i][0] == a && (side == wallGapsX[i][1] || wallGapsX[i][1] == 2)) ? (wallGapsX[i][2] == undef ? 1 : wallGapsX[i][2]) : drawWallGapX(a, side, i+1)) : 0; 
    
    function drawWallGapY(a, side, i) = (i < len(wallGapsY)) ? ((wallGapsY[i][0] == a && (side == wallGapsY[i][1] || wallGapsY[i][1] == 2)) ? (wallGapsY[i][2] == undef ? 1 : wallGapsY[i][2]) : drawWallGapY(a, side, i+1)) : 0; 
    
    function stabilizersXHeight(a) = stabilizerGridHeight + stabilizerGridOffset + (stabilizerExpansion > 0 && (holesX == false) && (((grid[0] > stabilizerExpansion + 1) && ((a % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[1] == 1)) ? max(baseCutoutDepth - stabilizerExpansionOffset - stabilizerGridHeight - stabilizerGridOffset, 0) : 0);
    
    function stabilizersYHeight(b) = stabilizerGridHeight + (stabilizerExpansion > 0 && (holesY == false) && (((grid[1] > stabilizerExpansion + 1) && ((b % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[0] == 1)) ? max(baseCutoutDepth - stabilizerExpansionOffset - stabilizerGridHeight, 0) : 0);
    
    function drawScrewHoleZ(a, b, i) = screwHolesZ == "all" || ((i < len(screwHolesZ)) && ( (a == screwHolesZ[i][0] && b == screwHolesZ[i][1]) || drawScrewHoleZ(a, b, i+1)));

    function sideX(side) = 0.5 * (sAdjustment[1] - sAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sAdjustment[3] - sAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;
    function sideZ(side) = (side - 0.5) * resultingBaseHeight;

    function decoratorX(side, depth, offsetHorizontal) = side < 2 ? ((depth > 0 ? (side - 0.5) * depth : 0) + sideX(side)) : offsetHorizontal * gridSizeXY;
    function decoratorY(side, depth, offsetVertical) = (side > 1 && side < 4) ? ((depth > 0 ? (side - 2 - 0.5) * depth : 0) + sideY(side - 2)) : (side > 3 && side < 6 ? offsetVertical*gridSizeXY : 0);
    function decoratorZ(side, depth, offsetVertical) = (side > 3 && side < 6) ? ((depth > 0 ? (side - 4 - 0.5) * depth : 0) + sideZ(side - 4)) : offsetVertical * gridSizeZ;
    /*
    * END Functions
    */

    knobRectX = posX(endX) - posX(startX) + tongueKnobSize;
    knobRectY = posY(endY) - posY(startY) + tongueKnobSize;

    translate([gridOffsetX, gridOffsetY, gridOffsetZ]){
        difference(){
            union(){
                if(baseCutoutType == "classic"){
                    union(){
                        difference() {
                            /*
                            * Base Block
                            */
                            color([0.945, 0.769, 0.059]) //f1c40f
                            mb_base(
                                grid = grid,
                                gridSizeXY = gridSizeXY,
                                objectSize = [objectSizeX, objectSizeY],
                                height = resultingBaseHeight,
                                baseSideAdjustment = sAdjustment,
                                roundingRadius = baseRoundingRadius, 
                                roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                pit = pit,
                                pitRoundingRadius = pitRoundingRadius,
                                pitDepth = resultingPitDepth,
                                pitWallThickness = pWallThickness,
                                pitWallGaps = pitWallGaps,
                                slanting = slanting,
                                slantingLowerHeight = slantingLowerHeight
                            );

                            mb_base_cutout(
                                grid = grid,
                                gridSizeXY = gridSizeXY,
                                baseHeight = resultingBaseHeight,
                                baseSideAdjustment = sAdjustment,
                                roundingRadius = baseCutoutRoundingRadius, 
                                roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                wallThickness = wallThickness,
                                topPlateHeight = resultingTopPlateHeight,
                                baseClampHeight = baseClampHeight,
                                baseClampThickness = baseClampThickness,
                                pit = pit,
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
                                                    cube([gapLength*gridSizeXY - 2*wallThickness + cutTolerance, 2 * (baseClampWallThickness + sAdjustment[2 + side] + cutTolerance), baseCutoutDepth + cutOffset], center=true); 
                                                
                                                    translate([-0.5 * (gapLength*gridSizeXY - 2*wallThickness), 0, -0.5 * (baseCutoutDepth - baseClampHeight) - 0.5 * cutOffset]) 
                                                        cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, baseClampHeight + cutOffset + cutTolerance], center=true);
                                                
                                                
                                                    translate([0.5 * (gapLength*gridSizeXY - 2*wallThickness), 0, -0.5 * (baseCutoutDepth - baseClampHeight) - 0.5 * cutOffset]) 
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
                                                    cube([2 * (baseClampWallThickness + sAdjustment[side] + cutTolerance), gapLength*gridSizeXY - 2 * wallThickness + cutTolerance, baseCutoutDepth + cutOffset], center=true);   
                                                
                                                    translate([0, -0.5 * (gapLength*gridSizeXY - 2 * wallThickness), -0.5 * (baseCutoutDepth - baseClampHeight) - 0.5 * cutOffset]) 
                                                        cube([2*(baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, baseClampHeight + cutOffset + cutTolerance], center=true);
                                                
                                                    translate([0, 0.5 * (gapLength*gridSizeXY - 2 * wallThickness), -0.5 * (baseCutoutDepth - baseClampHeight) - 0.5 * cutOffset]) 
                                                        cube([2 * (baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, baseClampHeight + cutOffset + cutTolerance], center=true);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        intersection(){
                            union(){
                                /*
                                * Adhesion Helpers
                                */
                                if(adhesionHelpers){
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
                                            
                                            if(pillars != false){
                                                /*
                                                * Cut TubeZ Area
                                                */
                                                for (a = [ startX : 1 : endX - 1 ]){
                                                    for (b = [ startY : 1 : endY - 1 ]){
                                                        if(drawPillar(a, b)){
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
                                if(topPlateHelpers){
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
                                if(stabilizerGrid){
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
                                                    if(drawScrewHoleZ(a, b, 0)){
                                                        translate([posX(a), posY(b)-0.5*(screwHoleZSize + screwHoleZHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight + screwHoleZHelperOffset)])
                                                            cube([gridSizeXY - stabilizerGridThickness, screwHoleZHelperThickness, screwHoleZHelperHeight + screwHoleZHelperOffset], center = true);
                                                        translate([posX(a), posY(b)+0.5*(screwHoleZSize + screwHoleZHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight + screwHoleZHelperOffset)])
                                                            cube([gridSizeXY - stabilizerGridThickness, screwHoleZHelperThickness, screwHoleZHelperHeight + screwHoleZHelperOffset], center = true);    
                                                        translate([posX(a)-0.5*(screwHoleZSize + screwHoleZHelperThickness), posY(b), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight)])
                                                            cube([screwHoleZHelperThickness, gridSizeXY - stabilizerGridThickness, screwHoleZHelperHeight], center = true);
                                                        translate([posX(a)+0.5*(screwHoleZSize + screwHoleZHelperThickness), posY(b), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight)])
                                                            cube([screwHoleZHelperThickness, gridSizeXY - stabilizerGridThickness, screwHoleZHelperHeight], center = true);    
                                                    } 
                                                }
                                            }
                                        }

                                        if(pillars != false){
                                            /*
                                            * Cut TubeZ area
                                            */
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                for (b = [ startY : 1 : endY - 1 ]){
                                                    if(drawPillar(a, b)){
                                                            translate([posX(a + 0.5), posY(b + 0.5), 0]){
                                                                cylinder(h=cutMultiplier * resultingBaseHeight, r=0.5 * tubeZSize - cutTolerance, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                                                            };
                                                    }
                                                }   
                                            }
                                        }
                                    }
                                }

                                if(pillars != false){
                                    /*
                                    * Middle Pins
                                    */
                                    //Middle Pin X
                                    if(endY == 0){
                                        color([0.953, 0.612, 0.071]) //f39c12
                                        for (a = [ startX : 1 : endX - 1 ]){
                                            if(drawPillar(a, 0)){
                                                translate([posX(a + 0.5), 0, baseCutoutZ]){
                                                    translate([0, 0, 0.5* baseClampHeight])
                                                        cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * pinSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                    translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                                        cylinder(h=baseClampHeight, r=0.5 * pinSize + pinClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                };
                                            }
                                        }
                                    }
                                    
                                    //Middle Pin Y
                                    if(endX == 0){
                                        color([0.953, 0.612, 0.071]) //f39c12
                                        for (b = [ startY : 1 : endY - 1 ]){
                                            if(drawPillar(0, b)){
                                                translate([0, posY(b + 0.5), baseCutoutZ]){
                                                    translate([0, 0, 0.5* baseClampHeight])
                                                        cylinder(h=baseCutoutDepth - baseClampHeight, r=0.5 * pinSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                    translate([0, 0, 0.5 * (baseClampHeight - baseCutoutDepth)])
                                                        cylinder(h=baseClampHeight, r=0.5 * pinSize + pinClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                };
                                            }
                                        }
                                    }
                                }
                                
                                //X-Holes Outer
                                if(holesX != false){
                                    color([0.953, 0.612, 0.071]) //f39c12
                                    for(r = [ 0 : 1 : holeXMaxRows-1]){
                                        for (a = [ startX : 1 : endX - 1 ]){
                                            if(drawHoleX(a, r)){
                                                translate([posX(a + 0.5), 0, -0.5*resultingBaseHeight + holeXGridOffsetZ*gridSizeZ + r * holeXGridSizeZ*gridSizeZ]){
                                                    rotate([90, 0, 0]){ 
                                                        cylinder(h=objectSizeY - 2*wallThickness, r=0.5 * tubeXSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                    }
                                                };
                                            }
                                        }
                                    }
                                }
                                
                                //Y-Holes Outer
                                if(holesY != false){
                                    color([0.953, 0.612, 0.071]) //f39c12
                                    for(r = [ 0 : 1 : holeYMaxRows-1]){
                                        for (b = [ startY : 1 : endY - 1 ]){
                                            if(drawHoleY(b, r)){
                                                translate([0, posY(b + 0.5), -0.5*resultingBaseHeight + holeYGridOffsetZ*gridSizeZ + r * holeYGridSizeZ*gridSizeZ]){
                                                    rotate([0, 90, 0]){ 
                                                        cylinder(h=objectSizeX - 2*wallThickness, r=0.5 * tubeYSize, center=true, $fn=($preview ? previewQuality : 1) * pillarResolution);
                                                    };
                                                };
                                            }
                                        }
                                    }
                                }
                                
                                if(holesZ != false){
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
                                }
                                
                                if(pillars != false){
                                    //Tubes with holes
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        for (b = [ startY : 1 : endY - 1 ]){
                                            if(drawPillar(a, b)){
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
                            if((baseCutoutRoundingRadius != 0) || (slanting != false)){
                                mb_base_cutout(
                                    grid = grid,
                                    gridSizeXY = gridSizeXY,
                                    baseHeight = resultingBaseHeight,
                                    baseSideAdjustment = sAdjustment,
                                    roundingRadius = baseCutoutRoundingRadius, 
                                    roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                    wallThickness = wallThickness,
                                    topPlateHeight = resultingTopPlateHeight,
                                    baseClampHeight = baseClampHeight,
                                    baseClampThickness = baseClampThickness,
                                    pit = pit,
                                    pitDepth = resultingPitDepth,
                                    slanting = slanting,
                                    slantingLowerHeight = slantingLowerHeight
                                );
                            }
                        } //End interception (for slanting only)
                    } //End union
                }
                else{
                    /*
                    * Solid Base Block
                    */
                    color([0.945, 0.769, 0.059]) //f1c40f
                        mb_base(
                            grid = grid,
                            gridSizeXY = gridSizeXY,
                            objectSize = [objectSizeX, objectSizeY],
                            height = resultingBaseHeight,
                            baseSideAdjustment = sAdjustment,
                            roundingRadius = baseRoundingRadius, 
                            roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                            pit = pit,
                            pitRoundingRadius = pitRoundingRadius,
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
                if(!isEmptyString(text) && textDepth > 0){
                    color([0.173, 0.243, 0.314]) //2c3e50
                        translate([decoratorX(textSide, textDepth, textOffset[0]), decoratorY(textSide, textDepth, textOffset[1]), decoratorZ(textSide, textDepth, textOffset[1])])
                            rotate(decoratorRotations[textSide])
                                mb_text3d(
                                    text = text,
                                    textDepth = textDepth,
                                    textSize = textSize,
                                    textFont = textFont,
                                    textSpacing = textSpacing,
                                    textVerticalAlign = textVerticalAlign,
                                    textHorizontalAlign = textHorizontalAlign,
                                    center = true
                                );
                }

                /*
                * SVG
                */
                if(!isEmptyString(svg) && svgDepth > 0){
                    color([0.173, 0.243, 0.314]) //2c3e50
                        translate([decoratorX(svgSide, svgDepth, svgOffset[0]), decoratorY(svgSide, svgDepth, svgOffset[1]), decoratorZ(svgSide, svgDepth, svgOffset[1])])
                            rotate(decoratorRotations[svgSide])
                                mb_svg3d(
                                    file = svg,
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
                                        
                                        if(knobType == "technic"){
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
                                            circleResolution = ($preview ? previewQuality : 1) * knobResolution,
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
                                            mb_rounded_block(
                                                size=[knobRectX + 2*tongueAdjustment, knobRectY + 2*tongueAdjustment, tongueHeight - tongueClampHeight], 
                                                center = true, 
                                                radius=[0,0,tongueRoundingRadius], 
                                                resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                                            );
                                            mb_rounded_block(
                                                size = [knobRectX - 2*tongueThickness, knobRectY - 2*tongueThickness, (tongueHeight - tongueClampHeight)*cutMultiplier], 
                                                center=true,
                                                radius=[0,0,pitRoundingRadius], 
                                                resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                                            );

                                        /*
                                        * Cut knobGrooveGaps
                                        */
                                        if(pit){
                                            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                                gap = pitWallGaps[gapIndex];
                                                if(gap[0] < 2){
                                                    translate([(-0.5 + gap[0]) * (knobRectX - tongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                                        cube([tongueThickness*cutMultiplier, pitSizeY - gap[1] - gap[2], (tongueHeight - tongueClampHeight)*cutMultiplier], center = true);
                                                }  
                                                else{
                                                    translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - tongueThickness), 0])
                                                        cube([pitSizeX - gap[1] - gap[2] , tongueThickness*cutMultiplier, (tongueHeight - tongueClampHeight)*cutMultiplier], center = true);     
                                                } 
                                            }  
                                        }
                                    }
                                }

                                //Tongue Clamp
                                translate([0, 0, 0.5 * (tongueHeight-tongueClampHeight)]){    
                                    difference(){       
                                        mb_rounded_block(
                                            size=[knobRectX + 2*tongueClampThickness + 2*tongueAdjustment, knobRectY + 2*tongueClampThickness + 2*tongueAdjustment, tongueClampHeight], 
                                            center = true, 
                                            radius=[0,0,tongueRoundingRadius], 
                                            resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                                        );
                                        mb_rounded_block(
                                            size = [knobRectX - 2*tongueThickness - 2*tongueClampThickness, knobRectY - 2*tongueThickness - 2*tongueClampThickness, tongueClampHeight*cutMultiplier], 
                                            center=true, 
                                            radius=[0,0,pitRoundingRadius], 
                                            resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                                        );
                                    
                                        /*
                                        * Cut knobGrooveGaps
                                        */
                                        if(pit){
                                            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                                gap = pitWallGaps[gapIndex];
                                                if(gap[0] < 2){
                                                    translate([(-0.5 + gap[0]) * (knobRectX - tongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                                        cube([(tongueThickness + 2*tongueClampThickness)*cutMultiplier, pitSizeY - gap[1] - gap[2]- 2*tongueClampThickness, tongueClampHeight*cutMultiplier], center = true);
                                                }  
                                                else{
                                                    translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - tongueThickness), 0])
                                                        cube([pitSizeX - gap[1] - gap[2] - 2*tongueClampThickness , (tongueThickness + 2*tongueClampThickness)*cutMultiplier, tongueClampHeight*cutMultiplier], center = true);     
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
                if(pcb){
                    translate([pcbOffset[0]*gridSizeXY, pcbOffset[1]*gridSizeXY, topPlateZ + 0.5*topPlateHeight]){
                        if(pcbMountingType == "clips"){
                            mb_pcb_clips(
                                pcbDimensions = pcbDimensions
                            );
                        }
                        if(pcbMountingType == "screws"){
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
            if(holesX != false){
                color([0.945, 0.769, 0.059]) //f1c40f
                for(r = [ 0 : 1 : holeXMaxRows-1]){
                    for (a = [ startX : 1 : endX - 1 ]){
                        if(drawHoleX(a, r)){
                            translate([posX(a + 0.5), 0, -0.5*resultingBaseHeight + holeXGridOffsetZ*gridSizeZ + r * holeXGridSizeZ*gridSizeZ]){
                                rotate([90, 0, 0]){ 
                                    cylinder(h=objectSizeY*cutMultiplier, r=0.5 * holeXSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                                    
                                    translate([0, 0, 0.5 * objectSizeY])
                                        cylinder(h=2*holeXInsetDepth, r=0.5 * (holeXSize + 2*holeXInsetThickness), center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                                    translate([0, 0, -0.5 * objectSizeY])
                                        cylinder(h=2*holeXInsetDepth, r=0.5 * (holeXSize + 2*holeXInsetThickness), center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                                };
                            };
                        }
                    }
                }
            }
            
            //Cut Y-Holes
            if(holesY != false){
                color([0.945, 0.769, 0.059]) //f1c40f
                for(r = [ 0 : 1 : holeYMaxRows-1]){
                    for (b = [ startY : 1 : endY - 1 ]){
                        if(drawHoleY(b, r)){
                            translate([0, posY(b + 0.5), -0.5*resultingBaseHeight + holeYGridOffsetZ*gridSizeZ + r * holeYGridSizeZ*gridSizeZ]){
                                rotate([0, 90, 0]){ 
                                    cylinder(h=objectSizeX*cutMultiplier, r=0.5 * holeYSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                                    
                                    translate([0, 0, 0.5 * objectSizeX])
                                        cylinder(h=2*holeYInsetDepth, r=0.5 * (holeYSize + 2*holeYInsetThickness), center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                                    translate([0, 0, -0.5 * objectSizeX])
                                        cylinder(h=2*holeYInsetDepth, r=0.5 * (holeYSize + 2*holeYInsetThickness), center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                                };
                            };
                        }
                    }
                }
            }
            
            if(holesZ != false){
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
            }
            
            /*
            * Text Cutout
            */
            if(!isEmptyString(text) && textDepth < 0){
                color([0.173, 0.243, 0.314]) //2c3e50
                    translate([decoratorX(textSide, textDepth, textOffset[0]), decoratorY(textSide, textDepth, textOffset[1]), decoratorZ(textSide, textDepth, textOffset[1])])
                        rotate(decoratorRotations[textSide])
                            mb_text3d(
                                text = text,
                                textDepth = 2 * abs(textDepth),
                                textSize = textSize,
                                textFont = textFont,
                                textSpacing = textSpacing,
                                textVerticalAlign = textVerticalAlign,
                                textHorizontalAlign = textHorizontalAlign,
                                center = true
                            );
            }

            /*
            * SVG Cutout
            */
            if(!isEmptyString(svg) && svgDepth < 0){
                color([0.173, 0.243, 0.314]) //2c3e50
                    translate([decoratorX(svgSide, svgDepth, svgOffset[0]), decoratorY(svgSide, svgDepth, svgOffset[1]), decoratorZ(svgSide, svgDepth, svgOffset[1])])
                        rotate(decoratorRotations[svgSide])
                            mb_svg3d(
                                file = svg,
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
            if(stabilizerGrid || (baseCutoutType == "none") || (baseCutoutType == "groove")){
                for (a = [ startX : 1 : endX ]){
                    for (b = [ startY : 1 : endY ]){
                        if(drawScrewHoleZ(a, b, 0)){
                            translate([posX(a), posY(b), 0.5*knobHeight])
                                cylinder(h = (resultingBaseHeight + knobHeight)*cutMultiplier, r = 0.5*screwHoleZSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
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
                        translate([posX(screwHolesX[b][0]), sideY(s) + (0.5 - s)*(screwHoleXDepth - cutOffset), xyScrewHolesZ + screwHolesX[b][1] * gridSizeZ])
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
                        translate([sideX(s) + (0.5 - s)*(screwHoleYDepth - cutOffset), posY(screwHolesY[b][0]), xyScrewHolesZ + screwHolesY[b][1] * gridSizeZ])
                            rotate([0, 90, 0])
                                cylinder(h = screwHoleYDepth + cutOffset, r = 0.5*screwHoleYSize, center=true, $fn=($preview ? previewQuality : 1) * holeResolution);
                    }
                }
            }

            /*
            * Cut Groove
            */
            if(baseCutoutType == "groove"){
                translate([0, 0, sideZ(0) + 0.5*tongueGrooveDepth]){ 
                    difference(){
                        union(){
                            translate([0, 0, -0.5 * tongueClampHeight]){
                                difference(){
                                    mb_rounded_block(
                                        size=[knobRectX + 2*tongueAdjustment, knobRectY + 2*tongueAdjustment, tongueGrooveDepth - tongueClampHeight + 2*cutOffset], 
                                        center = true,
                                        radius = [0,0,tongueRoundingRadius], 
                                        resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                                    );
                                    mb_rounded_block(
                                        size = [knobRectX - 2*tongueThickness, knobRectY - 2*tongueThickness, (tongueGrooveDepth - tongueClampHeight + 2*cutOffset)*cutMultiplier], 
                                        center=true,
                                        radius = [0,0,pitRoundingRadius], 
                                        resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                                    );
                                    /*
                                    * Cut knobGrooveGaps
                                    */
                                    for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                        gap = pitWallGaps[gapIndex];
                                        if(gap[0] < 2){
                                            translate([(-0.5 + gap[0]) * (knobRectX - tongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                                cube([tongueThickness*cutMultiplier, pitSizeY - gap[1] - gap[2], (tongueGrooveDepth - tongueClampHeight + 2*cutOffset)*cutMultiplier], center = true);
                                        }  
                                        else{
                                            translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - tongueThickness), 0])
                                                cube([pitSizeX - gap[1] - gap[2] , tongueThickness*cutMultiplier, (tongueGrooveDepth - tongueClampHeight + 2*cutOffset)*cutMultiplier], center = true);     
                                        } 
                                    }   
                                }
                            }
                            //Top Part with clamp
                            translate([0, 0, 0.5 * (tongueGrooveDepth - tongueClampHeight)]){    
                                difference(){       
                                    mb_rounded_block(
                                        size=[knobRectX + 2*tongueClampThickness + 2*tongueAdjustment, knobRectY + 2*tongueClampThickness + 2*tongueAdjustment, tongueClampHeight], 
                                        center = true,
                                        radius = [0,0,tongueRoundingRadius], 
                                        resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                                    );
                                    mb_rounded_block(
                                        size = [knobRectX - 2*tongueThickness - 2*tongueClampThickness, knobRectY - 2*tongueThickness - 2*tongueClampThickness, tongueClampHeight*cutMultiplier], 
                                        center=true,
                                        radius = [0,0,pitRoundingRadius], 
                                        resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                                    );
                                    /*
                                    * Cut knobGrooveGaps
                                    */
                                    for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                        gap = pitWallGaps[gapIndex];
                                        if(gap[0] < 2){
                                            translate([(-0.5 + gap[0]) * (knobRectX - tongueThickness), -0.5 * (gap[2] - gap[1]), 0])
                                                cube([(tongueThickness + 2*tongueClampThickness)*cutMultiplier, pitSizeY - gap[1] - gap[2]- 2*tongueClampThickness, tongueClampHeight*cutMultiplier], center = true);
                                        }  
                                        else{
                                            translate([-0.5 * (gap[2] - gap[1]), (-0.5 + gap[0] - 2) * (knobRectY - tongueThickness), 0])
                                                cube([pitSizeX - gap[1] - gap[2] - 2*tongueClampThickness , (tongueThickness + 2*tongueClampThickness)*cutMultiplier, tongueClampHeight*cutMultiplier], center = true);     
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
                                    cube([gapLength*gridSizeXY - (objectSizeX - (knobRectX + 2*tongueAdjustment)) + cutTolerance, (objectSizeY - (knobRectY + 2*tongueAdjustment) + sAdjustment[2 + side] + cutTolerance), tongueGrooveDepth + cutOffset], center=true); 
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
                                        cube([(objectSizeX - (knobRectX + 2*tongueAdjustment) + sAdjustment[side] + cutTolerance), gapLength*gridSizeXY - (objectSizeY - (knobRectY + 2*tongueAdjustment)) + cutTolerance, tongueGrooveDepth + cutOffset], center=true);   
                            }
                        }
                    }
                }   
            }
        }

        
    } //End translate brick offset

} // End module block    

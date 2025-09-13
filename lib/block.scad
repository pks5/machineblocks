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
use <axis.scad>;
use <utils.scad>;
use <bevel.scad>;
use <rounded.scad>;
use <quad.scad>;
use <polygon.scad>;
use <tongue.scad>;

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
        baseClampOffset = 0.4, //mm
        baseRoundingRadius = 0.0, //e.g. 4 or [4, 4, 4] or [4, [4, 4, 4, 4], [4,4,4,4]]
        baseCutoutRoundingRadius = -1.5, //e.g 2.7 or [2.7, 2.7, 2.7, 2.7] 
        baseRoundingResolution = 64,
        baseReliefCut = false,
        baseReliefCutHeight = 0.4,
        baseReliefCutThickness = 0.4,
        
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
        topPlateHelperHeight = 0.2, //mm
        topPlateHelperThickness = 0.4, //mm

        //Bevel
        //TODO rename slanting to bevelVertical
        slanting = false,
        slantingLowerHeight = 2, //mm
        bevelHorizontal = [[0, 0], [0, 0], [0, 0], [0, 0]],

        //Stabilizers
        stabilizerGrid = true,
        stabilizerGridOffset = 0.2, //mm
        stabilizerGridHeight = 0.8, //mm
        stabilizerGridThickness = 0.8, //mm
        stabilizerExpansion = 2,
        stabilizerExpansionOffset = 1.8, //mm
        
        //Pillars: Tubes and Pins
        pillars = true,
        pillarRoundingResolution = 64,
        pillarGapCornerLength = 2,
        pillarGapMiddle = 10,
        
        //Pins (little tubes for blocks with 1 brick side length)
        pinSize = 3.2, //mm
        pinClampThickness = 0.1, //mm
        pinClampOffset = 0.4, //mm
        pinClampHeight = 0.8, //mm

        //Tubes
        tubeXSize = 6.4, //mm
        tubeYSize = 6.4, //mm
        tubeZSize = 6.4, //mm
        tubeInnerClampThickness = 0.1, //mm
        tubeOuterClampThickness = 0.1, //mm
        tubeOuterClampOffset = 0.4, //mm
        tubeOuterClampHeight = 0.8, //mm

        //Holes
        holesX = false,
        holeXType = "technic",
        holeXCentered = true,
        holeXSize = 5.1, //mm
        holeXInsetThickness = 0.6, //mm
        holeXInsetDepth = 0.9, //mm
        holeXGridOffsetZ = 1.75, //Multiplier of gridSizeZ
        holeXGridSizeZ = 3, //Multiplier of gridSizeZ
        holeXMinTopMargin = 0.8, //mm

        holesY = false,
        holeYType = "technic",
        holeYCentered = true,
        holeYSize = 5.1, //mm
        holeYInsetThickness = 0.55, //mm
        holeYInsetDepth = 0.9, //mm
        holeYGridOffsetZ = 1.75, //Multiplier of gridSizeZ
        holeYGridSizeZ = 3, //Multiplier of gridSizeZ
        holeYMinTopMargin = 0.8, //mm

        holesZ = false,
        holeZType = "technic",
        holeZSize = 5.1, //mm
        holeRoundingResolution = 64,
        
        //Knobs
        knobs = true,
        knobType = "classic",
        knobCentered = false,
        knobSize = 5.0, //mm
        knobCutSize = 5.0,
        knobHeight = 1.8, //mm
        knobCutHeight = 2.2,
        knobClampHeight = 0.8, //mm
        knobClampThickness = 0.0, //mm
        knobHoleSize = 3.5, //mm
        knobHoleClampThickness = 0.1, //mm
        knobRounding = 0.1, //mm
        knobRoundingResolution = 64,
        knobMaxOverhang = 0.3,
        
        //Tongue
        tongue = false,
        tongueHeight = 2.0, //mm
        tongueRoundingRadius = "auto", //mm, e.g 3.4 or [3.4, 3.4, 3.4, 3.4] 
        tongueInnerRoundingRadius = "auto", //mm, e.g 3.4 or [3.4, 3.4, 3.4, 3.4] 
        tongueThickness = 1.1, //mm
        tongueThicknessAdjustment = 0,
        tongueOffset = 1.5, //mm (0.5 * (gridSizeXY - referenceKnobSize))
        tongueClampHeight = 0.8, //mm
        tongueClampOffset = 0.4, //mm
        tongueClampThickness = 0.1, //mm
        tongueGrooveDepth = 2.4, //mm
        
        //Pit
        pit=false,
        pitRoundingRadius = "auto", //e.g 2.7 or [2.7, 2.7, 2.7, 2.7]  
        pitDepth = 0.0, //mm
        pitWallThickness = 0.333, //Format: 0.333 or [0.333, 0.333, 0.333, 0.333], Multipliers of gridSizeXY
        pitKnobs=true,
        pitKnobType = "classic",
        pitKnobCentered = false,
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

        connectors = [],
        connectorHeight = 0,
        connectorDepth = 1.4,
        connectorSize = 4.0,
        connectorDepthTolerance = 0.2,
        connectorSideTolerance = 0.1,

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
        
        //Preview
        previewQuality = 0.5 //Between 0.0 and 1.0
        ){
            
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;
       
    //Side Adjustment
    sAdjustment = mb_resolve_base_side_adjustment(baseSideAdjustment);

    //Object Size     
    objectSizeX = gridSizeXY * grid[0];
    objectSizeY = gridSizeXY * grid[1];

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSizeX + sAdjustment[0] + sAdjustment[1];
    objectSizeYAdjusted = objectSizeY + sAdjustment[2] + sAdjustment[3];

    //Base Height
    resultingBaseHeight = baseLayers * baseHeight + baseHeightAdjustment;

    gridSizeX = slanting != false ? grid[0] + (slanting[0] < 0 ? slanting[0] : 0) + (slanting[1] < 0 ? slanting[1] : 0) : grid[0];
    gridSizeY = slanting != false ? grid[1] + (slanting[2] < 0 ? slanting[2] : 0) + (slanting[3] < 0 ? slanting[3] : 0) : grid[1];


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
    baseRoundingRadiusZ = mb_base_rounding_radius_z(radius = baseRoundingRadius);
    cutoutRoundingRadius = mb_base_cutout_radius(baseCutoutRoundingRadius, baseRoundingRadiusZ);
                                    
    //Calculate Z Positions
    baseCutoutZ = -0.5 * (resultingBaseHeight - baseCutoutDepth);        
    topPlateZ = baseCutoutZ + 0.5 * (resultingBaseHeight - resultingPitDepth);
    xyScrewHolesZ = -0.5 * resultingBaseHeight + 0.5 * gridSizeZ;
    pitFloorZ = 0.5 * resultingBaseHeight - resultingPitDepth;

    //Holes XY
    holeXBottomMargin = holeXGridOffsetZ*gridSizeZ - 0.5*(holeXSize + 2*holeXInsetThickness);
    holeXMaxRows = ceil((resultingBaseHeight - holeXBottomMargin - holeXMinTopMargin) / (holeXGridSizeZ*gridSizeZ)); 

    holeYBottomMargin = holeYGridOffsetZ*gridSizeZ - 0.5*(holeYSize + 2*holeYInsetThickness);
    holeYMaxRows = ceil((resultingBaseHeight - holeYBottomMargin - holeYMinTopMargin) / (holeYGridSizeZ*gridSizeZ)); 

    bevelOuter = mb_resolve_bevel_horizontal(bevelHorizontal, grid, gridSizeXY);
    bevelOuterAdjusted = mb_inset_quad_lrfh(bevelOuter, [-sAdjustment[0], -sAdjustment[1], -sAdjustment[2], -sAdjustment[3]]);
    bevelInner = mb_inset_quad_lrfh(bevelOuter, [wallThickness, wallThickness, wallThickness, wallThickness]);
    pitBevel = mb_inset_quad_lrfh(bevelOuter, [pWallThickness[0]*gridSizeXY+knobMaxOverhang, pWallThickness[1]*gridSizeXY+knobMaxOverhang, pWallThickness[2]*gridSizeXY+knobMaxOverhang, pWallThickness[3]*gridSizeXY+knobMaxOverhang]);
    
    pitBevelKnobs = mb_inset_quad_lrfh(bevelOuter, [pWallThickness[0]*gridSizeXY + wallThickness, pWallThickness[1]*gridSizeXY + wallThickness, pWallThickness[2]*gridSizeXY + wallThickness, pWallThickness[3]*gridSizeXY + wallThickness]);
    pMinThickness = [-min(pWallThickness[2], pWallThickness[0])*gridSizeXY, -min(pWallThickness[0], pWallThickness[3])*gridSizeXY, -min(pWallThickness[3], pWallThickness[1])*gridSizeXY, -min(pWallThickness[1], pWallThickness[2])*gridSizeXY];
    pitRadius = mb_base_cutout_radius(pitRoundingRadius == "auto" ? pMinThickness : pitRoundingRadius, baseRoundingRadiusZ);            
    
    corners = mb_resolve_bevel_horizontal([[0,0],[0,0],[0,0],[0,0]], grid, gridSizeXY);
    cornersAdjusted = mb_inset_quad_lrfh(corners, [-sAdjustment[0], -sAdjustment[1], -sAdjustment[2], -sAdjustment[3]]);
    cornersInner = mb_inset_quad_lrfh(corners, [wallThickness, wallThickness, wallThickness, wallThickness]);

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
    

    function posX(a) = (a - offsetX) * gridSizeXY;
    function posY(b) = (b - offsetY) * gridSizeXY;

    function sideX(side) = 0.5 * (sAdjustment[1] - sAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sAdjustment[3] - sAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;
    function sideZ(side) = (side - 0.5) * resultingBaseHeight;

    /*
    * Grid
    */
    function inGridArea(a, b, rect) = (a >= rect[0]) && (b >= rect[1]) && (a <= rect[2]) && (b <= rect[3]); //[x0, y0, x1, y1]
    function drawGridItem(items, a, b, i, prev) = (items[0] == undef ? items : ((i >= len(items)) ? prev : drawGridItem(items, a, b, i+1, items[i][0] == undef ? items[i] : (inGridArea(a, b, items[i]) ? (items[i][4] == true ? false : true) : prev))));

    /*
    * Slanting
    */
    function slanting(s, inv) = inv ? (s > 0 ? 0 : abs(s)) : (s < 0 ? 0 : s);
    function inSlantedArea(a, b, inv, qx, qy) = (slanting != false) && !inGridArea(a, b, [slanting(slanting[0], inv), slanting(slanting[2], inv), grid[0] - slanting(slanting[1], inv) - (inv ? qx : 1), grid[1] - slanting(slanting[3], inv) - (inv ? qy : 1)]);

    
    /*
    * Pillars / Pins
    */
    function isCornerZone(value, i) = (value < pillarGapCornerLength) || (value >= grid[i] - (pillarGapCornerLength + 1)); 
    function isMiddleZone(value, i) = (grid[i] >= pillarGapMiddle) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (grid[i] >= pillarGapMiddle) && (value == mid[i]);
    
    function drawCornerPillar(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddlePillar(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawPillarAuto(a, b) = ((a % 2==0) && (b % 2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawPillar(a, b) = !drawHoleZ(a, b) 
                                && !inSlantedArea(a, b, true, 2, 2) 
                                && ((pillars == "auto" && drawPillarAuto(a, b)) || (pillars != "auto" && drawGridItem(pillars, a, b, 0, false)));

    function drawPin(a, b, isX) = !drawHoleZ(a, b) 
                                && !inSlantedArea(a, b, true, isX ? 2 : 0, isX ? 0 : 2) 
                                && ((pillars == "auto" && drawPillarAuto(a, b)) || (pillars != "auto" && drawGridItem(pillars, a, b, 0, false)));

    
    /*
    * Pit
    */
    function onPitBorder(a, b) = mb_circle_in_convex_quad(bevelOuterAdjusted, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = knobMaxOverhang)
                                && !mb_circle_in_convex_quad(pitBevel, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, touch=true, overhang=0);
    
    //((ceil(a) < floor(pWallThickness[0])) || (floor(a) > grid[0] - floor(pWallThickness[1]) - 1) || (ceil(b) < floor(pWallThickness[2])) || (floor(b) > grid[1] - floor(pWallThickness[3]) - 1)) && !inPitWallGaps(a, b, true, 0);
    function inPit(a, b) = mb_circle_in_convex_quad(pitBevelKnobs, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = knobMaxOverhang)
                        && mb_circle_in_rounded_rect(pitBevelKnobs, pitRadius, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = knobMaxOverhang);
    
    //(floor(a) >= ceil(pWallThickness[0])) && (ceil(a) < grid[0] - ceil(pWallThickness[1])) && (floor(b) >= ceil(pWallThickness[2])) && (ceil(b) < grid[1] - ceil(pWallThickness[3])) || inPitWallGaps(a, b, false, 0);                                
    
    function inPitWallGaps(a, b, mx, i) = (i < len(pitWallGaps)) && (inPitWallGap(a, b, pitWallGaps[i], mx) || inPitWallGaps(a, b, mx, i+1));
    
    function mxRound(v, mx) = mx ? floor(v) : ceil(v);
    function inPitWallGap(a, b, gap, mx) = ((gap[0] == 0) && inPitWallGap0(a, b, gap, mx)) || ((gap[0] == 1) && inPitWallGap1(a, b, gap, mx)) || ((gap[0] == 2) && inPitWallGap2(a, b, gap, mx)) || ((gap[0] == 3) && inPitWallGap3(a, b, gap, mx));
    function inPitWallGap0(a, b, gap, mx) = (floor(a) >= 0) && (ceil(a) < floor(pWallThickness[0])) && (floor(b) >= mxRound(pWallThickness[2] + gap[1], mx)) && (ceil(b) < grid[1] - mxRound(pWallThickness[3] + gap[2], mx));                                
    function inPitWallGap1(a, b, gap, mx) = (floor(a) >= grid[0] - ceil(pWallThickness[1])) && (ceil(a) < grid[0]) && (floor(b) >= mxRound(pWallThickness[2] + gap[1], mx)) && (ceil(b) < grid[1] - mxRound(pWallThickness[3] + gap[2], mx));                                
    function inPitWallGap2(a, b, gap, mx) = (floor(b) >= 0) && (ceil(b) < floor(pWallThickness[2])) && (floor(a) >= mxRound(pWallThickness[0] + gap[1], mx)) && (ceil(a) < grid[0] - mxRound(pWallThickness[1] + gap[2], mx));                                
    function inPitWallGap3(a, b, gap, mx) = (floor(b) >= grid[1] - ceil(pWallThickness[3])) && (ceil(b) < grid[1]) && (floor(a) >= mxRound(pWallThickness[0] + gap[1], mx)) && (ceil(a) < grid[0] - mxRound(pWallThickness[1] + gap[2], mx));                                
    
    /*
    * Knobs
    */ 
    function drawKnob(a, b) = 
            !inSlantedArea(a, b, false, 2)
            && mb_circle_in_rounded_rect(cornersAdjusted, baseRoundingRadiusZ, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = knobMaxOverhang)
            && mb_circle_in_convex_quad(bevelOuterAdjusted, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = knobMaxOverhang)
            ;

    function knobZ(a, b) = pit && inPit(a, b) ? (pitFloorZ + 0.5 * knobHeight) : 0.5 * (resultingBaseHeight + knobHeight);
    function knobType(a, b) = pit && inPit(a, b) ? pitKnobType : knobType;

    /*
    * XYZ Holes
    */
    function drawHoleX(a, b) = drawGridItem(holesX, a, b, 0, false); 
    function drawHoleY(a, b) = drawGridItem(holesY, a, b, 0, false); 
    function drawHoleZ(a, b) = drawGridItem(holesZ, a, b, 0, false); 
    
    /*
    * Wall Gaps
    */
    function drawWallGapX(a, side, i) = (i < len(wallGapsX)) ? ((wallGapsX[i][0] == a && (side == wallGapsX[i][1] || wallGapsX[i][1] == 2)) ? (wallGapsX[i][2] == undef ? 1 : wallGapsX[i][2]) : drawWallGapX(a, side, i+1)) : 0; 
    function drawWallGapY(a, side, i) = (i < len(wallGapsY)) ? ((wallGapsY[i][0] == a && (side == wallGapsY[i][1] || wallGapsY[i][1] == 2)) ? (wallGapsY[i][2] == undef ? 1 : wallGapsY[i][2]) : drawWallGapY(a, side, i+1)) : 0; 
    
    /*
    * Stabilizer Grid
    */
    function stabilizersXHeight(a) = stabilizerGridHeight + stabilizerGridOffset + (stabilizerExpansion > 0 && (holesX == false) && (((grid[0] > stabilizerExpansion + 1) && ((a % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[1] == 1)) ? max(baseCutoutDepth - stabilizerExpansionOffset - stabilizerGridHeight - stabilizerGridOffset, 0) : 0);
    function stabilizersYHeight(b) = stabilizerGridHeight + (stabilizerExpansion > 0 && (holesY == false) && (((grid[1] > stabilizerExpansion + 1) && ((b % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[0] == 1)) ? max(baseCutoutDepth - stabilizerExpansionOffset - stabilizerGridHeight, 0) : 0);
    
    /*
    * Screw Holes
    */
    function drawScrewHoleZ(a, b, i) = screwHolesZ == "all" || ((i < len(screwHolesZ)) && ( (a == screwHolesZ[i][0] && b == screwHolesZ[i][1]) || drawScrewHoleZ(a, b, i+1)));

    /*
    * Decorators
    */
    function decoratorX(side, depth, offsetHorizontal) = side < 2 ? ((depth > 0 ? (side - 0.5) * depth : 0) + sideX(side)) : offsetHorizontal * gridSizeXY;
    function decoratorY(side, depth, offsetVertical) = (side > 1 && side < 4) ? ((depth > 0 ? (side - 2 - 0.5) * depth : 0) + sideY(side - 2)) : (side > 3 && side < 6 ? offsetVertical*gridSizeXY : 0);
    function decoratorZ(side, depth, offsetVertical) = (side > 3 && side < 6) ? ((depth > 0 ? (side - 4 - 0.5) * depth : 0) + sideZ(side - 4)) : offsetVertical * gridSizeZ;
    
    /*
    * END Functions
    */

    echo(
        preview= $preview,
        previewQuality = previewQuality,
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
        xyScrewHolesZ = xyScrewHolesZ,
        pitFloorZ = pitFloorZ,
        bevelOuterAdjusted = bevelOuterAdjusted
    );

    /*
    * START BLOCK
    */
    translate([gridOffsetX, gridOffsetY, gridOffsetZ]){
        union(){

            color([0.945, 0.769, 0.059]) //f1c40f
            difference(){
                union(){
                    if(baseCutoutType == "classic"){
                        difference() {
                            /*
                            * Base Block
                            */
                            mb_base(
                                grid = grid,
                                gridSizeXY = gridSizeXY,
                                objectSize = [objectSizeX, objectSizeY],
                                height = resultingBaseHeight,
                                baseSideAdjustment = sAdjustment,
                                baseReliefCut = baseReliefCut,
                                baseReliefCutHeight = baseReliefCutHeight,
                                baseReliefCutThickness = baseReliefCutThickness,
                                roundingRadius = baseRoundingRadius, 
                                roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                pit = pit,
                                pitRoundingRadius = pitRoundingRadius,
                                pitDepth = resultingPitDepth,
                                pitWallThickness = pWallThickness,
                                pitWallGaps = pitWallGaps,
                                slanting = slanting,
                                slantingLowerHeight = slantingLowerHeight,
                                bevelHorizontal = bevelHorizontal,
                                bevelOuter = bevelOuter,
                                bevelOuterAdjusted = bevelOuterAdjusted,
                                connectors = connectors,
                                connectorHeight = connectorHeight,
                                connectorDepth = connectorDepth,
                                connectorSize = connectorSize,
                                connectorDepthTolerance = connectorDepthTolerance,
                                connectorSideTolerance = connectorSideTolerance
                            );

                            /*
                            * Subtract base cutout
                            */
                            difference(){
                                
                                mb_base_cutout(
                                    grid = grid,
                                    gridSizeXY = gridSizeXY,
                                    
                                    baseHeight = resultingBaseHeight,
                                    baseSideAdjustment = sAdjustment,
                                    baseRoundingRadiusZ = baseRoundingRadiusZ,
                                    baseCutoutDepth = baseCutoutDepth,
                                    baseClampHeight = baseClampHeight,
                                    baseClampThickness = baseClampThickness,
                                    baseClampOffset = baseClampOffset,
                                    
                                    cutoutRoundingRadius = cutoutRoundingRadius,
                                    roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                    
                                    wallThickness = wallThickness,
                                    
                                    topPlateZ = topPlateZ,
                                    topPlateHeight = resultingTopPlateHeight,
                                    topPlateHelpers = topPlateHelpers,
                                    topPlateHelperHeight = topPlateHelperHeight,
                                    topPlateHelperThickness = topPlateHelperThickness,
                                    
                                    pit = pit,
                                    pitDepth = resultingPitDepth,
                                    
                                    slanting = slanting,
                                    slantingLowerHeight = slantingLowerHeight,
                                    bevelHorizontal = bevelHorizontal,
                                    bevelOuter = bevelOuter,
                                    bevelInner = bevelInner
                                );

                                /*
                                * Plate Helpers
                                */
                                if(topPlateHelpers){
                                    bevelTopPlateHelper = mb_inset_quad_lrfh(bevelOuter, [wallThickness + topPlateHelperThickness, wallThickness + topPlateHelperThickness, wallThickness + topPlateHelperThickness, wallThickness + topPlateHelperThickness]);
                                    topPlateHelperRoundingRadius = mb_base_cutout_radius(- wallThickness - topPlateHelperThickness, baseRoundingRadiusZ);

                                    translate([0, 0, topPlateZ - 0.5 * (resultingTopPlateHeight + topPlateHelperHeight) + 0.5 * cutOffset]){
                                        difference(){
                                            cube(
                                                size = [objectSizeX, objectSizeY, topPlateHelperHeight + cutOffset], 
                                                center=true
                                            );

                                            intersection(){
                                                make_bevel(bevelTopPlateHelper, cutMultiplier * (topPlateHelperHeight + cutOffset));
                                    
                                                mb_rounded_block(
                                                    size = [objectSizeX - 2*wallThickness - 2*topPlateHelperThickness, objectSizeY - 2*wallThickness - 2*topPlateHelperThickness, cutMultiplier * (topPlateHelperHeight + cutOffset)], 
                                                    center=true, 
                                                    resolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                                    radius = topPlateHelperRoundingRadius
                                                );
                                            }

                                            for (a = [ startX : 1 : endX ]){
                                                for (side = [ 0 : 1 : 1 ]){
                                                    gapLength = drawWallGapX(a, side, 0);
                                                    if(gapLength > 0){
                                                        translate([posX(a + 0.5*(gapLength-1)), sideY(side), 0]){
                                                            cube([
                                                                gapLength*gridSizeXY - 2*wallThickness - 2*topPlateHelperThickness + cutTolerance, 
                                                                2*(wallThickness + topPlateHelperThickness) + cutTolerance, 
                                                                cutMultiplier * (topPlateHelperHeight + cutOffset)
                                                            ], center=true); 
                                                        }
                                                    }
                                                }
                                            }

                                            /*
                                            * Groove Wall Gaps Y
                                            */
                                            //color([0.608, 0.349, 0.714]) //9b59b6
                                            for (b = [ startY : 1 : endY ]){
                                                for (side = [ 0 : 1 : 1 ]){
                                                    gapLength = drawWallGapY(b, side, 0);
                                                    if(gapLength > 0){
                                                        translate([sideX(side), posY(b + 0.5*(gapLength-1)), 0]){
                                                            cube([
                                                                2*(wallThickness + topPlateHelperThickness) + cutTolerance, 
                                                                gapLength*gridSizeXY - 2*wallThickness - 2*topPlateHelperThickness + cutTolerance, 
                                                                cutMultiplier * (topPlateHelperHeight + cutOffset)
                                                            ], center=true);   
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                if(stabilizerGrid){
                                    difference(){
                                        /*
                                        * Stabilizer Grid
                                        */
                                        union(){
                                            //Helpers X
                                            for (a = [ 0 : 1 : grid[0] - 2 ]){
                                                translate([posX(a + 0.5), 0, topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersXHeight(a)) + 0.5 * cutOffset]){ 
                                                    cube([stabilizerGridThickness, objectSizeY, stabilizersXHeight(a) + cutOffset], center = true);
                                                }
                                            }
                                            
                                            //Helpers Y
                                            for (b = [ 0 : 1 : grid[1] - 2 ]){
                                            translate([0, posY(b + 0.5), topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersYHeight(b)) + 0.5 * cutOffset]){
                                                    cube([objectSizeX, stabilizerGridThickness, stabilizersYHeight(b) + cutOffset], center = true);
                                                };
                                            }
                                        } // End union stabilizer grid

                                        /*
                                        * Pillar cutouts from stabilizer grid
                                        */
                                        if(pillars != false){
                                            /*
                                            * Cut TubeZ area
                                            */
                                            
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                for (b = [ startY : 1 : endY - 1 ]){
                                                    if(drawPillar(a, b)){
                                                            translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ + cutTolerance]){
                                                                cylinder(h=baseCutoutDepth, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                            };
                                                    }
                                                }   
                                            }

                                            for (a = [ startX : 1 : endX ]){
                                                for (side = [ 0 : 1 : 1 ]){
                                                    gapLength = drawWallGapX(a, side, 0);

                                                    if(gapLength > 1){
                                                        for (p = [ 0 : 1 : gapLength - 2 ]){
                                                            if(side == 0 || side == 2){
                                                                translate([posX(a + p + 0.5), posY(-0.5), baseCutoutZ + cutTolerance]){
                                                                    cylinder(h=baseCutoutDepth, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                                };
                                                            }
                                                            if(side == 1 || side == 2){
                                                                translate([posX(a + p + 0.5), posY(endY + 0.5), baseCutoutZ + cutTolerance]){
                                                                    cylinder(h=baseCutoutDepth, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                                };
                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                            for (b = [ startY : 1 : endY ]){
                                                for (side = [ 0 : 1 : 1 ]){
                                                    gapLength = drawWallGapY(b, side, 0);

                                                    if(gapLength > 1){
                                                        for (p = [ 0 : 1 : gapLength - 2 ]){
                                                            if(side == 0 || side == 2){
                                                                translate([posX(-0.5), posY(b + p + 0.5), baseCutoutZ + cutTolerance]){
                                                                    cylinder(h=baseCutoutDepth, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                                };
                                                            }
                                                            if(side == 1 || side == 2){
                                                                translate([posX(endX + 0.5), posY(b + p + 0.5), baseCutoutZ + cutTolerance]){
                                                                    cylinder(h=baseCutoutDepth, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                                };
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } // End Pillars Cutouts from stabilizer grid
                                    } // End difference stabilizer Grid

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
                                } // End stabilizer grid

                                if(pillars != false){
                                    //Tubes with holes
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        for (b = [ startY : 1 : endY - 1 ]){
                                            if(drawPillar(a, b)){
                                                translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ]){
                                                    difference(){
                                                        union(){
                                                            cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * tubeZSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                            
                                                            //Clamp
                                                            translate([0, 0, tubeOuterClampOffset + 0.5 * (tubeOuterClampHeight - baseCutoutDepth)])
                                                                cylinder(h=tubeOuterClampHeight, r=0.5 * tubeZSize + tubeOuterClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                        }
                                                        intersection(){
                                                            cylinder(h=baseCutoutDepth*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                            cube([holeZSize-2*tubeInnerClampThickness, holeZSize-2*tubeInnerClampThickness, baseCutoutDepth *cutMultiplier], center=true);
                                                        };
                                                    }
                                                };
                                            }
                                        }
                                    }
                                }

                                if(pillars != false){
                                    /*
                                    * Middle Pins
                                    */
                                    //Middle Pin X
                                    if(gridSizeX > 1 && gridSizeY == 1){
                                        for (b = [ startY : 1 : endY ]){
                                            for (a = [ startX : 1 : endX - 1 ]){
                                                if(drawPin(a, b, true)){
                                                    translate([posX(a + 0.5), posY(b), baseCutoutZ]){
                                                        cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * pinSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                        translate([0, 0, pinClampOffset + 0.5 * (pinClampHeight - baseCutoutDepth)])
                                                            cylinder(h=pinClampHeight, r=0.5 * pinSize + pinClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                    };
                                                }
                                            }
                                        }
                                    }
                                    
                                    //Middle Pin Y
                                    if(gridSizeX == 1 && gridSizeY > 1){
                                        for (a = [ startX : 1 : endX]){
                                            for (b = [ startY : 1 : endY - 1 ]){
                                                if(drawPin(a, b, false)){
                                                    translate([posX(a), posY(b + 0.5), baseCutoutZ]){
                                                        cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * pinSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                        translate([0, 0, pinClampOffset + 0.5 * (pinClampHeight - baseCutoutDepth)])
                                                            cylinder(h=pinClampHeight, r=0.5 * pinSize + pinClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                    };
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                //X-Holes Outer
                                if(holesX != false){
                                    for(r = [ 0 : 1 : holeXMaxRows-1]){
                                        for (a = [ startX : 1 : endX - (holeXCentered ? 1 : 0) ]){
                                            if(drawHoleX(a, r)){
                                                translate([posX(a + (holeXCentered ? 0.5 : 0)), 0, -0.5*resultingBaseHeight + holeXGridOffsetZ*gridSizeZ + r * holeXGridSizeZ*gridSizeZ]){
                                                    rotate([90, 0, 0]){ 
                                                        cylinder(h=objectSizeY - 2*wallThickness, r=0.5 * tubeXSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                    }
                                                };
                                            }
                                        }
                                    }
                                }
                                
                                //Y-Holes Outer
                                if(holesY != false){
                                    for(r = [ 0 : 1 : holeYMaxRows-1]){
                                        for (b = [ startY : 1 : endY - (holeYCentered ? 1 : 0) ]){
                                            if(drawHoleY(b, r)){
                                                translate([0, posY(b + (holeYCentered ? 0.5 : 0)), -0.5*resultingBaseHeight + holeYGridOffsetZ*gridSizeZ + r * holeYGridSizeZ*gridSizeZ]){
                                                    rotate([0, 90, 0]){ 
                                                        cylinder(h=objectSizeX - 2*wallThickness, r=0.5 * tubeYSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
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
                                    for (a = [ startX : 1 : endX - 1 ]){
                                        for (b = [ startY : 1 : endY - 1 ]){
                                            if(drawHoleZ(a, b)){
                                                translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ]){
                                                    cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * tubeZSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                    
                                                    //Clamp
                                                    translate([0, 0, tubeOuterClampOffset + 0.5 * (tubeOuterClampHeight - baseCutoutDepth)])
                                                        cylinder(h=tubeOuterClampHeight, r=0.5 * tubeZSize + tubeOuterClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                };
                                            }
                                        }   
                                    }
                                }
                            } // End Difference Base Cutout

                            
                            
                            /*
                            * Final Subtraction from the resulting hollowed base
                            */
                            difference(){
                                union(){
                                    for (a = [ startX : 1 : endX ]){
                                        for (b = [ startY : 1 : endY ]){
                                            if(!mb_circle_in_rounded_rect(cornersInner, baseRoundingRadiusZ, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = knobMaxOverhang)
                                                || !mb_circle_in_convex_quad(bevelInner, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = knobMaxOverhang)){
                                                translate([posX(a), posY(b), -0.5 * resultingBaseHeight + 0.5 * knobCutHeight]){
                                                    if(baseClampOffset > 0){
                                                        translate([0,0, -0.5 * (cutOffset + knobCutHeight - baseClampOffset)])
                                                            cylinder(h=baseClampOffset + cutOffset, r=0.5 * knobCutSize, center=true, $fn=($preview ? previewQuality : 1) * knobRoundingResolution);
                                                    }
                                                    translate([0,0,-0.5*cutOffset])
                                                        cylinder(h=knobCutHeight + cutOffset, r=0.5 * (knobCutSize - baseClampThickness), center=true, $fn=($preview ? previewQuality : 1) * knobRoundingResolution);
                                                    
                                                    translate([0,0, 0.5*(knobCutHeight - baseClampOffset - baseClampHeight)+ 0.5*cutOffset ])
                                                        cylinder(h=knobCutHeight - baseClampOffset - baseClampHeight, r=0.5 * knobCutSize, center=true, $fn=($preview ? previewQuality : 1) * knobRoundingResolution);
                                                }
                                            }
                                        }
                                    }

                                    /*
                                    * Wall Gaps X
                                    */
                                    //color([0.608, 0.349, 0.714]) //9b59b6
                                    for (a = [ startX : 1 : endX ]){
                                        for (side = [ 0 : 1 : 1 ]){
                                            gapLength = drawWallGapX(a, side, 0);
                                            if(gapLength > 0){
                                                translate([posX(a + 0.5*(gapLength-1)), sideY(side), baseCutoutZ]){
                                                    difference(){
                                                        translate([0, 0, -0.5 * cutOffset])
                                                            cube([gapLength*gridSizeXY - 2*wallThickness + cutTolerance, 2 * (baseClampWallThickness + sAdjustment[2 + side] + cutTolerance), baseCutoutDepth + cutOffset], center=true); 
                                                        
                                                        translate([-0.5 * (gapLength*gridSizeXY - 2*wallThickness), 0, (baseClampOffset > 0 ? baseClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - baseClampHeight) ]) 
                                                            cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, baseClampHeight + (baseClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                    
                                                    
                                                        translate([0.5 * (gapLength*gridSizeXY - 2*wallThickness), 0, (baseClampOffset > 0 ? baseClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - baseClampHeight) ]) 
                                                            cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, baseClampHeight + (baseClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                    }  
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                    /*
                                    * Wall Gaps Y
                                    */
                                    //color([0.608, 0.349, 0.714]) //9b59b6
                                    for (b = [ startY : 1 : endY ]){
                                        for (side = [ 0 : 1 : 1 ]){
                                            gapLength = drawWallGapY(b, side, 0);
                                            if(gapLength > 0){
                                                translate([sideX(side), posY(b + 0.5*(gapLength-1)), baseCutoutZ]){
                                                    difference(){
                                                        translate([0, 0, -0.5 * cutOffset])
                                                            cube([2 * (baseClampWallThickness + sAdjustment[side] + cutTolerance), gapLength*gridSizeXY - 2 * wallThickness + cutTolerance, baseCutoutDepth + cutOffset], center=true);   
                                                        
                                                        translate([0, -0.5 * (gapLength*gridSizeXY - 2 * wallThickness), (baseClampOffset > 0 ? baseClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - baseClampHeight)]) 
                                                            cube([2*(baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, baseClampHeight + (baseClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                    
                                                        translate([0, 0.5 * (gapLength*gridSizeXY - 2 * wallThickness), (baseClampOffset > 0 ? baseClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - baseClampHeight)]) 
                                                            cube([2 * (baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, baseClampHeight + (baseClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } // End union

                                translate([0,0,baseCutoutZ])
                                intersection(){
                                    //TODO move elsewhere
                                    bevelKnobCut = mb_inset_quad_lrfh(bevelOuter, [baseClampWallThickness*cutMultiplier, baseClampWallThickness*cutMultiplier, baseClampWallThickness*cutMultiplier, baseClampWallThickness*cutMultiplier]);
                                    
                                    make_bevel(bevelKnobCut, resultingBaseHeight);
                                    
                                    mb_rounded_block(
                                        size = [objectSizeX - 2*baseClampWallThickness*cutMultiplier, objectSizeY - 2*baseClampWallThickness*cutMultiplier, resultingBaseHeight], 
                                        center = true, 
                                        radius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius], 
                                        resolution = baseRoundingResolution
                                    );    
                                }
                            } //End difference final cutout elements
                        } // End difference base
                    }
                    else{
                        /*
                        * Solid Base Block
                        */
                        
                        mb_base(
                            grid = grid,
                            gridSizeXY = gridSizeXY,
                            objectSize = [objectSizeX, objectSizeY],
                            height = resultingBaseHeight,
                            baseSideAdjustment = sAdjustment,
                            baseReliefCut = baseReliefCut,
                            baseReliefCutHeight = baseReliefCutHeight,
                            baseReliefCutThickness = baseReliefCutThickness,
                            roundingRadius = baseRoundingRadius, 
                            roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                            pit = pit,
                            pitRoundingRadius = pitRoundingRadius,
                            pitDepth = resultingPitDepth,
                            pitWallThickness = pWallThickness,
                            pitWallGaps = pitWallGaps,
                            slanting = slanting,
                            slantingLowerHeight = slantingLowerHeight,
                            bevelHorizontal = bevelHorizontal,
                            bevelOuter = bevelOuter,
                            bevelOuterAdjusted = bevelOuterAdjusted,
                            connectors = connectors,
                            connectorHeight = connectorHeight,
                            connectorDepth = connectorDepth,
                            connectorSize = connectorSize,
                            connectorDepthTolerance = connectorDepthTolerance,
                            connectorSideTolerance = connectorSideTolerance
                        );
                    } //End baseCutoutType
                } //End base union

                /*
                * Final Subtraction
                * Starting from here, everything applies to the final block
                *
                */

                //Cut X-Holes
                if(holesX != false){
                    for(r = [ 0 : 1 : holeXMaxRows-1]){
                        for (a = [ startX : 1 : endX - (holeXCentered ? 1 : 0) ]){
                            if(drawHoleX(a, r)){
                                translate([posX(a + (holeXCentered ? 0.5 : 0)), 0, -0.5*resultingBaseHeight + holeXGridOffsetZ*gridSizeZ + r * holeXGridSizeZ*gridSizeZ]){
                                    rotate([90, 0, 0]){ 
                                        if(holeXType == "technic"){
                                            cylinder(h=objectSizeY*cutMultiplier, r=0.5 * holeXSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                        
                                            translate([0, 0, 0.5 * objectSizeY])
                                                cylinder(h=2*holeXInsetDepth, r=0.5 * (holeXSize + 2*holeXInsetThickness), center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                            translate([0, 0, -0.5 * objectSizeY])
                                                cylinder(h=2*holeXInsetDepth, r=0.5 * (holeXSize + 2*holeXInsetThickness), center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                        
                                        }
                                        else if(holeXType == "axis"){
                                            mb_axis(height = resultingBaseHeight * cutMultiplier, capHeight=0, size = holeZSize, center=true, alignBottom=false, roundingResolution=($preview ? previewQuality : 1) * 0.5 * holeRoundingResolution);
                                        }
                                    };
                                };
                            }
                        }
                    }
                }
                
                //Cut Y-Holes
                if(holesY != false){
                    for(r = [ 0 : 1 : holeYMaxRows-1]){
                        for (b = [ startY : 1 : endY - (holeYCentered ? 1 : 0) ]){
                            if(drawHoleY(b, r)){
                                translate([0, posY(b + (holeYCentered ? 0.5 : 0)), -0.5*resultingBaseHeight + holeYGridOffsetZ*gridSizeZ + r * holeYGridSizeZ*gridSizeZ]){
                                    rotate([0, 90, 0]){ 
                                        if(holeYType == "technic"){
                                            cylinder(h=objectSizeX*cutMultiplier, r=0.5 * holeYSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                        
                                            translate([0, 0, 0.5 * objectSizeX])
                                                cylinder(h=2*holeYInsetDepth, r=0.5 * (holeYSize + 2*holeYInsetThickness), center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                            translate([0, 0, -0.5 * objectSizeX])
                                                cylinder(h=2*holeYInsetDepth, r=0.5 * (holeYSize + 2*holeYInsetThickness), center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                        }
                                        else if(holeYType == "axis"){
                                            mb_axis(height = resultingBaseHeight * cutMultiplier, capHeight=0, size = holeZSize, center=true, alignBottom=false, roundingResolution=($preview ? previewQuality : 1) * 0.5 * holeRoundingResolution);
                                        }
                                    };
                                };
                            }
                        }
                    }
                }
                
                if(holesZ != false){
                    //Cut Z-Holes
                    for (a = [ startX : 1 : endX - 1 ]){
                        for (b = [ startY : 1 : endY - 1 ]){
                            if(drawHoleZ(a, b)){
                                translate([posX(a + 0.5), posY(b+0.5), 0]){
                                    if(holeZType == "technic"){
                                        cylinder(h=resultingBaseHeight*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                    }
                                    else if(holeZType == "axis"){
                                        mb_axis(height = resultingBaseHeight * cutMultiplier, capHeight=0, size = holeZSize, center=true, alignBottom=false, roundingResolution=($preview ? previewQuality : 1) * 0.5 * holeRoundingResolution);
                                    }
                                };
                            }
                        }
                    }
                }

                /*
                * Text Cutout
                */
                if(!mb_is_empty_string(text) && textDepth < 0){
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
                if(!mb_is_empty_string(svg) && svgDepth < 0){
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
                                    cylinder(h = (resultingBaseHeight + knobHeight)*cutMultiplier, r = 0.5*screwHoleZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
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
                                    cylinder(h = screwHoleXDepth + cutOffset, r = 0.5*screwHoleXSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
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
                                    cylinder(h = screwHoleYDepth + cutOffset, r = 0.5*screwHoleYSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                        }
                    }
                }

                /*
                * Cut Groove
                */
                if(baseCutoutType == "groove"){
                    translate([0, 0, sideZ(0) + 0.5*tongueGrooveDepth]){ 
                        translate([0, 0, -0.5 * cutOffset]){
                            mb_tongue(
                                gridSizeXY = gridSizeXY,
                                objectSize = [objectSizeX, objectSizeY],
                                baseRoundingRadius = baseRoundingRadius,
                                baseRoundingResolution = baseRoundingResolution,
                                bevelOuter = bevelOuter,
                                tongueOffset = tongueOffset,
                                tongueThickness = tongueThickness,
                                tongueThicknessAdjustment = 0,
                                tongueHeight = tongueGrooveDepth + cutOffset,
                                tongueClampThickness = tongueClampThickness,
                                tongueClampHeight = tongueClampHeight,
                                tongueClampOffset = tongueClampOffset + tongueGrooveDepth - tongueHeight,
                                tongueRoundingRadius = tongueRoundingRadius,
                                tongueInnerRoundingRadius = tongueInnerRoundingRadius,
                                pit = true,
                                pitWallGaps = pitWallGaps,
                                pitSizeX = pitSizeX,
                                pitSizeY = pitSizeY,
                                previewQuality = previewQuality
                            );
                        }

                        tongueSizeX = objectSizeX - 2 * tongueOffset + tongueThicknessAdjustment;
                        tongueSizeY = objectSizeY - 2 * tongueOffset + tongueThicknessAdjustment;
                        tongueThicknessAdjusted = tongueThickness + tongueThicknessAdjustment;
                        tongueInnerSizeX = tongueSizeX - 2 * tongueThicknessAdjusted;
                        tongueInnerSizeY = tongueSizeY - 2 * tongueThicknessAdjusted;

                        /*
                        * Groove Wall Gaps X
                        */
                        //color([0.608, 0.349, 0.714]) //9b59b6
                        for (a = [ startX : 1 : endX ]){
                            for (side = [ 0 : 1 : 1 ]){
                                gapLength = drawWallGapX(a, side, 0);
                                if(gapLength > 0){
                                    translate([posX(a + 0.5*(gapLength-1)), sideY(side), -0.5 * cutOffset]){
                                        cube([
                                            gapLength*gridSizeXY - objectSizeX + tongueSizeX + cutTolerance, 
                                            objectSizeY - tongueSizeY + sAdjustment[2 + side] + cutTolerance, 
                                            tongueGrooveDepth + cutOffset
                                        ], center=true); 
                                        
                                        translate([0,0,+0.5*(tongueGrooveDepth+cutOffset)-0.5*tongueClampHeight - (tongueClampOffset + tongueGrooveDepth - tongueHeight)])
                                            cube([
                                                gapLength*gridSizeXY - objectSizeX + tongueSizeX + 2* tongueClampThickness + cutTolerance, 
                                                objectSizeY - tongueSizeY + sAdjustment[2 + side] + cutTolerance, 
                                                tongueClampHeight
                                            ], center=true); 
                                    }
                                }
                            }
                        }
                        
                        /*
                        * Groove Wall Gaps Y
                        */
                        //color([0.608, 0.349, 0.714]) //9b59b6
                        for (b = [ startY : 1 : endY ]){
                            for (side = [ 0 : 1 : 1 ]){
                                gapLength = drawWallGapY(b, side, 0);
                                if(gapLength > 0){
                                    translate([sideX(side), posY(b + 0.5*(gapLength-1)), -0.5 * cutOffset]){
                                        cube([
                                            objectSizeX - tongueSizeX + sAdjustment[side] + cutTolerance, 
                                            gapLength*gridSizeXY - objectSizeY + tongueSizeY + cutTolerance, 
                                            tongueGrooveDepth + cutOffset
                                        ], center=true);   

                                        translate([0,0,+0.5*(tongueGrooveDepth+cutOffset)-0.5*tongueClampHeight - (tongueClampOffset + tongueGrooveDepth - tongueHeight)])
                                            cube([
                                                objectSizeX - tongueSizeX + sAdjustment[side] + cutTolerance, 
                                                gapLength*gridSizeXY - objectSizeY + tongueSizeY + 2* tongueClampThickness + cutTolerance, 
                                                tongueClampHeight
                                            ], center=true);   
                                    }
                                }
                            }
                        }
                        
                        
                    }   
                }
            } // End main difference

            /*
            * Final Addition AREA
            * Starting from here, everything affects both solid and cutout blocks
            */
            
            /*
            * Text
            */
            if(!mb_is_empty_string(text) && textDepth > 0){
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
            if(!mb_is_empty_string(svg) && svgDepth > 0){
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
                for (a = [ startX : 1 : (endX - (knobCentered ? 1 : 0)) ]){
                    for (b = [ startY : 1 : (endY - (knobCentered ? 1 : 0)) ]){
                        knobOffset = knobCentered ? 0.5 : 0;
                        if(drawGridItem(knobs, a, b, 0, false) && drawKnob(a + knobOffset, b + knobOffset)){
                            
                            pitKnobOffset = pitKnobCentered ? 0.5 : 0;
                            inPit = pit && pitKnobs && inPit(a + pitKnobOffset, b + pitKnobOffset);
                            onPitBorder = !pit || onPitBorder(a + knobOffset, b + knobOffset);
                            if(onPitBorder || inPit){
                                posOffset = (inPit ? pitKnobCentered : knobCentered) ? 0.5 : 0;
                                translate([posX(a + posOffset), posY(b + posOffset), knobZ(a + posOffset, b + posOffset)]){ 
                                    difference(){
                                        union(){
                                            translate([0, 0, -0.5 * (knobRounding + knobClampHeight)])
                                                cylinder(h=knobHeight - knobRounding - knobClampHeight, r=0.5 * knobSize, center=true, $fn=($preview ? previewQuality : 1) * knobRoundingResolution);

                                            
                                            translate([0, 0, 0.5 * (knobHeight - knobClampHeight) - knobRounding ])
                                                cylinder(h=knobClampHeight, r=0.5 * knobSize + knobClampThickness, center=true, $fn=($preview ? previewQuality : 1) * knobRoundingResolution);
                                            
                                            translate([0, 0, 0.5 * (knobHeight - knobRounding)])
                                                cylinder(h=knobRounding, r=0.5 * knobSize + knobClampThickness - knobRounding, center=true, $fn=($preview ? previewQuality : 1) * knobRoundingResolution);
                                        }
                                        
                                        if(knobType(a + posOffset, b + posOffset) == "technic"){
                                            intersection(){
                                                cube([knobHoleSize - 2*knobHoleClampThickness, knobHoleSize - 2*knobHoleClampThickness, knobHeight*cutMultiplier], center=true);
                                                cylinder(h=knobHeight * cutMultiplier, r=0.5 * knobHoleSize, center=true, $fn=($preview ? previewQuality : 1) * knobRoundingResolution);
                                            }
                                        }
                                    }
                                    
                                    //Knob Rounding
                                    translate([0, 0, 0.5 * knobHeight - knobRounding]){ 
                                        mb_torus(
                                            circleRadius = knobRounding, 
                                            torusRadius = 0.5 * knobSize + knobClampThickness, 
                                            circleResolution = ($preview ? previewQuality : 1) * knobRoundingResolution,
                                            torusResolution = ($preview ? previewQuality : 1) * knobRoundingResolution
                                        );
                                    };
                                };
                            }
                        }
                    }
                }
            } // End if knobs

            /*
            * Tongue
            */
            color([0.945, 0.769, 0.059]) //f1c40f
            if(tongue){
                translate([0, 0, 0.5 * (resultingBaseHeight + tongueHeight)]){ 
                    mb_tongue(
                        gridSizeXY = gridSizeXY,
                        objectSize = [objectSizeX, objectSizeY],
                        baseRoundingRadius = baseRoundingRadius,
                        baseRoundingResolution = baseRoundingResolution,
                        bevelOuter = bevelOuter,
                        tongueOffset = tongueOffset,
                        tongueThickness = tongueThickness,
                        tongueThicknessAdjustment = tongueThicknessAdjustment,
                        tongueHeight = tongueHeight,
                        tongueClampThickness = tongueClampThickness,
                        tongueClampHeight = tongueClampHeight,
                        tongueClampOffset = tongueClampOffset,
                        tongueRoundingRadius = tongueRoundingRadius,
                        tongueInnerRoundingRadius = tongueInnerRoundingRadius,
                        pit = pit,
                        pitWallGaps = pitWallGaps,
                        pitSizeX = pitSizeX,
                        pitSizeY = pitSizeY,
                        previewQuality = previewQuality
                    );
                }
            }

            //PCB
            if(pcb){
                translate([pcbOffset[0]*gridSizeXY, pcbOffset[1]*gridSizeXY, pitFloorZ]){
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

        } // End main union
    } //End translate brick offset

} // End module block    

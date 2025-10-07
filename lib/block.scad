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

module machineblock(
        //Grid
        gridSize = [5, 2], // mbu [xy, z]
        scale = 1.0, // Float

        //Size
        size = [1, 1, 1],
        offset = [0, 0, 0], // Multipliers of gridSizeXY and gridSizeZ

        //Base
        base = true,
        baseColor = "#EAC645", // hex color with leading #
        baseHeight = "auto", // mm or "auto"
        
        baseTopPlateHeight = 1, // mbu
        baseTopPlateHeightAdjustment = -0.6, // mm

        baseCutoutType = "classic",
        baseCutoutMaxDepth = 5, // mbu
        
        baseClampOffset = 0.25, // mbu
        baseClampHeight = 0.5, // mbu
        baseClampThickness = 0.1, // mm
        baseClampOuter = false,
        
        
        baseRoundingRadius = 0.0, // e.g. 4 or [4, 4, 4] or [4, [4, 4, 4, 4], [4,4,4,4]]
        baseCutoutRoundingRadius = "auto", // e.g 2.7 or [2.7, 2.7, 2.7, 2.7] 
        baseRoundingResolution = 64,
        
        //Relief Cut
        baseReliefCut = false,
        baseReliefCutHeight = 0.6, // mm
        baseReliefCutThickness = 0.6, // mm
        
        //Base Adjustment
        baseSideAdjustment = -0.1, // mm
        baseHeightAdjustment = 0.0, // mm
        
        //Walls
        baseWallThicknessAdjustment = -0.1, // mm
        baseWallGapsX = [],
        baseWallGapsY = [],
        
        //Top Plate Helpers
        topPlateHelpers = true,
        topPlateHelperHeight = 0.2, // mm, usually 1 printable layer height (0.2mm)
        topPlateHelperThickness = 0.4, // mm, usually 1 printable wall thickness (0.4mm)

        //Stabilizers
        stabilizerGrid = true,
        stabilizerGridOffset = 0.2, // mm, usually 1 printable layer height (0.2mm)
        stabilizerGridHeight = 0.5, // mbu
        stabilizerGridThickness = 0.5, // mbu
        stabilizerExpansion = 2, // Integer, Create expansion after each [n] bricks
        stabilizerExpansionOffset = 1, // mbu
        
        //Pillars: Tubes and Pins
        pillars = true,
        pillarRoundingResolution = 64,
        pillarGapCornerLength = 2,
        pillarGapMiddle = 10,
        
        //Pins (little tubes for blocks with 1 brick side length)
        pinDiameterAdjustment = 0.0, // mm
        
        //Tubes
        tubeXDiameterAdjustment = -0.1, // mm
        tubeYDiameterAdjustment = -0.1, // mm
        tubeZDiameterAdjustment = -0.1, // mm

        tubeInnerClampThickness = 0.1, // mm
        
        //Bevel
        //TODO rename slanting to bevelVertical
        slanting = false,
        slantingLowerHeight = 2, // mm
        bevelHorizontal = [[0, 0], [0, 0], [0, 0], [0, 0]],

        //Holes
        holeX = false,
        holeXType = "pin",
        holeXCentered = true,
        holeXDiameterAdjustment = 0.3, // mm
        holeXInsetThickness = 0.375, // mbu
        holeXInsetDepth = 0.25, // mbu
        holeXGridOffsetZ = 3.5, // mbu
        holeXGridSizeZ = 6, // mbu
        holeXMinTopMargin = 0.5, // mbu

        holeY = false,
        holeYType = "pin",
        holeYCentered = true,
        holeYDiameterAdjustment = 0.3, // mm
        holeYInsetThickness = 0.375, // mbu
        holeYInsetDepth = 0.25, // mbu
        holeYGridOffsetZ = 3.5, // mbu
        holeYGridSizeZ = 6, // mbu
        holeYMinTopMargin = 0.5, // mbu

        holeZ = false,
        holeZType = "pin",
        holeZCenteredX = true,
        holeZCenteredY = true,
        holeZDiameterAdjustment = 0.3, // mm
        holeRoundingResolution = 64,
        
        //Knobs
        studs = true,
        studType = "solid",
        studCentered = false,
        studMaxOverhang = 0.3, // mm
        studPadding = 0, // Multipliers of gridSizeXY
        
        studClampHeight = 0.5, // mbu
        studClampThickness = 0.0, // mm
        
        studHoleSize = 2, // mbu
        studHoleSizeAdjustment = 0.3, // mm
        studHoleClampThickness = 0.1, // mm
        
        studRounding = 0.1, // mm
        studRoundingResolution = 64,
        
        studDiameter = 3, // mbu
        studDiameterAdjustment = 0.2, // mm
        studHeight = 1, // mbu
        studCutoutAdjustment = [0, 0.2], // mm [diameter, height]
        
        //Tongue
        tongue = false,
        tongueHeight = 2.0, // mm
        tongueGrooveDepth = 2.4, // mm
        tongueRoundingRadius = "auto", // mm, e.g 3.4 or [3.4, 3.4, 3.4, 3.4] 
        tongueInnerRoundingRadius = "auto", // mm, e.g 3.4 or [3.4, 3.4, 3.4, 3.4] 
        tongueThickness = 1.1, // mm
        tongueThicknessAdjustment = 0, // mm
        tongueOffset = 1.5, // mm (0.5 * (gridSizeXY - referenceKnobSize))
        tongueClampHeight = 0.8, // mm
        tongueClampOffset = 0.4, // mm
        tongueClampThickness = 0.1, // mm
        
        
        //Pit
        pit=false,
        pitRoundingRadius = "auto", // e.g 2.7 or [2.7, 2.7, 2.7, 2.7] or "auto" 
        pitDepth = "auto", // mm or "auto"
        pitWallThickness = 0.333, // Format: 0.333 or [0.333, 0.333, 0.333, 0.333], Multipliers of gridSizeXY
        pitKnobs = true,
        pitKnobPadding = 0.2, // Multipliers of gridSizeXY
        pitKnobType = "solid",
        pitKnobCentered = false,
        pitWallGaps = [],
        
        //Text
        text = "",
        textSide = 0, // Side
        textDepth = -0.6, // mm
        textFont = "Liberation Sans", // font family
        textSize = 4, // pt
        textSpacing = 1,
        textVerticalAlign = "center",
        textHorizontalAlign = "center",
        textOffset = [0, 0], // Multipliers of gridSizeXY and gridSizeZ depending on side
        textColor = "#2c3e50", // hex color with leading #

        //SVG
        svg = "",
        svgSide = 5, // Side
        svgDepth = 0.4, // mm
        svgDimensions = [100, 100],
        svgScale = 1,
        svgOffset = [0, 0], // Multipliers of gridSizeXY and gridSizeZ depending on side
        svgColor = "#2c3e50", // hex color with leading #

        connectors = false,
        connectorHeight = 0, // mm
        connectorDepth = 1.4, // mm
        connectorSize = 4.0, // mm
        connectorDepthTolerance = 0.2, // mm
        connectorSideTolerance = 0.1, // mm

        //Screw Holes
        screwHolesZ = [],
        screwHoleZSize = 2.3, // mm
        screwHoleZHelperThickness = 0.8, // mm
        screwHoleZHelperOffset = 0.2, // mm
        screwHoleZHelperHeight = 0.2, // mm

        screwHolesX = [],
        screwHoleXSize = 2.1, // mm
        screwHoleXDepth = 4, // mm

        screwHolesY = [],
        screwHoleYSize = 2.1, // mm
        screwHoleYDepth = 4, // mm

        //PCB
        pcb=false,
        pcbMountingType = "clips",
        pcbDimensions = [20, 30, 3], // mm
        pcbOffset = [0, 0], // Multipliers of gridSizeXY
        pcbScrewSocketSize = 5, // mm
        pcbScrewSocketHoleSize = 2.2, // mm
        pcbScrewSocketHeight = 3, // mm
        pcbScrewSockets = [],

        //Alignment
        align = "start",
        alignChildren = "start",
        alignMode = "grid", // If set to object, brick is aligned like a normal scad object - TODO implement object mode
        
        //Preview
        previewQuality = 0.5, // Between 0.0 and 1.0
        previewRender = false, // Whether the brick should always be rendered in preview mode
        previewRenderConvexity = 15 // Convexity for preview rendering
        ){
            
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    rootUnit = scale * 1.6;

    gridSizeXY = gridSize[0] * rootUnit;
    gridSizeZ = gridSize[1] * rootUnit;

    grid = [size[0], size[1]];

    //Side Adjustment
    sAdjustment = mb_resolve_base_side_adjustment(baseSideAdjustment);

    //Object Size     
    objectSizeX = gridSizeXY * grid[0];
    objectSizeY = gridSizeXY * grid[1];
    
    //Object Size Adjusted      
    objectSizeXAdjusted = objectSizeX + sAdjustment[0] + sAdjustment[1];
    objectSizeYAdjusted = objectSizeY + sAdjustment[2] + sAdjustment[3];
    minObjectSide = min(objectSizeXAdjusted, objectSizeYAdjusted);

    //Base Height
    baseHeightResolved = baseHeight == "auto" ? size[2] * gridSizeZ : baseHeight;
    resultingBaseHeight = baseHeightResolved + baseHeightAdjustment;

    gridSizeX = slanting != false ? grid[0] + (slanting[0] < 0 ? slanting[0] : 0) + (slanting[1] < 0 ? slanting[1] : 0) : grid[0];
    gridSizeY = slanting != false ? grid[1] + (slanting[2] < 0 ? slanting[2] : 0) + (slanting[3] < 0 ? slanting[3] : 0) : grid[1];

    //Calculate Brick Align and Offset
    alignment = is_string(align) ? [align, align, align] : align;
    translateX = (alignment[0] == "center" || alignment[0] == "ccs") ? 0 : ((alignment[0] == "start" ? 1 : -1) * 0.5*objectSizeX);
    translateY = (alignment[1] == "center" || alignment[1] == "ccs") ? 0 : ((alignment[1] == "start" ? 1 : -1) * 0.5*objectSizeY);
    translateZ = alignment[2] == "center" ? 0 : ((alignment[2] == "start" || alignment[2] == "ccs") ? 0.5*resultingBaseHeight : 0.5*baseHeightAdjustment - 0.5*baseHeightResolved);
    
    gridOffsetX = offset[0] * gridSizeXY + translateX;
    gridOffsetY = offset[1] * gridSizeXY + translateY;
    gridOffsetZ = offset[2] * gridSizeZ + translateZ; 

    //Children alignment
    alignmentChildren = is_string(alignChildren) ? [alignChildren, alignChildren, alignChildren] : alignChildren;
    translateXChildren = (alignmentChildren[0] == "center" || alignmentChildren[0] == "ccs") ? 0 : ((alignmentChildren[0] == "start" ? -1 : 1) * 0.5*objectSizeX);
    translateYChildren = (alignmentChildren[1] == "center" || alignmentChildren[0] == "ccs") ? 0 : ((alignmentChildren[1] == "start" ? -1 : 1) * 0.5*objectSizeY);
    translateZChildren  = alignmentChildren[2] == "center" ? 0 : ((alignmentChildren[2] == "start" || alignmentChildren[2] == "ccs")  ? -0.5*resultingBaseHeight : -0.5*baseHeightAdjustment + 0.5*baseHeightResolved);
    
    //Base Cutout and Pit Depth
    topPlateHeight = baseTopPlateHeight * rootUnit + baseTopPlateHeightAdjustment;
    baseCutoutMinDepth = gridSize[1] * rootUnit - topPlateHeight; // mm -- 1 plate minus topPlateHeight
    maxBaseCutoutDepth = baseCutoutMaxDepth * rootUnit;  
    
    resultingPitDepth = pit ? (pitDepth != "auto" ? pitDepth : (resultingBaseHeight - topPlateHeight - (baseCutoutType == "none" ? 0 : baseCutoutMinDepth))) : 0;
    pWallThickness = pitWallThickness[0] == undef 
                ? [pitWallThickness, pitWallThickness, pitWallThickness, pitWallThickness] 
                : (len(pitWallThickness) == 2 ? [pitWallThickness[0], pitWallThickness[0], pitWallThickness[1], pitWallThickness[1]] : pitWallThickness);
    pitSizeX = objectSizeX - (pWallThickness[0] + pWallThickness[1]) * gridSizeXY;
    pitSizeY = objectSizeY - (pWallThickness[2] + pWallThickness[3]) * gridSizeXY;

    calculatedBaseCutoutDepth = resultingBaseHeight - topPlateHeight - resultingPitDepth;  
    resultingTopPlateHeight = topPlateHeight + ((maxBaseCutoutDepth > 0 && (calculatedBaseCutoutDepth > maxBaseCutoutDepth)) ? (calculatedBaseCutoutDepth - maxBaseCutoutDepth) : 0);
    baseCutoutDepth = baseCutoutType == "none" ? 0 : ((maxBaseCutoutDepth > 0 && (calculatedBaseCutoutDepth > maxBaseCutoutDepth)) ? maxBaseCutoutDepth : calculatedBaseCutoutDepth);
    
    wallThickness = 0.5 * (gridSize[0] - studDiameter) * rootUnit + baseWallThicknessAdjustment;
    baseClampWallThickness = wallThickness + baseClampThickness;
    baseRoundingRadiusZ = mb_base_rounding_radius_z(radius = baseRoundingRadius);
    
    cutoutRoundingRadius = mb_base_cutout_radius(baseCutoutRoundingRadius == "auto" ? -wallThickness : baseCutoutRoundingRadius, baseRoundingRadiusZ, minObjectSide);
    
    minCutoutSide = min(objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness);
    cutoutClampRoundingRadius = mb_base_cutout_radius(-baseClampThickness, cutoutRoundingRadius, minCutoutSide);

    baseClampThicknessOuter = baseClampOuter ? baseClampThickness : 0;
    bClampOffset = baseClampOffset * rootUnit;
    bClampHeight = baseClampHeight * rootUnit;
                                    
    //Calculate Z Positions
    baseCutoutZ = -0.5 * (resultingBaseHeight - baseCutoutDepth);        
    topPlateZ = baseCutoutZ + 0.5 * (resultingBaseHeight - resultingPitDepth);
    xyScrewHolesZ = -0.5 * resultingBaseHeight + 0.5 * gridSizeZ;
    pitFloorZ = 0.5 * resultingBaseHeight - resultingPitDepth;

    

    beveled = bevelHorizontal != [[0, 0], [0, 0], [0, 0], [0, 0]];
    bevelOuter = mb_resolve_bevel_horizontal(bevelHorizontal, grid, gridSizeXY);
    bevelOuterAdjusted = mb_inset_quad_lrfh(bevelOuter, [-sAdjustment[0], -sAdjustment[1], -sAdjustment[2], -sAdjustment[3]]);
    bevelInner = mb_inset_quad_lrfh(bevelOuter, wallThickness);
    
    corners = mb_resolve_bevel_horizontal([[0,0],[0,0],[0,0],[0,0]], grid, gridSizeXY);
    cornersInner = mb_inset_quad_lrfh(corners, wallThickness);

    //Pit
    pitBevel = mb_inset_quad_lrfh(bevelOuter, [pWallThickness[0]*gridSizeXY+studMaxOverhang, pWallThickness[1]*gridSizeXY+studMaxOverhang, pWallThickness[2]*gridSizeXY+studMaxOverhang, pWallThickness[3]*gridSizeXY+studMaxOverhang]);
    pitBevelPadding = mb_inset_quad_lrfh(bevelOuter, [(pWallThickness[0] + pitKnobPadding)*gridSizeXY, (pWallThickness[1] + pitKnobPadding)*gridSizeXY, (pWallThickness[2] + pitKnobPadding)*gridSizeXY, (pWallThickness[3] + pitKnobPadding)*gridSizeXY]);
    cornersPitPadding = mb_inset_quad_lrfh(corners, [(pWallThickness[0] + pitKnobPadding)*gridSizeXY, (pWallThickness[1] + pitKnobPadding)*gridSizeXY, (pWallThickness[2] + pitKnobPadding)*gridSizeXY, (pWallThickness[3] + pitKnobPadding)*gridSizeXY]);
    
    pMinThickness = [
        -min(pWallThickness[2], pWallThickness[0])*gridSizeXY, 
        -min(pWallThickness[0], pWallThickness[3])*gridSizeXY, 
        -min(pWallThickness[3], pWallThickness[1])*gridSizeXY, 
        -min(pWallThickness[1], pWallThickness[2])*gridSizeXY
    ];
    pitRadius = mb_base_cutout_radius(pitRoundingRadius == "auto" ? pMinThickness : pitRoundingRadius, baseRoundingRadiusZ, minObjectSide);            
    
    knobSize = studDiameter * rootUnit + studDiameterAdjustment;
    knobHeight = studHeight * rootUnit;

    knobCutSize = knobSize + studCutoutAdjustment[0];
    knobCutHeight = knobHeight + studCutoutAdjustment[1];
    knobHoleSize = studHoleSize * rootUnit + studHoleSizeAdjustment;

    //Knob Padding
    knobPaddingResolved = mb_resolve_quadruple(studPadding, gridSizeXY);
    bevelKnobPadding = mb_inset_quad_lrfh(bevelOuter, knobPaddingResolved);
    cornersKnobPadding = mb_inset_quad_lrfh(corners, knobPaddingResolved);
    knobPaddingRadiusInv = [
        -min(knobPaddingResolved[2], knobPaddingResolved[0]), 
        -min(knobPaddingResolved[0], knobPaddingResolved[3]), 
        -min(knobPaddingResolved[3], knobPaddingResolved[1]),
        -min(knobPaddingResolved[1], knobPaddingResolved[2])
    ];
    knobPaddingRoundingRadius = mb_base_rel_radius(knobPaddingRadiusInv, baseRoundingRadiusZ, minObjectSide, true);

    tubeDiameter = sqrt(2*studDiameter^2);
    tubeXSize = tubeDiameter * rootUnit + tubeXDiameterAdjustment;
    tubeYSize = tubeDiameter * rootUnit + tubeYDiameterAdjustment;
    tubeZSize = tubeDiameter * rootUnit + tubeZDiameterAdjustment;
    holeXSize = studDiameter * rootUnit + holeXDiameterAdjustment;
    holeYSize = studDiameter * rootUnit + holeYDiameterAdjustment;
    holeZSize = studDiameter * rootUnit + holeZDiameterAdjustment;
    pinSize = (gridSize[0] - studDiameter) * rootUnit + pinDiameterAdjustment;

    //Holes XY
    holeXBottomMargin = holeXGridOffsetZ*rootUnit - 0.5 * (holeXSize + 2 * holeXInsetThickness * rootUnit);
    holeXMaxRows = ceil((resultingBaseHeight - holeXBottomMargin - holeXMinTopMargin * rootUnit) / (holeXGridSizeZ * rootUnit)); 

    holeYBottomMargin = holeYGridOffsetZ*rootUnit - 0.5*(holeYSize + 2 * holeYInsetThickness * rootUnit);
    holeYMaxRows = ceil((resultingBaseHeight - holeYBottomMargin - holeYMinTopMargin * rootUnit) / (holeYGridSizeZ * rootUnit)); 

    //Stabilizer
    sGridThickness = stabilizerGridThickness * rootUnit;
    sGridHeight = stabilizerGridHeight * rootUnit;
    
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
    function onPitBorder(a, b) = mb_circle_in_convex_quad(bevelOuterAdjusted, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = studMaxOverhang)
                                && !mb_circle_in_convex_quad(pitBevel, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, touch=true, overhang=0);
    
    function inPit(a, b) = mb_circle_in_convex_quad(pitBevelPadding, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = studMaxOverhang)
                        && mb_circle_in_rounded_rect(cornersPitPadding, pitRadius, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = studMaxOverhang);
    
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
            && mb_circle_in_rounded_rect(cornersKnobPadding, knobPaddingRoundingRadius, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = studMaxOverhang)
            && mb_circle_in_convex_quad(bevelKnobPadding, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = studMaxOverhang)
            ;

    function knobZ(a, b) = pit && inPit(a, b) ? (pitFloorZ + 0.5 * knobHeight) : 0.5 * (resultingBaseHeight + knobHeight);
    function studType(a, b) = pit && inPit(a, b) ? pitKnobType : studType;

    /*
    * XYZ Holes
    */
    function drawHoleX(a, b) = drawGridItem(holeX, a, b, 0, false); 
    function drawHoleY(a, b) = drawGridItem(holeY, a, b, 0, false); 
    function drawHoleZ(a, b) = drawGridItem(holeZ, a, b, 0, false); 
    
    /*
    * Wall Gaps
    */
    function drawWallGapX(a, side, i) = (i < len(baseWallGapsX)) ? ((baseWallGapsX[i][0] == a && (side == baseWallGapsX[i][1] || baseWallGapsX[i][1] == 2)) ? (baseWallGapsX[i][2] == undef ? 1 : baseWallGapsX[i][2]) : drawWallGapX(a, side, i+1)) : 0; 
    function drawWallGapY(a, side, i) = (i < len(baseWallGapsY)) ? ((baseWallGapsY[i][0] == a && (side == baseWallGapsY[i][1] || baseWallGapsY[i][1] == 2)) ? (baseWallGapsY[i][2] == undef ? 1 : baseWallGapsY[i][2]) : drawWallGapY(a, side, i+1)) : 0; 
    
    /*
    * Stabilizer Grid
    */
    function stabilizersXHeight(a) = sGridHeight + stabilizerGridOffset + (stabilizerExpansion > 0 && (holeX == false) && (((grid[0] > stabilizerExpansion + 1) && ((a % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[1] == 1)) ? max(baseCutoutDepth - (stabilizerExpansionOffset * rootUnit) - sGridHeight - stabilizerGridOffset, 0) : 0);
    function stabilizersYHeight(b) = sGridHeight + (stabilizerExpansion > 0 && (holeY == false) && (((grid[1] > stabilizerExpansion + 1) && ((b % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[0] == 1)) ? max(baseCutoutDepth - (stabilizerExpansionOffset * rootUnit) - sGridHeight, 0) : 0);
    
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
        topPlateHeight = topPlateHeight,
        resultingTopPlateHeight = resultingTopPlateHeight, 
        baseCutoutDepth = baseCutoutDepth,
        pitDepth = resultingPitDepth, 
        knobSize = knobSize,
        knobHeight = knobHeight,
        wallThickness = wallThickness,
        baseClampWallThickness = baseClampWallThickness,
        baseCutoutZ = baseCutoutZ, 
        topPlateZ = topPlateZ, 
        tubeXSize = tubeXSize,
        tubeYSize = tubeYSize,
        tubeZSize = tubeZSize,
        xyScrewHolesZ = xyScrewHolesZ,
        pitFloorZ = pitFloorZ,
        beveled = beveled,
        bevelHorizontal = bevelHorizontal,
        bevelOuterAdjusted = bevelOuterAdjusted
    );

    /*
    * START BLOCK
    */
    
    translate([gridOffsetX, gridOffsetY, gridOffsetZ]){
        
            pre_render(previewRender, previewRenderConvexity){
                if(base){
                    difference(){
                        color(baseColor){
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
                                            baseClampHeight = bClampHeight,
                                            baseClampThicknessOuter = baseClampThicknessOuter,
                                            baseClampOffset = bClampOffset,
                                            roundingRadius = baseRoundingRadius, 
                                            roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                            pit = pit,
                                            pitRoundingRadius = pitRoundingRadius,
                                            pitDepth = resultingPitDepth,
                                            pitWallThickness = pWallThickness,
                                            pitWallGaps = pitWallGaps,
                                            slanting = slanting,
                                            slantingLowerHeight = slantingLowerHeight,
                                            beveled = beveled,
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
                                            union(){
                                                mb_base_cutout(
                                                    grid = grid,
                                                    gridSizeXY = gridSizeXY,
                                                    
                                                    baseHeight = resultingBaseHeight,
                                                    baseSideAdjustment = sAdjustment,
                                                    baseRoundingRadiusZ = baseRoundingRadiusZ,
                                                    baseCutoutDepth = baseCutoutDepth,
                                                    baseClampHeight = bClampHeight,
                                                    baseClampThickness = baseClampThickness,
                                                    baseClampOffset = bClampOffset,
                                                    
                                                    cutoutRoundingRadius = cutoutRoundingRadius,
                                                    cutoutClampRoundingRadius = cutoutClampRoundingRadius,
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

                                                    beveled = beveled,
                                                    bevelHorizontal = bevelHorizontal,
                                                    bevelOuter = bevelOuter,
                                                    bevelInner = bevelInner
                                                );
                                                
                                                /*
                                                * Wall Gaps X
                                                */
                                                for (a = [ startX : 1 : endX ]){
                                                    for (side = [ 0 : 1 : 1 ]){
                                                        gapLength = drawWallGapX(a, side, 0);
                                                        if(gapLength > 0){
                                                            translate([posX(a + 0.5*(gapLength-1)), sideY(side), baseCutoutZ]){
                                                                difference(){
                                                                    translate([0, 0, -0.5 * cutOffset])
                                                                        cube([gapLength*gridSizeXY - 2*wallThickness + cutTolerance, 2 * (baseClampWallThickness + sAdjustment[2 + side] + cutTolerance), baseCutoutDepth + cutOffset], center=true); 
                                                                    
                                                                    translate([-0.5 * (gapLength*gridSizeXY - 2*wallThickness), 0, (bClampOffset > 0 ? bClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - bClampHeight) ]) 
                                                                        cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, bClampHeight + (bClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                                
                                                                
                                                                    translate([0.5 * (gapLength*gridSizeXY - 2*wallThickness), 0, (bClampOffset > 0 ? bClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - bClampHeight) ]) 
                                                                        cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, bClampHeight + (bClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                                }  
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                                
                                                /*
                                                * Wall Gaps Y
                                                */
                                                for (b = [ startY : 1 : endY ]){
                                                    for (side = [ 0 : 1 : 1 ]){
                                                        gapLength = drawWallGapY(b, side, 0);
                                                        if(gapLength > 0){
                                                            translate([sideX(side), posY(b + 0.5*(gapLength-1)), baseCutoutZ]){
                                                                difference(){
                                                                    translate([0, 0, -0.5 * cutOffset])
                                                                        cube([2 * (baseClampWallThickness + sAdjustment[side] + cutTolerance), gapLength*gridSizeXY - 2 * wallThickness + cutTolerance, baseCutoutDepth + cutOffset], center=true);   
                                                                    
                                                                    translate([0, -0.5 * (gapLength*gridSizeXY - 2 * wallThickness), (bClampOffset > 0 ? bClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - bClampHeight)]) 
                                                                        cube([2*(baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, bClampHeight + (bClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                                
                                                                    translate([0, 0.5 * (gapLength*gridSizeXY - 2 * wallThickness), (bClampOffset > 0 ? bClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - bClampHeight)]) 
                                                                        cube([2 * (baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, bClampHeight + (bClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            } // End union cutout

                                            /*
                                            * Plate Helpers
                                            */
                                            if(topPlateHelpers){
                                                bevelTopPlateHelper = mb_inset_quad_lrfh(bevelOuter, wallThickness + topPlateHelperThickness);
                                                topPlateHelperRoundingRadius = mb_base_cutout_radius(- wallThickness - topPlateHelperThickness, baseRoundingRadiusZ, minObjectSide);
                                                
                                                translate([0, 0, topPlateZ - 0.5 * (resultingTopPlateHeight + topPlateHelperHeight) + 0.5 * cutOffset]){
                                                    difference(){
                                                        cube(
                                                            size = [objectSizeX, objectSizeY, topPlateHelperHeight + cutOffset], 
                                                            center=true
                                                        );

                                                        mb_beveled_rounded_block(
                                                            bevel = beveled ? bevelTopPlateHelper : false,
                                                            sizeX = objectSizeX - 2*wallThickness - 2*topPlateHelperThickness,
                                                            sizeY = objectSizeY - 2*wallThickness - 2*topPlateHelperThickness,
                                                            height = cutMultiplier * (topPlateHelperHeight + cutOffset),
                                                            roundingRadius = topPlateHelperRoundingRadius == 0 ? 0 : [0, 0, topPlateHelperRoundingRadius],
                                                            roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution
                                                        );

                                                        /*
                                                        intersection(){
                                                            make_bevel(bevelTopPlateHelper, cutMultiplier * (topPlateHelperHeight + cutOffset));
                                                
                                                            mb_rounded_block(
                                                                size = [objectSizeX - 2*wallThickness - 2*topPlateHelperThickness, objectSizeY - 2*wallThickness - 2*topPlateHelperThickness, cutMultiplier * (topPlateHelperHeight + cutOffset)], 
                                                                center=true, 
                                                                resolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                                                radius = topPlateHelperRoundingRadius == 0 ? 0 : [0, 0, topPlateHelperRoundingRadius]
                                                            );
                                                        }*/

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
                                            } // End if topPlateHelpers

                                            if(stabilizerGrid){
                                                
                                                difference(){
                                                    /*
                                                    * Stabilizer Grid
                                                    */
                                                    union(){
                                                        //Helpers X
                                                        for (a = [ 0 : 1 : grid[0] - 2 ]){
                                                            translate([posX(a + 0.5), 0, topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersXHeight(a)) + 0.5 * cutOffset]){ 
                                                                cube([sGridThickness, objectSizeY, stabilizersXHeight(a) + cutOffset], center = true);
                                                            }
                                                        }
                                                        
                                                        //Helpers Y
                                                        for (b = [ 0 : 1 : grid[1] - 2 ]){
                                                        translate([0, posY(b + 0.5), topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersYHeight(b)) + 0.5 * cutOffset]){
                                                                cube([objectSizeX, sGridThickness, stabilizersYHeight(b) + cutOffset], center = true);
                                                            };
                                                        }

                                                        /*
                                                        * Screw Hole Helpers
                                                        */
                                                        for (a = [ startX : 1 : endX ]){
                                                            for (b = [ startY : 1 : endY ]){
                                                                if(drawScrewHoleZ(a, b, 0)){
                                                                    translate([posX(a), posY(b)-0.5*(screwHoleZSize + screwHoleZHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight + screwHoleZHelperOffset)])
                                                                        cube([gridSizeXY - sGridThickness, screwHoleZHelperThickness, screwHoleZHelperHeight + screwHoleZHelperOffset], center = true);
                                                                    translate([posX(a), posY(b)+0.5*(screwHoleZSize + screwHoleZHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight + screwHoleZHelperOffset)])
                                                                        cube([gridSizeXY - sGridThickness, screwHoleZHelperThickness, screwHoleZHelperHeight + screwHoleZHelperOffset], center = true);    
                                                                    translate([posX(a)-0.5*(screwHoleZSize + screwHoleZHelperThickness), posY(b), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight)])
                                                                        cube([screwHoleZHelperThickness, gridSizeXY - sGridThickness, screwHoleZHelperHeight], center = true);
                                                                    translate([posX(a)+0.5*(screwHoleZSize + screwHoleZHelperThickness), posY(b), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight)])
                                                                        cube([screwHoleZHelperThickness, gridSizeXY - sGridThickness, screwHoleZHelperHeight], center = true);    
                                                                } 
                                                            }
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
                                                                        translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                            cylinder(h=bClampHeight, r=0.5 * tubeZSize + baseClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
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
                                            } // End if pillars

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
                                                                    translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                        cylinder(h=bClampHeight, r=0.5 * pinSize + baseClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
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
                                                                    translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                        cylinder(h=bClampHeight, r=0.5 * pinSize + baseClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                                };
                                                            }
                                                        }
                                                    }
                                                }
                                            } // End if pillars
                                            
                                            //X-Holes Outer
                                            if(holeX != false){
                                                for(r = [ 0 : 1 : holeXMaxRows-1]){
                                                    for (a = [ startX : 1 : endX - (holeXCentered ? 1 : 0) ]){
                                                        if(drawHoleX(a, r)){
                                                            translate([posX(a + (holeXCentered ? 0.5 : 0)), 0, -0.5*resultingBaseHeight + holeXGridOffsetZ*rootUnit + r * holeXGridSizeZ*rootUnit]){
                                                                rotate([90, 0, 0]){ 
                                                                    cylinder(h=objectSizeY - 2*wallThickness, r=0.5 * tubeXSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                                }
                                                            };
                                                        }
                                                    }
                                                }
                                            } // End if holeX
                                            
                                            //Y-Holes Outer
                                            if(holeY != false){
                                                for(r = [ 0 : 1 : holeYMaxRows-1]){
                                                    for (b = [ startY : 1 : endY - (holeYCentered ? 1 : 0) ]){
                                                        if(drawHoleY(b, r)){
                                                            translate([0, posY(b + (holeYCentered ? 0.5 : 0)), -0.5*resultingBaseHeight + holeYGridOffsetZ*rootUnit + r * holeYGridSizeZ*rootUnit]){
                                                                rotate([0, 90, 0]){ 
                                                                    cylinder(h=objectSizeX - 2*wallThickness, r=0.5 * tubeYSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                                };
                                                            };
                                                        }
                                                    }
                                                }
                                            } // End if holeY
                                            
                                            if(holeZ != false){
                                                /*
                                                * Z-Holes Outer
                                                */
                                                for (a = [ startX : 1 : endX - (holeZCenteredX ? 1 : 0) ]){
                                                    for (b = [ startY : 1 : endY - (holeZCenteredY ? 1 : 0) ]){
                                                        if(drawHoleZ(a, b)){
                                                            translate([posX(a + (holeZCenteredX ? 0.5 : 0)), posY(b +(holeZCenteredY ? 0.5 : 0)), baseCutoutZ]){
                                                                cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * tubeZSize, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                                
                                                                //Clamp
                                                                translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                    cylinder(h=bClampHeight, r=0.5 * tubeZSize + baseClampThickness, center=true, $fn=($preview ? previewQuality : 1) * pillarRoundingResolution);
                                                            };
                                                        }
                                                    }   
                                                }
                                            } // End if holeZ
                                        } // End Difference Base Cutout

                                        
                                        
                                        /*
                                        * Knob subtraction from the resulting hollowed base
                                        */
                                        translate([0, 0, -0.5 * resultingBaseHeight + 0.5 * knobCutHeight - 0.5*cutOffset]){
                                            difference(){
                                                union(){
                                                    for (a = [ startX : 1 : endX ]){
                                                        for (b = [ startY : 1 : endY ]){
                                                            if(!mb_circle_in_rounded_rect(cornersInner, baseRoundingRadiusZ, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = studMaxOverhang)
                                                                || !mb_circle_in_convex_quad(bevelInner, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSize, overhang = studMaxOverhang)){
                                                                translate([posX(a), posY(b), 0]){
                                                                    if(bClampOffset > 0){
                                                                        translate([0,0, -0.5 * (knobCutHeight - bClampOffset)])
                                                                            cylinder(h=bClampOffset + cutOffset, r=0.5 * knobCutSize, center=true, $fn=($preview ? previewQuality : 1) * studRoundingResolution);
                                                                    }
                                                                    //color("red")
                                                                    cylinder(h=knobCutHeight + cutOffset, r=0.5 * (knobCutSize - 2*baseClampThickness), center=true, $fn=($preview ? previewQuality : 1) * studRoundingResolution);
                                                                    
                                                                    //color("green")
                                                                    translate([0,0, 0.5*(knobCutHeight + cutOffset) - 0.5*(knobCutHeight - bClampOffset - bClampHeight)])
                                                                        cylinder(h=knobCutHeight - bClampOffset - bClampHeight, r=0.5 * knobCutSize, center=true, $fn=($preview ? previewQuality : 1) * studRoundingResolution);
                                                                }
                                                            }
                                                        }
                                                    }

                                                    
                                                } // End union

                                                union(){
                                                    mb_beveled_rounded_block(
                                                        bevel = beveled ? mb_inset_quad_lrfh(bevelOuter, baseClampWallThickness+cutTolerance) : false,
                                                        sizeX = objectSizeX - 2 * (baseClampWallThickness+cutTolerance),
                                                        sizeY = objectSizeY - 2 * (baseClampWallThickness+cutTolerance),
                                                        height = cutMultiplier * (knobCutHeight + cutOffset),
                                                        roundingRadius = cutoutClampRoundingRadius == 0 ? 0 : [0, 0, cutoutClampRoundingRadius],
                                                        roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution
                                                    );
                                                    map = [[0,1],[2,3],[0,3],[1,2]];
                                                    for (side = [ 0 : 1 : 1 ]){
                                                        
                                                        if((baseRoundingRadiusZ[map[side][0]] == 0) 
                                                            && (baseRoundingRadiusZ[map[side][1]] == 0)
                                                            && (bevelHorizontal[map[side][0]] == [0,0])
                                                            && (bevelHorizontal[map[side][1]] == [0,0])){
                                                            translate([(-0.5 + side) * ((objectSizeX - 2 * (baseClampWallThickness+cutTolerance)) + (baseClampWallThickness + sAdjustment[2+side])), 0,0]){
                                                                cube([
                                                                    cutMultiplier * (baseClampWallThickness + sAdjustment[2+side]), 
                                                                    objectSizeY - 2 * (baseClampWallThickness+cutTolerance), 
                                                                    
                                                                    cutMultiplier * (knobCutHeight + cutOffset)
                                                                ], center=true);
                                                            }
                                                        }
                                                    }
                                                    
                                                    for (side = [ 0 : 1 : 1 ]){
                                                        if((baseRoundingRadiusZ[map[2 + side][0]] == 0) 
                                                            && (baseRoundingRadiusZ[map[2 + side][1]] == 0)
                                                            && (bevelHorizontal[map[2+side][0]] == [0,0])
                                                            && (bevelHorizontal[map[2+side][1]] == [0,0])){
                                                            translate([0, (-0.5 + side) * ((objectSizeY - 2 * (baseClampWallThickness+cutTolerance)) + (baseClampWallThickness + sAdjustment[side])),0]){
                                                                cube([
                                                                    objectSizeX - 2 * (baseClampWallThickness+cutTolerance), 
                                                                    cutMultiplier * (baseClampWallThickness + sAdjustment[side]), 
                                                                    cutMultiplier * (knobCutHeight + cutOffset)
                                                                ], center=true);
                                                            }
                                                        }
                                                    }

                                                    
                                                    
                                                    //echo(bevelOuter = bevelOuter, bevelHorizontal=bevelHorizontal, cutoutClampRoundingRadius=cutoutClampRoundingRadius);
                                                }
                                                /*
                                                intersection(){
                                                    make_bevel(bevelKnobCut, cutMultiplier * (knobCutHeight + cutOffset));
                                                    mb_rounded_block(
                                                        size = [objectSizeX - 2*baseClampWallThickness*cutMultiplier, objectSizeY - 2*baseClampWallThickness*cutMultiplier, cutMultiplier * (knobCutHeight + cutOffset)], 
                                                        center = true, 
                                                        radius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius], 
                                                        resolution = baseRoundingResolution
                                                    );
                                                }*/
                                            } //End difference final cutout elements
                                        } // End translate
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
                                        baseClampHeight = bClampHeight,
                                        baseClampThicknessOuter = baseClampThicknessOuter,
                                        baseClampOffset = bClampOffset,
                                        roundingRadius = baseRoundingRadius, 
                                        roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution,
                                        pit = pit,
                                        pitRoundingRadius = pitRoundingRadius,
                                        pitDepth = resultingPitDepth,
                                        pitWallThickness = pWallThickness,
                                        pitWallGaps = pitWallGaps,
                                        slanting = slanting,
                                        slantingLowerHeight = slantingLowerHeight,
                                        beveled = beveled,
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
                        } //End base color
                        
                        /*
                        * Final Subtraction
                        * Starting from here, everything applies to the final block
                        *
                        */

                        //Cut X-Holes
                        if(holeX != false){
                            color(baseColor){
                                for(r = [ 0 : 1 : holeXMaxRows-1]){
                                    for (a = [ startX : 1 : endX - (holeXCentered ? 1 : 0) ]){
                                        if(drawHoleX(a, r)){
                                            translate([posX(a + (holeXCentered ? 0.5 : 0)), 0, -0.5*resultingBaseHeight + holeXGridOffsetZ*rootUnit + r * holeXGridSizeZ*rootUnit]){
                                                rotate([90, 0, 0]){ 
                                                    if(holeXType == "pin"){
                                                        cylinder(h=objectSizeY*cutMultiplier, r=0.5 * holeXSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                    
                                                        translate([0, 0, 0.5 * objectSizeY])
                                                            cylinder(h=2*holeXInsetDepth * rootUnit, r=0.5 * (holeXSize + 2 * holeXInsetThickness * rootUnit), center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                        translate([0, 0, -0.5 * objectSizeY])
                                                            cylinder(h=2*holeXInsetDepth * rootUnit, r=0.5 * (holeXSize + 2 * holeXInsetThickness * rootUnit), center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                    
                                                    }
                                                    else if(holeXType == "axle"){
                                                        mb_axis(height = resultingBaseHeight * cutMultiplier, capHeight=0, size = holeZSize, center=true, alignBottom=false, roundingResolution=($preview ? previewQuality : 1) * 0.5 * holeRoundingResolution);
                                                    }
                                                };
                                            };
                                        }
                                    }
                                }
                            } // End color
                        } // End if holeX
                        
                        //Cut Y-Holes
                        if(holeY != false){
                            color(baseColor){
                                for(r = [ 0 : 1 : holeYMaxRows-1]){
                                    for (b = [ startY : 1 : endY - (holeYCentered ? 1 : 0) ]){
                                        if(drawHoleY(b, r)){
                                            translate([0, posY(b + (holeYCentered ? 0.5 : 0)), -0.5*resultingBaseHeight + holeYGridOffsetZ*rootUnit + r * holeYGridSizeZ*rootUnit]){
                                                rotate([0, 90, 0]){ 
                                                    if(holeYType == "pin"){
                                                        cylinder(h=objectSizeX*cutMultiplier, r=0.5 * holeYSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                    
                                                        translate([0, 0, 0.5 * objectSizeX])
                                                            cylinder(h=2*holeYInsetDepth * rootUnit, r=0.5 * (holeYSize + 2 * holeYInsetThickness * rootUnit), center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                        translate([0, 0, -0.5 * objectSizeX])
                                                            cylinder(h=2*holeYInsetDepth * rootUnit, r=0.5 * (holeYSize + 2 * holeYInsetThickness * rootUnit), center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                    }
                                                    else if(holeYType == "axle"){
                                                        mb_axis(height = resultingBaseHeight * cutMultiplier, capHeight=0, size = holeZSize, center=true, alignBottom=false, roundingResolution=($preview ? previewQuality : 1) * 0.5 * holeRoundingResolution);
                                                    }
                                                };
                                            };
                                        }
                                    }
                                }
                            } // End color
                        } // End if holeY
                        
                        if(holeZ != false){
                            color(baseColor){
                                //Cut Z-Holes
                                for (a = [ startX : 1 : endX - (holeZCenteredX ? 1 : 0) ]){
                                    for (b = [ startY : 1 : endY - (holeZCenteredY ? 1 : 0) ]){
                                        if(drawHoleZ(a, b)){
                                            translate([posX(a + (holeZCenteredX ? 0.5 : 0)), posY(b+(holeZCenteredY ? 0.5 : 0)), 0]){
                                                if(holeZType == "pin"){
                                                    cylinder(h=resultingBaseHeight*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                                }
                                                else if(holeZType == "axle"){
                                                    mb_axis(height = resultingBaseHeight * cutMultiplier, capHeight=0, size = holeZSize, center=true, alignBottom=false, roundingResolution=($preview ? previewQuality : 1) * 0.5 * holeRoundingResolution);
                                                }
                                            };
                                        }
                                    }
                                }
                            } // End color
                        } // End if holeZ

                        /*
                        * Text Cutout
                        */
                        if(!mb_is_empty_string(text) && textDepth < 0){
                            color(textColor == "inherit" ? baseColor : textColor){
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
                            } // End color
                        } // End if text

                        /*
                        * SVG Cutout
                        */
                        if(!mb_is_empty_string(svg) && svgDepth < 0){
                            color(svgColor == "inherit" ? baseColor : svgColor){
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
                            } // End color
                        } // End if svg

                        /*
                        * Screw Holes Z
                        */
                        if(stabilizerGrid || (baseCutoutType == "none") || (baseCutoutType == "groove")){
                            color(baseColor){
                                for (a = [ startX : 1 : endX ]){
                                    for (b = [ startY : 1 : endY ]){
                                        if(drawScrewHoleZ(a, b, 0)){
                                            translate([posX(a), posY(b), 0.5*knobHeight])
                                                cylinder(h = (resultingBaseHeight + knobHeight)*cutMultiplier, r = 0.5*screwHoleZSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                        } 
                                    }
                                }
                            } // End color
                        } // End if stabilizerGrid

                        /*
                        * Screw Holes X
                        */
                        for (b = [ 0 : 1 : len(screwHolesX) - 1]){
                            color(baseColor){
                                for (s = [ 0 : 1 : 1]){
                                    if(screwHolesX[b][2] == undef || screwHolesX[b][2] == s){
                                        translate([posX(screwHolesX[b][0]), sideY(s) + (0.5 - s)*(screwHoleXDepth - cutOffset), xyScrewHolesZ + screwHolesX[b][1] * gridSizeZ])
                                            rotate([90, 0, 0])
                                                cylinder(h = screwHoleXDepth + cutOffset, r = 0.5*screwHoleXSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                    }
                                }
                            } // End color
                        } // End for screwHolesX

                        /*
                        * Screw Holes Y
                        */
                        for (b = [ 0 : 1 : len(screwHolesY) - 1]){
                            color(baseColor){
                                for (s = [ 0 : 1 : 1]){
                                    if(screwHolesY[b][2] == undef || screwHolesY[b][2] == s){
                                        translate([sideX(s) + (0.5 - s)*(screwHoleYDepth - cutOffset), posY(screwHolesY[b][0]), xyScrewHolesZ + screwHolesY[b][1] * gridSizeZ])
                                            rotate([0, 90, 0])
                                                cylinder(h = screwHoleYDepth + cutOffset, r = 0.5*screwHoleYSize, center=true, $fn=($preview ? previewQuality : 1) * holeRoundingResolution);
                                    }
                                }
                            } // End color
                        } // End for screwHolesY

                        /*
                        * Cut Groove
                        */
                        if(baseCutoutType == "groove"){
                            color(baseColor){
                                translate([0, 0, sideZ(0) + 0.5*tongueGrooveDepth]){ 
                                    translate([0, 0, -0.5 * cutOffset]){
                                        mb_tongue(
                                            gridSizeXY = gridSizeXY,
                                            objectSize = [objectSizeX, objectSizeY],
                                            objectSizeAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted],
                                            baseRoundingRadius = baseRoundingRadius,
                                            baseRoundingResolution = baseRoundingResolution,
                                            beveled = beveled,
                                            bevelOuter = bevelOuter,
                                            tongueOffset = tongueOffset,
                                            tongueThickness = tongueThickness,
                                            tongueThicknessAdjustment = tongueThicknessAdjustment,
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
                            } // End color
                        } // End if baseCutoutType
                    } // End main difference
                }

                /*
                * Final Addition AREA
                * Starting from here, everything affects both solid and cutout blocks
                */
                
                /*
                * Classic Knobs
                */
                if(studs != false){
                    color(baseColor){
                        /*
                        * Normal studs
                        */
                        for (a = [ startX : 1 : (endX - (studCentered ? 1 : 0)) ]){
                            for (b = [ startY : 1 : (endY - (studCentered ? 1 : 0)) ]){
                                knobOffset = studCentered ? 0.5 : 0;
                                if(drawGridItem(studs, a, b, 0, false) && drawKnob(a + knobOffset, b + knobOffset)){
                                    
                                    pitKnobOffset = pitKnobCentered ? 0.5 : 0;
                                    inPit = pit && pitKnobs && inPit(a + pitKnobOffset, b + pitKnobOffset);
                                    onPitBorder = !pit || onPitBorder(a + knobOffset, b + knobOffset);
                                    if(onPitBorder || inPit){
                                        posOffset = (inPit ? pitKnobCentered : studCentered) ? 0.5 : 0;
                                        translate([posX(a + posOffset), posY(b + posOffset), knobZ(a + posOffset, b + posOffset)]){ 
                                            difference(){
                                                union(){
                                                    translate([0, 0, -0.5 * (studRounding + studClampHeight * rootUnit)])
                                                        cylinder(h=knobHeight - studRounding - studClampHeight * rootUnit, r=0.5 * knobSize, center=true, $fn=($preview ? previewQuality : 1) * studRoundingResolution);

                                                    
                                                    translate([0, 0, 0.5 * (knobHeight - studClampHeight * rootUnit) - studRounding ])
                                                        cylinder(h=studClampHeight * rootUnit, r=0.5 * knobSize + studClampThickness, center=true, $fn=($preview ? previewQuality : 1) * studRoundingResolution);
                                                    
                                                    translate([0, 0, 0.5 * (knobHeight - studRounding)])
                                                        cylinder(h=studRounding, r=0.5 * knobSize + studClampThickness - studRounding, center=true, $fn=($preview ? previewQuality : 1) * studRoundingResolution);
                                                }
                                                
                                                if(studType(a + posOffset, b + posOffset) == "ring"){
                                                    intersection(){
                                                        cube([knobHoleSize - 2*studHoleClampThickness, knobHoleSize - 2*studHoleClampThickness, knobHeight*cutMultiplier], center=true);
                                                        cylinder(h=knobHeight * cutMultiplier, r=0.5 * knobHoleSize, center=true, $fn=($preview ? previewQuality : 1) * studRoundingResolution);
                                                    }
                                                }
                                            }
                                            
                                            //Knob Rounding
                                            translate([0, 0, 0.5 * knobHeight - studRounding]){ 
                                                mb_torus(
                                                    circleRadius = studRounding, 
                                                    torusRadius = 0.5 * knobSize + studClampThickness, 
                                                    circleResolution = ($preview ? previewQuality : 1) * studRoundingResolution,
                                                    torusResolution = ($preview ? previewQuality : 1) * studRoundingResolution
                                                );
                                            };
                                        };
                                    }
                                }
                            }
                        }
                    } // End base color
                } // End if studs

                /*
                * Tongue
                */
                if(tongue){
                    color(baseColor){
                        translate([0, 0, 0.5 * (resultingBaseHeight + tongueHeight)]){ 
                            mb_tongue(
                                gridSizeXY = gridSizeXY,
                                objectSize = [objectSizeX, objectSizeY],
                                objectSizeAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted],
                                baseRoundingRadius = baseRoundingRadius,
                                baseRoundingResolution = baseRoundingResolution,
                                beveled = beveled,
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
                    } // End color
                } // End if tongue

                //PCB
                if(pcb){
                    color(baseColor){
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
                    } // End color
                } // End if pcb
                
                /*
                * Text
                */
                if(!mb_is_empty_string(text) && textDepth > 0){
                    color(textColor == "inherit" ? baseColor : textColor)
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
                } // End if text

                /*
                * SVG
                */
                if(!mb_is_empty_string(svg) && svgDepth > 0){
                    color(svgColor == "inherit" ? baseColor : svgColor)
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
                } // End if svg

                
            } // End pre_render
        
        

        translate([translateXChildren, translateYChildren, translateZChildren]){
            children();
        }
        
    } //End grid offset
} // End module block    

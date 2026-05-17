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

use <core/block_model.scad>;
use <core/block_part.scad>;
use <core/utils.scad>;
use <core/quality.scad>;

use <layout/layout.scad>;
use <layout/base.scad>;

use <shape/prismoid.scad>;
use <shape/text3d.scad>;
use <shape/svg3d.scad>;
use <shape/pcb.scad>;
use <shape/axis.scad>;

use <bevel.scad>;
use <rounded.scad>;
use <quad.scad>;
use <tongue.scad>;
use <stud.scad>;

include <core/api.scad>;

/*
* Main Module
*/
module mb_block(
    config,
    settings
){
    

    //START get parameters
    unitMbu = mb_param_unitMbu(config, settings);
    unitGrid = mb_param_unitGrid(config, settings);

    scale = mb_param_scale(config, settings);

    rotation = mb_param_rotation(config, settings);
    rotationOffset = mb_param_rotationOffset(config, settings);
    rotationOffsetRevert = mb_param_rotationOffsetRevert(config, settings);
    direction = mb_param_direction(config, settings);

    size = mb_param_size(config, settings);
    sizeAdjustment = mb_param_sizeAdjustment(config, settings);

    offset = mb_param_offset(config, settings);
    

    cutouts = mb_param_cutouts(config, settings);
    ports = mb_param_ports(config, settings);
    
    base = mb_param_base(config, settings);
    baseColor = mb_param_baseColor(config, settings);
    
    baseMod = mb_param_sizeMod(config, settings);

    baseTopPlateHeight = mb_param_baseTopPlateHeight(config, settings);
    baseTopPlateHeightAdjustment = mb_param_baseTopPlateHeightAdjustment(config, settings);

    baseCutoutType = mb_param_baseCutoutType(config, settings);
    baseCutoutMaxDepth = mb_param_baseCutoutMaxDepth(config, settings);

    baseClampOffset = mb_param_baseClampOffset(config, settings);
    baseClampHeight = mb_param_baseClampHeight(config, settings);
    baseClampThickness = mb_param_baseClampThickness(config, settings);
    baseClampOuter = mb_param_baseClampOuter(config, settings);

    baseRoundingRadius = mb_param_baseRoundingRadius(config, settings);
    baseCutoutRoundingRadius = mb_param_baseCutoutRoundingRadius(config, settings);
    

    baseReliefCut = mb_param_baseReliefCut(config, settings);
    baseReliefCutHeight = mb_param_baseReliefCutHeight(config, settings);
    baseReliefCutThickness = mb_param_baseReliefCutThickness(config, settings);

    baseSideAdjustment = mb_param_baseSideAdjustment(config, settings);
    
    baseWallThickness = mb_param_baseWallThickness(config, settings);
    baseWallThicknessAdjustment = mb_param_baseWallThicknessAdjustment(config, settings);
    //baseWallGapsX = mb_param_baseWallGapsX(config, settings);
    //baseWallGapsY = mb_param_baseWallGapsY(config, settings);
    baseWallGaps = mb_param_baseWallGaps(config, settings);

    topPlateHelpers = mb_param_topPlateHelpers(config, settings);
    topPlateHelperHeight = mb_param_topPlateHelperHeight(config, settings);
    topPlateHelperThickness = mb_param_topPlateHelperThickness(config, settings);

    stabilizerGrid = mb_param_stabilizerGrid(config, settings);
    stabilizerGridOffset = mb_param_stabilizerGridOffset(config, settings);
    stabilizerGridHeight = mb_param_stabilizerGridHeight(config, settings);
    stabilizerGridThickness = mb_param_stabilizerGridThickness(config, settings);
    stabilizerExpansion = mb_param_stabilizerExpansion(config, settings);
    stabilizerExpansionOffset = mb_param_stabilizerExpansionOffset(config, settings);

    pillars = mb_param_pillars(config, settings);
    pillarGapCornerLength = mb_param_pillarGapCornerLength(config, settings);
    pillarGapMiddle = mb_param_pillarGapMiddle(config, settings);

    pinDiameter = mb_param_pinDiameter(config, settings);
    pinDiameterAdjustment = mb_param_pinDiameterAdjustment(config, settings);

    tubeWallThickness = mb_param_tubeWallThickness(config, settings);
    tubeXDiameter = mb_param_tubeXDiameter(config, settings);
    tubeXDiameterAdjustment = mb_param_tubeXDiameterAdjustment(config, settings);
    tubeYDiameter = mb_param_tubeYDiameter(config, settings);
    tubeYDiameterAdjustment = mb_param_tubeYDiameterAdjustment(config, settings);
    tubeZDiameter = mb_param_tubeZDiameter(config, settings);
    tubeZDiameterAdjustment = mb_param_tubeZDiameterAdjustment(config, settings);
    tubeInnerClampThickness = mb_param_tubeInnerClampThickness(config, settings);

    slope = mb_param_slope(config, settings);
    slopeBaseHeightLower = mb_param_slopeBaseHeightLower(config, settings);
    slopeBaseHeightLowerInner = mb_param_slopeBaseHeightLowerInner(config, settings);
    slopeBaseHeightUpper = mb_param_slopeBaseHeightUpper(config, settings);

    bevel = mb_param_bevel(config, settings);

    holeX = mb_param_holeX(config, settings);
    holeXType = mb_param_holeXType(config, settings);
    holeXShift = mb_param_holeXShift(config, settings);
    holeXDiameter = mb_param_holeXDiameter(config, settings);
    holeXDiameterAdjustment = mb_param_holeXDiameterAdjustment(config, settings);
    holeXInsetThickness = mb_param_holeXInsetThickness(config, settings);
    holeXInsetThicknessAdjustment = mb_param_holeXInsetThicknessAdjustment(config, settings);
    holeXInsetDepth = mb_param_holeXInsetDepth(config, settings);
    holeXInsetDepthAdjustment = mb_param_holeXInsetDepthAdjustment(config, settings);
    holeXGridOffsetZ = mb_param_holeXGridOffsetZ(config, settings);
    holeXGridOffsetZAdjustment = mb_param_holeXGridOffsetZAdjustment(config, settings);
    holeXGridSizeZ = mb_param_holeXGridSizeZ(config, settings);
    holeXGridSizeZAdjustment = mb_param_holeXGridSizeZAdjustment(config, settings);
    holeXMinTopMargin = mb_param_holeXMinTopMargin(config, settings);
    holeXPartial = mb_param_holeXPartial(config, settings);

    holeY = mb_param_holeY(config, settings);
    holeYType = mb_param_holeYType(config, settings);
    holeYShift = mb_param_holeYShift(config, settings);
    holeYDiameter = mb_param_holeYDiameter(config, settings);
    holeYDiameterAdjustment = mb_param_holeYDiameterAdjustment(config, settings);
    holeYInsetThickness = mb_param_holeYInsetThickness(config, settings);
    holeYInsetThicknessAdjustment = mb_param_holeYInsetThicknessAdjustment(config, settings);
    holeYInsetDepth = mb_param_holeYInsetDepth(config, settings);
    holeYInsetDepthAdjustment = mb_param_holeYInsetDepthAdjustment(config, settings);
    holeYGridOffsetZ = mb_param_holeYGridOffsetZ(config, settings);
    holeYGridOffsetZAdjustment = mb_param_holeYGridOffsetZAdjustment(config, settings);
    holeYGridSizeZ = mb_param_holeYGridSizeZ(config, settings);
    holeYGridSizeZAdjustment = mb_param_holeYGridSizeZAdjustment(config, settings);
    holeYMinTopMargin = mb_param_holeYMinTopMargin(config, settings);
    holeYPartial = mb_param_holeYPartial(config, settings);

    holeZ = mb_param_holeZ(config, settings);
    holeZType = mb_param_holeZType(config, settings);
    holeZShift = mb_param_holeZShift(config, settings);
    holeZDiameter = mb_param_holeZDiameter(config, settings);
    holeZDiameterAdjustment = mb_param_holeZDiameterAdjustment(config, settings);
    
    holeZPartialX = mb_param_holeZPartialX(config, settings);
    holeZPartialY = mb_param_holeZPartialY(config, settings);

    holeAxleThickness = mb_param_holeAxleThickness(config, settings);

    studs = mb_param_studs(config, settings);
    studType = mb_param_studType(config, settings);
    studShift = mb_param_studShift(config, settings);
    studMaxOverhang = mb_param_studMaxOverhang(config, settings);
    studPadding = mb_param_studPadding(config, settings);

    studClampHeight = mb_param_studClampHeight(config, settings);
    studClampThickness = mb_param_studClampThickness(config, settings);

    studHoleDiameter = mb_param_studHoleDiameter(config, settings);
    studHoleDiameterAdjustment = mb_param_studHoleDiameterAdjustment(config, settings);
    studHoleClampThickness = mb_param_studHoleClampThickness(config, settings);

    studRounding = mb_param_studRounding(config, settings);

    studDiameter = mb_param_studDiameter(config, settings);
    studDiameterAdjustment = mb_param_studDiameterAdjustment(config, settings);

    studHeight = mb_param_studHeight(config, settings);
    studHeightAdjustment = mb_param_studHeightAdjustment(config, settings);

    studSink = mb_param_studSink(config, settings);

    studCutoutAdjustment = mb_param_studCutoutAdjustment(config, settings);

    studIcon = mb_param_studIcon(config, settings);
    studIconDimensions = mb_param_studIconDimensions(config, settings);
    studIconScale = mb_param_studIconScale(config, settings);
    studIconDepth = mb_param_studIconDepth(config, settings);
    studIconColor = mb_param_studIconColor(config, settings);

    tongue = mb_param_tongue(config, settings);
    tongueHeight = mb_param_tongueHeight(config, settings);
    tongueGrooveDepth = mb_param_tongueGrooveDepth(config, settings);
    tongueRoundingRadius = mb_param_tongueRoundingRadius(config, settings);
    tongueInnerRoundingRadius = mb_param_tongueInnerRoundingRadius(config, settings);
    tongueThickness = mb_param_tongueThickness(config, settings);
    tongueThicknessAdjustment = mb_param_tongueThicknessAdjustment(config, settings);
    tongueOffset = mb_param_tongueOffset(config, settings);
    tongueClampHeight = mb_param_tongueClampHeight(config, settings);
    tongueClampOffset = mb_param_tongueClampOffset(config, settings);
    tongueClampThickness = mb_param_tongueClampThickness(config, settings);

    grille = mb_param_grille(config, settings);
    grilleInverted = mb_param_grilleInverted(config, settings);
    grilleDepth = mb_param_grilleDepth(config, settings);
    grilleCount = mb_param_grilleCount(config, settings);

    recess = mb_param_recess(config, settings);
    recessRoundingRadius = mb_param_recessRoundingRadius(config, settings);
    recessDepth = mb_param_recessDepth(config, settings);
    recessWallThickness = mb_param_recessWallThickness(config, settings);
    recessStuds = mb_param_recessStuds(config, settings);
    recessStudPadding = mb_param_recessStudPadding(config, settings);
    recessStudType = mb_param_recessStudType(config, settings);
    recessStudShift = mb_param_recessStudShift(config, settings);
    recessWallGaps = mb_param_recessWallGaps(config, settings);

    text = mb_param_text(config, settings);
    textSide = mb_param_textSide(config, settings);
    textDepth = mb_param_textDepth(config, settings);
    textFont = mb_param_textFont(config, settings);
    textSize = mb_param_textSize(config, settings);
    textSpacing = mb_param_textSpacing(config, settings);
    textVerticalAlign = mb_param_textVerticalAlign(config, settings);
    textHorizontalAlign = mb_param_textHorizontalAlign(config, settings);
    textOffset = mb_param_textOffset(config, settings);
    textColor = mb_param_textColor(config, settings);

    surfacePattern = mb_param_surfacePattern(config, settings);
    surfacePatternDimensions = mb_param_surfacePatternDimensions(config, settings);
    surfacePatternOffset = mb_param_surfacePatternOffset(config, settings);
    surfacePatternScale = mb_param_surfacePatternScale(config, settings);
    surfacePatternDepth = mb_param_surfacePatternDepth(config, settings);
    surfacePatternColor = mb_param_surfacePatternColor(config, settings);

    svg = mb_param_svg(config, settings);
    svgSide = mb_param_svgSide(config, settings);
    svgDepth = mb_param_svgDepth(config, settings);
    svgDimensions = mb_param_svgDimensions(config, settings);
    svgScale = mb_param_svgScale(config, settings);
    svgOffset = mb_param_svgOffset(config, settings);
    svgColor = mb_param_svgColor(config, settings);

    connectors = mb_param_connectors(config, settings);
    connectorPadding = mb_param_connectorPadding(config, settings);
    connectorHeight = mb_param_connectorHeight(config, settings);
    connectorDepth = mb_param_connectorDepth(config, settings);
    connectorWidth = mb_param_connectorWidth(config, settings);
    connectorDepthTolerance = mb_param_connectorDepthTolerance(config, settings);
    connectorSideTolerance = mb_param_connectorSideTolerance(config, settings);

    screwHolesZ = mb_param_screwHolesZ(config, settings);
    screwHoleZSize = mb_param_screwHoleZSize(config, settings);
    screwHoleZHelperThickness = mb_param_screwHoleZHelperThickness(config, settings);
    screwHoleZHelperOffset = mb_param_screwHoleZHelperOffset(config, settings);
    screwHoleZHelperHeight = mb_param_screwHoleZHelperHeight(config, settings);

    screwHolesX = mb_param_screwHolesX(config, settings);
    screwHoleXSize = mb_param_screwHoleXSize(config, settings);
    screwHoleXDepth = mb_param_screwHoleXDepth(config, settings);

    screwHolesY = mb_param_screwHolesY(config, settings);
    screwHoleYSize = mb_param_screwHoleYSize(config, settings);
    screwHoleYDepth = mb_param_screwHoleYDepth(config, settings);

    pcb = mb_param_pcb(config, settings);
    pcbMountingType = mb_param_pcbMountingType(config, settings);
    pcbDimensions = mb_param_pcbDimensions(config, settings);
    pcbOffset = mb_param_pcbOffset(config, settings);
    pcbScrewSocketSize = mb_param_pcbScrewSocketSize(config, settings);
    pcbScrewSocketHoleSize = mb_param_pcbScrewSocketHoleSize(config, settings);
    pcbScrewSocketHeight = mb_param_pcbScrewSocketHeight(config, settings);
    pcbScrewSockets = mb_param_pcbScrewSockets(config, settings);

    align = mb_param_align(config, settings);
    alignChildren = mb_param_alignChildren(config, settings);

    qualitySegBase = mb_param_qualitySegBase(config, settings);
    qualityResolutionMax = mb_param_qualityResolutionMax(config, settings);
    qualityFactor = mb_param_qualityFactor(config, settings);
    qualityResolutionMin = mb_param_qualityResolutionMin(config, settings);
    qualityResolutionMultiplier = mb_param_qualityResolutionMultiplier(config, settings);

    previewQuality = mb_param_previewQuality(config, settings);
    previewRender = mb_param_previewRender(config, settings);
    previewRenderConvexity = mb_param_previewRenderConvexity(config, settings);

    blockId = mb_param_id(config, settings);
    debug = mb_param_debug(config, settings);

    //END get parameters

    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    /*
    * Start measurements
    */
    
    
    block_obj = mb_block_obj(
        size = size, 
        size_adj = sizeAdjustment,
        size_mod = baseMod, 
        base_adj = baseSideAdjustment,
        bevel = bevel,
        slope = slope,
        grid_cfg = [unitMbu, unitGrid[0], unitGrid[1]],
        scale = scale,
        recess = recess,
        recess_wall_thickness = recessWallThickness,
        recess_wall_gaps = recessWallGaps,
        baseWallGaps = baseWallGaps,
        relief_cut = baseReliefCut
    );
    
    mbuToMm = scale * unitMbu;

    gridSizeXY = unitGrid[0] * mbuToMm;
    gridSizeZ = unitGrid[1] * mbuToMm;

    //Object Size     
    objectSizeX = gridSizeXY * size[0];
    objectSizeY = gridSizeXY * size[1];
    objectSizeZ = size[2] * gridSizeZ;

    objectSize = [objectSizeX, objectSizeY, objectSizeZ];

    os_mm = mb_block_obj_size(block_obj, unit="mm");
    osm_mm = mb_block_obj_size_mod(block_obj, unit="mm");
    osa_mm = mb_block_obj_size_adj(block_obj, unit="mm");
    
    

    //Side Adjustment
   
    baseModRes = mb_qc_resolve(qc = baseMod, cube = true, mul = [gridSizeXY, gridSizeXY, gridSizeZ]);
    baseModR = mb_qc_resolve(qc = baseMod, cube = true);
    bevelMod = [[-baseModR[0], -baseModR[2]],[-baseModR[0], baseModR[3]], [baseModR[1],baseModR[3]],[baseModR[1],-baseModR[2]]];
    bevelRes = mb_bevel_resolve(bevel);

    objectSizeMod = [
        objectSizeX + baseModRes[0] + baseModRes[1],
        objectSizeY + baseModRes[2] + baseModRes[3],
        objectSizeZ + baseModRes[4] + baseModRes[5]
    ];
    
    bsa =  mb_qc_resolve(qc = baseSideAdjustment, cube = true, default = [sizeAdjustment[0], sizeAdjustment[0], sizeAdjustment[0], sizeAdjustment[0], 0, sizeAdjustment[1]]); 
    sideAdjustment = mb_array_add(bsa, baseModRes);

    // Object Size Fully Adjusted
    objectSizeXAdjusted = objectSizeX + sideAdjustment[0] + sideAdjustment[1];
    objectSizeYAdjusted = objectSizeY + sideAdjustment[2] + sideAdjustment[3];
    objectSizeZAdjusted = objectSizeZ + sideAdjustment[4] + sideAdjustment[5];

    objectSizeAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted, objectSizeZAdjusted];


    echo(
        objectSize = objectSize, 
        os_mm = os_mm, 
        objectSizeMod = objectSizeMod,
        osm_mm = osm_mm, 
        objectSizeAdjusted = objectSizeAdjusted,
        osa_mm = osa_mm, 
        baseModRes = baseModRes,
        size_mod = mb_block_size_mod(block_obj, unit="mm"), 
        bsa = bsa,
        base_adj = mb_block_base_adj(block_obj, unit="mm"));

    /*
    * End measurements
    */

    minObjectSide = min(objectSizeXAdjusted, objectSizeYAdjusted);
    adjustedSizeRelation = [objectSizeXAdjusted / objectSizeMod[0], objectSizeYAdjusted / objectSizeMod[1], objectSizeZAdjusted / objectSizeMod[2]];

    gridSizeX = mb_grid_size_x(size, slope);
    gridSizeY = mb_grid_size_y(size, slope);

    //Calculate Brick Align and Offset
    //alignment = align;
    //alignX = (alignment[0] == "center" || alignment[0] == "ccs") ? 0 : ((alignment[0] == "start" ? 1 : -1) * 0.5*objectSizeX);
    //alignY = (alignment[1] == "center" || alignment[1] == "ccs") ? 0 : ((alignment[1] == "start" ? 1 : -1) * 0.5*objectSizeY);
    //alignZ = alignment[2] == "center" ? 0 : ((alignment[2] == "start" || alignment[2] == "ccs") ? 0.5*objectSizeZ : -0.5*objectSizeZ);
    alignX = mb_align_offset(align[0], objectSizeX);
    alignY = mb_align_offset(align[1], objectSizeY);
    alignZ = mb_align_offset(align[2], objectSizeZ); 
    
    directionRotationZ = direction * -90;

    //Rotation Offset
    rotationOffsetX = rotationOffset[0] * gridSizeXY;
    rotationOffsetY = rotationOffset[1] * gridSizeXY;
    rotationOffsetZ = rotationOffset[2] * gridSizeZ;

    preRotationOffset = [rotationOffsetX + (direction % 2 == 0 ? alignX : alignY), rotationOffsetY + (direction % 2 == 0 ? alignY : alignX), rotationOffsetZ + alignZ];

    //Grid offset
    gridOffsetX = offset[0] * gridSizeXY - (rotationOffsetRevert ? rotationOffsetX : 0);
    gridOffsetY = offset[1] * gridSizeXY - (rotationOffsetRevert ? rotationOffsetY : 0);
    gridOffsetZ = offset[2] * gridSizeZ - (rotationOffsetRevert ? rotationOffsetZ : 0); 

    //Children alignment
    //alignmentChildren = is_string(alignChildren) ? [alignChildren, alignChildren, alignChildren] : alignChildren;
    //translateXChildren = ((alignmentChildren[0] == "center" || alignmentChildren[0] == "ccs") ? 0 : ((alignmentChildren[0] == "start" ? -1 : 1) * 0.5*objectSizeX));
    //translateYChildren = ((alignmentChildren[1] == "center" || alignmentChildren[0] == "ccs") ? 0 : ((alignmentChildren[1] == "start" ? -1 : 1) * 0.5*objectSizeY));
    //translateZChildren = (alignmentChildren[2] == "center" ? 0 : ((alignmentChildren[2] == "start" || alignmentChildren[2] == "ccs")  ? -0.5*objectSizeZ : 0.5*objectSizeZ));
    
    translateXChildren = mb_align_offset(alignChildren[0], objectSizeX, true);
    translateYChildren = mb_align_offset(alignChildren[1], objectSizeY, true);
    translateZChildren = mb_align_offset(alignChildren[2], objectSizeZ, true); 

    //Base Cutout and Pit Depth
    topPlateHeight = baseTopPlateHeight * mbuToMm + baseTopPlateHeightAdjustment;
    baseCutoutMinDepth = gridSizeZ - topPlateHeight; // mm -- 1 plate minus topPlateHeight
    maxBaseCutoutDepth = baseCutoutMaxDepth * mbuToMm;  
    maxRecessDepth = objectSizeMod[2] - topPlateHeight - (baseCutoutType == "none" ? 0 : baseCutoutMinDepth);
    
    resultingPitDepth = recess ? (recessDepth != "auto" ? min(recessDepth * gridSizeZ, maxRecessDepth) : maxRecessDepth) : 0;
    
    calculatedBaseCutoutDepth = max(0, min(maxBaseCutoutDepth, objectSizeMod[2] - topPlateHeight - resultingPitDepth));  
    resultingTopPlateHeight = objectSizeMod[2] - resultingPitDepth - calculatedBaseCutoutDepth; //topPlateHeight + ((maxBaseCutoutDepth > 0 && (calculatedBaseCutoutDepth > maxBaseCutoutDepth)) ? (calculatedBaseCutoutDepth - maxBaseCutoutDepth) : 0);
    baseCutoutDepth = baseCutoutType == "none" ? 0 : calculatedBaseCutoutDepth; //((maxBaseCutoutDepth > 0 && (calculatedBaseCutoutDepth > maxBaseCutoutDepth)) ? maxBaseCutoutDepth : calculatedBaseCutoutDepth);
    
    pWallThickness = mb_resolve_side_quad(recessWallThickness);
    recWallThickness = mb_resolve_side_quad(recessWallThickness, gridSizeXY);
    recStudPaddingResolved = mb_resolve_side_quad(recessStudPadding, gridSizeXY);

    pitSizeX = objectSizeMod[0] - (recWallThickness[0] + recWallThickness[1]);
    pitSizeY = objectSizeMod[1] - (recWallThickness[2] + recWallThickness[3]);

    //Default diameter of pins and stud holes
    //Default thickness of a base wall multiplied by 2
    pDiameter = unitGrid[0] - studDiameter;

    wallThicknessOrg = (baseWallThickness == "auto" ? 0.5 * pDiameter : baseWallThickness) * mbuToMm;
    wallThickness = wallThicknessOrg + baseWallThicknessAdjustment;
    baseClampWallThickness = wallThickness + baseClampThickness;

    baseRoundingRadiusResolved = mb_base_rounding_radius(baseRoundingRadius, gridSizeXY * min(adjustedSizeRelation[0], adjustedSizeRelation[1]), gridSizeZ * adjustedSizeRelation[2]);
    baseRoundingRadiusZ = baseRoundingRadiusResolved[2];
    
    textureRoundingRadius = mb_base_cutout_radius(-0.5 * wallThickness, baseRoundingRadiusZ, minObjectSide);
    cutoutRoundingRadius = mb_base_cutout_radius(baseCutoutRoundingRadius == "auto" ? -wallThickness : mb_rounding_radius(baseCutoutRoundingRadius, gridSizeXY), baseRoundingRadiusZ, minObjectSide);
    
    minCutoutSide = min(objectSizeMod[0] - 2*wallThickness, objectSizeMod[0] - 2*wallThickness);
    cutoutClampRoundingRadius = baseClampThickness > 0 ? mb_base_cutout_radius(-baseClampThickness, cutoutRoundingRadius, minCutoutSide) : cutoutRoundingRadius;

    baseClampThicknessOuter = baseClampOuter ? baseClampThickness : 0;
    bClampOffset = baseClampOffset * mbuToMm;
    bClampHeight = baseClampHeight * mbuToMm;
                                    
    //Calculate Z Positions
    floorZ = sideZ(0, false);
    baseCutoutZ = floorZ + 0.5 * baseCutoutDepth;        
    topPlateZ = floorZ + baseCutoutDepth + 0.5 * resultingTopPlateHeight;
    xyScrewHolesZ = floorZ + 0.5 * gridSizeZ;
    pitFloorZ = floorZ  + baseCutoutDepth + resultingTopPlateHeight;

    
    //Bevel
    beveled = true;
    cornersMod = mb_resolve_bevel_horizontal(bevelMod, size, gridSizeXY);
    bevelOuter = mb_resolve_bevel_horizontal(bevelRes, size, gridSizeXY);
    bevelCrop = mb_inset_quad_lrfh(bevelOuter, mb_array_mul(baseModRes, -1));
    
    //bevelOuterAdjusted = mb_inset_quad_lrfh(bevelOuter, [-sideAdjustment[0], -sideAdjustment[1], -sideAdjustment[2], -sideAdjustment[3]]);
    bevelOuterAdjusted =
        mb_inset_quad_lrfh(
            bevelOuter,
            mb_array_mul(bsa, -1)
        );
    
    bevelInner = mb_inset_quad_lrfh(bevelCrop, wallThickness);

    mul_grd_to_mm = mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from="grd", to="mm");
    
    stud_base_cutout = mb_block_part_to_prismoid(block_obj, part=mb_block_part__stud_base_cutout(block_obj), mul=mul_grd_to_mm)[1][0];
    base_cutout = mb_block_part_to_prismoid(block_obj, part=mb_block_part__base_cutout(block_obj), mul=mul_grd_to_mm)[1][0];
    base_adjusted = mb_block_part_to_prismoid(block_obj, part=mb_block_part__base_outer(block_obj, adjusted = true), mul=mul_grd_to_mm)[1][0];

    bevelInnerOrg = mb_inset_quad_lrfh(bevelCrop, wallThicknessOrg);
    bevelTexture = mb_inset_quad_lrfh(bevelCrop, 0.5*wallThickness);
    
    //corners = mb_resolve_bevel_horizontal([[0,0],[0,0],[0,0],[0,0]], size, gridSizeXY);
    
    //cornersInner = mb_inset_quad_lrfh(corners, wallThickness);
    cornersInnerOrg = mb_inset_quad_lrfh(cornersMod, wallThicknessOrg);

    // Pit
    //pBevelPad =  [(recWallThickness[0] + recStudPaddingResolved[0]), (recWallThickness[1] + recStudPaddingResolved[1]), (recWallThickness[2] + recStudPaddingResolved[2]), (recWallThickness[3] + recStudPaddingResolved[3])];
    //pitBevel = mb_inset_quad_lrfh(bevelOuter, [recWallThickness[0]+studMaxOverhang, recWallThickness[1]+studMaxOverhang, recWallThickness[2]+studMaxOverhang, recWallThickness[3]+studMaxOverhang]);
    pBevelPad = mb_array_add(recWallThickness, recStudPaddingResolved);

    pitBevel = mb_inset_quad_lrfh(
        bevelCrop,
        mb_array_add(recWallThickness, studMaxOverhang)
    );
    
    pitBevelPadding = mb_inset_quad_lrfh(bevelCrop, pBevelPad);
    cornersPitPadding = mb_inset_quad_lrfh(cornersMod, pBevelPad);
    
    //pMinThickness = [
    //    -min(recWallThickness[2], recWallThickness[0]), 
    //    -min(recWallThickness[0], recWallThickness[3]), 
    //    -min(recWallThickness[3], recWallThickness[1]), 
    //    -min(recWallThickness[1], recWallThickness[2])
    //];
    pMinThickness = mb_array_min_pair_cycle_neg(recWallThickness);
    pitRadius = mb_base_cutout_radius(recessRoundingRadius == "auto" ? pMinThickness : mb_rounding_radius(recessRoundingRadius, gridSizeXY), baseRoundingRadiusZ, minObjectSide);            
    
    // Studs
    knobSizeOrg = studDiameter * mbuToMm;
    knobSize = knobSizeOrg + studDiameterAdjustment;
    knobHeightOrg = studHeight * mbuToMm;
    knobHeight = knobHeightOrg + studHeightAdjustment;

    knobCutSize = knobSizeOrg + studCutoutAdjustment[0];
    knobCutHeight = knobHeightOrg + studCutoutAdjustment[1];
    knobHoleSize = (studHoleDiameter == "auto" ? pDiameter : studHoleDiameter) * mbuToMm + studHoleDiameterAdjustment;

    knobRounding = studRounding * mbuToMm;
    knobSink = studSink * mbuToMm;
    knobPartsOverlap = 0.01;

    //Knob Padding
    knobPaddingResolved = mb_resolve_side_quad(studPadding, gridSizeXY);
    bevelKnobPadding = mb_inset_quad_lrfh(bevelCrop, knobPaddingResolved);
    cornersKnobPadding = mb_inset_quad_lrfh(cornersMod, knobPaddingResolved);
    //knobPaddingRadiusInv = [
    //    -min(knobPaddingResolved[2], knobPaddingResolved[0]), 
    //    -min(knobPaddingResolved[0], knobPaddingResolved[3]), 
    //    -min(knobPaddingResolved[3], knobPaddingResolved[1]),
    //    -min(knobPaddingResolved[1], knobPaddingResolved[2])
    //];
    knobPaddingRadiusInv = mb_array_min_pair_cycle_neg(knobPaddingResolved);
    knobPaddingRoundingRadius = mb_base_rel_radius(knobPaddingRadiusInv, baseRoundingRadiusZ, minObjectSide, true);

    // Tubes XYZ
    tubeDiameter = studDiameter + 2 * tubeWallThickness;
    tubeXSize = (tubeXDiameter == "auto" ? tubeDiameter : tubeXDiameter) * mbuToMm + tubeXDiameterAdjustment;
    tubeYSize = (tubeYDiameter == "auto" ? tubeDiameter : tubeYDiameter) * mbuToMm + tubeYDiameterAdjustment;
    tubeZSize = (tubeZDiameter == "auto" ? tubeDiameter : tubeZDiameter) * mbuToMm + tubeZDiameterAdjustment;
    
    // Pin
    pinSize = (pinDiameter == "auto" ? pDiameter : pinDiameter) * mbuToMm + pinDiameterAdjustment;
    
    //Holes XYZ
    holeXDiameterResolved = (holeXDiameter == "auto" ? studDiameter : holeXDiameter) * mbuToMm;
    holeXSize = holeXDiameterResolved + holeXDiameterAdjustment;

    holeXInsetThicknessFinal = holeXInsetThickness * mbuToMm + holeXInsetThicknessAdjustment;
    holeXMaxRows = mb_vertical_hole_count(
        rect_height = objectSizeZ,
        first_hole_center_from_bottom = holeXGridOffsetZ * mbuToMm,
        hole_diameter = holeXDiameterResolved + holeXInsetThickness * mbuToMm,
        hole_center_spacing = holeXGridSizeZ * mbuToMm,
        min_top_margin = holeXMinTopMargin * mbuToMm
    );

    holeYDiameterResolved = (holeYDiameter == "auto" ? studDiameter : holeYDiameter) * mbuToMm;
    holeYSize = holeYDiameterResolved + holeYDiameterAdjustment;

    holeYInsetThicknessFinal = holeYInsetThickness * mbuToMm + holeYInsetThicknessAdjustment;
    holeYMaxRows = mb_vertical_hole_count(
        rect_height = objectSizeZ,
        first_hole_center_from_bottom = holeYGridOffsetZ * mbuToMm,
        hole_diameter = holeYDiameterResolved + holeYInsetThickness * mbuToMm,
        hole_center_spacing = holeYGridSizeZ * mbuToMm,
        min_top_margin = holeYMinTopMargin * mbuToMm
    );

    holeZDiameterResolved = (holeZDiameter == "auto" ? studDiameter : holeZDiameter) * mbuToMm;
    holeZSize = holeZDiameterResolved + holeZDiameterAdjustment;

    holeZCenteredX = (holeZShift == true || holeZShift == "x" || holeZShift == "xy");
    holeZCenteredY = (holeZShift == true || holeZShift == "y" || holeZShift == "xy");
    
    //Stabilizer
    sGridThickness = stabilizerGridThickness * mbuToMm;
    sGridHeight = stabilizerGridHeight * mbuToMm;
    
    //Tongue
    tonHeightCalc = tongueHeight * mbuToMm;
    tonThicknessCalc = tongueThickness * mbuToMm;
    tonOffsetCalc = tongueOffset * mbuToMm;
    tonClampHeightCalc = tongueClampHeight * mbuToMm;
    tonClampOffsetCalc = tongueClampOffset * mbuToMm;
    tonGrooveDepthCalc = tongueGrooveDepth * mbuToMm;

    txtDepth = textDepth * mbuToMm;

    grilleSmall = grilleDepth * mbuToMm < resultingTopPlateHeight;

    //Decorator Rotations
    decoratorRotations = [[90, 0, -90], [90, 0, 90], [90, 0, 0], [90, 0, 180], [0, 180, 180], [0, 0, 0]];

    //Surface Pattern
    surfacePatternSide = 5;
    
    //Grid
    startX = floor(- baseModR[0]);
    midX = floor(0.5 * size[0] - 1);
    endX = ceil(size[0] - 1 + baseModR[1]);
    
    startY = floor(- baseModR[2]);
    midY = floor(0.5 * size[1] - 1);
    endY = ceil(size[1] - 1 + baseModR[3]);
            
    mid = [midX, midY];
    
    offsetX = 0.5 * (size[0] - 1);
    offsetY = 0.5 * (size[1] - 1);

    holeXStart = holeXShift ? (holeXPartial == "start" || holeXPartial == "all" ? startX - 1 : startX) : startX;
    holeXEnd = holeXShift ? (holeXPartial == "end" || holeXPartial == "all" ? floor(endX) : round(endX) - 1) : (holeXPartial == "end" || holeXPartial == "all" ? floor(endX) + 1 : floor(endX));

    holeYStart = holeYShift ? (holeYPartial == "start" || holeYPartial == "all" ? startY - 1 : startY) : startY;
    holeYEnd = holeYShift ? (holeYPartial == "end" || holeYPartial == "all" ? floor(endY) : round(endY) - 1) : (holeYPartial == "end" || holeYPartial == "all" ? floor(endY) + 1 : floor(endY));

    holeZStartX = holeZCenteredX ? (holeZPartialX == "start" || holeZPartialX == "all" ? startX - 1 : startX) : startX;
    holeZEndX = holeZCenteredX ? (holeZPartialX == "end" || holeZPartialX == "all" ? floor(endX) : round(endX) - 1) : (holeZPartialX == "end" || holeZPartialX == "all" ? floor(endX) + 1 : floor(endX));

    holeZStartY = holeZCenteredY ? (holeZPartialY == "start" || holeZPartialY == "all" ? startY - 1 : startY) : startY;
    holeZEndY = holeZCenteredY ? (holeZPartialY == "end" || holeZPartialY == "all" ? floor(endY) : round(endY) - 1) : (holeZPartialY == "end" || holeZPartialY == "all" ? floor(endY) + 1 : floor(endY));

    pillarStartX = min(holeZStartX, startX);
    pillarEndX = max(holeZEndX, ceil(endX) - 1);

    pillarStartY = min(holeZStartY, startY);
    pillarEndY = max(holeZEndY, ceil(endY) - 1);

    /*
    echo(startX = startX, 
        endX = endX, 
        startY = startY, 
        endY = endY, 
        pillarStartX = pillarStartX, 
        pillarEndX = pillarEndX, 
        pillarStartY =  pillarStartY, 
        pillarEndY = pillarEndY);*/

    /*
    * START Functions
    */
    

    
    function sideX(side, adj = true) = adj ? 0.5 * (sideAdjustment[1] - sideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted : (side - 0.5) * objectSizeX;
    function sideY(side, adj = true) = adj ? 0.5 * (sideAdjustment[3] - sideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted : (side - 0.5) * objectSizeY;
    function sideZ(side, adj = true) = adj ? 0.5 * (sideAdjustment[5] - sideAdjustment[4]) + (side - 0.5) * objectSizeZAdjusted : (side - 0.5) * objectSizeZ;

    function posX(a) = (a - offsetX) * gridSizeXY;
    function posY(b) = (b - offsetY) * gridSizeXY;
    
    function sidePosX(c, axisFace = 0, offsetX = 0) = sideX(axisFace, false) + offsetX + c * gridSizeXY;
    function sidePosY(c, axisFace = 0, offsetY = 0) = sideY(axisFace, false) + offsetY + c * gridSizeXY;
    function sidePosZ(c, axisFace = 0, offsetZ = 0) = sideZ(axisFace, false) + offsetZ + c * gridSizeZ;

    function portSideOffset(side, align, gridPos) = 
            let(align = mb_align_resolve(align),
                axisFace = mb_side_to_axis_face(side),
                offsets = [
                            [sideX(axisFace, false), sidePosY(gridPos[0], mb_align_to_axis_face(align[0])), sidePosZ(gridPos[1],  mb_align_to_axis_face(align[1]))],
                            [sidePosX(gridPos[0], mb_align_to_axis_face(align[0])), sideY(axisFace, false), sidePosZ(gridPos[1], mb_align_to_axis_face(align[1]))],
                            [sidePosX(gridPos[0], mb_align_to_axis_face(align[0])), sidePosY(gridPos[1], mb_align_to_axis_face(align[1])), sideZ(axisFace, false)]
                          ])
                offsets[mb_side_to_axis(side)];

    function portOffset(side, portOffset) = 
            let(offsets = [
                            [0, portOffset[0], portOffset[1]], 
                            [portOffset[0], 0, portOffset[1]], 
                            [portOffset[0], portOffset[1], 0]
                            ])
                offsets[mb_side_to_axis(side)];

    function portShapeRotation(side) = 
            let(rots = [
                [0, -90, 0], 
                [-90, 0, 0], 
                [0, 0, 0]
                ])
                rots[mb_side_to_axis(side)];

    function portRotation(side, rot) = 
            let(rots = [
                [rot, 0, 0], 
                [0, rot, 0], 
                [0, 0, rot]
                ])
                rots[mb_side_to_axis(side)];

    
    function portShapeRectSize(side, rectSize, portCutThickness) =
            let(axisInt = mb_side_to_axis(side))
            [rectSize[axisInt > 0 ? 0 : 1], rectSize[axisInt > 0 ? 1 : 0],  portCutThickness];

    /*
    * Grid
    */
    function inGridArea(a, b, rect) = (a >= rect[0]) && (b >= rect[1]) && (a <= rect[2]) && (b <= rect[3]); //[x0, y0, x1, y1]
    function getGridItem(items, defaultValue, a, b, i, prev) = (is_bool(items) ? (items == false ? false : defaultValue) : ((i >= len(items)) ? prev : getGridItem(items, defaultValue, a, b, i+1, is_bool(items[i]) ? (items[i] == false ? false : defaultValue) : (inGridArea(a, b, items[i]) ? (items[i][4] == undef ? defaultValue : items[i][4]) : prev))));
    
    /*
    * Pillars / Pins
    */
    function isCornerZone(value, i) = (value < pillarGapCornerLength) || (value >= size[i] - (pillarGapCornerLength + 1)); 
    function isMiddleZone(value, i) = (size[i] >= pillarGapMiddle) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (size[i] >= pillarGapMiddle) && (value == mid[i]);
    
    function drawCornerPillar(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddlePillar(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawPillarAuto(a, b) = ((a % 2==0) && (b % 2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawPillar(a, b) = 
        ((pillars == "auto" && drawPillarAuto(a, b)) || (pillars != "auto" && getGridItem(pillars, true, a, b, 0, false)));

    function drawPin(a, b, isX) = 
        ((pillars == "auto" && drawPillarAuto(a, b)) || (pillars != "auto" && getGridItem(pillars, true, a, b, 0, false)));

    
    /*
    * Pit
    */
    function onPitBorder(a, b) = mb_circle_in_convex_quad(bevelOuter, [mb_grid_pos_x(a, size, gridSizeXY), mb_grid_pos_y(b, size, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang)
                                && !mb_circle_in_convex_quad(pitBevel, [mb_grid_pos_x(a, size, gridSizeXY), mb_grid_pos_y(b, size, gridSizeXY)], 0.5*knobSizeOrg, touch=true, overhang=0);
    
    function inPit(a, b) = mb_circle_in_convex_quad(pitBevelPadding, [mb_grid_pos_x(a, size, gridSizeXY), mb_grid_pos_y(b, size, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang)
                        && mb_circle_in_rounded_rect(cornersPitPadding, pitRadius, [mb_grid_pos_x(a, size, gridSizeXY), mb_grid_pos_y(b, size, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang);
    
    function inPitWallGaps(a, b, mx, i) = (i < len(recessWallGaps)) && (inPitWallGap(a, b, mb_to_array(recessWallGaps[i]), mx) || inPitWallGaps(a, b, mx, i+1));
    
    function mxRound(v, mx) = mx ? floor(v) : ceil(v);
    function inPitWallGap(a, b, gap, mx) = ((gap[0] == 0) && inPitWallGap0(a, b, gap, mx)) || ((gap[0] == 1) && inPitWallGap1(a, b, gap, mx)) || ((gap[0] == 2) && inPitWallGap2(a, b, gap, mx)) || ((gap[0] == 3) && inPitWallGap3(a, b, gap, mx));
    function inPitWallGap0(a, b, gap, mx) = (floor(a) >= 0) && (ceil(a) < floor(pWallThickness[0])) && (floor(b) >= mxRound(pWallThickness[2] + mb_undef_to(gap[1]), mx)) && (ceil(b) < size[1] - mxRound(pWallThickness[3] + mb_undef_to(gap[2]), mx));                                
    function inPitWallGap1(a, b, gap, mx) = (floor(a) >= size[0] - ceil(pWallThickness[1])) && (ceil(a) < size[0]) && (floor(b) >= mxRound(pWallThickness[2] + mb_undef_to(gap[1]), mx)) && (ceil(b) < size[1] - mxRound(pWallThickness[3] + mb_undef_to(gap[2]), mx));                                
    function inPitWallGap2(a, b, gap, mx) = (floor(b) >= 0) && (ceil(b) < floor(pWallThickness[2])) && (floor(a) >= mxRound(pWallThickness[0] + mb_undef_to(gap[1]), mx)) && (ceil(a) < size[0] - mxRound(pWallThickness[1] + mb_undef_to(gap[2]), mx));                                
    function inPitWallGap3(a, b, gap, mx) = (floor(b) >= size[1] - ceil(pWallThickness[3])) && (ceil(b) < size[1]) && (floor(a) >= mxRound(pWallThickness[0] + mb_undef_to(gap[1]), mx)) && (ceil(a) < size[0] - mxRound(pWallThickness[1] + mb_undef_to(gap[2]), mx));                                
    
    /*
    * Knobs
    */ 
    function drawStud(a, b) = 
            let(sType = getGridItem(studs, studType, a, b, 0, false))
            (sType != false
            && mb_circle_in_convex_quad(base_adjusted[1], [mb_grid_pos_x(a, size, gridSizeXY), mb_grid_pos_y(b, size, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang))
            ? sType : false;

    function knobZ(a, b) = (recess && inPit(a, b) ? pitFloorZ : sideZ(1)) - knobSink;
    function studType(ovStudType, a, b) = is_string(ovStudType) ? ovStudType : (recess && inPit(a, b) ? recessStudType : studType);

    /*
    * XYZ Holes
    */
    function drawHoleX(a, b) = getGridItem(holeX, holeXType, a, b, 0, false);
    function drawHoleY(a, b) = getGridItem(holeY, holeYType, a, b, 0, false);
    function drawHoleZ(a, b) = getGridItem(holeZ, holeZType, a, b, 0, false);

    /*
    * Wall Gaps
    * /
    function drawWallGapX(a, side, i) = (i < len(baseWallGapsX)) ? ((baseWallGapsX[i][0] == a && (side == baseWallGapsX[i][1] || baseWallGapsX[i][1] == 2)) ? (baseWallGapsX[i][2] == undef ? 1 : baseWallGapsX[i][2]) : drawWallGapX(a, side, i+1)) : 0; 
    function drawWallGapY(a, side, i) = (i < len(baseWallGapsY)) ? ((baseWallGapsY[i][0] == a && (side == baseWallGapsY[i][1] || baseWallGapsY[i][1] == 2)) ? (baseWallGapsY[i][2] == undef ? 1 : baseWallGapsY[i][2]) : drawWallGapY(a, side, i+1)) : 0; 
    */

    /*
    * Stabilizer Grid
    */
    function stabilizersXHeight(a) = sGridHeight + stabilizerGridOffset + (stabilizerExpansion > 0 && (holeX == false) && (((size[0] > stabilizerExpansion + 1) && ((a % stabilizerExpansion) == (stabilizerExpansion - 1))) || (size[1] == 1)) ? max(baseCutoutDepth - (stabilizerExpansionOffset * mbuToMm) - sGridHeight - stabilizerGridOffset, 0) : 0);
    function stabilizersYHeight(b) = sGridHeight + (stabilizerExpansion > 0 && (holeY == false) && (((size[1] > stabilizerExpansion + 1) && ((b % stabilizerExpansion) == (stabilizerExpansion - 1))) || (size[0] == 1)) ? max(baseCutoutDepth - (stabilizerExpansionOffset * mbuToMm) - sGridHeight, 0) : 0);
    
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
    if(mb_param_render(config, settings)){
    if(debug){
        echo(
            id = blockId,
            debugSource = "block.scad",
            preview= $preview,
            previewQuality = previewQuality,
            size = size,
            objectSizeZAdjusted = objectSizeZAdjusted, 
            heightWithKnobs = objectSizeZAdjusted + knobHeight,
            objectSizeXY = [objectSizeX, objectSizeY],
            objectSizeMod = objectSizeMod,
            objectSizeXYAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted],
            topPlateHeight = topPlateHeight,
            resultingTopPlateHeight = resultingTopPlateHeight, 
            baseCutoutDepth = baseCutoutDepth,
            calcBaseCutoutDepth = calculatedBaseCutoutDepth,
            baseCutoutMinDepth = baseCutoutMinDepth,
            slopeBaseHeightLower = slopeBaseHeightLower * mbuToMm,
            recessDepth = resultingPitDepth, 
            knobSize = knobSize,
            knobHeight = knobHeight,
            wallThickness = wallThickness,
            baseClampWallThickness = baseClampWallThickness,
            baseCutoutZ = baseCutoutZ, 
            topPlateZ = topPlateZ, 
            tubeDiameter = tubeDiameter,
            tubeXSize = tubeXSize,
            tubeYSize = tubeYSize,
            tubeZSize = tubeZSize,
            xyScrewHolesZ = xyScrewHolesZ,
            pitFloorZ = pitFloorZ,
            bevel = bevelRes,
            bevelOuterAdjusted = bevelOuterAdjusted,
            baseRoundingRadiusZ = baseRoundingRadiusZ,
            adjustedSizeRelation = adjustedSizeRelation,
            direction = direction,
            directionRotationZ = directionRotationZ
        );
    }
    /*
    * START BLOCK
    */
    
    translate([gridOffsetX, gridOffsetY, gridOffsetZ]){
        rotate(rotation){
            translate(preRotationOffset){
                rotate([0, 0, directionRotationZ]){
                    union(){ // Final union
                        mb_pre_render(previewRender, previewRenderConvexity){
                            
                            if(base){
                                difference(){
                                    color(baseColor){
                                        union(){
                                            if(baseCutoutType == "standard"){
                                                difference() {
                                                    /*
                                                    * Base Block
                                                    */
                                                    mb_base(
                                                        block_obj = block_obj,

                                                        grid = size,
                                                        gridSizeXY = gridSizeXY,
                                                        gridSizeZ = gridSizeZ,
                                                        
                                                        objectSize = objectSize,
                                                        objectSizeMod = objectSizeMod,
                                                        objectSizeAdjusted = objectSizeAdjusted, 
                                                        
                                                        height = objectSizeZAdjusted,
                                                        
                                                        connectors = connectors,
                                                        connectorPadding = connectorPadding,
                                                        connectorHeight = connectorHeight == "auto" ? "auto" : connectorHeight * mbuToMm,
                                                        connectorDepth = connectorDepth * mbuToMm,
                                                        connectorSize = connectorWidth * mbuToMm,
                                                        connectorDepthTolerance = connectorDepthTolerance,
                                                        connectorSideTolerance = connectorSideTolerance,

                                                        qualitySegBase = qualitySegBase,
                                                        qualityFactor = qualityFactor,
                                                        qualityResolutionMin = qualityResolutionMin,
                                                        qualityResolutionMax = qualityResolutionMax,
                                                        qualityResolutionMultiplier = qualityResolutionMultiplier,
                                                        previewQuality = previewQuality,

                                                        blockId = blockId,
                                                        debug = debug
                                                    );

                                                    /*
                                                    * Subtract base cutout
                                                    */
                                                    difference(){
                                                        union(){
                                                            mb_base_cutout(
                                                                block_obj = block_obj,
                                                                debug = debug
                                                            );

                                                            /*
                                                            * Grille
                                                            */
                                                            if(grille != "none"){
                                                                grilleHeight = grilleDepth * mbuToMm + cutOffset;
                                                                color(baseColor){
                                                                    if(grille == "x"){
                                                                        grilleWidthY = size[1] * unitGrid[0] * mbuToMm / grilleCount;
                                                                        for (g = [ 0 : 1 : grilleCount - 1 ]){
                                                                            if(g % 2 == (grilleInverted ? 0 : 1)){
                                                                                translate([0, sideY(0) + (0.5 + g) * grilleWidthY, sideZ(1, false) - 0.5 * (grilleHeight - cutOffset)])
                                                                                    cube(size=[objectSizeXAdjusted*cutMultiplier, grilleWidthY, grilleHeight+ cutOffset], center=true);
                                                                            }
                                                                        }
                                                                    }
                                                                    else if(grille == "y"){
                                                                        grilleWidthX = size[0] * unitGrid[0] * mbuToMm / grilleCount;
                                                                        for (g = [ 0 : 1 : grilleCount - 1 ]){
                                                                            if(g % 2 == (grilleInverted ? 0 : 1)){
                                                                                translate([sideX(0) + (0.5 + g) * grilleWidthX, 0, sideZ(1, false) - 0.5 * (grilleHeight - cutOffset)])
                                                                                    cube(size=[grilleWidthX, objectSizeYAdjusted*cutMultiplier, grilleHeight+ cutOffset], center=true);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }

                                                            
                                                        } // End union cutout

                                                        

                                                        *if(stabilizerGrid){
                                                            
                                                            difference(){
                                                                /*
                                                                * Stabilizer Grid
                                                                */
                                                                union(){
                                                                    

                                                                    if(grille == "none" || grilleSmall){
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
                                                                    }
                                                                } // End union stabilizer grid

                                                                
                                                            } // End difference stabilizer Grid

                                                            
                                                        } // End stabilizer grid

                                                        if(pillars != false){
                                                            pilRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * tubeZSize + baseClampThickness, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            holeZRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * holeZSize, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            //Tubes with holes
                                                            for (a = [ pillarStartX : 1 : pillarEndX ]){
                                                                for (b = [ pillarStartY : 1 : pillarEndY ]){
                                                                    if(drawPillar(a, b)){
                                                                        translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ]){
                                                                            difference(){
                                                                                union(){
                                                                                    cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * tubeZSize, center=true, $fn=pilRoundingRes);
                                                                                    
                                                                                    //Clamp
                                                                                    translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                                        cylinder(h=bClampHeight, r=0.5 * tubeZSize + baseClampThickness, center=true, $fn=pilRoundingRes);
                                                                                    
                                                                                    if(topPlateHelpers)
                                                                                        translate([0, 0, 0.5 * baseCutoutDepth - topPlateHelperHeight])
                                                                                            cylinder(h=topPlateHelperHeight, r=0.5 * tubeZSize + topPlateHelperThickness, center=true, $fn=pilRoundingRes);
                                                                                }

                                                                                // Hollow only if there is no z-hole here
                                                                                if(drawHoleZ(a, b) == false || a > holeZEndX || b > holeZEndY){
                                                                                    intersection(){
                                                                                        cylinder(h=baseCutoutDepth*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=holeZRoundingRes);
                                                                                        cube([holeZSize-2*tubeInnerClampThickness, holeZSize-2*tubeInnerClampThickness, baseCutoutDepth *cutMultiplier], center=true);
                                                                                    };
                                                                                }
                                                                            }
                                                                        };
                                                                    }
                                                                }
                                                            }
                                                        } // End if pillars

                                                        if(pillars != false){
                                                            pinRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * pinSize + baseClampThickness, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            /*
                                                            * Middle Pins
                                                            */
                                                            //Middle Pin X
                                                            if(gridSizeX > 1 && gridSizeY == 1){
                                                                for (b = [ startY : 1 : ceil(endY) ]){
                                                                    for (a = [ startX : 1 : ceil(endX) - 1 ]){
                                                                        if(drawPin(a, b, true)){
                                                                            translate([posX(a + 0.5), posY(b), baseCutoutZ]){
                                                                                cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * pinSize, center=true, $fn=pinRoundingRes);
                                                                                translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                                    cylinder(h=bClampHeight, r=0.5 * pinSize + baseClampThickness, center=true, $fn=pinRoundingRes);
                                                                            };
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            
                                                            //Middle Pin Y
                                                            if(gridSizeX == 1 && gridSizeY > 1){
                                                                for (a = [ startX : 1 : ceil(endX)]){
                                                                    for (b = [ startY : 1 : ceil(endY) - 1 ]){
                                                                        if(drawPin(a, b, false)){
                                                                            translate([posX(a), posY(b + 0.5), baseCutoutZ]){
                                                                                cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * pinSize, center=true, $fn=pinRoundingRes);
                                                                                translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                                    cylinder(h=bClampHeight, r=0.5 * pinSize + baseClampThickness, center=true, $fn=pinRoundingRes);
                                                                            };
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } // End if pillars
                                                        
                                                        //X-Holes Outer
                                                        if(holeX != false){
                                                            holeXRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * tubeXSize, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            for(r = [ 0 : 1 : holeXMaxRows-1]){
                                                                for (a = [ holeXStart : 1 : holeXEnd ]){
                                                                    if(drawHoleX(a, r) != false){
                                                                        translate([posX(a + (holeXShift ? 0.5 : 0)), 0, sideZ(0, false) + holeXGridOffsetZ*mbuToMm + holeXGridOffsetZAdjustment + r * (holeXGridSizeZ*mbuToMm + holeXGridSizeZAdjustment)]){
                                                                            rotate([90, 0, 0]){ 
                                                                                cylinder(h=objectSizeY - 2*wallThickness, r=0.5 * tubeXSize, center=true, $fn=holeXRoundingRes);
                                                                            }
                                                                        };
                                                                    }
                                                                }
                                                            }
                                                        } // End if holeX
                                                        
                                                        //Y-Holes Outer
                                                        if(holeY != false){
                                                            holeYRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * tubeYSize, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            for(r = [ 0 : 1 : holeYMaxRows-1]){
                                                                for (b = [ holeYStart : 1 : holeYEnd ]){
                                                                    if(drawHoleY(b, r) != false){
                                                                        translate([0, posY(b + (holeYShift ? 0.5 : 0)), sideZ(0, false) + holeYGridOffsetZ*mbuToMm + holeYGridOffsetZAdjustment + r * (holeYGridSizeZ*mbuToMm + holeYGridSizeZAdjustment)]){
                                                                            rotate([0, 90, 0]){ 
                                                                                cylinder(h=objectSizeX - 2*wallThickness, r=0.5 * tubeYSize, center=true, $fn=holeYRoundingRes);
                                                                            };
                                                                        };
                                                                    }
                                                                }
                                                            }
                                                        } // End if holeY
                                                        
                                                    } // End Difference (subtract from cutout)
                                                } // End difference (subtract cutout from base)
                                            }
                                            else{
                                                /*
                                                * Solid Base Block
                                                */
                                                
                                                mb_base(
                                                    block_obj = block_obj,

                                                    grid = size,
                                                    gridSizeXY = gridSizeXY,
                                                    gridSizeZ = gridSizeZ,
                                                    
                                                    objectSize = objectSize,
                                                    objectSizeMod = objectSizeMod,
                                                    objectSizeAdjusted = objectSizeAdjusted, 

                                                    height = objectSizeZAdjusted,
                                                    
                                                    connectors = connectors,
                                                    connectorPadding = connectorPadding,
                                                    connectorHeight = connectorHeight == "auto" ? "auto" : connectorHeight * mbuToMm,
                                                    connectorDepth = connectorDepth * mbuToMm,
                                                    connectorSize = connectorWidth * mbuToMm,
                                                    connectorDepthTolerance = connectorDepthTolerance,
                                                    connectorSideTolerance = connectorSideTolerance,

                                                    qualitySegBase = qualitySegBase,
                                                    qualityFactor = qualityFactor,
                                                    qualityResolutionMin = qualityResolutionMin,
                                                    qualityResolutionMax = qualityResolutionMax,
                                                    qualityResolutionMultiplier = qualityResolutionMultiplier,
                                                    previewQuality = previewQuality,

                                                    blockId = blockId,
                                                    debug = debug
                                                );
                                            } //End baseCutoutType
                                            
                                            //Cutouts
                                            if(is_list(cutouts)){
                                                translate([-rotationOffsetX - alignX, -rotationOffsetY - alignY, -rotationOffsetZ - alignZ]){
                                                    for(i = [0 : len(cutouts)]){
                                                        if(mb_map_get(cutouts[i], "cutoutWall", false)){
                                                            intersection(){
                                                                mb_block(
                                                                    config = config,
                                                                    settings = mb_map_merge(cutouts[i], [["baseCutoutType", "none"], ["baseClampOuter", true], ["baseMod", 0.2], ["studs", false]])
                                                                );

                                                                mb_block(
                                                                    config = config,
                                                                    settings = mb_map_merge(settings, [["cutouts", undef], ["baseCutoutType", "none"], ["studs", false]])
                                                                );
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } //End base union
                                    } //End base color
                                    
                                    /*
                                    * Final Subtraction
                                    * Starting from here, everything applies to the final block
                                    *
                                    */

                                    if(baseCutoutType != "none" && baseCutoutType != "groove"){
                                        studRoundingRes = mb_fn_even_for_radius(
                                            0.5 * knobCutSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(baseColor){
                                            /*
                                            * Knob subtraction from base
                                            */
                                            
                                                difference(){
                                                    union(){
                                                        translate([0, 0, sideZ(0, false) + 0.5 * knobCutHeight - 0.5*cutOffset]){
                                                        
                                                            for (a = [ startX : 1 : ceil(endX) ]){
                                                                for (b = [ startY : 1 : ceil(endY) ]){
                                                                    if(baseCutoutType == "studs" //|| !mb_circle_in_rounded_rect(cornersInnerOrg, baseRoundingRadiusZ, [mb_grid_pos_x(a, size, gridSizeXY), mb_grid_pos_y(b, size, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang)
                                                                        || !mb_circle_in_convex_quad(base_cutout[0], [mb_grid_pos_x(a, size, gridSizeXY), mb_grid_pos_y(b, size, gridSizeXY)], 0.5*knobSizeOrg, overhang = 0)){
                                                                        translate([posX(a), posY(b), 0]){
                                                                            if(bClampOffset > 0){
                                                                                translate([0,0, -0.5 * (knobCutHeight - bClampOffset)])
                                                                                    cylinder(h=bClampOffset + cutOffset, r=0.5 * knobCutSize, center=true, $fn=studRoundingRes);
                                                                            }
                                                                            //color("red")
                                                                            cylinder(h=knobCutHeight + cutOffset, r=0.5 * (knobCutSize - 2*baseClampThickness), center=true, $fn=studRoundingRes);
                                                                            
                                                                            //color("green")
                                                                            translate([0,0, 0.5*(knobCutHeight + cutOffset) - 0.5*(knobCutHeight - bClampOffset - bClampHeight)])
                                                                                cylinder(h=knobCutHeight - bClampOffset - bClampHeight, r=0.5 * knobCutSize, center=true, $fn=studRoundingRes);
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } // End translate
                                                    } // End union

                                                    if(baseCutoutType != "studs"){
                                                        mb_prismoid(shape = stud_base_cutout, debug = debug);
                                                    }
                                                } //End difference final cutout elements
                                            
                                        }
                                    }

                                    //Cut X-Holes
                                    if(holeX != false){
                                        holeXRoundingRes = mb_fn_even_for_radius(
                                            0.5 * (holeXSize + 2 * holeXInsetThicknessFinal), 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(baseColor){
                                            for(r = [ 0 : 1 : holeXMaxRows-1]){
                                                for (a = [ holeXStart : 1 : holeXEnd ]){
                                                    xHole = drawHoleX(a, r);
                                                    if(xHole != false){
                                                        translate([posX(a + (holeXShift ? 0.5 : 0)), 0, sideZ(0, false) + holeXGridOffsetZ*mbuToMm + holeXGridOffsetZAdjustment + r * (holeXGridSizeZ*mbuToMm + holeXGridSizeZAdjustment)]){
                                                            rotate([90, 0, 0]){ 
                                                                if(xHole == true || xHole == "pin"){
                                                                    cylinder(h=objectSizeY*cutMultiplier, r=0.5 * holeXSize, center=true, $fn=holeXRoundingRes);
                                                                
                                                                    translate([0, 0, 0.5 * objectSizeY])
                                                                        cylinder(h=2 * (holeXInsetDepth * mbuToMm + holeXInsetDepthAdjustment), r=0.5 * (holeXSize + 2 * holeXInsetThicknessFinal), center=true, $fn=holeXRoundingRes);
                                                                    translate([0, 0, -0.5 * objectSizeY])
                                                                        cylinder(h=2 * (holeXInsetDepth * mbuToMm + holeXInsetDepthAdjustment), r=0.5 * (holeXSize + 2 * holeXInsetThicknessFinal), center=true, $fn=holeXRoundingRes);
                                                                
                                                                }
                                                                else if(xHole == "axle"){
                                                                    mb_axis(
                                                                        height = objectSizeZAdjusted * cutMultiplier, 
                                                                        capHeight=0, 
                                                                        size = holeXSize, 
                                                                        thickness = holeAxleThickness * mbuToMm,
                                                                        center=true, 
                                                                        alignBottom=false, 
                                                                        roundingResolution=holeXRoundingRes
                                                                    );
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
                                        holeYRoundingRes = mb_fn_even_for_radius(
                                            0.5 * (holeYSize + 2 * holeYInsetThicknessFinal), 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(baseColor){
                                            for(r = [ 0 : 1 : holeYMaxRows-1]){
                                                for (b = [ holeYStart : 1 : holeYEnd ]){
                                                    yHole = drawHoleY(b, r);
                                                    if(yHole != false){
                                                        translate([0, posY(b + (holeYShift ? 0.5 : 0)), sideZ(0, false) + holeYGridOffsetZ*mbuToMm + holeYGridOffsetZAdjustment + r * (holeYGridSizeZ*mbuToMm + holeYGridSizeZAdjustment)]){
                                                            rotate([0, 90, 0]){ 
                                                                if(yHole == true || yHole == "pin"){
                                                                    cylinder(h=objectSizeX*cutMultiplier, r=0.5 * holeYSize, center=true, $fn=holeYRoundingRes);
                                                                
                                                                    translate([0, 0, 0.5 * objectSizeX])
                                                                        cylinder(h=2 * (holeYInsetDepth * mbuToMm + holeYInsetDepthAdjustment), r=0.5 * (holeYSize + 2 * holeYInsetThicknessFinal), center=true, $fn=holeYRoundingRes);
                                                                    translate([0, 0, -0.5 * objectSizeX])
                                                                        cylinder(h=2 * (holeYInsetDepth * mbuToMm + holeYInsetDepthAdjustment), r=0.5 * (holeYSize + 2 * holeYInsetThicknessFinal), center=true, $fn=holeYRoundingRes);
                                                                }
                                                                else if(yHole == "axle"){
                                                                    mb_axis(
                                                                        height = objectSizeZAdjusted * cutMultiplier, 
                                                                        capHeight=0, 
                                                                        size = holeYSize, 
                                                                        thickness = holeAxleThickness * mbuToMm,
                                                                        center=true, 
                                                                        alignBottom=false, 
                                                                        roundingResolution=holeYRoundingRes
                                                                    );
                                                                }
                                                            };
                                                        };
                                                    }
                                                }
                                            }
                                        } // End color
                                    } // End if holeY
                                    
                                    if(holeZ != false){
                                        holeZRoundingRes = mb_fn_even_for_radius(
                                            0.5 * holeZSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(baseColor){
                                            //Cut Z-Holes
                                            for (a = [ holeZStartX : 1 :  holeZEndX ]){
                                                for (b = [ holeZStartY : 1 : holeZEndY ]){
                                                    zHole = drawHoleZ(a, b);
                                                    if(zHole != false){
                                                        translate([posX(a + (holeZCenteredX ? 0.5 : 0)), posY(b+(holeZCenteredY ? 0.5 : 0)), 0]){
                                                            if(zHole == true || zHole == "pin"){
                                                                cylinder(h=objectSizeZAdjusted*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=holeZRoundingRes);
                                                            }
                                                            else if(zHole == "axle"){
                                                                mb_axis(
                                                                    height = objectSizeZAdjusted * cutMultiplier, 
                                                                    capHeight=0, 
                                                                    size = holeZSize, 
                                                                    thickness = holeAxleThickness * mbuToMm,
                                                                    center = true, 
                                                                    alignBottom = false, 
                                                                    roundingResolution = holeZRoundingRes
                                                                );
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
                                    if(text != false && !mb_is_empty_string(text) && txtDepth < 0){
                                        color(textColor == "inherit" ? baseColor : textColor){
                                            translate([decoratorX(textSide, txtDepth, textOffset[0]), decoratorY(textSide, txtDepth, textOffset[1]), decoratorZ(textSide, txtDepth, textOffset[1])])
                                                rotate(decoratorRotations[textSide])
                                                    mb_text3d(
                                                        text = text,
                                                        textDepth = 2 * abs(txtDepth),
                                                        textSize = scale * textSize,
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
                                                        size = scale * svgScale,
                                                        center = true
                                                    );
                                        } // End color
                                    } // End if svg

                                    /*
                                    * Surface Pattern Cutout
                                    */
                                    if(!mb_is_empty_string(surfacePattern) && surfacePattern != "none" && surfacePatternDepth < 0){
                                        textureRoundingRadiusQuality = mb_fn_even_for_radius(
                                            textureRoundingRadius, 
                                            2, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(surfacePatternColor == "inherit" ? baseColor : surfacePatternColor){
                                            translate([decoratorX(surfacePatternSide, surfacePatternDepth, surfacePatternOffset[0]), decoratorY(surfacePatternSide, surfacePatternDepth, surfacePatternOffset[1]), decoratorZ(surfacePatternSide, surfacePatternDepth, surfacePatternOffset[1])])
                                                rotate(decoratorRotations[surfacePatternSide])
                                                    intersection(){
                                                        mb_svg3d(
                                                            file = surfacePattern,
                                                            orgWidth = surfacePatternDimensions[0],
                                                            orgHeight = surfacePatternDimensions[1],
                                                            depth = 2 * abs(surfacePatternDepth),
                                                            size = scale * surfacePatternScale,
                                                            center = true
                                                        );
                                                        mb_prismoid(
                                                            shape = [bevelTexture], 
                                                            height = (2 + 0.1) * abs(surfacePatternDepth), 
                                                            radius = mb_xyz_rad_convert(textureRoundingRadius == 0 ? 0 : [0, 0, textureRoundingRadius]), 
                                                            resolution = textureRoundingRadiusQuality
                                                        );

                                                        /*
                                                        mb_beveled_rounded_block(
                                                            bevel = beveled ? bevelTexture : false,
                                                            sizeX = objectSizeX - wallThickness,
                                                            sizeY = objectSizeY - wallThickness,
                                                            height = (2 + 0.1) * abs(surfacePatternDepth),
                                                            roundingRadius = textureRoundingRadius == 0 ? 0 : [0, 0, textureRoundingRadius],
                                                            roundingResolution = textureRoundingRadiusQuality
                                                        );*/
                                                    }
                                        } // End color
                                    } // End if surface pattern

                                    /*
                                    * Grille
                                    */
                                    if(grille != "none" && baseCutoutType != "standard"){
                                        grilleHeight = grilleDepth * mbuToMm + cutOffset;
                                        color(baseColor){
                                            if(grille == "x"){
                                                
                                                grilleWidthY = size[1] * unitGrid[0] * mbuToMm / grilleCount;
                                                for (g = [ 0 : 1 : grilleCount - 1 ]){
                                                    if(g % 2 == (grilleInverted ? 0 : 1)){
                                                        translate([0, sideY(0) + (0.5 + g) * grilleWidthY, sideZ(1, false) - 0.5 * (grilleHeight - cutOffset)])
                                                            cube(size=[objectSizeXAdjusted*cutMultiplier, grilleWidthY, grilleHeight+ cutOffset], center=true);
                                                    }
                                                }
                                            }
                                            else if(grille == "y"){
                                                grilleWidthX = size[0] * unitGrid[0] * mbuToMm / grilleCount;
                                                for (g = [ 0 : 1 : grilleCount - 1 ]){
                                                    if(g % 2 == (grilleInverted ? 0 : 1)){
                                                        translate([sideX(0) + (0.5 + g) * grilleWidthX, 0, sideZ(1, false) - 0.5 * (grilleHeight - cutOffset)])
                                                            cube(size=[grilleWidthX, objectSizeYAdjusted*cutMultiplier, grilleHeight+ cutOffset], center=true);
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    /*
                                    * Screw Holes Z
                                    */
                                    if(stabilizerGrid || (baseCutoutType == "none") || (baseCutoutType == "groove")){
                                        screwHoleZRoundingRadius = mb_fn_even_for_radius(
                                            0.5 * screwHoleZSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );
                                        color(baseColor){
                                            for (a = [ startX : 1 : endX ]){
                                                for (b = [ startY : 1 : endY ]){
                                                    if(drawScrewHoleZ(a, b, 0)){
                                                        translate([posX(a), posY(b), 0.5*knobHeight])
                                                            cylinder(h = (objectSizeZAdjusted + knobHeight)*cutMultiplier, r = 0.5*screwHoleZSize, center=true, $fn=screwHoleZRoundingRadius);
                                                    } 
                                                }
                                            }
                                        } // End color
                                    } // End if stabilizerGrid

                                    /*
                                    * Screw Holes X
                                    */
                                    if(screwHolesX != false && len(screwHolesX) > 0){
                                        screwHoleXRoundingRadius = mb_fn_even_for_radius(
                                            0.5 * screwHoleXSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );
                                        for (b = [ 0 : 1 : len(screwHolesX) - 1]){
                                            
                                            color(baseColor){
                                                for (s = [ 0 : 1 : 1]){
                                                    if(screwHolesX[b][2] == undef || screwHolesX[b][2] == s){
                                                        translate([posX(screwHolesX[b][0]), sideY(s) + (0.5 - s)*(screwHoleXDepth - cutOffset), xyScrewHolesZ + screwHolesX[b][1] * gridSizeZ])
                                                            rotate([90, 0, 0])
                                                                cylinder(h = screwHoleXDepth + cutOffset, r = 0.5*screwHoleXSize, center=true, $fn=screwHoleXRoundingRadius);
                                                    }
                                                }
                                            } // End color
                                        } // End for screwHolesX
                                    }

                                    /*
                                    * Screw Holes Y
                                    */
                                    if(screwHolesY != false && len(screwHolesY) > 0){
                                        screwHoleYRoundingRadius = mb_fn_even_for_radius(
                                            0.5 * screwHoleYSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );
                                        for (b = [ 0 : 1 : len(screwHolesY) - 1]){
                                            color(baseColor){
                                                for (s = [ 0 : 1 : 1]){
                                                    if(screwHolesY[b][2] == undef || screwHolesY[b][2] == s){
                                                        translate([sideX(s) + (0.5 - s)*(screwHoleYDepth - cutOffset), posY(screwHolesY[b][0]), xyScrewHolesZ + screwHolesY[b][1] * gridSizeZ])
                                                            rotate([0, 90, 0])
                                                                cylinder(h = screwHoleYDepth + cutOffset, r = 0.5*screwHoleYSize, center=true, $fn=screwHoleYRoundingRadius);
                                                    }
                                                }
                                            } // End color
                                        } // End for screwHolesY
                                    }
                                    /*
                                    * Cut Groove
                                    */
                                    if(baseCutoutType == "groove"){
                                        color(baseColor){
                                            translate([0, 0, sideZ(0, false) + 0.5*tonGrooveDepthCalc]){ 
                                                translate([0, 0, -0.5 * cutOffset]){
                                                    mb_tongue(
                                                        block_obj = block_obj,

                                                        gridSizeXY = gridSizeXY,
                                                        
                                                        objectSize = objectSize,
                                                        objectSizeAdjusted = objectSizeAdjusted,
                                                        
                                                        baseRoundingRadiusZ = baseRoundingRadiusZ,
                                                        
                                                        beveled = beveled,
                                                        bevelOuter = bevelOuter,
                                                        
                                                        tongueOffset = tonOffsetCalc,
                                                        tongueThickness = tonThicknessCalc,
                                                        tongueThicknessAdjustment = tongueThicknessAdjustment,
                                                        tongueHeight = tonGrooveDepthCalc + cutOffset,
                                                        tongueClampThickness = tongueClampThickness,
                                                        tongueClampHeight = tonClampHeightCalc,
                                                        tongueClampOffset = tonClampOffsetCalc + tonGrooveDepthCalc - tonHeightCalc,
                                                        tongueRoundingRadius = tongueRoundingRadius,
                                                        tongueInnerRoundingRadius = tongueInnerRoundingRadius,
                                                        
                                                        pit = true,
                                                        pitWallGaps = recessWallGaps,
                                                        pitSizeX = pitSizeX,
                                                        pitSizeY = pitSizeY,
                                                        
                                                        qualitySegBase = qualitySegBase,
                                                        qualityFactor = qualityFactor,
                                                        qualityResolutionMin = qualityResolutionMin,
                                                        qualityResolutionMax = qualityResolutionMax,
                                                        qualityResolutionMultiplier = qualityResolutionMultiplier,
                                                        previewQuality = previewQuality
                                                    );
                                                }

                                                tongueSizeX = objectSizeX - 2 * tonOffsetCalc + tongueThicknessAdjustment;
                                                tongueSizeY = objectSizeY - 2 * tonOffsetCalc + tongueThicknessAdjustment;
                                                tongueThicknessAdjusted = tonThicknessCalc + tongueThicknessAdjustment;
                                                tongueInnerSizeX = tongueSizeX - 2 * tongueThicknessAdjusted;
                                                tongueInnerSizeY = tongueSizeY - 2 * tongueThicknessAdjusted;
                                                
                                                /*
                                                * Groove Wall Gaps New
                                                */
                                                *for (i = [ 0 : 1 : len(baseWallGaps)-1 ]){
                                                    gap = baseWallGaps[i];
                                                    
                                                    gapSide = mb_side_to_int(gap[0]);
                                                    gapPos = gap[1] != undef ? gap[1]: 0;
                                                    gapLength = gap[2] != undef ? gap[2] : 1;

                                                    if(gapLength > 0){
                                                        if(gapSide < 2){
                                                            translate([posX(gapPos + 0.5*(gapLength-1)), sideY(gapSide), -0.5 * cutOffset]){
                                                                cube([
                                                                    gapLength*gridSizeXY - objectSizeX + tongueSizeX + cutTolerance, 
                                                                    objectSizeY - tongueSizeY + sideAdjustment[gapSide + 2] + cutTolerance, 
                                                                    tonGrooveDepthCalc + cutOffset
                                                                ], center=true); 
                                                                
                                                                translate([0,0,+0.5*(tonGrooveDepthCalc+cutOffset)-0.5*tonClampHeightCalc - (tonClampOffsetCalc + tonGrooveDepthCalc - tonHeightCalc)])
                                                                    cube([
                                                                        gapLength*gridSizeXY - objectSizeX + tongueSizeX + 2* tongueClampThickness + cutTolerance, 
                                                                        objectSizeY - tongueSizeY + sideAdjustment[gapSide + 2] + cutTolerance, 
                                                                        tonClampHeightCalc
                                                                    ], center=true); 
                                                            }
                                                        }
                                                        else if(gapSide < 4){
                                                            translate([sideX(gapSide - 2), posY(gapPos + 0.5*(gapLength-1)), -0.5 * cutOffset]){
                                                                cube([
                                                                    objectSizeX - tongueSizeX + sideAdjustment[gapSide - 2] + cutTolerance, 
                                                                    gapLength*gridSizeXY - objectSizeY + tongueSizeY + cutTolerance, 
                                                                    tonGrooveDepthCalc + cutOffset
                                                                ], center=true);   

                                                                translate([0,0,+0.5*(tonGrooveDepthCalc+cutOffset)-0.5*tonClampHeightCalc - (tonClampOffsetCalc + tonGrooveDepthCalc - tonHeightCalc)])
                                                                    cube([
                                                                        objectSizeX - tongueSizeX + sideAdjustment[gapSide - 2] + cutTolerance, 
                                                                        gapLength*gridSizeXY - objectSizeY + tongueSizeY + 2* tongueClampThickness + cutTolerance, 
                                                                        tonClampHeightCalc
                                                                    ], center=true);   
                                                            }
                                                        }
                                                    }
                                                }

                                                /*
                                                * Groove Wall Gaps X
                                                * /
                                                for (a = [ startX : 1 : endX ]){
                                                    for (side = [ 0 : 1 : 1 ]){
                                                        gapLength = drawWallGapX(a, side, 0);
                                                        if(gapLength > 0){
                                                            translate([posX(a + 0.5*(gapLength-1)), sideY(side), -0.5 * cutOffset]){
                                                                cube([
                                                                    gapLength*gridSizeXY - objectSizeX + tongueSizeX + cutTolerance, 
                                                                    objectSizeY - tongueSizeY + sideAdjustment[2 + side] + cutTolerance, 
                                                                    tonGrooveDepthCalc + cutOffset
                                                                ], center=true); 
                                                                
                                                                translate([0,0,+0.5*(tonGrooveDepthCalc+cutOffset)-0.5*tonClampHeightCalc - (tonClampOffsetCalc + tonGrooveDepthCalc - tonHeightCalc)])
                                                                    cube([
                                                                        gapLength*gridSizeXY - objectSizeX + tongueSizeX + 2* tongueClampThickness + cutTolerance, 
                                                                        objectSizeY - tongueSizeY + sideAdjustment[2 + side] + cutTolerance, 
                                                                        tonClampHeightCalc
                                                                    ], center=true); 
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                /*
                                                * Groove Wall Gaps Y
                                                * /
                                                for (b = [ startY : 1 : endY ]){
                                                    for (side = [ 0 : 1 : 1 ]){
                                                        gapLength = drawWallGapY(b, side, 0);
                                                        if(gapLength > 0){
                                                            translate([sideX(side), posY(b + 0.5*(gapLength-1)), -0.5 * cutOffset]){
                                                                cube([
                                                                    objectSizeX - tongueSizeX + sideAdjustment[side] + cutTolerance, 
                                                                    gapLength*gridSizeXY - objectSizeY + tongueSizeY + cutTolerance, 
                                                                    tonGrooveDepthCalc + cutOffset
                                                                ], center=true);   

                                                                translate([0,0,+0.5*(tonGrooveDepthCalc+cutOffset)-0.5*tonClampHeightCalc - (tonClampOffsetCalc + tonGrooveDepthCalc - tonHeightCalc)])
                                                                    cube([
                                                                        objectSizeX - tongueSizeX + sideAdjustment[side] + cutTolerance, 
                                                                        gapLength*gridSizeXY - objectSizeY + tongueSizeY + 2* tongueClampThickness + cutTolerance, 
                                                                        tonClampHeightCalc
                                                                    ], center=true);   
                                                            }
                                                        }
                                                    }
                                                }
                                                */
                                                
                                            }   
                                        } // End color
                                    } // End if baseCutoutType

                                    
                                    if(is_list(cutouts)){
                                        translate([-rotationOffsetX - alignX, -rotationOffsetY - alignY, -rotationOffsetZ - alignZ]){
                                            for(i = [0 : len(cutouts)]){
                                                mb_block(
                                                    config = config,
                                                    settings = mb_map_merge(cutouts[i], [["baseCutoutType", "none"], ["studs", false]])
                                                );
                                            }
                                        }
                                    }

                                    if(is_list(ports)){
                                        
                                        for(p = [0 : len(ports) - 1]){
                                            port = ports[p];
                                            sideInt = mb_side_to_int(port[0]);
                                            
                                            
                                            portCutThickness = 2*((port[5] == undef || port[5] == "auto" ? (recess && sideInt < 4 ? recWallThickness[sideInt] : objectSize[mb_side_to_axis(port[0])]) : port[5] * (sideInt < 4 ? gridSizeXY : gridSizeZ)) + cutTolerance);
                                            shapes = port[4];
                                            translate(portSideOffset(port[0], port[1], port[2])){
                                                rotate(portRotation(port[0], port[3])){
                                                    for(s = [0 : len(shapes) - 1]){
                                                        shape = shapes[s];
                                                        translate(portOffset(port[0], shape[1])){
                                                            rotate(portShapeRotation(port[0])){
                                                                rotate([0, 0, shape[2]]){
                                                                    if(shape[0] == "circle"){
                                                                        cylinder(h = portCutThickness, r=0.5*shape[3][0], center=true, $fn=20);
                                                                    }
                                                                    else if(shape[0] == "rect"){
                                                                        mb_cube(
                                                                            size = portShapeRectSize(port[0], shape[3][0], portCutThickness), 
                                                                            radius = shape[3][1], center=true, resolution=20);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
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
                                    studRoundingRes = mb_fn_even_for_radius(
                                        0.5 * knobSize + studClampThickness, 
                                        0, 
                                        qualitySegBase,
                                        qualityFactor,
                                        qualityResolutionMin,
                                        qualityResolutionMax,
                                        qualityResolutionMultiplier,
                                        previewQuality
                                    );

                                    studHoleRoundingRes = mb_fn_even_for_radius(
                                        0.5 * knobHoleSize, 
                                        0, 
                                        qualitySegBase,
                                        qualityFactor,
                                        qualityResolutionMin,
                                        qualityResolutionMax,
                                        qualityResolutionMultiplier,
                                        previewQuality
                                    );

                                    studHelperRoundingRes = mb_fn_even_for_radius(
                                        knobRounding, 
                                        2, 
                                        qualitySegBase,
                                        qualityFactor,
                                        qualityResolutionMin,
                                        qualityResolutionMax,
                                        qualityResolutionMultiplier,
                                        previewQuality
                                    );

                                    knobShiftedX = (studShift == true || studShift == "x" || studShift == "xy");
                                    knobShiftedY = (studShift == true || studShift == "y" || studShift == "xy");

                                    /*
                                    * Normal studs
                                    */
                                    for (a = [ startX : 1 : (ceil(endX) - (knobShiftedX ? 1 : 0)) ]){
                                        for (b = [ startY : 1 : (ceil(endY) - (knobShiftedY ? 1 : 0)) ]){
                                            knobOffsetX = knobShiftedX ? 0.5 : 0;
                                            knobOffsetY = knobShiftedY ? 0.5 : 0;
                                            ovStudType = drawStud(a + knobOffsetX, b + knobOffsetY);
                                            if(ovStudType != false){
                                                pitKnobShiftedX = (recessStudShift == true || recessStudShift == "x" || recessStudShift == "xy");
                                                pitKnobShiftedY = (recessStudShift == true || recessStudShift == "y" || recessStudShift == "xy");
                                                pitKnobOffsetX = pitKnobShiftedX ? 0.5 : 0;
                                                pitKnobOffsetY = pitKnobShiftedY ? 0.5 : 0;
                                                inPit = recess && recessStuds && inPit(a + pitKnobOffsetX, b + pitKnobOffsetY);
                                                onPitBorder = !recess || onPitBorder(a + knobOffsetX, b + knobOffsetY);
                                                if(onPitBorder || inPit){
                                                    posOffsetX = (inPit ? pitKnobShiftedX : knobShiftedX) ? 0.5 : 0;
                                                    posOffsetY = (inPit ? pitKnobShiftedY : knobShiftedY) ? 0.5 : 0;
                                                    translate([posX(a + posOffsetX), posY(b + posOffsetY), knobZ(a + posOffsetX, b + posOffsetY)]){ 
                                                        kType = studType(ovStudType, a + posOffsetX, b + posOffsetY);
                                                        difference(){

                                                            union(){
                                                                /*
                                                                difference(){
                                                                    union(){
                                                                        translate([0, 0, -0.5 * (knobRounding + studClampHeight * mbuToMm) - 0.5 * knobSink])
                                                                            cylinder(h=knobHeight - knobRounding - studClampHeight * mbuToMm + knobSink + knobPartsOverlap, r=0.5 * knobSize, center=true, $fn=studRoundingRes);

                                                                        
                                                                        translate([0, 0, 0.5 * (knobHeight - studClampHeight * mbuToMm) - knobRounding ])
                                                                            cylinder(h=studClampHeight * mbuToMm + (knobRounding > knobPartsOverlap ? knobPartsOverlap : 0), r=0.5 * knobSize + studClampThickness, center=true, $fn=studRoundingRes);
                                                                        
                                                                        if(knobRounding > 0){
                                                                            translate([0, 0, 0.5 * (knobHeight - knobRounding)])
                                                                                cylinder(h=knobRounding, r=0.5 * knobSize + studClampThickness - knobRounding, center=true, $fn=studRoundingRes);
                                                                        }
                                                                    }
                                                                    
                                                                    if(kType == "hollow"){
                                                                        intersection(){
                                                                            cube([knobHoleSize - 2*studHoleClampThickness, knobHoleSize - 2*studHoleClampThickness, knobHeight*cutMultiplier], center=true);
                                                                            cylinder(h=knobHeight * cutMultiplier, r=0.5 * knobHoleSize, center=true, $fn=studHoleRoundingRes);
                                                                        }
                                                                    }
                                                                } // end difference
                                                                
                                                                //Knob Rounding
                                                                if(knobRounding > 0){
                                                                    translate([0, 0, 0.5 * knobHeight - knobRounding]){ 
                                                                        mb_torus(
                                                                            circleRadius = knobRounding, 
                                                                            torusRadius = 0.5 * knobSize + studClampThickness, 
                                                                            circleResolution = studHelperRoundingRes,
                                                                            torusResolution = studRoundingRes
                                                                        );
                                                                    }
                                                                }*/

                                                                mb_stud(
                                                                    height = knobHeight + knobSink,
                                                                    radius = 0.5 * knobSize,
                                                                    holeRadius = kType == "hollow" ? 0.5 * knobHoleSize : 0,
                                                                    holeClampThickness = studHoleClampThickness,
                                                                    roundingRadius = knobRounding,
                                                                    clampHeight = studClampHeight,
                                                                    clampThickness = studClampThickness,
                                                                    bodyRoundingResolution = studRoundingRes,
                                                                    holeRoundingResolution = studHoleRoundingRes,
                                                                    edgeRoundingResolution = studHelperRoundingRes
                                                                );

                                                                if(!mb_is_empty_string(studIcon) && studIcon != "none" && studIconDepth > 0 && kType != "hollow"){
                                                                    color(studIconColor == "inherit" ? baseColor : studIconColor){
                                                                        translate([0, 0, knobHeight + knobSink])
                                                                            rotate(decoratorRotations[surfacePatternSide])
                                                                                mb_svg3d(
                                                                                    file = studIcon,
                                                                                    orgWidth = studIconDimensions[0],
                                                                                    orgHeight = studIconDimensions[1],
                                                                                    depth = 2 * abs(studIconDepth),
                                                                                    size = scale * studIconScale,
                                                                                    center = true
                                                                                );
                                                                                
                                                                    } // End color
                                                                }
                                                            } // End union
                                                            
                                                            

                                                            if(!mb_is_empty_string(studIcon) && studIcon != "none" && studIconDepth < 0 && kType != "hollow"){
                                                                color(studIconColor == "inherit" ? baseColor : studIconColor){
                                                                    translate([0, 0, knobHeight + knobSink])
                                                                        rotate(decoratorRotations[surfacePatternSide])
                                                                            mb_svg3d(
                                                                                file = studIcon,
                                                                                orgWidth = studIconDimensions[0],
                                                                                orgHeight = studIconDimensions[1],
                                                                                depth = 2 * abs(studIconDepth),
                                                                                size = scale * studIconScale,
                                                                                center = true
                                                                            );
                                                                            
                                                                } // End color
                                                            }
                                                        } // End difference
                                                    } // End translate
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
                                    translate([0, 0, sideZ(1) + 0.5 * tonHeightCalc]){ 
                                        mb_tongue(
                                            block_obj = block_obj,

                                            gridSizeXY = gridSizeXY,
                                            objectSize = objectSize,
                                            objectSizeAdjusted = objectSizeAdjusted,
                                            
                                            baseRoundingRadiusZ = baseRoundingRadiusZ,
                                            
                                            beveled = beveled,
                                            bevelOuter = bevelOuter,
                                            
                                            tongueOffset = tonOffsetCalc,
                                            tongueThickness = tonThicknessCalc,
                                            tongueThicknessAdjustment = tongueThicknessAdjustment,
                                            tongueHeight = tonHeightCalc,
                                            tongueClampThickness = tongueClampThickness,
                                            tongueClampHeight = tonClampHeightCalc,
                                            tongueClampOffset = tonClampOffsetCalc,
                                            tongueRoundingRadius = tongueRoundingRadius,
                                            tongueInnerRoundingRadius = tongueInnerRoundingRadius,
                                            
                                            pit = recess,
                                            pitWallGaps = recessWallGaps,
                                            pitSizeX = pitSizeX,
                                            pitSizeY = pitSizeY,
                                            
                                            qualitySegBase = qualitySegBase,
                                            qualityFactor = qualityFactor,
                                            qualityResolutionMin = qualityResolutionMin,
                                            qualityResolutionMax = qualityResolutionMax,
                                            qualityResolutionMultiplier = qualityResolutionMultiplier,
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
                            if(text != false && !mb_is_empty_string(text) && txtDepth > 0){
                                color(textColor == "inherit" ? baseColor : textColor)
                                    translate([decoratorX(textSide, txtDepth, textOffset[0]), decoratorY(textSide, txtDepth, textOffset[1]), decoratorZ(textSide, txtDepth, textOffset[1])])
                                        rotate(decoratorRotations[textSide])
                                            mb_text3d(
                                                text = text,
                                                textDepth = txtDepth,
                                                textSize = scale * textSize,
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
                                                size = scale * svgScale,
                                                center = true
                                            );
                            } // End if svg
                            
                        } // End pre_render

                        translate([translateXChildren, translateYChildren, translateZChildren]){
                            children();
                        }
                        
                    } // End final union
                
                } // End direction rotation
            } // End rotation offset and alignment
        } // End rotation
    } //End grid offset and rotation offset revert

    echo(str("Rendered ", blockId, " - Need Help? Join our Discord: MachineBlocks.com"));
    }
    else{
        echo(str("Ignored ", blockId));
    }
} // End module block
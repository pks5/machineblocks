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
use <core/block_dim.scad>;
use <core/block_part.scad>;
use <core/utils.scad>;
use <core/quality.scad>;


use <layout/base_outer.scad>;
use <layout/base_cutout.scad>;
use <layout/base.scad>;

use <shape/cube.scad>;

include <core/api.scad>;

/*
* Main Module
*/
module mb_block(
    config,
    settings
){
    

    //START get parameters
    unitMbu = mb_param_unitMbuToMm(config, settings);
    unitGrid = mb_param_unitGridToMbu(config, settings);

    scale = mb_param_scale(config, settings);

    rotation = mb_param_rotation(config, settings);
    rotationOffset = mb_param_rotationOffset(config, settings);
    rotationOffsetRevert = mb_param_rotationOffsetRevert(config, settings);
    direction = mb_param_direction(config, settings);

    

    offset = mb_param_offset(config, settings);
    

    cutouts = mb_param_cutouts(config, settings);
    ports = mb_param_ports(config, settings);
    
    baseMod = mb_param_sizeMod(config, settings);

    baseCutoutType = mb_param_baseCutoutType(config, settings);
    baseClampOuter = mb_param_baseClampOuter(config, settings);

    baseSideAdjustment = mb_param_baseAdjustment(config, settings);
    
    stabilizerGrid = mb_param_stabilizers(config, settings);
    stabilizerGridOffset = mb_param_stabilizerLayerOffset(config, settings);
    stabilizerGridHeight = mb_param_stabilizerHeight(config, settings);
    stabilizerGridThickness = mb_param_stabilizerThickness(config, settings);
    stabilizerExpansion = mb_param_stabilizerExpansion(config, settings);
    stabilizerExpansionOffset = mb_param_stabilizerExpansionOffset(config, settings);

    pillars = mb_param_pillars(config, settings);
    pillarGapCornerLength = mb_param_pillarGapCornerLength(config, settings);
    pillarGapMiddle = mb_param_pillarGapMiddle(config, settings);

    bevel = mb_param_bevel(config, settings);

    studs = mb_param_studs(config, settings);
    
    recess = mb_param_recess(config, settings);
    recessDepth = mb_param_recessDepth(config, settings);
    recessWallThickness = mb_param_recessWallThickness(config, settings);
    recessStuds = mb_param_recessStuds(config, settings);
    recessStudPadding = mb_param_recessStudPadding(config, settings);
    recessStudType = mb_param_recessStudType(config, settings);
    recessStudShift = mb_param_recessStudShift(config, settings);
    recessWallGaps = mb_param_recessWallGaps(config, settings);

    align = mb_param_align(config, settings);
    alignChildren = mb_param_alignChildren(config, settings);

    previewRender = mb_param_scadPreviewPreRender(config, settings);
    previewRenderConvexity = mb_param_scadPreviewPreRenderConvexity(config, settings);

    blockId = mb_param_id(config, settings);
    debug = mb_param_debug(config, settings);

    //END get parameters

    //Variables for cutouts        
    cutTolerance = 0.01;

    /*
    * Start measurements
    */
    
    
    block_obj = mb_block_obj(
        config = config,
        settings = settings
    );

    size = mb_block_get_size(block_obj);
    sizeAdjustment = mb_param_sizeAdjustment(config, settings);

    os_mm = mb_block_obj_size(block_obj, unit="mm");
    osm_mm = mb_block_obj_size_mod(block_obj, unit="mm");
    osa_mm = mb_block_obj_size_adj(block_obj, unit="mm");

    
    mbuToMm = scale * unitMbu;

    gridSizeXY = unitGrid[0] * mbuToMm;
    gridSizeZ = unitGrid[1] * mbuToMm;

    //Object Size     
    objectSizeX = os_mm[0];
    objectSizeY = os_mm[1];
    objectSizeZ = os_mm[2];

    objectSize = os_mm;

    
    
    block_dim = mb_block_get_dim(block_obj);

    ss = mb_block_dim_opposite_offset(
            block_dim, 
            off = mb_block_get_stud_base_overlap(block_obj), 
            adjusted = true, 
            face = "z-"
        );

    echo(
        mod_size = mb_block_dim_mod_size(block_dim),
        min_max_pos = mb_block_dim_min_max_pos(block_dim),
        ss = ss
    );

    //Side Adjustment
   
    baseModRes = mb_qc_resolve(qc = baseMod, cube = true, mul = [gridSizeXY, gridSizeXY, gridSizeZ]);
    baseModR = mb_qc_resolve(qc = baseMod, cube = true);
    
    bsa =  mb_qc_resolve(qc = baseSideAdjustment, cube = true, default = [sizeAdjustment[0], sizeAdjustment[0], sizeAdjustment[0], sizeAdjustment[0], 0, sizeAdjustment[1]]); 
    sideAdjustment = mb_array_add(bsa, baseModRes);

    // Object Size Fully Adjusted
    objectSizeXAdjusted = osa_mm[0];
    objectSizeYAdjusted = osa_mm[1];
    objectSizeZAdjusted = osa_mm[2];

    objectSizeAdjusted = osa_mm;


    echo(
        objectSize = objectSize, 
        os_mm = os_mm, 
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

    align_offset = mb_block_align_offset(block_obj, align);

    //Calculate Brick Align and Offset
    alignX = align_offset[0];
    alignY = align_offset[1];
    alignZ = align_offset[2]; 
    
    directionRotationZ = direction * -90;

    //Rotation Offset
    rotationOffsetX = rotationOffset[0] * gridSizeXY;
    rotationOffsetY = rotationOffset[1] * gridSizeXY;
    rotationOffsetZ = rotationOffset[2] * gridSizeZ;

    preRotationOffset = [
        rotationOffsetX + (direction % 2 == 0 ? alignX : alignY) * gridSizeXY, 
        rotationOffsetY + (direction % 2 == 0 ? alignY : alignX) * gridSizeXY, 
        rotationOffsetZ + alignZ * gridSizeZ
    ];
//preRotationOffset = [0,0,0];
    //Grid offset
    gridOffsetX = offset[0] * gridSizeXY - (rotationOffsetRevert ? rotationOffsetX : 0);
    gridOffsetY = offset[1] * gridSizeXY - (rotationOffsetRevert ? rotationOffsetY : 0);
    gridOffsetZ = offset[2] * gridSizeZ - (rotationOffsetRevert ? rotationOffsetZ : 0);

    //Children alignment
    children_align_offset = mb_block_align_offset(block_obj, alignChildren, true);
    translateXChildren = children_align_offset[0] * gridSizeXY;
    translateYChildren = children_align_offset[1] * gridSizeXY;
    translateZChildren = children_align_offset[2] * gridSizeZ; 

    recWallThickness = mb_resolve_side_quad(recessWallThickness, gridSizeXY);
    
    //Stabilizer
    sGridThickness = stabilizerGridThickness * mbuToMm;
    sGridHeight = stabilizerGridHeight * mbuToMm;
    
    //Grid
    
    
    offsetX = 0.5 * (size[0] - 1);
    offsetY = 0.5 * (size[1] - 1);

    
    

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
    * Stabilizer Grid
    */
    function stabilizersXHeight(a) = sGridHeight + stabilizerGridOffset + (stabilizerExpansion > 0 && (holeX == false) && (((size[0] > stabilizerExpansion + 1) && ((a % stabilizerExpansion) == (stabilizerExpansion - 1))) || (size[1] == 1)) ? max(baseCutoutDepth - (stabilizerExpansionOffset * mbuToMm) - sGridHeight - stabilizerGridOffset, 0) : 0);
    function stabilizersYHeight(b) = sGridHeight + (stabilizerExpansion > 0 && (holeY == false) && (((size[1] > stabilizerExpansion + 1) && ((b % stabilizerExpansion) == (stabilizerExpansion - 1))) || (size[0] == 1)) ? max(baseCutoutDepth - (stabilizerExpansionOffset * mbuToMm) - sGridHeight, 0) : 0);
    
    /*
                                                            
                                                                            * Screw Hole Helpers Z
                                                                            
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
                                                                            }*/

    /*
    * END Functions
    */
    if(mb_param_render(config, settings)){
        translate([gridOffsetX, gridOffsetY, gridOffsetZ]){
            rotate(rotation){
                translate(preRotationOffset){
                    rotate([0, 0, directionRotationZ]){
                        union(){ // Final union
                            mb_pre_render(previewRender, previewRenderConvexity){
                                
                                difference(){
                                    
                                        union(){
                                            /*
                                            * Base Block
                                            */
                                            /*
                                            mb_base(
                                                block_obj = block_obj,
                                                debug = debug
                                            );
                                            */
                                            mb_block_part(block_obj, part = mb_block_part__base(block_obj), debug = debug);
                                            
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
                                                                            radius = [0, 0, shape[3][1]], 
                                                                            xyz_rad = true,
                                                                            rounding_resolution=20
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } // END main difference
                                
                            } // END pre_render

                            // Render Children
                            translate([translateXChildren, translateYChildren, translateZChildren]){
                                children();
                            }
                            
                        } // END final union
                    
                    } // END direction rotation
                } // END rotation offset and alignment
            } // END rotation
        } // END grid offset and rotation offset revert

        echo(str("Rendered ", blockId, " - Need Help? Join our Discord: MachineBlocks.com"));
    } // END if render
    else{
        echo(str("Ignored ", blockId));
    }
} // END module block
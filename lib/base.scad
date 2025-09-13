use <shapes.scad>;
use <connectors.scad>;
use <utils.scad>;
use <quad.scad>;
use <polygon.scad>;

module mb_slant_prism(side, l, w, h, inv){
    invRot = inv ? 180 : 0;
    rotations = [[invRot, 0, 0], [invRot, 0, 180], [invRot, 0, 90], [invRot, 0, 270]];

    rotate(rotations[side])
        translate([-0.5*l, -0.5*w, -0.5 * h])
            polyhedron(
                    points=[[0,0,h], [l,0,h], [l,w,h], [0,w,h], [0,w,0], [0,0,0]],
                    faces=[[1,2,4,5],[3,2,1,0],[5,4,3,0],[0,1,5],[2,3,4]]
                    );
}


/*
* Base Cutout
*/
module mb_base_cutout(
    grid,
    gridSizeXY,
    
    baseHeight,
    baseSideAdjustment, 
    baseCutoutDepth,
    baseRoundingRadiusZ,
    baseClampHeight,
    baseClampThickness,
    baseClampOffset,
    
    cutoutRoundingRadius,
    roundingResolution,
    wallThickness,
    
    //Top Plate
    topPlateZ,
    topPlateHeight,
    topPlateHelpers,
    topPlateHelperHeight,
    topPlateHelperThickness,

    //Pit
    pit,
    pitDepth,
    
    //Slanting
    slanting,
    slantingLowerHeight,

    beveled,
    bevelHorizontal,
    bevelOuter,
    bevelInner
){
    baseClampWallThickness = wallThickness + baseClampThickness;

    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    objectSizeX = gridSizeXY * (grid[0] + (slanting != false ? slanting(slanting[0]) + slanting(slanting[1]) : 0)); //todo support slanting undef
    objectSizeY = gridSizeXY * (grid[1] + (slanting != false ? slanting(slanting[2]) + slanting(slanting[3]) : 0));
    objectSize=[objectSizeX, objectSizeY];

    offsetX =  0.5*(slanting != false ? -slanting(slanting[0]) + slanting(slanting[1]) : 0) * gridSizeXY;
    offsetY =  0.5*(slanting != false ? -slanting(slanting[2]) + slanting(slanting[3]) : 0) * gridSizeXY;

    echo(
        slanting=slanting, 
        offsetX = offsetX, 
        offsetY = offsetY, 
        baseHeight=baseHeight, 
        topPlateHeight = topPlateHeight, 
        baseClampOffset=baseClampOffset,
        baseRoundingRadiusZ = baseRoundingRadiusZ,
        cutoutRoundingRadius = cutoutRoundingRadius);

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSize[0] + baseSideAdjustment[0] + baseSideAdjustment[1];
    objectSizeYAdjusted = objectSize[1] + baseSideAdjustment[2] + baseSideAdjustment[3];

    bevelClamp = mb_inset_quad_lrfh(bevelOuter, baseClampWallThickness);
    
    
    function posX(a) = (a - (0.5 * (grid[0] - 1))) * gridSizeXY;
    function posY(b) = (b - (0.5 * (grid[1] - 1))) * gridSizeXY;

    function slantingSize(side) = (slanting[side] >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (gridSizeXY * slanting[side] + baseSideAdjustment[side])) + cutTolerance;
    function slanting(s) = s > 0 ? 0 : s;

    
    translate([offsetX, offsetY, 0]){ 
        difference(){
            
                
            union(){
                
                    
                    union(){
                        /*
                        * Bottom Hole
                        */
                        translate([0, 0, 0.5*(baseClampOffset + baseClampHeight - (pit ? pitDepth : 0) - topPlateHeight) ]){
                            
                            mb_beveled_rounded_block(
                                bevel = beveled ? bevelInner : false,
                                sizeX = objectSize[0] - 2*wallThickness,
                                sizeY = objectSize[1] - 2*wallThickness,
                                height = baseHeight - (pit ? pitDepth : 0) - topPlateHeight - baseClampHeight - baseClampOffset,
                                roundingRadius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius],
                                roundingResolution = roundingResolution
                            );
                            /*
                            intersection(){
                                make_bevel(bevelInner, baseHeight - (pit ? pitDepth : 0) - topPlateHeight - baseClampHeight - baseClampOffset);
                                mb_rounded_block(
                                    size = [objectSize[0] - 2*wallThickness, objectSize[1] - 2*wallThickness, baseHeight - (pit ? pitDepth : 0) - topPlateHeight - baseClampHeight - baseClampOffset], 
                                    center = true, 
                                    radius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius], 
                                    resolution=roundingResolution
                                );
                            }*/
                        }
                        /*
                        * Clamp Offset
                        */
                        if(baseClampOffset > 0){
                            translate([0, 0, 0.5*(baseClampOffset - baseHeight - cutOffset)]){
                                mb_beveled_rounded_block(
                                    bevel = beveled ? bevelInner : false,
                                    sizeX = objectSize[0] - 2 * wallThickness,
                                    sizeY = objectSize[1] - 2 * wallThickness,
                                    height = baseClampOffset + cutOffset,
                                    roundingRadius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius],
                                    roundingResolution = roundingResolution
                                );
                                /*
                                intersection(){
                                    make_bevel(bevelInner, baseClampOffset + cutOffset);
                                    mb_rounded_block(
                                        size = [objectSize[0] - 2 * wallThickness, objectSize[1] - 2 * wallThickness, baseClampOffset + cutOffset], 
                                        center = true, 
                                        radius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius], 
                                        resolution=roundingResolution
                                    );
                                }*/
                            }
                        }
                    }    
                

                /*
                * Clamp Skirt
                */
                translate([0, 0, baseClampOffset + 0.5 * (baseClampHeight - baseHeight)]){
                    mb_beveled_rounded_block(
                        bevel = beveled ? bevelClamp : false,
                        sizeX = objectSize[0] - 2 * baseClampWallThickness,
                        sizeY = objectSize[1] - 2 * baseClampWallThickness,
                        height = baseClampHeight * cutMultiplier,
                        roundingRadius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius],
                        roundingResolution = roundingResolution
                    );

                    /*
                    intersection(){
                        make_bevel(bevelClamp, baseClampHeight * cutMultiplier);
                        mb_rounded_block(
                            size = [objectSize[0] - 2 * baseClampWallThickness, objectSize[1] - 2 * baseClampWallThickness, baseClampHeight * cutMultiplier], 
                            center = true, 
                            radius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius], 
                            resolution=roundingResolution
                        );
                    }*/
                }
            }
            
            /*
            * Slanting
            */
            if(slanting != false){
                
                if(slanting[0] > 0){
                    slanting0 = slantingSize(0);
                    translate([-0.5 * (objectSize[0] - 2*wallThickness - slanting0 + cutTolerance), 0, 0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(0, slanting0, objectSize[1] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance, false);
                }

                if(slanting[1] > 0){
                    slanting1 = slantingSize(1);
                    translate([0.5 * (objectSize[0] - 2*wallThickness - slanting1 + cutTolerance), 0, 0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(1, slanting1, objectSize[1] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance, false);
                }

                if(slanting[2] > 0){
                    slanting2 = slantingSize(2);
                    translate([0, -0.5 * (objectSize[1] - 2*wallThickness - slanting2 + cutTolerance), 0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(2, slanting2, objectSize[0] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance, false);
                }
                
                if(slanting[3] > 0){
                    slanting3 = slantingSize(3);
                    translate([0, 0.5 * (objectSize[1] - 2*wallThickness - slanting3 + cutTolerance), 0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(3, slanting3, objectSize[0] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance, false);
                }
                
            }
        }
    } 

}

/*
* Base Block
*/
module mb_base(
    grid,
    gridSizeXY,
    objectSize, 
    height, 
    baseSideAdjustment, 
    baseReliefCut,
    baseReliefCutHeight,
    baseReliefCutThickness,
    roundingRadius, 
    roundingResolution,
    pit,
    pitRoundingRadius,
    pitWallThickness,
    pitDepth,
    pitWallGaps,
    slanting,
    slantingLowerHeight,
    beveled,
    bevelHorizontal,
    bevelOuter,
    bevelOuterAdjusted,
    connectors = [],
    connectorHeight,
    connectorDepth,
    connectorSize,
    connectorDepthTolerance,
    connectorSideTolerance
){
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    //Object Size     
    objectSizeX = gridSizeXY * grid[0];
    objectSizeY = gridSizeXY * grid[1];

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSize[0] + baseSideAdjustment[0] + baseSideAdjustment[1];
    objectSizeYAdjusted = objectSize[1] + baseSideAdjustment[2] + baseSideAdjustment[3];

    size = [objectSizeXAdjusted, objectSizeYAdjusted, height];

    baseRoundingRadiusZ = mb_base_rounding_radius_z(radius = roundingRadius);
    reliefRadius = mb_base_cutout_radius(-baseReliefCutThickness, baseRoundingRadiusZ);

    bevelReliefCut = mb_inset_quad_lrfh(bevelOuter, baseReliefCutThickness);

    function sideX(side) = 0.5 * (baseSideAdjustment[1] - baseSideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (baseSideAdjustment[3] - baseSideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;

    function slantingSize(side) = (abs(slanting[side]) >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (gridSizeXY * abs(slanting[side]) + baseSideAdjustment[side])) + cutTolerance;

    union(){
        
        difference(){
            translate([0.5*(baseSideAdjustment[1] - baseSideAdjustment[0]), 0.5*(baseSideAdjustment[3] - baseSideAdjustment[2]), 0]){
                
                difference(){ // Subtract relief cut and slanting from base
                    mb_beveled_rounded_block(
                        bevel = beveled ? bevelOuterAdjusted : false,
                        sizeX = objectSizeXAdjusted,
                        sizeY = objectSizeYAdjusted,
                        height = height,
                        roundingRadius = roundingRadius,
                        roundingResolution = roundingResolution
                    );

                    /*
                    intersection(){
                        make_bevel(bevelOuterAdjusted, height);

                        mb_rounded_block(
                            size = size, 
                            center=true, 
                            resolution = roundingResolution,
                            radius = roundingRadius
                        );
                    }*/

                    if(baseReliefCut){
                        translate([0,0,-0.5*(height-baseReliefCutHeight)-0.5*cutOffset]){
                            difference(){
                                cube(
                                    size = [cutMultiplier * objectSize[0], cutMultiplier * objectSize[1], baseReliefCutHeight + cutOffset], 
                                    center=true
                                );

                                mb_beveled_rounded_block(
                                    bevel = beveled ? bevelReliefCut : false,
                                    sizeX = objectSize[0] - 2*baseReliefCutThickness,
                                    sizeY = objectSize[1] - 2*baseReliefCutThickness,
                                    height = cutMultiplier * (baseReliefCutHeight + cutOffset),
                                    roundingRadius = reliefRadius == 0 ? 0 : [0, 0, reliefRadius],
                                    roundingResolution = roundingResolution
                                );

                                /*
                                intersection(){
                                    make_bevel(bevelReliefCut, cutMultiplier * (baseReliefCutHeight + cutOffset));
                        
                                    mb_rounded_block(
                                        size = [objectSize[0] - 2*baseReliefCutThickness, objectSize[1] - 2*baseReliefCutThickness, cutMultiplier * (baseReliefCutHeight + cutOffset)], 
                                        center=true, 
                                        resolution = roundingResolution,
                                        radius = reliefRadius == 0 ? 0 : [0, 0, reliefRadius]
                                    );
                                }*/
                            }
                        }
                    }

                    /*
                    * Slanting
                    */
                    if(slanting != false){
                        if(slanting[0] != 0){
                            slanting0 = slantingSize(0);
                            translate([-0.5 * (objectSizeXAdjusted - slanting0 + cutTolerance), 0, sign(slanting[0])*0.5*(slantingLowerHeight + cutTolerance)])
                                mb_slant_prism(0, slanting0, objectSizeYAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance, slanting[0] < 0);
                        }

                        if(slanting[1] != 0){
                            slanting1 = slantingSize(1);
                            translate([0.5 * (objectSizeXAdjusted - slanting1 + cutTolerance), 0, sign(slanting[1])*0.5*(slantingLowerHeight + cutTolerance)])
                                mb_slant_prism(1, slanting1, objectSizeYAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance, slanting[1] < 0);
                        }

                        if(slanting[2] != 0){
                            slanting2 = slantingSize(2);
                            translate([0, -0.5 * (objectSizeYAdjusted - slanting2 + cutTolerance), sign(slanting[2])*0.5*(slantingLowerHeight + cutTolerance)])
                                mb_slant_prism(2, slanting2, objectSizeXAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance, slanting[2] < 0);
                        }

                        if(slanting[3] != 0){
                            slanting3 = slantingSize(3);
                            translate([0, 0.5 * (objectSizeYAdjusted - slanting3 + cutTolerance), sign(slanting[3])*0.5*(slantingLowerHeight + cutTolerance)])
                                mb_slant_prism(3, slanting3, objectSizeXAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance, slanting[3] < 0);
                        }
                    }
                } // End difference
                
            } // End translate

            /*
            * Pit
            */
            if(pit){
                pitSizeX = objectSize[0] - (pitWallThickness[0] + pitWallThickness[1]) * gridSizeXY;
                pitSizeY = objectSize[1] - (pitWallThickness[2] + pitWallThickness[3]) * gridSizeXY;
                pitBevelInner = mb_inset_quad_lrfh(bevelOuter, [pitWallThickness[0]*gridSizeXY, pitWallThickness[1]*gridSizeXY, pitWallThickness[2]*gridSizeXY, pitWallThickness[3]*gridSizeXY]);
                pMinThickness = [-min(pitWallThickness[2], pitWallThickness[0])*gridSizeXY, -min(pitWallThickness[0], pitWallThickness[3])*gridSizeXY, -min(pitWallThickness[3], pitWallThickness[1])*gridSizeXY, -min(pitWallThickness[1], pitWallThickness[2])*gridSizeXY];
                pitRadius = mb_base_cutout_radius(pitRoundingRadius == "auto" ? pMinThickness : pitRoundingRadius, baseRoundingRadiusZ);
                    
                translate([0, 0, 0.5 * (height - pitDepth) + 0.5 * cutOffset]){
                    intersection(){
                        make_bevel(pitBevelInner, pitDepth + cutOffset);
                        translate([0.5 * (pitWallThickness[0] - pitWallThickness[1]) * gridSizeXY, 0.5 * (pitWallThickness[2] - pitWallThickness[3]) * gridSizeXY, 0])
                            mb_rounded_block(size = [pitSizeX, pitSizeY, pitDepth + cutOffset], radius=pitRadius == 0 ? 0 : [0, 0, pitRadius], resolution=roundingResolution, center = true);
                    }
                }

                //Pit Wall Gaps
                for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                    gap = pitWallGaps[gapIndex];
                    if(gap[0] < 2){
                        translate([sideX(gap[0]), -0.5 * (gap[2] - gap[1]) * gridSizeXY, 0.5*(height - pitDepth + cutOffset)])
                            cube([2 * pitWallThickness[gap[0]] * gridSizeXY * cutMultiplier, pitSizeY - (gap[1] + gap[2]) * gridSizeXY, pitDepth + cutOffset], center = true);
                    }  
                    else{
                        translate([-0.5 * (gap[2] - gap[1]) * gridSizeXY, sideY(gap[0] - 2), 0.5*(height - pitDepth + cutOffset)])
                            cube([pitSizeX - (gap[1] + gap[2]) * gridSizeXY , 2 * pitWallThickness[gap[0]] * gridSizeXY * cutMultiplier, pitDepth + cutOffset], center = true);     
                    } 
                }
            } // End Pit

            /*
            * Connectors
            */
            for (con = [ 0 : 1 : len(connectors)-1 ]){
                if(connectors[con][1] == 1){
                    mb_connectors(side = connectors[con][0],
                            grid = grid,
                            height = (connectorHeight == 0 ? height : connectorHeight) + connectorDepthTolerance,
                            baseHeight = height,
                            inverse=true,
                            size = connectorSize,
                            depth = connectorDepth,
                            gs = gridSizeXY);
                }
                else if(connectors[con][1] > 1){
                    mb_connector_grooves(side = connectors[con][0],
                        grid = grid,
                        depth = (connectorHeight == 0 ? height : connectorHeight) + connectorDepthTolerance,
                        baseHeight = height,
                        inverse=connectors[con][1]==3,
                        size = connectorSize,
                        height = connectorDepth,
                        gs = gridSizeXY);
                }
            }

            
        } // End difference

        /*
        * Connectors
        */
        for (con = [ 0 : 1 : len(connectors)-1 ]){
            if(connectors[con][1] == 0){
                mb_connectors(side = connectors[con][0],
                        grid = grid,
                        height = (connectorHeight == 0 ? height : connectorHeight),
                        baseHeight = height,
                        inverse=connectors[con][1]==1,
                        size = connectorSize - 2*connectorSideTolerance,
                        depth = connectorDepth - connectorSideTolerance,
                        gs = gridSizeXY);
            }
        }
    } // End union
} // End mb_base
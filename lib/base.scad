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
    cutoutClampRoundingRadius,
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
    
    //Slope
    slope,
    slopeBaseHeightLower,

    //Bevel
    beveled,
    bevelOuter,
    bevelInner
){
    baseClampWallThickness = wallThickness + baseClampThickness;

    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    objectSizeX = gridSizeXY * (grid[0] + (slope != false ? min(slope[0], 0) + min(slope[1], 0) : 0));
    objectSizeY = gridSizeXY * (grid[1] + (slope != false ? min(slope[2], 0) + min(slope[3], 0) : 0));
    objectSize=[objectSizeX, objectSizeY];

    offsetX =  0.5*(slope != false ? -min(slope[0], 0) + min(slope[1], 0) : 0) * gridSizeXY;
    offsetY =  0.5*(slope != false ? -min(slope[2], 0) + min(slope[3], 0) : 0) * gridSizeXY;

    echo(
        slope=slope, 
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
    
    
    //function posX(a) = (a - (0.5 * (grid[0] - 1))) * gridSizeXY;
    //function posY(b) = (b - (0.5 * (grid[1] - 1))) * gridSizeXY;

    function slopeSize(side) = (slope[side] >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (gridSizeXY * slope[side] + baseSideAdjustment[side])) + cutTolerance;
    //function slan2ting(s) = s > 0 ? 0 : s;

    
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
                        roundingRadius = cutoutClampRoundingRadius == 0 ? 0 : [0, 0, cutoutClampRoundingRadius],
                        roundingResolution = roundingResolution
                    );
                }
            }
            
            /*
            * Slope
            */
            if(slope != false){
                for(side = [0 : 1 : 3]){
                    if(slope[side] > 0){
                        slopeSide0 = slopeSize(side);
                        tx = ((side % 2 == 0) ? -0.5 : 0.5) * (objectSize[side < 2 ? 0 : 1] - 2*wallThickness - slopeSide0 + cutTolerance);
                        translate([side < 2 ? tx : 0, side < 2 ? 0 : tx, 0.5*(slopeBaseHeightLower + cutTolerance)])
                            mb_slant_prism(side, slopeSide0, objectSize[side < 2 ? 1 : 0] * cutMultiplier, baseHeight - slopeBaseHeightLower + cutTolerance, false);
                    }
                }
                /*
                if(slope[0] > 0){
                    slopeSide0 = slopeSize(0);
                    translate([-0.5 * (objectSize[0] - 2*wallThickness - slopeSide0 + cutTolerance), 0, 0.5*(slopeBaseHeightLower + cutTolerance)])
                        mb_slant_prism(0, slopeSide0, objectSize[1] * cutMultiplier, baseHeight - slopeBaseHeightLower + cutTolerance, false);
                }

                if(slope[1] > 0){
                    slopeSide1 = slopeSize(1);
                    translate([0.5 * (objectSize[0] - 2*wallThickness - slopeSide1 + cutTolerance), 0, 0.5*(slopeBaseHeightLower + cutTolerance)])
                        mb_slant_prism(1, slopeSide1, objectSize[1] * cutMultiplier, baseHeight - slopeBaseHeightLower + cutTolerance, false);
                }

                if(slope[2] > 0){
                    slopeSide2 = slopeSize(2);
                    translate([0, -0.5 * (objectSize[1] - 2*wallThickness - slopeSide2 + cutTolerance), 0.5*(slopeBaseHeightLower + cutTolerance)])
                        mb_slant_prism(2, slopeSide2, objectSize[0] * cutMultiplier, baseHeight - slopeBaseHeightLower + cutTolerance, false);
                }
                
                if(slope[3] > 0){
                    slopeSide3 = slopeSize(3);
                    translate([0, 0.5 * (objectSize[1] - 2*wallThickness - slopeSide3 + cutTolerance), 0.5*(slopeBaseHeightLower + cutTolerance)])
                        mb_slant_prism(3, slopeSide3, objectSize[0] * cutMultiplier, baseHeight - slopeBaseHeightLower + cutTolerance, false);
                }*/
                
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
    gridSizeZ,
    objectSize, 
    height, 
    
    baseSideAdjustment, 
    baseReliefCut,
    baseReliefCutHeight,
    baseReliefCutThickness,
    baseClampHeight,
    baseClampThicknessOuter,
    baseClampOffset,
    
    roundingRadius, 
    roundingResolution,
    
    pit,
    pitRoundingRadius,
    pitWallThickness,
    pitDepth,
    pitWallGaps,
    
    slope,
    slopeBaseHeightLower,
    slopeBaseHeightUpper,
    
    beveled,
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
    minObjectSide = min(objectSizeXAdjusted, objectSizeYAdjusted);

    size = [objectSizeXAdjusted, objectSizeYAdjusted, height];

    baseRoundingRadiusResolved = mb_base_rounding_radius(roundingRadius, gridSizeXY, gridSizeZ);
    baseRoundingRadiusZ = baseRoundingRadiusResolved[2];
    
    reliefRadius = mb_base_cutout_radius(-baseReliefCutThickness, baseRoundingRadiusZ, minObjectSide);
    bevelReliefCut = mb_inset_quad_lrfh(bevelOuter, baseReliefCutThickness);

    bevelBaseClampOuter = mb_inset_quad_lrfh(bevelOuterAdjusted, -baseClampThicknessOuter);
    baseClampOuterRoundingRadius = mb_base_rel_radius(baseClampThicknessOuter, baseRoundingRadiusZ, minObjectSide, true);

    //TODO create functions in utils and remove this functions here
    function sideX(side) = 0.5 * (baseSideAdjustment[1] - baseSideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (baseSideAdjustment[3] - baseSideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;

    function slopeSize(side) = (abs(slope[side]) >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (gridSizeXY * abs(slope[side]) + baseSideAdjustment[side])) + cutTolerance;
    function slopeBaseHeight(side) = slope[side] < 0 ? slopeBaseHeightUpper : slopeBaseHeightLower;

    union(){
        
        difference(){
            translate([0.5*(baseSideAdjustment[1] - baseSideAdjustment[0]), 0.5*(baseSideAdjustment[3] - baseSideAdjustment[2]), 0]){
                
                difference(){ // Subtract relief cut and slope from base
                    union(){
                        mb_beveled_rounded_block(
                            bevel = beveled ? bevelOuterAdjusted : false,
                            sizeX = objectSizeXAdjusted,
                            sizeY = objectSizeYAdjusted,
                            height = height,
                            roundingRadius = baseRoundingRadiusResolved,
                            roundingResolution = roundingResolution
                        );

                        if(baseClampThicknessOuter > 0){
                            //Outer clamp
                            //Only used to produce cutouts
                            translate([0,0,-0.5*(height-baseClampHeight) + baseClampOffset])
                                mb_beveled_rounded_block(
                                    bevel = beveled ? bevelBaseClampOuter : false,
                                    sizeX = objectSizeXAdjusted + 2*baseClampThicknessOuter,
                                    sizeY = objectSizeYAdjusted + 2*baseClampThicknessOuter,
                                    height = baseClampHeight,
                                    roundingRadius = baseClampOuterRoundingRadius,
                                    roundingResolution = roundingResolution
                                );
                        }
                    }

                    if(baseReliefCut){
                        translate([-0.5*(baseSideAdjustment[1] - baseSideAdjustment[0]), -0.5*(baseSideAdjustment[3] - baseSideAdjustment[2]),-0.5*(height-baseReliefCutHeight)-0.5*cutOffset]){
                            difference(){
                                cube(
                                    size = [cutMultiplier * objectSizeXAdjusted, cutMultiplier * objectSizeYAdjusted, baseReliefCutHeight + cutOffset], 
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
                            }
                        }
                    }

                    /*
                    * Slope
                    */
                    if(slope != false){
                        for(side = [0 : 1 : 3]){
                            if(slope[side] != 0){
                                slopeSide0 = slopeSize(side);
                                slopeBaseHeight0 = slopeBaseHeight(side);
                                tx = ((side % 2 == 0) ? -0.5 : 0.5) * ((side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) - slopeSide0 + cutTolerance);
                                translate([side < 2 ? tx : 0, side < 2 ? 0 : tx, sign(slope[0])*0.5*(slopeBaseHeight0 + cutTolerance)])
                                    mb_slant_prism(side, slopeSide0, (side < 2 ? objectSizeYAdjusted : objectSizeXAdjusted) * cutMultiplier, height - slopeBaseHeight0 + cutTolerance, slope[side] < 0);
                            }
                        }

                        /*
                        if(slope[0] != 0){
                            slopeSide0 = slopeSize(0);
                            slopeBaseHeight0 = slopeBaseHeight(0);
                            translate([-0.5 * (objectSizeXAdjusted - slopeSide0 + cutTolerance), 0, sign(slope[0])*0.5*(slopeBaseHeight0 + cutTolerance)])
                                mb_slant_prism(0, slopeSide0, objectSizeYAdjusted * cutMultiplier, height - slopeBaseHeight0 + cutTolerance, slope[0] < 0);
                        }

                        if(slope[1] != 0){
                            slopeSide1 = slopeSize(1);
                            slopeBaseHeight1 = slopeBaseHeight(1);
                            translate([0.5 * (objectSizeXAdjusted - slopeSide1 + cutTolerance), 0, sign(slope[1])*0.5*(slopeBaseHeight1 + cutTolerance)])
                                mb_slant_prism(1, slopeSide1, objectSizeYAdjusted * cutMultiplier, height - slopeBaseHeight1 + cutTolerance, slope[1] < 0);
                        }

                        if(slope[2] != 0){
                            slopeSide2 = slopeSize(2);
                            slopeBaseHeight2 = slopeBaseHeight(2);
                            translate([0, -0.5 * (objectSizeYAdjusted - slopeSide2 + cutTolerance), sign(slope[2])*0.5*(slopeBaseHeight2 + cutTolerance)])
                                mb_slant_prism(2, slopeSide2, objectSizeXAdjusted * cutMultiplier, height - slopeBaseHeight2 + cutTolerance, slope[2] < 0);
                        }

                        if(slope[3] != 0){
                            slopeSide3 = slopeSize(3);
                            slopeBaseHeight3 = slopeBaseHeight(3);
                            translate([0, 0.5 * (objectSizeYAdjusted - slopeSide3 + cutTolerance), sign(slope[3])*0.5*(slopeBaseHeight3 + cutTolerance)])
                                mb_slant_prism(3, slopeSide3, objectSizeXAdjusted * cutMultiplier, height - slopeBaseHeight3 + cutTolerance, slope[3] < 0);
                        }*/
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
                pitRadius = mb_base_cutout_radius(pitRoundingRadius == "auto" ? pMinThickness : mb_rounding_radius(pitRoundingRadius, gridSizeXY), baseRoundingRadiusZ, minObjectSide);
                    
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
            if(connectors != false){
                for (con = [ 0 : 1 : len(connectors)-1 ]){
                    if(connectors[con][1] == 1){
                        mb_connectors(side = connectors[con][0],
                                grid = grid,
                                height = (connectorHeight == "auto" ? height : connectorHeight) + connectorDepthTolerance,
                                baseHeight = height,
                                inverse=true,
                                size = connectorSize,
                                depth = connectorDepth,
                                gs = gridSizeXY);
                    }
                    else if(connectors[con][1] > 1){
                        mb_connector_grooves(side = connectors[con][0],
                            grid = grid,
                            depth = (connectorHeight == "auto" ? height : connectorHeight) + connectorDepthTolerance,
                            baseHeight = height,
                            inverse=connectors[con][1]==3,
                            size = connectorSize,
                            height = connectorDepth,
                            gs = gridSizeXY);
                    }
                }
            }

            
        } // End difference

        /*
        * Connectors
        */
        if(connectors != false){
            for (con = [ 0 : 1 : len(connectors)-1 ]){
                if(connectors[con][1] == 0){
                    mb_connectors(side = connectors[con][0],
                            grid = grid,
                            height = (connectorHeight == "auto" ? height : connectorHeight),
                            baseHeight = height,
                            inverse=connectors[con][1]==1,
                            size = connectorSize - 2*connectorSideTolerance,
                            depth = connectorDepth - connectorSideTolerance,
                            gs = gridSizeXY);
                }
            }
        }
    } // End union
} // End mb_base
use <prismoid.scad>;
use <connectors.scad>;
use <utils.scad>;
use <quad.scad>;
use <polygon.scad>;
use <quality.scad>;

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

    objectSizeMod,
    baseMod,
    
    baseHeight,
    baseCutoutDepth,
    baseRoundingRadiusZ,
    baseClampHeight,
    baseClampThickness,
    baseClampOffset,
    
    cutoutRoundingRadius,
    cutoutClampRoundingRadius,
    wallThickness,
    
    //Pit
    pit,
    pitDepth,
    
    //Slope
    slope,
    slopeBaseHeightLowerInner,

    //Bevel
    beveled,
    bevelOuter,
    bevelInner,
    bevelMod,

    qualitySegBase,
    qualityFactor,
    qualityResolutionMin,
    qualityResolutionMax,
    qualityResolutionMultiplier,
    previewQuality,

    blockId,
    debug
){
    baseClampWallThickness = wallThickness + baseClampThickness;

    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    objectSizeX = gridSizeXY * (grid[0] + (slope != false ? min(slope[0], 0) + min(slope[1], 0) : 0));
    objectSizeY = gridSizeXY * (grid[1] + (slope != false ? min(slope[2], 0) + min(slope[3], 0) : 0));
    objectSize = [objectSizeX + baseMod[0] + baseMod[1], objectSizeY + baseMod[2] + baseMod[3]];

    offsetX =  0.5*(slope != false ? -min(slope[0], 0) + min(slope[1], 0) : 0) * gridSizeXY + 0.5*(baseMod[1] - baseMod[0]);
    offsetY =  0.5*(slope != false ? -min(slope[2], 0) + min(slope[3], 0) : 0) * gridSizeXY + 0.5*(baseMod[3] - baseMod[2]);

    if(debug){
        echo(
            id = blockId,
            debugSource = "base.scad",
            baseMod=baseMod,
            slope=slope, 
            offsetX = offsetX, 
            offsetY = offsetY, 
            baseHeight=baseHeight, 
            baseClampOffset=baseClampOffset,
            baseRoundingRadiusZ = baseRoundingRadiusZ,
            cutoutRoundingRadius = cutoutRoundingRadius);
    }

    //Object Size Adjusted      
    bevelClamp = mb_inset_quad_lrfh(bevelMod, baseClampWallThickness);
    
    
    function slopeSize(side) = (slope[side] >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSize[0] : objectSize[1]) : (gridSizeXY * slope[side])) + cutTolerance;
    
    translate([offsetX, offsetY, 0.5*baseMod[5]]){
        difference(){
            
                
            union(){
                
                    
                    union(){
                        cutoutRoundingRadiusQuality = mb_fn_even_for_radius(
                                    cutoutRoundingRadius, 
                                    1, 
                                    qualitySegBase,
                                    qualityFactor,
                                    qualityResolutionMin,
                                    qualityResolutionMax,
                                    qualityResolutionMultiplier,
                                    previewQuality
                                );

                        /*
                        * Bottom Hole
                        */
                        baseCutoutTopHeight = baseCutoutDepth - (baseClampOffset + baseClampHeight);
                        translate([0, 0,-0.5*baseHeight + baseClampOffset + baseClampHeight + 0.5*baseCutoutTopHeight ]){
                            /*
                            mb_beveled_rounded_block(
                                bevel = beveled ? bevelInner : false,
                                sizeX = objectSize[0] - 2*wallThickness,
                                sizeY = objectSize[1] - 2*wallThickness,
                                height = baseHeight - (pit ? pitDepth : 0) - topPlateHeight - baseClampHeight - baseClampOffset,
                                roundingRadius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius],
                                roundingResolution = cutoutRoundingRadiusQuality
                            );*/

                            mb_prismoid(
                                shape = [bevelInner], 
                                height = baseCutoutTopHeight,
                                radius = mb_xyz_rad_convert(cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius]), 
                                resolution = cutoutRoundingRadiusQuality
                            );
                        }
                        /*
                        * Clamp Offset
                        */
                        if(baseClampOffset > 0){
                            translate([0, 0, 0.5 * (-baseHeight + baseClampOffset - cutOffset)]){
                                /*
                                mb_beveled_rounded_block(
                                    bevel = beveled ? bevelInner : false,
                                    sizeX = objectSize[0] - 2 * wallThickness,
                                    sizeY = objectSize[1] - 2 * wallThickness,
                                    height = baseClampOffset + cutOffset,
                                    roundingRadius = cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius],
                                    roundingResolution = cutoutRoundingRadiusQuality
                                );*/

                                mb_prismoid(
                                    shape = [bevelInner], 
                                    height = baseClampOffset + cutOffset,
                                    radius = mb_xyz_rad_convert(cutoutRoundingRadius == 0 ? 0 : [0, 0, cutoutRoundingRadius]), 
                                    resolution = cutoutRoundingRadiusQuality
                                );
                            }
                        }
                    }    
                

                /*
                * Clamp Skirt
                */
                translate([0, 0, baseClampOffset + 0.5 * (baseClampHeight - baseHeight)]){
                    cutoutClampRoundingRadiusQuality = mb_fn_even_for_radius(
                                    cutoutClampRoundingRadius, 
                                    1, 
                                    qualitySegBase,
                                    qualityFactor,
                                    qualityResolutionMin,
                                    qualityResolutionMax,
                                    qualityResolutionMultiplier,
                                    previewQuality
                                );

                    /*
                    mb_beveled_rounded_block(
                        bevel = beveled ? bevelClamp : false,
                        sizeX = objectSize[0] - 2 * baseClampWallThickness,
                        sizeY = objectSize[1] - 2 * baseClampWallThickness,
                        height = baseClampHeight * cutMultiplier,
                        roundingRadius = cutoutClampRoundingRadius == 0 ? 0 : [0, 0, cutoutClampRoundingRadius],
                        roundingResolution = cutoutClampRoundingRadiusQuality
                    );*/

                    mb_prismoid(
                        shape = [bevelClamp], 
                        height = baseClampHeight * cutMultiplier, 
                        radius = mb_xyz_rad_convert(cutoutClampRoundingRadius == 0 ? 0 : [0, 0, cutoutClampRoundingRadius]), 
                        resolution = cutoutClampRoundingRadiusQuality
                    );
                }
            }
            
            /*
            * Slope
            */
            if(slope != false && slope != [0, 0, 0, 0]){
                for(side = [0 : 1 : 3]){
                    if(slope[side] > 0){
                        slopeSide0 = slopeSize(side);
                        tx = ((side % 2 == 0) ? -0.5 : 0.5) * (objectSize[side < 2 ? 0 : 1] - 2*wallThickness - slopeSide0 + cutTolerance);
                        translate([side < 2 ? tx : 0, side < 2 ? 0 : tx, 0.5*(slopeBaseHeightLowerInner + cutTolerance)])
                            mb_slant_prism(side, slopeSide0, objectSize[side < 2 ? 1 : 0] * cutMultiplier, baseHeight - slopeBaseHeightLowerInner + cutTolerance, false);
                    }
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
    gridSizeZ,
    
    objectSize, 
    objectSizeMod,
    objectSizeAdjusted,

    height, 
    
    baseSideAdjustment, 
    sideAdjustment,
    
    baseMod,
    baseReliefCut,
    baseReliefCutHeight,
    baseReliefCutThickness,
    baseClampHeight,
    baseClampThicknessOuter,
    baseClampOffset,
    baseRoundingRadius,

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
    bevelMod,
    bevelRecess,

    connectors = [],
    connectorPadding,
    connectorHeight,
    connectorDepth,
    connectorSize,
    connectorDepthTolerance,
    connectorSideTolerance,

    qualitySegBase,
    qualityFactor,
    qualityResolutionMin,
    qualityResolutionMax,
    qualityResolutionMultiplier,
    previewQuality,

    blockId,
    debug
){
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSizeAdjusted[0];
    objectSizeYAdjusted = objectSizeAdjusted[1];
    objectSizeZAdjusted = objectSizeAdjusted[2];

    minObjectSide = min(objectSizeXAdjusted, objectSizeYAdjusted);

    baseRoundingRadiusZ = baseRoundingRadius[2];
    
    reliefRadius = mb_base_cutout_radius(-baseReliefCutThickness, baseRoundingRadiusZ, minObjectSide);
    bevelReliefCut = mb_inset_quad_lrfh(bevelOuter, baseReliefCutThickness);

    bevelBaseClampOuter = mb_inset_quad_lrfh(bevelOuterAdjusted, -baseClampThicknessOuter);
    baseClampOuterRoundingRadius = mb_base_rel_radius(baseClampThicknessOuter, baseRoundingRadiusZ, minObjectSide, true);

    //TODO create functions in utils and remove this functions here
    function sideX(side) = 0.5 * (sideAdjustment[1] - sideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sideAdjustment[3] - sideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;

    function slopeSize(side) = (abs(slope[side]) >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (gridSizeXY * abs(slope[side]) + sideAdjustment[side])) + cutTolerance;
    function slopeBaseHeight(side) = slope[side] < 0 ? slopeBaseHeightUpper : slopeBaseHeightLower;

    union(){
        
        difference(){
            translate([0.5*(sideAdjustment[1] - sideAdjustment[0]), 0.5*(sideAdjustment[3] - sideAdjustment[2]), 0.5*(sideAdjustment[5]-sideAdjustment[4])]){
                
                difference(){ // Subtract relief cut and slope from base
                    union(){
                        baseRoundingRadiusQuality = mb_fn_even_for_radius(
                            baseRoundingRadius, 
                            1, 
                            qualitySegBase,
                            qualityFactor,
                            qualityResolutionMin,
                            qualityResolutionMax,
                            qualityResolutionMultiplier,
                            previewQuality
                        );

                        /*
                        mb_beveled_rounded_block(
                            bevel = beveled ? bevelOuterAdjusted : false,
                            sizeX = objectSizeXAdjusted,
                            sizeY = objectSizeYAdjusted,
                            height = height,
                            roundingRadius = baseRoundingRadius,
                            roundingResolution = baseRoundingRadiusQuality
                        );*/

                        mb_prismoid(
                            shape = [bevelOuterAdjusted], 
                            height = height, 
                            radius = mb_xyz_rad_convert(baseRoundingRadius), 
                            resolution = baseRoundingRadiusQuality
                        );

                        if(baseClampThicknessOuter > 0){
                            baseClampOuterRoundingRadiusQuality = mb_fn_even_for_radius(
                                baseClampOuterRoundingRadius, 
                                1, 
                                qualitySegBase,
                                qualityFactor,
                                qualityResolutionMin,
                                qualityResolutionMax,
                                qualityResolutionMultiplier,
                                previewQuality
                            );

                            //Outer clamp
                            //Only used to produce cutouts
                            translate([0,0,-0.5*(height-baseClampHeight) + baseClampOffset]){
                                /*
                                mb_beveled_rounded_block(
                                    bevel = beveled ? bevelBaseClampOuter : false,
                                    sizeX = objectSizeXAdjusted + 2*baseClampThicknessOuter,
                                    sizeY = objectSizeYAdjusted + 2*baseClampThicknessOuter,
                                    height = baseClampHeight,
                                    roundingRadius = baseClampOuterRoundingRadius,
                                    roundingResolution = baseClampOuterRoundingRadiusQuality
                                );*/
                            
                                mb_prismoid(
                                    shape = [bevelBaseClampOuter], 
                                    height = baseClampHeight, 
                                    radius = mb_xyz_rad_convert(baseClampOuterRoundingRadius), 
                                    resolution = baseClampOuterRoundingRadiusQuality
                                );
                            }
                        }
                    }

                    if(baseReliefCut){
                        translate([
                            -0.5*(sideAdjustment[1] - sideAdjustment[0]) + 0.5*(baseMod[1] - baseMod[0]), 
                            -0.5*(sideAdjustment[3] - sideAdjustment[2]) + 0.5*(baseMod[3] - baseMod[2]),
                            -0.5*(height-baseReliefCutHeight)-0.5*cutOffset
                        ]){
                            difference(){
                                cube(
                                    size = [cutMultiplier * objectSizeXAdjusted, cutMultiplier * objectSizeYAdjusted, baseReliefCutHeight + cutOffset], 
                                    center=true
                                );

                                reliefRadiusQuality = mb_fn_even_for_radius(
                                    reliefRadius, 
                                    1, 
                                    qualitySegBase,
                                    qualityFactor,
                                    qualityResolutionMin,
                                    qualityResolutionMax,
                                    qualityResolutionMultiplier,
                                    previewQuality
                                );

                                mb_prismoid(
                                    shape = [bevelReliefCut], 
                                    height = cutMultiplier * (baseReliefCutHeight + cutOffset), 
                                    radius = mb_xyz_rad_convert(reliefRadius == 0 ? 0 : [0, 0, reliefRadius]), 
                                    resolution = reliefRadiusQuality
                                );

                                /*
                                mb_beveled_rounded_block(
                                    bevel = beveled ? bevelReliefCut : false,
                                    sizeX = objectSizeMod[0] - 2*baseReliefCutThickness,
                                    sizeY = objectSizeMod[1] - 2*baseReliefCutThickness,
                                    height = cutMultiplier * (baseReliefCutHeight + cutOffset),
                                    roundingRadius = reliefRadius == 0 ? 0 : [0, 0, reliefRadius],
                                    roundingResolution = reliefRadiusQuality
                                );*/
                            }
                        }
                    }

                    /*
                    * Slope
                    */
                    if(slope != false && slope != [0, 0, 0, 0]){
                        for(side = [0 : 1 : 3]){
                            if(slope[side] != 0){
                                slopeSide0 = slopeSize(side);
                                slopeBaseHeight0 = slopeBaseHeight(side);
                                tx = ((side % 2 == 0) ? -0.5 : 0.5) * ((side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) - slopeSide0 + cutTolerance);
                                t = [side < 2 ? tx : 0, side < 2 ? 0 : tx, sign(slope[side]) * 0.5 * (slopeBaseHeight0 + cutTolerance)];
                                echo (t = t, s= sign(slope[0]));
                                translate(t)
                                    mb_slant_prism(side, slopeSide0, (side < 2 ? objectSizeYAdjusted : objectSizeXAdjusted) * cutMultiplier, height - slopeBaseHeight0 + cutTolerance, slope[side] < 0);
                            }
                        }
                    }
               } // End difference
                
            } // End translate

            /*
            * Pit
            */
            if(pit){
                pitSizeX = objectSizeMod[0] - (pitWallThickness[0] + pitWallThickness[1]);
                pitSizeY = objectSizeMod[1] - (pitWallThickness[2] + pitWallThickness[3]);
                echo(pitSizeX = pitSizeX, pitSizeY = pitSizeY);
                pitBevelInner = mb_inset_quad_lrfh(bevelMod, pitWallThickness);
                pMinThickness = [-min(pitWallThickness[2], pitWallThickness[0]), -min(pitWallThickness[0], pitWallThickness[3]), -min(pitWallThickness[3], pitWallThickness[1]), -min(pitWallThickness[1], pitWallThickness[2])];
                pitRadius = mb_base_cutout_radius(pitRoundingRadius == "auto" ? pMinThickness : mb_rounding_radius(pitRoundingRadius, gridSizeXY), baseRoundingRadiusZ, minObjectSide);

                pitRadiusQuality = mb_fn_even_for_radius(
                    pitRadius, 
                    1, 
                    qualitySegBase,
                    qualityFactor,
                    qualityResolutionMin,
                    qualityResolutionMax,
                    qualityResolutionMultiplier,
                    previewQuality
                );

                translate([0.5*(baseMod[1] - baseMod[0]), 0.5*(baseMod[3] - baseMod[2]), 0.5 * (objectSizeMod[2] - pitDepth + baseMod[5]+ cutOffset)]){
                    intersection(){
                        make_bevel(pitBevelInner, pitDepth + cutOffset);
                        translate([0.5 * (pitWallThickness[0] - pitWallThickness[1]), 0.5 * (pitWallThickness[2] - pitWallThickness[3]), 0])
                            mb_cube(size = [pitSizeX, pitSizeY, pitDepth + cutOffset], radius=pitRadius == 0 ? 0 : [0, 0, pitRadius], resolution=pitRadiusQuality, center = true);
                    }
                }

                //Pit Wall Gaps
                for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                    gap = mb_to_array(pitWallGaps[gapIndex]);
                    side = mb_side_to_int(gap[0]);
                    if(side < 2){
                        translate([sideX(side), -0.5 * (mb_undef_to(gap[2]) - mb_undef_to(gap[1])) * gridSizeXY, 0.5*(height - pitDepth + cutOffset)])
                            cube([2 * pitWallThickness[side] * cutMultiplier, pitSizeY - (mb_undef_to(gap[1]) + mb_undef_to(gap[2])) * gridSizeXY, pitDepth + cutOffset], center = true);
                    }  
                    else{
                        translate([-0.5 * (mb_undef_to(gap[2]) - mb_undef_to(gap[1])) * gridSizeXY, sideY(side - 2), 0.5*(height - pitDepth + cutOffset)])
                            cube([pitSizeX - (mb_undef_to(gap[1]) + mb_undef_to(gap[2])) * gridSizeXY , 2 * pitWallThickness[side] * cutMultiplier, pitDepth + cutOffset], center = true);     
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
                                padding = connectorPadding,
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
                            padding = connectorPadding,
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
                            padding = connectorPadding,
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
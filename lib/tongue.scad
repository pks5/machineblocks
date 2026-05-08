use <utils.scad>;
use <quad.scad>;
//use <polygon.scad>;
use <prismoid.scad>;
use <quality.scad>;

module mb_tongue(
    block_obj,
    
    gridSizeXY,
    objectSize,
    objectSizeAdjusted,
    baseRoundingRadiusZ,
    beveled,
    bevelOuter,
    tongueOffset,
    tongueThickness,
    tongueThicknessAdjustment,
    tongueHeight,
    tongueClampThickness,
    tongueClampHeight,
    tongueClampOffset,
    tongueRoundingRadius,
    tongueInnerRoundingRadius,
    pit,
    pitWallGaps,
    pitSizeX,
    pitSizeY,

    qualitySegBase,
    qualityFactor,
    qualityResolutionMin,
    qualityResolutionMax,
    qualityResolutionMultiplier,
    previewQuality,
){
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    minObjectSide = min(objectSizeAdjusted[0], objectSizeAdjusted[1]);

    tongueOffsetAdjusted = tongueOffset - 0.5 * tongueThicknessAdjustment;
    tongueThicknessAdjusted = tongueThickness + tongueThicknessAdjustment;
    tongueInnerOffsetAdjusted = tongueOffsetAdjusted + tongueThicknessAdjusted;

    tongueSizeX = objectSize[0] - 2 * tongueOffset + tongueThicknessAdjustment;
    tongueSizeY = objectSize[1] - 2 * tongueOffset + tongueThicknessAdjustment;

    tongueInnerSizeX = tongueSizeX - 2 * tongueThicknessAdjusted;
    tongueInnerSizeY = tongueSizeY - 2 * tongueThicknessAdjusted;

    tongueRadius = mb_base_cutout_radius(tongueRoundingRadius == "auto" ? -tongueOffset : mb_rounding_radius(tongueRoundingRadius, gridSizeXY), baseRoundingRadiusZ, minObjectSide);
    tongueRadiusInner = mb_base_cutout_radius(tongueInnerRoundingRadius == "auto" ? -tongueThickness : mb_rounding_radius(tongueInnerRoundingRadius, gridSizeXY), tongueRadius, minObjectSide);
    
    bevelTongueOuter = mb_inset_quad_lrfh(bevelOuter, tongueOffsetAdjusted);
    bevelTongueInner = mb_inset_quad_lrfh(bevelOuter, tongueInnerOffsetAdjusted);
    
    bevelTongueClampOuter = mb_inset_quad_lrfh(bevelOuter, tongueOffsetAdjusted - tongueClampThickness);
    bevelTongueClampInner = mb_inset_quad_lrfh(bevelOuter, tongueInnerOffsetAdjusted + tongueClampThickness);
    
    tongueRadiusQuality = mb_fn_even_for_radius(
                                    tongueRadius, 
                                    1, 
                                    qualitySegBase,
                                    qualityFactor,
                                    qualityResolutionMin,
                                    qualityResolutionMax,
                                    qualityResolutionMultiplier,
                                    previewQuality
                                );

    tongueRadiusInnerQuality = mb_fn_even_for_radius(
                                    tongueRadiusInner, 
                                    1, 
                                    qualitySegBase,
                                    qualityFactor,
                                    qualityResolutionMin,
                                    qualityResolutionMax,
                                    qualityResolutionMultiplier,
                                    previewQuality
                                );

    difference(){
        union(){
            difference(){
                mb_prismoid(
                    shape = [bevelTongueOuter], 
                    height = tongueHeight, 
                    radius = mb_xyz_rad_convert(tongueRadius == 0 ? 0 : [0, 0, tongueRadius]), 
                    resolution = tongueRadiusQuality
                );
                mb_prismoid(
                    shape = [bevelTongueInner], 
                    height = tongueHeight * cutMultiplier, 
                    radius = mb_xyz_rad_convert(tongueRadiusInner == 0 ? 0 : [0, 0, tongueRadiusInner]), 
                    resolution = tongueRadiusInnerQuality
                );

                /*
                mb_beveled_rounded_block(
                    bevel = beveled ? bevelTongueOuter : false,
                    sizeX = tongueSizeX,
                    sizeY = tongueSizeY,
                    height = tongueHeight,
                    roundingRadius = tongueRadius == 0 ? 0 : [0, 0, tongueRadius],
                    roundingResolution = tongueRadiusQuality
                );
                mb_beveled_rounded_block(
                    bevel = beveled ? bevelTongueInner : false,
                    sizeX = tongueInnerSizeX,
                    sizeY = tongueInnerSizeY,
                    height = tongueHeight * cutMultiplier,
                    roundingRadius = tongueRadiusInner == 0 ? 0 : [0, 0, tongueRadiusInner],
                    roundingResolution = tongueRadiusInnerQuality
                );*/

                /*
                * Cut knobGrooveGaps
                * TODO cutMultiplier is too small!
                */
                if(pit){
                    for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                        gap = mb_to_array(pitWallGaps[gapIndex]);
                        side = mb_side_to_int(gap[0]);
                        if(side < 2){
                            translate([(-0.5 + side) * (tongueSizeX - tongueThicknessAdjusted), -0.5 * (mb_undef_to(gap[2]) - mb_undef_to(gap[1])) * gridSizeXY, 0])
                                cube([
                                    tongueThicknessAdjusted * cutMultiplier,
                                    pitSizeY - (mb_undef_to(gap[1]) + mb_undef_to(gap[2])) * gridSizeXY + tongueInnerSizeY - pitSizeY, 
                                    tongueHeight * cutMultiplier
                                    ], center = true);
                        }  
                        else{
                            translate([-0.5 * (mb_undef_to(gap[2]) - mb_undef_to(gap[1])) * gridSizeXY, (-0.5 + side - 2) * (tongueSizeY - tongueThicknessAdjusted), 0])
                                cube([
                                    pitSizeX  - (mb_undef_to(gap[1]) + mb_undef_to(gap[2])) * gridSizeXY + tongueInnerSizeX - pitSizeX, 
                                    tongueThicknessAdjusted * cutMultiplier, 
                                    tongueHeight * cutMultiplier
                                    ], center = true);     
                        } 
                    }  
                }
            }
            

            //Tongue Clamp
            if(tongueClampThickness > 0){
                translate([0, 0, 0.5 * (tongueHeight - tongueClampHeight) - tongueClampOffset]){    
                    difference(){ 
                        mb_prismoid(
                            shape = [bevelTongueClampOuter], 
                            height = tongueClampHeight, 
                            radius = mb_xyz_rad_convert(tongueRadius == 0 ? 0 : [0, 0, tongueRadius]), 
                            resolution = tongueRadiusQuality
                        );
                        mb_prismoid(
                            shape = [bevelTongueClampInner], 
                            height = tongueClampHeight * cutMultiplier, 
                            radius = mb_xyz_rad_convert(tongueRadiusInner == 0 ? 0 : [0, 0, tongueRadiusInner]), 
                            resolution = tongueRadiusInnerQuality
                        );
                        
                        /*
                        mb_beveled_rounded_block(
                            bevel = beveled ? bevelTongueClampOuter : false,
                            sizeX = tongueSizeX + 2 * tongueClampThickness,
                            sizeY = tongueSizeY + 2 * tongueClampThickness,
                            height = tongueClampHeight,
                            roundingRadius = tongueRadius == 0 ? 0 : [0, 0, tongueRadius],
                            roundingResolution = tongueRadiusQuality
                        );
                        mb_beveled_rounded_block(
                            bevel = beveled ? bevelTongueClampInner : false,
                            sizeX = tongueInnerSizeX - 2 * tongueClampThickness,
                            sizeY = tongueInnerSizeY - 2 * tongueClampThickness,
                            height = tongueClampHeight * cutMultiplier,
                            roundingRadius = tongueRadiusInner == 0 ? 0 : [0, 0, tongueRadiusInner],
                            roundingResolution = tongueRadiusInnerQuality
                        );*/
                    
                        /*
                        * Cut knobGrooveGaps
                        * TODO why we cut here again, could be cut both in one step
                        */
                        if(pit){
                            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                gap = mb_to_array(pitWallGaps[gapIndex]);
                                side = mb_side_to_int(gap[0]);
                                if(side < 2){
                                    translate([(-0.5 + side) * (tongueSizeX - tongueThicknessAdjusted), -0.5 * (mb_undef_to(gap[2]) - mb_undef_to(gap[1])) * gridSizeXY, 0])
                                        cube(
                                            [
                                            (tongueThicknessAdjusted + 2 * tongueClampThickness) * cutMultiplier, 
                                            pitSizeY  - (mb_undef_to(gap[1]) + mb_undef_to(gap[2])) * gridSizeXY - 2 * tongueClampThickness + tongueInnerSizeY - pitSizeY, 
                                            tongueClampHeight * cutMultiplier
                                            ], center = true);
                                }  
                                else{
                                    translate([-0.5 * (mb_undef_to(gap[2]) - mb_undef_to(gap[1])) * gridSizeXY, (-0.5 + side - 2) * (tongueSizeY - tongueThicknessAdjusted), 0])
                                        cube([
                                            pitSizeX  - (mb_undef_to(gap[1]) + mb_undef_to(gap[2])) * gridSizeXY - 2*tongueClampThickness + tongueInnerSizeX - pitSizeX, 
                                            (tongueThicknessAdjusted + 2 * tongueClampThickness) * cutMultiplier, 
                                            tongueClampHeight * cutMultiplier
                                            ], center = true);     
                                } 
                            }  
                        }
                    }
                }
            }
        }

        
    }

}
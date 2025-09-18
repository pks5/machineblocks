use <utils.scad>;
use <quad.scad>;
use <polygon.scad>;
use <shapes.scad>;

module mb_tongue(
    gridSizeXY,
    objectSize,
    objectSizeAdjusted,
    baseRoundingRadius,
    baseRoundingResolution,
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

    baseRoundingRadiusZ = mb_base_rounding_radius_z(radius = baseRoundingRadius);

    tongueRadius = mb_base_cutout_radius(tongueRoundingRadius == "auto" ? -tongueOffset : tongueRoundingRadius, baseRoundingRadiusZ, minObjectSide);
    tongueRadiusInner = mb_base_cutout_radius(tongueInnerRoundingRadius == "auto" ? -tongueThickness : tongueInnerRoundingRadius, tongueRadius, minObjectSide);
    
    bevelTongueOuter = mb_inset_quad_lrfh(bevelOuter, tongueOffsetAdjusted);
    bevelTongueInner = mb_inset_quad_lrfh(bevelOuter, tongueInnerOffsetAdjusted);
    
    bevelTongueClampOuter = mb_inset_quad_lrfh(bevelOuter, tongueOffsetAdjusted - tongueClampThickness);
    bevelTongueClampInner = mb_inset_quad_lrfh(bevelOuter, tongueInnerOffsetAdjusted + tongueClampThickness);
    

    difference(){
        union(){
            difference(){
                mb_beveled_rounded_block(
                    bevel = beveled ? bevelTongueOuter : false,
                    sizeX = tongueSizeX,
                    sizeY = tongueSizeY,
                    height = tongueHeight,
                    roundingRadius = tongueRadius == 0 ? 0 : [0, 0, tongueRadius],
                    roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution
                );
                mb_beveled_rounded_block(
                    bevel = beveled ? bevelTongueInner : false,
                    sizeX = tongueInnerSizeX,
                    sizeY = tongueInnerSizeY,
                    height = tongueHeight * cutMultiplier,
                    roundingRadius = tongueRadiusInner == 0 ? 0 : [0, 0, tongueRadiusInner],
                    roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution
                );
                /*
                intersection(){
                    make_bevel(bevelTongueOuter, tongueHeight);
                    mb_rounded_block(
                        size=[tongueSizeX, tongueSizeY, tongueHeight], 
                        center = true, 
                        radius=[0, 0, tongueRadius], 
                        resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                    );
                }
                intersection(){
                    make_bevel(bevelTongueInner, tongueHeight * cutMultiplier);
                    mb_rounded_block(
                        size = [tongueInnerSizeX, tongueInnerSizeY, tongueHeight * cutMultiplier], 
                        center=true,
                        radius=[0,0,tongueRadiusInner], 
                        resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                    );
                }*/

                /*
                * Cut knobGrooveGaps
                * TODO cutMultiplier is too small!
                */
                if(pit){
                    for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                        gap = pitWallGaps[gapIndex];
                        if(gap[0] < 2){
                            translate([(-0.5 + gap[0]) * (tongueSizeX - tongueThicknessAdjusted), -0.5 * (gap[2] - gap[1]) * gridSizeXY, 0])
                                cube([
                                    tongueThicknessAdjusted * cutMultiplier,
                                    pitSizeY - (gap[1] + gap[2]) * gridSizeXY + tongueInnerSizeY - pitSizeY, 
                                    tongueHeight * cutMultiplier
                                    ], center = true);
                        }  
                        else{
                            translate([-0.5 * (gap[2] - gap[1]) * gridSizeXY, (-0.5 + gap[0] - 2) * (tongueSizeY - tongueThicknessAdjusted), 0])
                                cube([
                                    pitSizeX  - (gap[1] + gap[2]) * gridSizeXY + tongueInnerSizeX - pitSizeX, 
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
                        mb_beveled_rounded_block(
                            bevel = beveled ? bevelTongueClampOuter : false,
                            sizeX = tongueSizeX + 2 * tongueClampThickness,
                            sizeY = tongueSizeY + 2 * tongueClampThickness,
                            height = tongueClampHeight,
                            roundingRadius = tongueRadius == 0 ? 0 : [0, 0, tongueRadius],
                            roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution
                        );
                        mb_beveled_rounded_block(
                            bevel = beveled ? bevelTongueClampInner : false,
                            sizeX = tongueInnerSizeX - 2 * tongueClampThickness,
                            sizeY = tongueInnerSizeY - 2 * tongueClampThickness,
                            height = tongueClampHeight * cutMultiplier,
                            roundingRadius = tongueRadiusInner == 0 ? 0 : [0, 0, tongueRadiusInner],
                            roundingResolution = ($preview ? previewQuality : 1) * baseRoundingResolution
                        );
                        /*      
                        intersection(){
                            make_bevel(bevelTongueClampOuter, tongueClampHeight);
                            mb_rounded_block(
                                size=[tongueSizeX + 2 * tongueClampThickness, tongueSizeY + 2 * tongueClampThickness, tongueClampHeight], 
                                center = true, 
                                radius=[0, 0, tongueRadius], 
                                resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                            );
                        }
                        intersection(){
                            make_bevel(bevelTongueClampInner, tongueClampHeight*cutMultiplier);
                            mb_rounded_block(
                                size = [tongueInnerSizeX - 2 * tongueClampThickness, tongueInnerSizeY - 2 * tongueClampThickness, tongueClampHeight * cutMultiplier], 
                                center=true, 
                                radius=[0,0,tongueRadiusInner], 
                                resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                            );
                        }*/
                    
                        /*
                        * Cut knobGrooveGaps
                        * TODO why we cut here again, could be cut both in one step
                        */
                        if(pit){
                            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                gap = pitWallGaps[gapIndex];
                                if(gap[0] < 2){
                                    translate([(-0.5 + gap[0]) * (tongueSizeX - tongueThicknessAdjusted), -0.5 * (gap[2] - gap[1]) * gridSizeXY, 0])
                                        cube(
                                            [
                                            (tongueThicknessAdjusted + 2 * tongueClampThickness) * cutMultiplier, 
                                            pitSizeY  - (gap[1] + gap[2]) * gridSizeXY - 2 * tongueClampThickness + tongueInnerSizeY - pitSizeY, 
                                            tongueClampHeight * cutMultiplier
                                            ], center = true);
                                }  
                                else{
                                    translate([-0.5 * (gap[2] - gap[1]) * gridSizeXY, (-0.5 + gap[0] - 2) * (tongueSizeY - tongueThicknessAdjusted), 0])
                                        cube([
                                            pitSizeX  - (gap[1] + gap[2]) * gridSizeXY - 2*tongueClampThickness + tongueInnerSizeX - pitSizeX, 
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
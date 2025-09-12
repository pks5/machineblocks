use <utils.scad>;
use <quad.scad>;
use <polygon.scad>;
use <shapes.scad>;

module mb_tongue(
    gridSizeXY,
    objectSize,
    baseRoundingRadius,
    baseRoundingResolution,
    bevelOuter,
    tongueOffset,
    tongueThickness,
    tongueHeight,
    tongueClampThickness,
    tongueClampHeight,
    tongueClampOffset,
    tongueOuterAdjustment,
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

    knobRectX = objectSize[0] - 2*tongueOffset;
    knobRectY = objectSize[1] - 2*tongueOffset;

    baseRoundingRadiusZ = mb_base_rounding_radius_z(radius = baseRoundingRadius);

    tongueRadius = mb_base_cutout_radius(tongueRoundingRadius == "auto" ? -tongueOffset : tongueRoundingRadius, baseRoundingRadiusZ);
    tongueRadiusInner = mb_base_cutout_radius(tongueInnerRoundingRadius == "auto" ? -tongueThickness : tongueInnerRoundingRadius, tongueRadius);
    bevelTongueOuter = mb_inset_quad_lrfh(bevelOuter, [tongueOffset - tongueOuterAdjustment, tongueOffset - tongueOuterAdjustment, tongueOffset - tongueOuterAdjustment, tongueOffset - tongueOuterAdjustment]);
    bevelTongueInner = mb_inset_quad_lrfh(bevelOuter, [tongueOffset + tongueThickness, tongueOffset + tongueThickness, tongueOffset + tongueThickness, tongueOffset + tongueThickness]);
    bevelTongueClampOuter = mb_inset_quad_lrfh(bevelOuter, [tongueOffset - tongueOuterAdjustment - tongueClampThickness, tongueOffset - tongueOuterAdjustment-tongueClampThickness, tongueOffset - tongueOuterAdjustment-tongueClampThickness, tongueOffset - tongueOuterAdjustment-tongueClampThickness]);
    bevelTongueClampInner = mb_inset_quad_lrfh(bevelOuter, [tongueOffset + tongueThickness + tongueClampThickness, tongueOffset + tongueThickness + tongueClampThickness, tongueOffset + tongueThickness + tongueClampThickness, tongueOffset + tongueThickness + tongueClampThickness]);
    

    difference(){
        union(){
            difference(){
                intersection(){
                    make_bevel(bevelTongueOuter, tongueHeight);
                    mb_rounded_block(
                        size=[knobRectX + 2 * tongueOuterAdjustment, knobRectY + 2 * tongueOuterAdjustment, tongueHeight], 
                        center = true, 
                        radius=[0,0,tongueRadius], 
                        resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                    );
                }
                intersection(){
                    make_bevel(bevelTongueInner, tongueHeight * cutMultiplier);
                    mb_rounded_block(
                        size = [knobRectX - 2*tongueThickness, knobRectY - 2*tongueThickness, tongueHeight * cutMultiplier], 
                        center=true,
                        radius=[0,0,tongueRadiusInner], 
                        resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                    );
                }

                /*
                * Cut knobGrooveGaps
                * TODO cutMultiplier is too small!
                */
                if(pit){
                    for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                        gap = pitWallGaps[gapIndex];
                        if(gap[0] < 2){
                            translate([(-0.5 + gap[0]) * (knobRectX + 2 * tongueOuterAdjustment - tongueThickness), -0.5 * (gap[2] - gap[1]) * gridSizeXY, 0])
                                cube([(tongueThickness + tongueOuterAdjustment)*cutMultiplier, pitSizeY  - (gap[1] + gap[2]) * gridSizeXY, tongueHeight * cutMultiplier], center = true);
                        }  
                        else{
                            translate([-0.5 * (gap[2] - gap[1]) * gridSizeXY, (-0.5 + gap[0] - 2) * (knobRectY + 2 * tongueOuterAdjustment - tongueThickness), 0])
                                cube([pitSizeX  - (gap[1] + gap[2]) * gridSizeXY , (tongueThickness + tongueOuterAdjustment)*cutMultiplier, tongueHeight * cutMultiplier], center = true);     
                        } 
                    }  
                }
            }
            

            //Tongue Clamp
            if(tongueClampThickness > 0){
                translate([0, 0, 0.5 * (tongueHeight - tongueClampHeight) - tongueClampOffset]){    
                    difference(){       
                        intersection(){
                            make_bevel(bevelTongueClampOuter, tongueClampHeight);
                            mb_rounded_block(
                                size=[knobRectX + 2 * tongueOuterAdjustment + 2*tongueClampThickness, knobRectY + 2 * tongueOuterAdjustment + 2*tongueClampThickness, tongueClampHeight], 
                                center = true, 
                                radius=[0,0,tongueRadius], 
                                resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                            );
                        }
                        intersection(){
                            make_bevel(bevelTongueClampInner, tongueClampHeight*cutMultiplier);
                            mb_rounded_block(
                                size = [knobRectX - 2*tongueThickness - 2*tongueClampThickness, knobRectY - 2*tongueThickness - 2*tongueClampThickness, tongueClampHeight*cutMultiplier], 
                                center=true, 
                                radius=[0,0,tongueRadiusInner], 
                                resolution=($preview ? previewQuality : 1) * baseRoundingResolution
                            );
                        }
                    
                        /*
                        * Cut knobGrooveGaps
                        * TODO why we cut here again, could be cut both in one step
                        */
                        if(pit){
                            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                                gap = pitWallGaps[gapIndex];
                                if(gap[0] < 2){
                                    translate([(-0.5 + gap[0]) * (knobRectX + 2 * tongueOuterAdjustment - tongueThickness), -0.5 * (gap[2] - gap[1]) * gridSizeXY, 0])
                                        cube([(tongueThickness + tongueOuterAdjustment + 2*tongueClampThickness)*cutMultiplier, pitSizeY  - (gap[1] + gap[2]) * gridSizeXY - 2*tongueClampThickness, tongueClampHeight*cutMultiplier], center = true);
                                }  
                                else{
                                    translate([-0.5 * (gap[2] - gap[1]) * gridSizeXY, (-0.5 + gap[0] - 2) * (knobRectY + 2 * tongueOuterAdjustment - tongueThickness), 0])
                                        cube([pitSizeX  - (gap[1] + gap[2]) * gridSizeXY - 2*tongueClampThickness , (tongueThickness + tongueOuterAdjustment + 2*tongueClampThickness)*cutMultiplier, tongueClampHeight*cutMultiplier], center = true);     
                                } 
                            }  
                        }
                    }
                }
            }
        }

        
    }

}
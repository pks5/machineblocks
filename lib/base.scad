use <prismoid.scad>;
use <connectors.scad>;
use <utils.scad>;
use <quad.scad>;
use <quality.scad>;

/*
* Base Cutout
*/
module mb_base_cutout(
    block_obj,
    debug
){
    difference(){
        //Base Cutout
        mb_block_part(block_obj, part="base_cutout", debug = debug);
        
        //Base Clamp Inner
        difference(){
            mb_block_part(block_obj, part="base_cutout_clamp_mask", debug = debug);
            mb_block_part(block_obj, part="base_cutout_clamp_cut", debug = debug);
        }

        //Top Plate Helpers
        if(mb_block_get_top_plate_helpers(block_obj)){ 
            difference(){
                mb_block_part(block_obj, part="top_plate_helpers_mask", debug = debug);
                mb_block_part(block_obj, part="top_plate_helpers_cut", debug = debug);
            }
        }    
    }
}

/*
* Base Block
*/
module mb_base(
    block_obj,

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
    
    bevelBaseClampOuter = mb_inset_quad_lrfh(bevelOuterAdjusted, -baseClampThicknessOuter);
    baseClampOuterRoundingRadius = mb_base_rel_radius(baseClampThicknessOuter, baseRoundingRadiusZ, minObjectSide, true);

    //TODO create functions in utils and remove this functions here
    function sideX(side) = 0.5 * (sideAdjustment[1] - sideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sideAdjustment[3] - sideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;


    union(){
        
        difference(){
            
            union(){
                mb_block_part(block_obj, part="base_adjusted", debug = debug);
                
                if(baseClampThicknessOuter > 0){ //TODO
                    mb_block_part(block_obj, part="base_clamp_outer", debug = debug);
                }

            }

            if(baseReliefCut){
                difference(){
                    mb_block_part(block_obj, part="relief_cut_mask", debug = debug);
                    mb_block_part(block_obj, part="relief_cut", debug = debug);
                }
            }

                
              

            /*
            * Pit
            */
            if(mb_block_get_recess(block_obj)){
                mb_block_part(block_obj, part="recess", debug = debug);
                mb_block_part(block_obj, part="recess_wall_gaps", debug = debug);


                /*
                //Pit Wall Gaps
                pitSizeX = objectSizeMod[0] - (pitWallThickness[0] + pitWallThickness[1]);
                pitSizeY = objectSizeMod[1] - (pitWallThickness[2] + pitWallThickness[3]);
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
                }*/
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
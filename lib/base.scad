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
    base_cutout = mb_block_to_prismoid(block_obj, mode="base_cutout", mul=[8, 8, 3.2]);
    base_cutout_clamp_mask = mb_block_to_prismoid(block_obj, mode="base_cutout_clamp_mask", mul=[8, 8, 3.2]);
    base_cutout_clamp_mask_inner = mb_block_to_prismoid(block_obj, mode="base_cutout_clamp_mask_inner", mul=[8, 8, 3.2]);
    top_plate_helpers_mask = mb_block_to_prismoid(block_obj, mode="top_plate_helpers_mask", mul=[8, 8, 3.2]);
    top_plate_helpers_cut = mb_block_to_prismoid(block_obj, mode="top_plate_helpers_cut", mul=[8, 8, 3.2]);
    

    difference(){
        mb_prismoid(shape = base_cutout, skip_resolve = true, debug = debug);
        
        difference(){
            mb_prismoid(shape = base_cutout_clamp_mask, skip_resolve = true, debug = debug);
            mb_prismoid(shape = base_cutout_clamp_mask_inner, skip_resolve = true, debug = debug);
        }

        if(true){ //Top Plate Helpers
            difference(){
                mb_prismoid(shape = top_plate_helpers_mask, skip_resolve = true, debug = debug);
                mb_prismoid(shape = top_plate_helpers_cut, skip_resolve = true, debug = debug);
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
    
    reliefRadius = mb_base_cutout_radius(-baseReliefCutThickness, baseRoundingRadiusZ, minObjectSide);
    bevelReliefCut = mb_inset_quad_lrfh(bevelOuter, baseReliefCutThickness);

    bevelBaseClampOuter = mb_inset_quad_lrfh(bevelOuterAdjusted, -baseClampThicknessOuter);
    baseClampOuterRoundingRadius = mb_base_rel_radius(baseClampThicknessOuter, baseRoundingRadiusZ, minObjectSide, true);

    //TODO create functions in utils and remove this functions here
    function sideX(side) = 0.5 * (sideAdjustment[1] - sideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sideAdjustment[3] - sideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;

    base_adjusted = mb_block_to_prismoid(block_obj, mode="base_adjusted", mul=[8, 8, 3.2]);
    base_recess = mb_block_to_prismoid(block_obj, mode="recess", mul=[8, 8, 3.2]);
    relief_cut_mask = mb_block_to_prismoid(block_obj, mode="relief_cut_mask", mul=[8, 8, 3.2]);
    relief_cut = mb_block_to_prismoid(block_obj, mode="relief_cut", mul=[8, 8, 3.2]);
    base_clamp_outer = mb_block_to_prismoid(block_obj, mode="base_clamp_outer", mul=[8, 8, 3.2]);

echo(block_obj = block_obj);
    union(){
        
        difference(){
            
            union(){
                mb_prismoid(shape = base_adjusted, skip_resolve = true, debug = false);

                if(baseClampThicknessOuter > 0){ //TODO
                    mb_prismoid(shape = base_clamp_outer, skip_resolve = true, debug = debug);
                }
            }

            if(baseReliefCut){
                difference(){
                    mb_prismoid(shape = relief_cut_mask, skip_resolve = true, debug = debug);
                    mb_prismoid(shape = relief_cut, skip_resolve = true, debug = debug);
                }
            }

                
              

            /*
            * Pit
            */
            if(pit){
                pitSizeX = objectSizeMod[0] - (pitWallThickness[0] + pitWallThickness[1]);
                pitSizeY = objectSizeMod[1] - (pitWallThickness[2] + pitWallThickness[3]);
                
                mb_prismoid(shape = base_recess, skip_resolve = true, debug = debug);

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
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
    union(){
        
        difference(){
            
            union(){
                mb_block_part(block_obj, part="base_adjusted", debug = debug);
                
                if(mb_block_get_inverted(block_obj)){
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
            * Recess
            */
            if(mb_block_get_recess(block_obj)){
                mb_block_part(block_obj, part="recess", debug = debug);
                mb_block_part(block_obj, part="recess_wall_gaps", debug = debug);
            } // End Recess

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
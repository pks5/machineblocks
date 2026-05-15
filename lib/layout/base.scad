use <../core/block_model.scad>;
use <../core/block_part.scad>;
use <layout.scad>;
use <../shape/prismoid.scad>;
use <../shape/connectors.scad>;
use <../core/utils.scad>;
use <../quad.scad>;
use <../core/quality.scad>;

/*
* Base Cutout
*/
module mb_base_cutout(
    block_obj,
    debug
){
    union(){
        difference(){
            //Base Cutout
            mb_block_part(block_obj, part = mb_block_part__base_cutout(block_obj), debug = debug);

            //Base Clamp Inner
            mb_block_part(block_obj, part = mb_block_part__base_cutout_clamp(block_obj), debug = debug);

            //Top Plate Helpers
            if(mb_block_get_top_plate_helpers(block_obj)){ 
                mb_block_part(block_obj, part = mb_block_part__top_plate_helpers(block_obj), debug = debug);
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
                mb_block_part(block_obj, part = mb_block_part__base_adjusted(block_obj), debug = debug);
                
                if(mb_block_get_inverted(block_obj)){
                    mb_block_part(block_obj, part = mb_block_part__base_clamp_outer(block_obj), debug = debug);
                }

                mb_block_part(block_obj, part = mb_block_part__tube(block_obj));

                //Just for testing TO BE REMOVED
                *mb_block_part(block_obj, part=[
                    "my_cube",
                    [
                        [
                            "cube",
                            [10, 10, 10],
                        ],
                        [
                            "list",
                            [
                                [
                                    "my_cube",
                                    [
                                        
                                        [
                                            "cube",
                                            [34, 34, 44]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                    
                ], debug = debug);

            }

            /*
            * Relief Cut
            */
            if(mb_block_get_relief_cut(block_obj)){
                mb_block_part(block_obj, part = mb_block_part__relief_cut(block_obj), debug = debug);
            }

            /*
            * Recess
            */
            if(mb_block_get_recess(block_obj)){
                mb_block_part(block_obj, part = mb_block_part__recess(block_obj), debug = debug);
            }


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
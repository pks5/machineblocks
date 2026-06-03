use <../core/block_dim.scad>;
use <../core/block_model.scad>;
use <../core/block_part.scad>;
use <../core/utils.scad>;
use <../core/quality.scad>;

use <../shape/connectors.scad>;

use <base_outer.scad>;
use <base_outer_clamp.scad>;

use <standard_cutout.scad>;

use <recess.scad>;
use <relief_cut.scad>;

use <studs.scad>;
use <tongue.scad>;

use <surface_pattern.scad>;
use <grille.scad>;

use <svg_decorator.scad>;
use <text_decorator.scad>;

use <pcb_holder.scad>;
use <screw_holes.scad>;

/*
* Base Cutout
*/
module mb_base_cutout(
    block_obj,
    debug
){
    
    
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

    blockId,
    debug
){
    union(){
        
        difference(){
            
            union(){
                /*
                * Base Outer
                */
                mb_block_part(block_obj, part = mb_block_part__base_outer(block_obj, adjusted = true), debug = true);
                
                /*
                * Base Clamp Outer
                */
                mb_block_part(block_obj, part = mb_block_part__base_clamp_outer(block_obj), debug = debug);
                
                /*
                * Surface Pattern
                */
                mb_block_part(block_obj, part = mb_block_part__surface_pattern(block_obj), debug = debug);

                
                //Just for testing TO BE REMOVED
                *mb_block_part(
                    block_obj, 
                    part= mb_block_part_custom(
                        type = "my_cube", 
                        items = [
                            [
                                [10, 40, 40],
                            ],
                            mb_block_part_model(
                                type = "list",
                                items = [
                                    mb_block_part_custom(
                                        type = "my_cube", 
                                        data = [
                                            [34, 14, 44]
                                        ]
                                    )
                                ]
                            )
                        ]
                    ), 
                    debug = debug
                );

            }

            /*
            * Standard Cutout
            */
            mb_block_part(block_obj, part = mb_block_part__standard_cutout(block_obj));

            /*
            * Grille
            */
            mb_block_part(block_obj, part = mb_block_part__grille(block_obj), debug = debug);

            /*
            * Relief Cut
            */
            mb_block_part(block_obj, part = mb_block_part__relief_cut(block_obj), debug = debug);
            
            /*
            * Recess
            */
            mb_block_part(block_obj, part = mb_block_part__recess(block_obj), debug = debug);
            
            /*
            * Groove
            */
            mb_block_part(block_obj, part = mb_block_part__tongue(block_obj, groove = true), debug = debug);

            /*
            * SVG Decorator
            */
            mb_block_part(block_obj, part = mb_block_part__svg_decorator(block_obj, subtract = true), debug = debug);
                
            /*
            * Text Decorator
            */
            mb_block_part(block_obj, part = mb_block_part__text_decorator(block_obj, subtract = true), debug = debug);

            /*
            * Screw Holes
            */
            mb_block_part(block_obj, part = mb_block_part__screw_holes(block_obj), debug = debug);

            /*
            * Connectors
            */
            if(connectors != false){
                for (con = [ 0 : 1 : len(connectors)-1 ]){
                    if(connectors[con][1] == 1){
                        mb_connectors(
                            block_obj = block_obj,
                            side = connectors[con][0],
                            grid = grid,
                            padding = connectorPadding,
                            height = (connectorHeight == "auto" ? height : connectorHeight) + connectorDepthTolerance,
                            baseHeight = height,
                            inverse=true,
                            size = connectorSize,
                            depth = connectorDepth,
                            gs = gridSizeXY
                        );
                    }
                    else if(connectors[con][1] > 1){
                        mb_connector_grooves(
                            block_obj = block_obj,
                            side = connectors[con][0],
                            grid = grid,
                            padding = connectorPadding,
                            depth = (connectorHeight == "auto" ? height : connectorHeight) + connectorDepthTolerance,
                            baseHeight = height,
                            inverse=connectors[con][1]==3,
                            size = connectorSize,
                            height = connectorDepth,
                            gs = gridSizeXY
                        );
                    }
                }
            }

            
        } // End difference

        /*
        * Studs
        */
        mb_block_part(block_obj, part = mb_block_part__studs(block_obj), debug = debug);

        /*
        * Tongue
        */
        mb_block_part(block_obj, part = mb_block_part__tongue(block_obj), debug = debug);

        /*
        * SVG Decorator
        */
        mb_block_part(block_obj, part = mb_block_part__svg_decorator(block_obj), debug = debug);

        /*
        * Text Decorator
        */
        mb_block_part(block_obj, part = mb_block_part__text_decorator(block_obj), debug = debug);

        /*
        * PCB
        */
        mb_block_part(block_obj, part = mb_block_part__pcb_holder(block_obj), debug = debug);

        

        /*
        * Connectors
        */
        if(connectors != false){
            for (con = [ 0 : 1 : len(connectors)-1 ]){
                if(connectors[con][1] == 0){
                    mb_connectors(
                        block_obj = block_obj,
                        side = connectors[con][0],
                        grid = grid,
                        padding = connectorPadding,
                        height = (connectorHeight == "auto" ? height : connectorHeight),
                        baseHeight = height,
                        inverse=false,  //connectors[con][1]==1,
                        size = connectorSize - 2*connectorSideTolerance,
                        depth = connectorDepth - connectorSideTolerance,
                        gs = gridSizeXY
                    );
                }
            }
        }
    } // End union
} // End mb_base
use <../core/block_dim.scad>;
use <../core/block_model.scad>;
use <../core/block_part.scad>;
use <../core/utils.scad>;
use <../core/quality.scad>;

use <base_outer.scad>;
use <base_outer_clamp.scad>;

use <standard_cutout.scad>;

use <recess.scad>;
use <relief_cut.scad>;

use <studs_new.scad>;
use <tongue.scad>;

use <surface_pattern.scad>;
use <grille.scad>;

use <svg_decorator.scad>;
use <text_decorator.scad>;

use <pcb_holder.scad>;
use <screw_holes.scad>;

use <tubes.scad>;

use <connectors.scad>;

function mb_block_part__base(block_obj) =
    mb_block_part_model(
        type = "list",
        name = "base",
        items = [
            mb_block_part_model(
                type = "difference",
                items = [
                    mb_block_part_model(
                        type = "union",
                        items = [
                            /*
                            * Base Outer
                            */
                            mb_block_part__base_outer(block_obj, adjusted = true),

                            /*
                            * Base Clamp Outer
                            */
                            mb_block_part__base_clamp_outer(block_obj),

                            /*
                            * Surface Pattern
                            */
                            mb_block_part__surface_pattern(block_obj),

                            /*
                            * Custom Test
                            */
                            mb_block_part_custom(
                                render = false,
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
                            )
                        ]
                    ),

                    /*
                    * Standard Cutout
                    */
                    mb_block_part__standard_cutout(block_obj),

                    /*
                    * Grille
                    */
                    mb_block_part__grille(block_obj),

                    /*
                    * Relief Cut
                    */
                    mb_block_part__relief_cut(block_obj),

                    /*
                    * Recess
                    */
                    mb_block_part__recess(block_obj),

                    /*
                    * Groove
                    */
                    mb_block_part__tongue(block_obj, groove = true),

                    /*
                    * SVG Decorator
                    */
                    mb_block_part__svg_decorator(block_obj, subtract = true),

                    /*
                    * Text Decorator
                    */
                    mb_block_part__text_decorator(block_obj, subtract = true),

                    /*
                    * Screw Holes
                    */
                    mb_block_part__screw_holes(block_obj),

                    /*
                    * Tube Holes
                    */
                    mb_block_part__tubes(block_obj, hole = true),

                    /*
                    * Connectors
                    */
                    mb_block_part__connectors(block_obj, subtract = true),


                ],
                render = mb_block_has_base(block_obj)
            ),

            /*
            * Studs
            */
            mb_block_part__studs(block_obj),

            /*
            * Tongue
            */
            mb_block_part__tongue(block_obj),

            /*
            * SVG Decorator
            */
            mb_block_part__svg_decorator(block_obj),

            /*
            * Text Decorator
            */
            mb_block_part__text_decorator(block_obj),

            /*
            * PCB
            */
            mb_block_part__pcb_holder(block_obj),

            /*
            * Connectors
            */
            mb_block_part__connectors(block_obj)
        ]
    );


use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

use <base_cutout.scad>;
use <base_cutout_clamp.scad>;

use <top_plate_helpers.scad>;
use <stabilizers.scad>;
use <pillars.scad>;
use <tubes.scad>;
use <stud_cutouts.scad>;

function mb_block_part__standard_cutout(block_obj) =
    let(
        has_standard_cutout = mb_block_has_standard_cutout(block_obj)
    )
    mb_block_part_model(
        render = has_standard_cutout,
        type = "difference",
        items = [
            mb_block_part_model(
                type = "union",
                items = [
                    mb_block_part_model(
                        type = "difference",
                        items = [
                            mb_block_part__base_cutout(block_obj),
                            mb_block_part__base_cutout_clamp(block_obj),
                            mb_block_part__top_plate_helpers(block_obj),
                            mb_block_part__stabilizers(block_obj)
                        ]
                    ),

                    mb_block_part__stud_cutouts(block_obj)
                ]
            ),

            mb_block_part__pillars(block_obj),

            mb_block_part__tubes(block_obj)
        ]
    );
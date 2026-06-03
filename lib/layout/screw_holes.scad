use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

function mb_block_part__screw_holes(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj)
    )
    mb_block_part_model(
        type = "list",
        items = [
            
        ]
    );
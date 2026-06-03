use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <shared.scad>;

function mb_block_part__screw_holes(block_obj) =
    let(
        block_dim = mb_block_get_dim(block_obj),
        screw_holes = mb_block_get_screw_holes(block_obj),
        screw_hole_diameter = mb_block_get_screw_hole_diameter(block_obj),
        screw_hole_depth = mb_block_get_screw_hole_depth(block_obj),
        screw_hole_inset_thickness = mb_block_get_screw_hole_inset_thickness(block_obj),
        screw_hole_inset_depth = mb_block_get_screw_hole_inset_depth(block_obj)
    )
    mb_block_part_model(
        type = "list",
        items = [
            for(screw_hole = screw_holes)
                let(
                    axis = mb_face_to_axis(screw_hole[0])
                )
                mb_block_part_tube(
                    block_dim = block_dim,
                    radius = screw_hole_diameter,
                    axis = axis,
                    expand = [
                        0,
                        base_cutout_ceiling_offset_with_cut
                    ],
                    offset = mb_block_screw_hole_offset(block_obj, x, y, z)
                )
        ]
    );
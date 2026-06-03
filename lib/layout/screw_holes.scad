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
    screw_holes == false || screw_holes == "none" ? undef :
    mb_block_part_model(
        type = "list",
        items = [
            for(screw_hole = screw_holes)
                let(
                    face = mb_face_to_int(screw_hole[0]),
                    axis = mb_face_to_axis(face),
                    face_start = mb_face_has_common(face, "x-") 
                        || mb_face_has_common(face, "y-") 
                        || mb_face_has_common(face, "z-"),
                    tube_clamp = screw_hole_inset_thickness[0] > 0 && screw_hole_inset_depth[axis] > 0 ? [
                        screw_hole_inset_thickness[0],
                        screw_hole_inset_depth[axis] + mb_block_dim_overlap(block_dim, overlap = true),
                        0
                    ] : undef
                )
                mb_block_part_tube(
                    block_dim = block_dim,
                    radius = screw_hole_diameter[0],
                    axis = axis,
                    clamp_start = face_start ? tube_clamp : undef,
                    clamp_end = face_start ? undef : tube_clamp,
                    expand = face_start
                        ?  [
                            mb_block_dim_face_edge_expand(
                            block_dim, 
                            adjusted = true, 
                            face = face
                        ),
                        mb_block_dim_face_edge_expand(
                            block_dim, 
                            adjusted = true, 
                            exp = screw_hole_depth[axis], 
                            opposite = true,
                            face = mb_face_opposite(face)
                        ),
                        
                    ] : [
                        mb_block_dim_face_edge_expand(
                            block_dim, 
                            adjusted = true, 
                            exp = screw_hole_depth[axis], 
                            opposite = true,
                            face = mb_face_opposite(face)
                        ),
                        mb_block_dim_face_edge_expand(
                            block_dim, 
                            adjusted = true, 
                            face = face
                        ),
                    ],
                    offset = mb_block_screw_hole_offset(block_obj, axis, screw_hole[1])
                )
        ]
    );
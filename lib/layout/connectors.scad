use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <../core/utils.scad>;
function mb_block_part__connectors(block_obj, subtract = false) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        connectors = mb_block_get_connectors(block_obj)
    )
    !is_list(connectors) ? undef :
    mb_block_part_model(
        type = "list",
        items = [
            for(connector = connectors)
                let(
                    connector_face = mb_block_connector_face(block_obj, connector, subtract),
                    axis_faces = mb_axis_faces(mb_face_to_axis(connector_face)),
                    connector_range = mb_block_connector_range(block_obj, connector),
                    connector_tilt = mb_block_connector_tilt(block_obj, connector),
                    connector_length = mb_block_get_connector_length(block_obj, connector_tilt, subtract),
                    connector_expand = connector_length == "auto" 
                        ? [
                            mb_block_dim_face_edge_expand(
                                block_dim, 
                                face = connector_tilt == 0 ? "z-" : axis_faces[0], 
                                adjusted = true, 
                                overlap = true
                            ), 
                            mb_block_dim_face_edge_expand(
                                block_dim, 
                                face = connector_tilt == 0 ? "z+" : axis_faces[1], 
                                adjusted = true, 
                                overlap = true
                            ),
                        ] 
                        : [0, "auto"]
                )
                if(mb_block_connector_render(block_obj, connector, subtract))
                    for(xy = connector_range)
                        mb_block_part_wedge(
                            block_dim,
                            mb_block_get_connector_width(block_obj, connector_tilt, subtract),
                            mb_block_get_connector_depth(block_obj, connector_tilt, subtract),
                            connector_length == "auto" ? undef : connector_length,
                            face = connector_face,
                            tilt = connector_tilt,
                            expand = connector_expand,
                            offset = mb_block_connector_offset(block_obj, connector, xy, subtract)
                        )
        ]
    );
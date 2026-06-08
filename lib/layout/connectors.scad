use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <../core/utils.scad>;
function mb_block_part__connectors(block_obj, female = false) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        connectors = mb_block_connectors(block_obj),
        connector_length = mb_block_connector_length(block_obj, female = female),
        connector_depth = mb_block_connector_depth(block_obj, female = female),
        connector_width = mb_block_connector_width(block_obj, female = female)
    )
    !is_list(connectors) ? undef :
    mb_block_part_model(
        type = "list",
        items = [
            for(connector = connectors)
                let(
                    f = mb_face_to_int(connector[0]),
                    face = female ? mb_face_opposite(f) : f,
                    axis = mb_face_to_axis(face),
                    connector_type = mb_connector_type_to_int(connector[1]),
                    connector_range = mb_block_connector_range(block_obj, connector)
                )
                if((!female && connector_type == 0) || (female && connector_type > 0))
                    for(xy = connector_range)
                        mb_block_part_wedge(
                            block_dim,
                            connector_width[0],
                            connector_depth[0],
                            connector_length[2],
                            face = face,
                            expand = [0, "auto"],
                            offset = mb_block_connector_offset(block_obj, face, xy, female)
                        )
        ]
    );
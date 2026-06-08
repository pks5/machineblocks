use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;
use <../core/utils.scad>;
function mb_block_part__connectors(block_obj, subtract = false) = 
    let(
        block_dim = mb_block_get_dim(block_obj),
        connectors = mb_block_connectors(block_obj),
        connector_length = mb_block_connector_length(block_obj, subtract),
        connector_depth = mb_block_connector_depth(block_obj, subtract),
        connector_width = mb_block_connector_width(block_obj, subtract)
    )
    !is_list(connectors) ? undef :
    mb_block_part_model(
        type = "list",
        items = [
            for(connector = connectors)
                let(
                    face = mb_block_connector_face(block_obj, connector, subtract),
                    connector_type = mb_block_connector_type(block_obj, connector),
                    connector_range = mb_block_connector_range(block_obj, connector),
                    connector_tilt = mb_block_connector_tilt(block_obj, connector)
                )
                if(mb_block_connector_render(block_obj, connector, subtract))
                    for(xy = connector_range)
                        mb_block_part_wedge(
                            block_dim,
                            connector_width[0],
                            connector_depth[connector_tilt == 0 ? 0 : 2],
                            connector_length[connector_tilt == 0 ? 2 : 0],
                            face = face,
                            tilt = connector_tilt,
                            expand = [0, "auto"],
                            offset = mb_block_connector_offset(block_obj, connector, xy, subtract)
                        )
        ]
    );
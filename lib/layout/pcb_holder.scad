use <../core/utils.scad>;
use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

function mb_block_part__pcb_holder(block_obj) = 
    let(
        pcb = mb_block_get_pcb(block_obj)
    )
    pcb == false || pcb == "none" ? undef :
    let(
        pcb_dimensions = mb_block_get_pcb_dimensions(block_obj),
        pcb_offset = mb_block_get_pcb_offset(block_obj),
        pcb_socket_diameter = mb_block_get_pcb_socket_diameter(block_obj),
        pcb_socket_hole_diameter = mb_block_get_pcb_socket_hole_diameter(block_obj),
        pcb_socket_height = mb_block_get_pcb_socket_height(block_obj),
        pcb_sockets = mb_block_get_pcb_sockets(block_obj),
        recess_floor_offset_z = 0.5*mb_block_get_mod_size(block_obj)[2] + mb_block_recess_floor_offset(block_obj, "z+")
    )
    mb_block_part_pcb(
        
        pcb,
        pcb_dimensions,
        pcb_sockets,
        pcb_socket_height,
        pcb_socket_diameter,
        pcb_socket_hole_diameter,
        offset = [
            pcb_offset[0],
            pcb_offset[1],
            recess_floor_offset_z
        ],
        name = "pcb_holder"
    );
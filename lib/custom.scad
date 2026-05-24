use <core/block_part.scad>;
use <core/block_model.scad>;
use <core/block_dim.scad>;
use <core/utils.scad>;

module mb_block_part__custom(block_obj, part, part_params, debug, mul){
    part_type = mb_block_part_model_type(part);
    part_data = mb_block_part_model_data(part);
    part_data_length = mb_block_part_model_data_length(part);

    if(is_string(part_type) && part_data_length > 0){
        if(part_type == "my_cube"){
            mb_block_part__my_cube__cube(block_obj, part, part_params, debug, mul);
        }
    }
}

module mb_block_part__my_cube__cube(block_obj, part, part_params, debug, mul){
    cube_data = mb_block_part_model_data_item(part, 0);

    // Render module
    cube(size = cube_data[1], center = true);

    // Render children
    mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 1), part_params=part_params, mul = mul, debug = debug);
}
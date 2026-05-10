module mb_block_part__custom_0(block_obj, module_children, part_params, debug, mul){
    if(is_list(module_children)){
        child_module_name = module_children[0];
        if(child_module_name == "cube"){
            mb_block_part__my_cube__cube(block_obj, module_children[1], module_children[2], part_params, debug, mul);
        }
        else{
            // Unknown
        }
    }
}

module mb_block_part__my_cube__cube(block_obj, data, module_children, part_params, debug, mul){
    // Render module
    cube(size = data[0], center = true);
echo(data);
    // Render children
    mb_block_part(block_obj, part = module_children, part_params=part_params, mul = mul, debug = debug, source_custom_module = 0);
}
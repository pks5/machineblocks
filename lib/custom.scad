module mb_block_part__custom_0(block_obj, module_children, part_params, debug, mul){
    if(is_list(module_children)){
        child_module_name = module_children[0][0];
        if(child_module_name == "cube"){
            mb_block_part__my_cube__cube(block_obj, module_children, part_params, debug, mul);
        }
        else{
            sphere(r = 2);
        }
    }
}

module mb_block_part__my_cube__cube(block_obj, module_children, part_params, debug, mul){
    // Render module
    cube(size = module_children[0][1], center = true);

    // Render children
    mb_block_part(block_obj, part = module_children[1], part_params=part_params, mul = mul, debug = debug, source_custom_module = 0);
}
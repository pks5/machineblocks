module mb_block_part__custom_0(block_obj, module_children, part_params, debug, mul){
    if(is_list(module_children))
        for(child_module = module_children){
            if(is_string(child_module[0])){
                if(child_module[0] == "cube"){
                    mb_block_part__my_cube__cube(block_obj, child_module[1], part_params, debug, mul);
                }
                else{
                    mb_block_part(block_obj, part = child_module, part_params=part_params, mul = mul, debug = debug);
                }
            }
            else{
                mb_prismoid(shape = child_module, mul = mul, debug = debug);
            }
        }
}

module mb_block_part__my_cube__cube(block_obj, module_children, part_params, debug, mul){
    // Render module
    cmd = module_children[0];
    cube(size = cmd[0]);

    // Render children
    mb_block_part(block_obj, part = module_children[1], part_params=part_params, mul = mul, debug = debug);
}
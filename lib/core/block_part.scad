use <geometry.scad>;
use <block_model.scad>;
use <utils.scad>;

use <../shape/prismoid.scad>;
use <../shape/tube.scad>;
use <../shape/cube.scad>;

include <../custom.scad>;



function mb_block_part_tube(
    block_size,
    block_mod = undef,
    radius,
    rounding_radius = undef,
    clamp_start = undef,
    clamp_end = undef,
    axis = "z",
    length = undef,
    expand = undef,
    offset = undef
) = 
    let(offset = mb_resolve_xyz(xyz = offset, default = [0, 0, 0]),
        mod_min_max = mb_block_mod_min_max(block_size = block_size, block_mod = block_mod),
        mod_size = mod_min_max[1][0],
        axis = mb_axis_to_int(axis),
        h = mod_size[axis],
        h_adj = is_undef(expand) || expand == "auto" || expand == ["auto", "auto"] ? [-0.5 * (!is_undef(length) ? length : h), 0.5 * (!is_undef(length) ? length : h)] :
            [expand[0] == "auto" ? 0.5 * h + expand[1] - (!is_undef(length) ? length : h) : -0.5 * h - expand[0], 
            expand[1] == "auto" ? -0.5 * h - expand[0] + (!is_undef(length) ? length : h) : 0.5 * h + expand[1]]
        
    )
    [
        "tube",
        [
            [
                
                radius,
                h_adj,
                rounding_radius,
                clamp_start,
                clamp_end,
                axis,
                [axis != 0 ? offset[0] : 0, axis != 1 ? offset[1] : 0, axis != 2 ? offset[2] : 0]
            ]
        ]
    ];

function mb_block_part_cube(
    block_size,
    block_mod = undef,
    size = undef,
    expand = undef,
    offset = [0, 0, 0]
) = 
    let(mod_min_max = mb_block_mod_min_max(block_size = block_size, block_mod = block_mod),
        mod_size = mod_min_max[1][0],
        
        si = is_undef(size) ? mod_size : size,
        si2 = [(is_undef(si[0]) ? mod_size[0] : si[0]), (is_undef(si[1]) ? mod_size[1] : si[1]), (is_undef(si[2]) ? mod_size[2] : si[2])],
        s_adj = is_undef(expand) || expand == "auto" || expand == ["auto", "auto", "auto"] ? 
            si :

            [
                [
                    expand[0] == "auto" && expand[1] == "auto" ? 
                        -0.5 * si2[0] : expand[0] == "auto" ? 
                        (0.5 * mod_size[0] + expand[1] - si2[0]) : 
                        -0.5 * (expand[1] == "auto" ? mod_size[0] : si2[0]) - expand[0],
                    expand[2] == "auto" && expand[3] == "auto" ? 
                        -0.5 * si2[1] : expand[2] == "auto" ? 
                        (0.5 * mod_size[1] + expand[3] - si2[1]) : 
                        -0.5 * (expand[3] == "auto" ? mod_size[1] : si2[1]) - expand[2],
                    expand[4] == "auto" && expand[5] == "auto" ? 
                        -0.5 * si2[2] : expand[4] == "auto" ? 
                        (0.5 * mod_size[2] + expand[5] - si2[2]) : 
                        -0.5 * (expand[5] == "auto" ? mod_size[2] : si2[2]) - expand[4]
                ],
                [
                    expand[0] == "auto" && expand[1] == "auto" ? 
                        0.5 * si2[0] : expand[1] == "auto" ? 
                        (-0.5 * mod_size[0] - expand[0] + si2[0]) : 
                        0.5 * (expand[0] == "auto" ? mod_size[0] : si2[0]) + expand[1],
                    expand[2] == "auto" && expand[3] == "auto" ? 
                        0.5 * si2[1] : expand[3] == "auto" ? 
                        (-0.5 * mod_size[1] - expand[2] + si2[1]) : 
                        0.5 * (expand[2] == "auto" ? mod_size[1] : si2[1]) + expand[3],
                    expand[4] == "auto" && expand[5] == "auto" ? 
                        0.5 * si2[2] : expand[5] == "auto" ? 
                        (-0.5 * mod_size[2] - expand[4] + si2[2]) : 
                        0.5 * (expand[4] == "auto" ? mod_size[2] : si2[2]) + expand[5]
                ]
            ]
    )
    [
        "cube",
        [
            [
                s_adj,
                offset
            ]
        ]
    ];

function mb_block_part_prismoid(
    block_size, 
    block_mod = undef, 
    bevel = undef, 
    slope = undef, 
    socket = undef, 
    expand = undef, 
    height = undef
) =
    let(
        mod_min_max = mb_block_mod_min_max(block_size = block_size, block_mod = block_mod),
        mod_size = mod_min_max[1][0],
        min_max = mod_min_max[1][2],
        h_d = is_undef(height) ? [min_max[0][2], min_max[1][2]] : [-0.5 * height, 0.5 * height],

        exp_sin = is_list(expand) && (len(expand) == 2) && is_list(expand[0]) && is_list(expand[1]),
        exp_1 = is_list(expand) && (((len(expand) == 1) && is_list(expand[0])) 
            || (len(expand) == 2 && is_undef(expand[0]) && !is_undef(expand[1])) 
            || (len(expand) == 2 && !is_undef(expand[0]) && is_undef(expand[1]))),
        exp_h = is_undef(expand) ? undef : (!is_undef(expand[0]) ? expand[0] : (!is_undef(expand[1]) ? expand[1] : undef)),

        h = is_undef(exp_h) || (exp_h[4] == "auto" && exp_h[5] == "auto") ? h_d : [exp_h[4] == "auto" ? min_max[1][2] - height : h_d[0], exp_h[5] == "auto" ? min_max[0][2] + height : h_d[1] ],
        h_exp = is_undef(exp_h) ? h : [h[0] - (exp_h[4] == "auto" ? 0 : exp_h[4]), h[1] + (exp_h[5] == "auto" ? 0 : exp_h[5])],
        exp = is_undef(expand) ? undef : exp_sin ? [ is_undef(expand[0]) ? undef : [expand[0][0], expand[0][1], expand[0][2], expand[0][3], 0, 0], is_undef(expand[1]) ? undef : [expand[1][0], expand[1][1], expand[1][2], expand[1][3], 0, 0]] : exp_1 ? [[exp_h[0], exp_h[1], exp_h[2], exp_h[3], 0, 0]] : undef,
        
        
        bevel_matrix = mb_bevel_matrix(is_undef(bevel) ? mb_bevel_resolve(0) : bevel, mod_size, min_max),
        bevel_res = bevel_matrix[0],
        bevel_fil = bevel_matrix[1],
        
        slope = is_undef(slope) ? mb_qc_resolve(0, false) : slope,
        //sl = mb_slope_matrix(slope, bevel_res, mod_size),
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos = mb_slope_filter(slope, 1)
    )
    [
        "prismoid",
        [
            [
                mb_prismoid_plane_expand(bevel_fil, 0, slope_neg),
                mb_prismoid_plane_expand(bevel_fil, 1, [-slope_pos[0], -slope_pos[1], -slope_pos[2], -slope_pos[3]]),
                [h_exp, socket, undef, exp]
            ]
        ] // Shape
    ];

function mb_block_part_type_is_builtin(type) = 
    is_string(type) && (
        type == "prismoid" || 
        type == "tube" ||
        type == "cube" ||  
        type == "union" || 
        type == "difference" || 
        type == "intersection"  || 
        type == "list");

function mb_block_part_to_prismoid(
    block_obj,
    part = undef,
    part_params = undef,
    radius = undef,
    mul = undef, 
    add = undef
) =
    is_undef(part) || !is_list(part) ? undef : 
        let(type = part[0], 
            list = part[1])
        mb_block_part_type_is_builtin(type) ?
        [
            type,
            [
                for(list_item = list)
                 
                 mb_block_part_type_is_builtin(list_item[0]) ?

                    mb_block_part_to_prismoid(
                        block_obj,
                        part = list_item,
                        part_params = part_params,
                        radius = radius,
                        mul = mul, 
                        add = add
                    ) : 

                    type == "prismoid" ?
                    mb_prismoid_shape_resolve(
                        shape = list_item, 
                        radius = radius,
                        mul = mul,
                        add = add
                    ) : undef

            ]
        ] : undef;

module mb_block_part(block_obj, part, part_params = undef, debug = false, mul = undef){
    mul = is_undef(mul) ? mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from="grd", to="mm") : mul;
    
    if(!is_undef(part) && is_list(part)){
        type = part[0];
        list = part[1];
        list_len = len(list);
        if(is_string(type) && list_len > 0){
            if(type == "list"){
                for(list_item = list){
                    mb_block_part(block_obj, part = list_item, part_params=part_params, mul = mul, debug = debug);
                }
            }
            else if(type == "union"){
                if(list_len > 1){
                    union(){
                        mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                        for(i = [1 : list_len - 1]){
                            mb_block_part(block_obj, part = list[i], part_params=part_params, mul = mul, debug = debug);
                        }
                    }
                }
                else{
                    mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                }
            }
            else if(type == "difference"){
                if(list_len > 1){
                    difference(){
                        mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                        for(i = [1 : list_len - 1]){
                            mb_block_part(block_obj, part = list[i], part_params=part_params, mul = mul, debug = debug);
                        }
                    }
                }
                else{
                    mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                }
            }
            else if(type == "intersection"){
                if(list_len > 1){
                    intersection(){
                        mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                        for(i = [1 : list_len - 1]){
                            mb_block_part(block_obj, part = list[i], part_params=part_params, mul = mul, debug = debug);
                        }
                    }
                }
                else{
                    mb_block_part(block_obj, part = list[0], part_params=part_params, mul = mul, debug = debug);
                }
            }
            else if(type == "prismoid"){
                mb_prismoid(shape = list[0], mul = mul, debug = debug);
                
                mb_block_part(block_obj, part = list[1], part_params=part_params, mul = mul, debug = debug);
            }
            else if(type == "tube"){
                mb_tube(
                    radius = list[0][0],
                    length = list[0][1],
                    rounding_radius = list[0][2],
                    clamp_start = list[0][3],
                    clamp_end = list[0][4],
                    axis = list[0][5],
                    offset = list[0][6],
                    mul = mul,
                    debug = debug
                );
                
                mb_block_part(block_obj, part = list[1], part_params=part_params, mul = mul, debug = debug);
            }
            else if(type == "cube"){
                mb_cube(
                    size = list[0][0],
                    offset = list[0][1],
                    mul = mul
                );
                
                mb_block_part(block_obj, part = list[1], part_params=part_params, mul = mul, debug = debug);
            }
            else{
                mapping = mb_block_custom_module_mapping(block_obj, type);
                
                if(mapping == 0){
                    mb_block_part__custom_0(block_obj, list, part_params, debug, mul);
                }
                else if(mapping == 1){
                    mb_block_part__custom_1(block_obj, list, part_params, debug, mul);
                }
                else if(mapping == 2){
                    mb_block_part__custom_2(block_obj, list, part_params, debug, mul);
                }
                else if(mapping == 3){
                    mb_block_part__custom_3(block_obj, list, part_params, debug, mul);
                }
            }
        }
    }
}

/*
module mb_cylinder(
    
    radius,
    length,
    axis = "z",
    offset = [0, 0, 0],
    
    mul = [1, 1, 1],
    center = true,
    debug = false
){
    offset = mb_resolve_xyz(offset, default = [0, 0, 0]);
    mul = mb_resolve_xyz(mul, default = [1, 1, 1]);
    axis = mb_axis_to_int(axis);
    hl = is_list(length) ? length[1] - length[0] : length;
    length_offset = is_list(length) ? 0.5*(length[0] + length[1]) : 0;
    rot = axis == 0 ? [0, 90 , 0] : axis == 1 ? [90, 0, 0] : [0, 0, 0];
echo (l = length, hl = hl, lo = length_offset);
    translate([offset[0] * mul[0], offset[1] * mul[1], offset[2] * mul[2]])
        rotate(rot)
            translate([0, 0, length_offset * mul[axis]])
                cylinder(r =  radius * mul[axis == 2 ? 0 : 2], h = hl * mul[axis], center = center, $fn = 100);
}*/


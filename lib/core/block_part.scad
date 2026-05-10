use <../utils.scad>
use <../prismoid.scad>

function mb_block_part_to_prismoid(
    block_obj,
    part = undef,
    part_params = undef,
    radius = undef, 
    mul = undef, 
    add = undef
) =
    let(part_shapes = mb_block_part_shape(block_obj, part = part, part_params = part_params))
    is_undef(part_shapes) ? undef : 
    [
        for(part_shape = part_shapes)
            mb_prismoid_shape_resolve(
                shape = part_shape[0], 
                height = part_shape[1], 
                socket = part_shape[2][0],
                radius = radius, 
                mul = mul,
                add = add,
                expand = part_shape[2][1]
            )
    ];

module mb_block_part(block_obj, part, part_params = undef, debug = false){
    mul = mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from="grd", to="mm");
    
    if(part == "some_custom_module_tbd"){

    }
    if(part == "some_other_custom_module_tbd"){
        
    }
    else{
        part_shapes = mb_block_part_to_prismoid(block_obj, part = part, part_params = part_params, mul=mul);
        
        if(!is_undef(part_shapes)){
            for(part_shape = part_shapes)
                mb_prismoid(shape = part_shape, skip_resolve = true, debug = debug);
        }
    }
}

/**
* CUBE
*/
module mb_cube(
    size, 
    radius = 0, 
    xyz_rad = false, 
    center = true, 
    resolution = 80, 
    debug = false
){
    size = mb_resolve_xyz(xyz = size);
    rad0 = radius == 0 || radius == [0, 0, 0] || (xyz_rad && (radius == [[0,0,0,0],[0,0,0,0],[0,0,0,0]]));

    if(rad0){
        cube(size, center = center);
    }
    else{
        rad = xyz_rad ? mb_xyz_rad_convert(radius) : radius;

        block_obj = mb_block_obj(size);

        mul = mb_unit_mul(mb_block_get_grid_cfg(block_obj), scale = mb_block_get_scale(block_obj), from="grd", to="mm");
        prismoid_shape = mb_block_part_to_prismoid(
            block_obj,
            part = "simple",
            radius = radius,
            mul = mul
        );

        mb_prismoid(shape = prismoid_shape[0], skip_resolve = true, align = center ? "center" : "start", resolution = resolution, debug = debug);
    }
}

/*
* ----------------------
* START TESTING (REMOVE)
* ----------------------
*/


sr = [80, 10.1, 10];
corner = [1,0];


*color("#ffffff55")
mb_rounding_corner(corner = corner, radius = sr, angle = [0, 0, 0, 0], resolution = 80);


*translate([0, -300, 0])
mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-0, -50], undef, [-0, 50], undef, [40, 50], undef, [40, -50], undef]
], height = 120, socket = [20, 0], socket_top = undef, radius = 0, resolution = 160);

translate([0, 300, 0])
mb_prismoid(shape = [
    [[-70, -50], [-140, 0], [-70, 50], undef, [50, 40], undef, [50, -40], undef],
    
    [[-20, -30], [-70, 0], [-20, 30], undef, [20, 40], undef, [50, -40], undef]
], height = 120, socket = [20, 0], radius = [15, 14, 6, 12], resolution = 160, debug=true, align="sticky");

translate([200, 0, 0])
mb_cube(
    debug = true, 
    size = [4, 4, 3], 
    radius = [[[1, 1, 0], [1, 1, 0], [1, 1, 0], [1, 1, 0]], [[1.2, 1.2, 1, 2], [1.2, 1.2, 1, 1.2], [0.1, 0.1, 0.1,0.1], [1, 1, 1, 1]]]);


*mb_prismoid(shape = [
    [[-20, -30, undef, [10,10,0]], [-20, 30, undef,[10,10,0]], [50, 30,undef, [10,10,0]], [50, -30,undef, [10,10,0]]],
    [[-20, -30, undef,[10,10,0]], [-20, 30,undef, [10,10,0]], [20, 30, undef,[10,10,0]], [20, -30, undef,[10,10,0]]]
    
], height = 120, socket = [0, 20], radius = 0, resolution = 160);



*mb_prismoid(shape = [
    [[-20, -50], undef, [-20, 50], undef, [20, 50], undef, [20, -50], undef],
    
    [[-20, -50], undef, [-20, 50], undef, [40, 40], undef, [20, -50], undef]
], height = 120, socket = [20, 20], radius = 0, resolution = 160, debug=true);
use <block_model.scad>;
use <block_dim.scad>;
use <utils.scad>;
use <poly_expand.scad>;
use <quality.scad>;

use <../shape/prismoid.scad>;
use <../shape/tube.scad>;
use <../shape/cube.scad>;
use <../shape/wedge.scad>;
use <../shape/svg3d.scad>;
use <../shape/text3d.scad>;
use <../shape/pcb.scad>;
use <../shape/custom_shapes.scad>;

/*
* ----------
* PART MODEL
* ----------
*/

function mb_block_part_model(
    type, 
    items = undef, 
    data = undef, 
    render = true
) =
    render ? [
        type,
        is_undef(data) ? items : [data]
    ] : undef;

function mb_block_part_custom(type, items = undef, data = undef, render = true) =
    mb_block_part_type_is_builtin(type) ? undef 
    : mb_block_part_model(
        type = type, 
        items = items, 
        data = data, 
        render = render
    );

function _mb_block_part_model_valid(part_model) =
    is_list(part_model) && len(part_model) == 2 && is_string(part_model[0]) && is_list(part_model[1]);

function mb_block_part_model_type(part_model) = 
    _mb_block_part_model_valid(part_model) ? part_model[0] : undef;

function mb_block_part_model_data(part_model) = 
    _mb_block_part_model_valid(part_model) ? part_model[1] : undef;

function mb_block_part_model_data_length(part_model) = 
    _mb_block_part_model_valid(part_model) ? len(part_model[1]) : undef;

function mb_block_part_model_data_item(part_model, item = 0) = 
    _mb_block_part_model_valid(part_model) && len(part_model[1]) > 0 ? part_model[1][item] : undef;

function mb_block_part_type_is_builtin(type) = 
    is_string(type) && (
        type == "mb_prismoid" || 
        type == "mb_tube" ||
        type == "mb_cube" ||
        type == "mb_wedge" || 
        type == "mb_svg" ||  
        type == "mb_text" ||  
        type == "mb_pcb" ||  
        
        type == "union" || 
        type == "difference" || 
        type == "intersection"  || 
        type == "list"
    );

/*
* ---
* PCB
* ---
*/
function mb_block_part_pcb(
    pcb,
    dimensions,
    screw_sockets,
    screw_socket_height,
    screw_socket_size,
    screw_socket_hole_size,
    offset = undef,
    render = true
) = 
mb_block_part_model(
    type = "mb_pcb",
    data = [
        pcb,
        dimensions,
        screw_sockets,
        screw_socket_height,
        screw_socket_size,
        screw_socket_hole_size,
        offset,
    ], 
    render = render
);

/*
* ---
* SVG
* ---
*/
function mb_block_part_svg(
    block_dim,
    svg_file,
    svg_size,
    svg_face,
    size = undef,
    expand = undef,
    offset = undef,
    color = undef,
    render = true
) = 
mb_block_part_model(
    type = "mb_svg",
    data = [
        svg_file,
        svg_size,
        svg_face,
        mb_block_dim_size_expand(block_dim, size, expand),
        offset,
        color
    ], 
    render = render
);

/*
* ----
* TEXT
* ----
*/
function mb_block_part_text(
    block_dim,
    text,
    text_size,
    height,
    font,
    spacing,
    align,
    face = "z+",
    expand = undef,
    offset = undef,
    color = undef,
    render = true
) = 
mb_block_part_model(
    type = "mb_text",
    data = [
        text,
        text_size,
        mb_block_dim_height_expand(block_dim, mb_face_to_axis(face), height, expand),
        font,
        spacing,
        align,
        face,
        offset,
        color
    ], 
    render = render
);


/*
* ----
* TUBE
* ----
*/
function mb_block_part_tube(
    block_dim,
    radius,
    rounding_radius = undef,
    clamp_start = undef,
    clamp_end = undef,
    axis = "z",
    length = undef,
    expand = undef,
    offset = undef,
    quality_class = ["functional", "visual"],
    render = true
) = 
    let(
       /*
        clamp_start = is_undef(clamp_start) 
            ? undef 
            : [
                clamp_start[0],
                clamp_start[1],
                clamp_start[2],
                clamp_start[3]
            ]*/
        
    )
    mb_block_part_model(
        type = "mb_tube",
        data = [
            radius,
            mb_block_dim_height_expand(block_dim, axis, length, expand),
            rounding_radius,
            clamp_start,
            clamp_end,
            axis,
            offset,
            quality_class
        ],
        render = render
    );

/*
* ----
* TUBE
* ----
*/
function mb_block_part_wedge(
    block_dim,
    width,
    depth,
    length,
    face = "x-",
    dir = "z",
    expand = undef,
    offset = undef,
    render = true
) = 
    let(
       dir = mb_axis_to_int(dir)
    )
    mb_block_part_model(
        type = "mb_wedge",
        data = [
            width,
            depth,
            mb_block_dim_height_expand(block_dim, dir, length, expand),
            face,
            dir,
            offset
        ],
        render = render
    );

/*
* ----
* CUBE
* ----
*/
function mb_block_part_cube(
    block_dim,
    size = undef,
    expand = undef,
    offset = undef,
    radius = undef,
    xyz_rad = true,
    render = true
) = 
    mb_block_part_model(
        type = "mb_cube",
        data = [
            mb_block_dim_size_expand(block_dim, size, expand),
            offset,
            radius,
            xyz_rad
        ],
        render = render
    );

/*
* --------
* PRISMOID
* --------
*/
function mb_block_part_prismoid(
    block_dim, 
    bevel = true, 
    slope = undef, 
    socket = undef, 
    expand = undef, 
    rad_expand = true,
    height = undef,
    radius = undef,
    quality_class = "visual",
    render = true
) =
    let(
        mod_size = mb_block_dim_mod_size(block_dim),
        min_max = mb_block_dim_min_max_pos(block_dim),
        
        h_d = is_num(height) ? [-0.5 * height, 0.5 * height] : [min_max[0][2], min_max[1][2]],
        h_r = is_num(height) ? height : mod_size[2],

        exp_planes = is_undef(expand) ? undef : [
            mb_prismoid_plane(expand, 0),
            mb_prismoid_plane(expand, 1)
        ],
       

        /*
        exp_sin = is_list(expand) && (len(expand) == 2) && is_list(expand[0]) && is_list(expand[1]),
        exp_1 = is_list(expand) && (((len(expand) == 1) && is_list(expand[0])) 
            || (len(expand) == 2 && is_undef(expand[0]) && !is_undef(expand[1])) 
            || (len(expand) == 2 && !is_undef(expand[0]) && is_undef(expand[1]))),
        exp_h = is_undef(expand) ? undef : (!is_undef(expand[0]) ? expand[0] : (!is_undef(expand[1]) ? expand[1] : undef)),
        */

        
        /*
        h_exp = is_undef(expand) 
                    || is_undef(exp_planes[0]) && is_undef(exp_planes[1]) 
                    || (exp_planes[0][4] == "auto" && exp_planes[1][5] == "auto") 
            ? h_d 
            : [
                exp_planes[0][4] == "auto" 
                    ? min_max[1][2] - h_r 
                    : h_d[0] - exp_planes[0][4], 
                exp_planes[1][5] == "auto" 
                    ? min_max[0][2] + h_r 
                    : h_d[1] + exp_planes[1][5]
            ],*/
        
        
        /*h_exp = is_undef(exp_h) 
            ? h 
            : [
                h[0] - (exp_h[4] == "auto" ? 0 : exp_h[4]), 
                h[1] + (exp_h[5] == "auto" ? 0 : exp_h[5])
            ],*/
        //exp = is_undef(expand) ? undef : exp_sin ? [ is_undef(expand[0]) ? undef : [expand[0][0], expand[0][1], expand[0][2], expand[0][3], 0, 0], is_undef(expand[1]) ? undef : [expand[1][0], expand[1][1], expand[1][2], expand[1][3], 0, 0]] : exp_1 ? [[exp_h[0], exp_h[1], exp_h[2], exp_h[3], 0, 0]] : undef,
        
        exp = is_undef(expand) ? undef : [
            [
                exp_planes[0][0], 
                exp_planes[0][1], 
                exp_planes[0][2], 
                exp_planes[0][3], 
                exp_planes[0][4] == "auto" ? -mod_size[2] + h_r : exp_planes[0][4], 
                0 // z+ on bottom plane is ignored
            ],
            [
                exp_planes[1][0], 
                exp_planes[1][1], 
                exp_planes[1][2], 
                exp_planes[1][3], 
                0, // z- on top plane is ignored
                exp_planes[1][5] == "auto" ? -mod_size[2] + h_r : exp_planes[1][5], 
            ]
        ],

        bevel_matrix = mb_block_dim_bevel_matrix(block_dim),
        
        slope = is_undef(slope) ? mb_qc_resolve(0, false) : slope,
        
        slope_neg = mb_slope_filter(slope, -1),
        slope_pos_inv = mb_slope_filter(slope, 1, -1),
        //socket = slope_inner ? [] : []
    )
    mb_block_part_model(
        type = "mb_prismoid",
        data = [
            mb_poly_expand(bevel_matrix, 0, slope_neg),
            mb_poly_expand(bevel_matrix, 1, slope_pos_inv),
            [
                h_d, 
                socket,
                radius, 
                exp,
                rad_expand,
                quality_class
            ]
        ],
        render = render
    );


/*
* ---------
* RENDERING
* ---------
*/

module mb_block_part(block_obj, part, part_params = undef, debug = false, mul = undef){
    mul = is_undef(mul) ? mb_block_default_multiplier(block_obj) : mul;
    base_color = mb_block_get_base_color(block_obj);

    quality = mb_block_get_quality(block_obj);
    scad_quality_profile = mb_block_get_scad_quality_profile(block_obj);
    scad_quality_class_factors = mb_block_get_scad_quality_class_factors(block_obj);
    scad_quality_class_min_segments = mb_block_get_scad_quality_class_min_segments(block_obj);
    scad_quality_segment_multiplier = mb_block_get_scad_quality_segment_multiplier(block_obj);
    scad_preview_quality = mb_block_get_scad_preview_quality(block_obj);
    scad_preview_max_mult = mb_block_get_scad_preview_max_mult(block_obj);
    
    part_type = mb_block_part_model_type(part);
    part_data = mb_block_part_model_data(part);
    part_data_length = mb_block_part_model_data_length(part);

    if(is_string(part_type) && part_data_length > 0){
        /*
        * Aggregations
        */
        if(part_type == "list"){
            for(list_item = part_data){
                mb_block_part(block_obj, part = list_item, part_params=part_params, mul = mul, debug = debug);
            }
        }
        else if(part_type == "union"){
            if(part_data_length > 1){
                union(){
                    mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 0), part_params=part_params, mul = mul, debug = debug);
                    for(i = [1 : part_data_length - 1]){
                        mb_block_part(block_obj, part = mb_block_part_model_data_item(part, i), part_params=part_params, mul = mul, debug = debug);
                    }
                }
            }
            else{
                mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 0), part_params=part_params, mul = mul, debug = debug);
            }
        }
        else if(part_type == "difference"){
            if(part_data_length > 1){
                difference(){
                    mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 0), part_params=part_params, mul = mul, debug = debug);
                    for(i = [1 : part_data_length - 1]){
                        mb_block_part(block_obj, part = mb_block_part_model_data_item(part, i), part_params=part_params, mul = mul, debug = debug);
                    }
                }
            }
            else{
                mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 0), part_params=part_params, mul = mul, debug = debug);
            }
        }
        else if(part_type == "intersection"){
            if(part_data_length > 1){
                intersection(){
                    mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 0), part_params=part_params, mul = mul, debug = debug);
                    for(i = [1 : part_data_length - 1]){
                        mb_block_part(block_obj, part = mb_block_part_model_data_item(part, i), part_params=part_params, mul = mul, debug = debug);
                    }
                }
            }
            else{
                mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 0), part_params=part_params, mul = mul, debug = debug);
            }
        }

        /**
        * Shapes
        */
        else if(part_type == "mb_prismoid"){
            mb_prismoid(
                shape = mb_block_part_model_data_item(part, 0), 
                mul = mul, 
                debug = debug,
                quality = quality,

                q_profile = scad_quality_profile,
                q_class_factors = scad_quality_class_factors,
                q_class_min_segments = scad_quality_class_min_segments,
                q_segment_multiplier = scad_quality_segment_multiplier,
                q_preview_quality = scad_preview_quality,
                q_preview_max_mult = scad_preview_max_mult,
                color = base_color
            );
            
            mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 1), part_params=part_params, mul = mul, debug = debug);
        }
        else if(part_type == "mb_tube"){
            tube_data = mb_block_part_model_data_item(part, 0);
            radius = tube_data[0];
            rounding_radius = tube_data[2];
            quality_class = tube_data[7]; // [tube, edge]

            /*
            tube_resolution = mb_q_fn_even_for_radius(
                r = (is_list(radius) ? radius[1] : radius) * mul[0],
                q = quality_class[0],
                preset = quality,
                profile = scad_quality_profile,
                class_factors = scad_quality_class_factors,
                class_min_segments = scad_quality_class_min_segments,
                segment_multiplier = scad_quality_segment_multiplier,
                preview_quality = scad_preview_quality,
                preview_max_mult = scad_preview_max_mult
            );

            edge_resolution = is_num(rounding_radius) ? mb_q_fn_even_for_radius(
                r = rounding_radius * mul[0],
                q = quality_class[1],
                preset = quality,
                profile = scad_quality_profile,
                class_factors = scad_quality_class_factors,
                class_min_segments = scad_quality_class_min_segments,
                segment_multiplier = scad_quality_segment_multiplier,
                preview_quality = scad_preview_quality,
                preview_max_mult = scad_preview_max_mult
            ) : 8;

            echo(q = quality, r=rounding_radius, qc = quality_class[1], t_r = edge_resolution);*/

            mb_tube(
                radius = radius,
                length = tube_data[1],
                rounding_radius = rounding_radius,
                clamp_start = tube_data[3],
                clamp_end = tube_data[4],
                axis = tube_data[5],
                offset = tube_data[6],
                mul = mul,
                debug = debug,
                color = base_color,
                
                quality_class_tube = quality_class[0],
                quality_class_edge = quality_class[1],

                quality = quality,

                q_profile = scad_quality_profile,
                q_class_factors = scad_quality_class_factors,
                q_class_min_segments = scad_quality_class_min_segments,
                q_segment_multiplier = scad_quality_segment_multiplier,
                q_preview_quality = scad_preview_quality,
                q_preview_max_mult = scad_preview_max_mult
            );
            
            mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 1), part_params=part_params, mul = mul, debug = debug);
        }
        else if(part_type == "mb_cube"){
            cube_data = mb_block_part_model_data_item(part, 0);

            mb_cube(
                size = cube_data[0],
                offset = cube_data[1],
                radius = cube_data[2],
                xyz_rad = cube_data[3],
                mul = mul,
                color = base_color
            );
            
            mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 1), part_params=part_params, mul = mul, debug = debug);
        }
        else if(part_type == "mb_wedge"){
            wedge_data = mb_block_part_model_data_item(part, 0);

            mb_wedge(
                width = wedge_data[0],
                depth = wedge_data[1],
                length = wedge_data[2],
                face = wedge_data[3],
                dir = wedge_data[4],
                offset = wedge_data[5],
                mul = mul,
                color = base_color
            );
            
            mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 1), part_params=part_params, mul = mul, debug = debug);
        }
        else if(part_type == "mb_svg"){
            svg_data = mb_block_part_model_data_item(part, 0);

            mb_svg(
                svg_file = svg_data[0],
                svg_size = svg_data[1],
                face = svg_data[2],
                size = svg_data[3],
                offset = svg_data[4],
                color = is_undef(svg_data[5]) ? base_color : svg_data[5],
                mul = mul,
                quality = quality,

                q_profile = scad_quality_profile,
                q_class_factors = scad_quality_class_factors,
                q_class_min_segments = scad_quality_class_min_segments,
                q_segment_multiplier = scad_quality_segment_multiplier,
                q_preview_quality = scad_preview_quality,
                q_preview_max_mult = scad_preview_max_mult
            );
            
            mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 1), part_params=part_params, mul = mul, debug = debug);
        }
        else if(part_type == "mb_text"){
            text_data = mb_block_part_model_data_item(part, 0);

            mb_text(
                text = text_data[0],
                text_size = text_data[1],
                height = text_data[2],
                font = text_data[3],
                spacing = text_data[4],
                align = text_data[5],
                face = text_data[6],
                offset = text_data[7],
                color = is_undef(text_data[8]) ? base_color : text_data[8],
                mul = mul,
                quality = quality,

                q_profile = scad_quality_profile,
                q_class_factors = scad_quality_class_factors,
                q_class_min_segments = scad_quality_class_min_segments,
                q_segment_multiplier = scad_quality_segment_multiplier,
                q_preview_quality = scad_preview_quality,
                q_preview_max_mult = scad_preview_max_mult
            );
            
            mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 1), part_params=part_params, mul = mul, debug = debug);
        }
        else if(part_type == "mb_pcb"){
            pcb_data = mb_block_part_model_data_item(part, 0);

            mb_pcb(
                pcb = pcb_data[0],
                dimensions = pcb_data[1],
                screw_sockets = pcb_data[2],
                screw_socket_height = pcb_data[3],
                screw_socket_size = pcb_data[4],
                screw_socket_hole_size = pcb_data[5],
                offset = pcb_data[6],
                mul = mul,
                color = base_color
            );

            mb_block_part(block_obj, part = mb_block_part_model_data_item(part, 1), part_params=part_params, mul = mul, debug = debug);
        }
        /*
        * Custom Shapes
        */
        else{
            mb_block_part__custom_shapes(block_obj, part = part, part_params=part_params, mul = mul, debug = debug);
        }
        
    }
}
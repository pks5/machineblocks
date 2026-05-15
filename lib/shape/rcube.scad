use <../utils.scad>;

function _mb_rcube_arc_points(cx, cy, r, a0, a1, segments = 8) =
    [
        for (i = [0:segments])
            let(a = a0 + (a1 - a0) * i / segments)
                [cx + cos(a) * r, cy + sin(a) * r]
    ];

function _mb_rcube_profile_points(
    size,
    radius,
    rounding_resolution
) =
    let(
        corner_sw = [size[0][0], size[0][1]],
        corner_nw = [size[0][0], size[1][1]],
        corner_ne = [size[1][0], size[1][1]],
        corner_se = [size[1][0], size[0][1]],

        round_sw_x = corner_sw[0] + radius[0][0],
        round_sw_y = corner_sw[1] + radius[0][1],

        round_nw_x = corner_nw[0] + radius[1][0],
        round_nw_y = corner_nw[1] - radius[1][1],

        round_ne_x = corner_ne[0] - radius[2][0],
        round_ne_y = corner_ne[1] - radius[2][1],

        round_se_x = corner_se[0] - radius[3][0],
        round_se_y = corner_se[1] + radius[3][1],
    )
    concat(
        //corner_sw,
        concat(
            [
                [round_sw_x, corner_sw[1]]
            ],
        
            _mb_rcube_arc_points(
                cx = round_sw_x,
                cy = round_sw_y,
                r = radius[0][0],
                a0 = -180,
                a1 = -90,
                segments = rounding_resolution
            ),

            [
                [corner_sw[0], round_sw_y]
            ]
        ),
        //corner_nw,
        concat(
            [
                [corner_nw[0], round_nw_y]
            ],
        
            _mb_rcube_arc_points(
                cx = round_nw_x,
                cy = round_nw_y,
                r = radius[1][0],
                a0 = 180,
                a1 = 90,
                segments = rounding_resolution
            ),

            [
                [round_nw_x, corner_nw[1]]
            ]
        ),
        //corner_ne,
        concat(
            [
                [round_ne_x, corner_ne[1]]
            ],
        
            _mb_rcube_arc_points(
                cx = round_ne_x,
                cy = round_ne_y,
                r = radius[2][0],
                a0 = 90,
                a1 = 0,
                segments = rounding_resolution
            ),

            [
                [corner_ne[0], round_ne_y]
            ]
        ),
        //corner_se
        concat(
            [
                [corner_se[0], round_se_y]
            ],
        
            _mb_rcube_arc_points(
                cx = round_se_x,
                cy = round_se_y,
                r = radius[3][0],
                a0 = 0,
                a1 = -90,
                segments = rounding_resolution
            ),

            [
                [round_se_x, corner_se[1]]
            ]
        )
        
        
    );

module mb_rcube(
    size,
    radius,
    rounding_resolution = 100
){
    size =  mb_cube_size_resolve(size);

    polygon(points = _mb_rcube_profile_points(
        size = size, 
        radius = radius, 
        rounding_resolution = rounding_resolution
    ));
}


mb_rcube(
    size = [200, 100, 300],
    radius = [[5, 5], [10, 10], [15, 15], [20, 20]],
    rounding_resolution = 100
);
use <../utils.scad>;

function _mb_rcube_ellipse_arc_points(cx, cy, rx, ry, a0, a1, segments = 8) =
    [
        for (i = [0:segments])
            let(a = a0 + (a1 - a0) * i / segments)
                [cx + cos(a) * rx, cy + sin(a) * ry]
    ];

function _mb_rcube_profile_points(
    size,
    radius,
    rounding_resolution
) =
    let(
        size = [
            [
                size[0][0],
                size[0][1]
            ],
            [
                max(size[0][0], size[1][0]),
                max(size[0][1], size[1][1])
            ]
        ],

        dim = [
            size[1][0] - size[0][0], 
            size[1][1] - size[0][1]
        ],

        rad_sw_x = min(dim[0], max(0, radius[0][0])),
        rad_sw_y = min(dim[1], max(0, radius[0][1])),

        rad_nw_x = min(dim[0], max(0, radius[1][0])),
        rad_nw_y = min(dim[1] - rad_sw_y, max(0, radius[1][1])),

        rad_ne_x = min(dim[0] - rad_sw_x, max(0, radius[2][0])),
        rad_ne_y = min(dim[1], max(0, radius[2][1])),

        rad_se_x = min(dim[0] - rad_sw_x, max(0, radius[3][0])),
        rad_se_y = min(dim[1] - rad_ne_y, max(0, radius[3][1])),

        corner_sw = [size[0][0], size[0][1]],
        corner_nw = [size[0][0], size[1][1]],
        corner_ne = [size[1][0], size[1][1]],
        corner_se = [size[1][0], size[0][1]],

        round_sw_x = corner_sw[0] + rad_sw_x,
        round_sw_y = corner_sw[1] + rad_sw_y,

        round_nw_x = corner_nw[0] + rad_nw_x,
        round_nw_y = corner_nw[1] - rad_nw_y,

        round_ne_x = corner_ne[0] - rad_ne_x,
        round_ne_y = corner_ne[1] - rad_ne_y,

        round_se_x = corner_se[0] - rad_se_x,
        round_se_y = corner_se[1] + rad_se_y,
    )
    concat(
        //corner_sw,
        rad_sw_x > 0 && rad_sw_y > 0 ? concat(
            [
                [round_sw_x, corner_sw[1]]
            ],
        
            _mb_rcube_ellipse_arc_points(
                cx = round_sw_x,
                cy = round_sw_y,
                rx = rad_sw_x,
                ry = rad_sw_y,
                a0 = -180,
                a1 = -90,
                segments = 0.25 * rounding_resolution
            ),

            [
                [corner_sw[0], round_sw_y]
            ]
        ) : 
        [
            corner_sw
        ],
        //corner_nw,
        rad_nw_x > 0 && rad_nw_y > 0 ? concat(
            [
                [corner_nw[0], round_nw_y]
            ],
        
            _mb_rcube_ellipse_arc_points(
                cx = round_nw_x,
                cy = round_nw_y,
                rx = rad_nw_x,
                ry = rad_nw_y,
                a0 = 180,
                a1 = 90,
                segments = 0.25 * rounding_resolution
            ),

            [
                [round_nw_x, corner_nw[1]]
            ]
        ) : 
        [
            corner_nw
        ],
        //corner_ne,
        rad_ne_x > 0 && rad_ne_y > 0 ? concat(
            [
                [round_ne_x, corner_ne[1]]
            ],
        
            _mb_rcube_ellipse_arc_points(
                cx = round_ne_x,
                cy = round_ne_y,
                rx = rad_ne_x,
                ry = rad_ne_y,
                a0 = 90,
                a1 = 0,
                segments = 0.25 * rounding_resolution
            ),

            [
                [corner_ne[0], round_ne_y]
            ]
        ) : 
        [
            corner_ne
        ],
        //corner_se
        rad_se_x > 0 && rad_se_y > 0 ? concat(
            [
                [corner_se[0], round_se_y]
            ],
        
            _mb_rcube_ellipse_arc_points(
                cx = round_se_x,
                cy = round_se_y,
                rx = rad_se_x,
                ry = rad_se_y,
                a0 = 0,
                a1 = -90,
                segments = 0.25 * rounding_resolution
            ),

            [
                [round_se_x, corner_se[1]]
            ]
        ) : 
        [
            corner_se
        ]
        
        
    );

module mb_rcube(
    size,
    radius,
    rounding_resolution = 100
){
    size =  mb_cube_size_resolve(size);

    dim = [
            size[1][0] - size[0][0], 
            size[1][1] - size[0][1],
            size[1][2] - size[0][2]
        ];

    tz = 0.5 * (size[0][2] + size[1][2]);

    translate([0, 0, tz])
        linear_extrude(height = dim[2], center = true)
            polygon(
                points = _mb_rcube_profile_points(
                    size = size, 
                    radius = radius, 
                    rounding_resolution = rounding_resolution
                ),
                convexity = 10
            );
}


mb_rcube(
    size = [[-200, -100, -200], [100, 100, 100]],
    radius = [[0, 0], [150, 100], [150, 100], [150, 100]],
    rounding_resolution = 100
);

function mb_ellibox_inset_cap(z, rz_total, rz_axis, r_axis) =
    z < -rz_total + rz_axis
        ? let(t = (z + rz_total) / rz_axis)
            r_axis * (1 - sqrt(max(0, 1 - pow(1 - t, 2))))
    : z > rz_total - rz_axis
        ? let(t = (rz_total - z) / rz_axis)
            r_axis * (1 - sqrt(max(0, 1 - pow(1 - t, 2))))
    : 0;


// einfache "rounded rect" Approx (superellipse style)
function mb_ellibox_rr_point(theta, hx, hy, rx, ry) =
    let(
        ct = cos(theta),
        st = sin(theta),

        // superellipse trick
        nx = sign(ct) * pow(abs(ct), 0.5),
        ny = sign(st) * pow(abs(st), 0.5)
    )
    [
        nx * (hx - rx) + ct * rx,
        ny * (hy - ry) + st * ry
    ];


// corner index:
// 0 = sw = x-, y-
// 1 = nw = x-, y+
// 2 = ne = x+, y+
// 3 = se = x+, y-
function mb_ellibox_corner_theta0(corner_index) =
    corner_index == 0 || corner_index == 1 ? 180 :
    corner_index == 2 || corner_index == 3 ? 90  :
    corner_index == 4 || corner_index == 5 ? 0   :
                        270;


module mb_ellibox_octant(
    x_y, x_z,
    y_x, y_z,
    z_x, z_y,
    z_plane,
    corner_index,
    n_z = 24,
    n_a = 12,
    shell = "hull"
){
    rz = max(z_x, z_y);

    z0 = z_plane == 0 ? -rz : 0;
    z1 = z_plane == 0 ? 0   : rz;

    theta0 = mb_ellibox_corner_theta0(corner_index);
    theta1 = theta0 + 90;

    function ring_point(z, theta) =
        let(
            ix = mb_ellibox_inset_cap(z, rz, z_x, x_z),
            iy = mb_ellibox_inset_cap(z, rz, z_y, y_z),

            hx = max(0.001, max(x_y, x_z) - ix),
            hy = max(0.001, max(y_x, y_z) - iy),

            rx = min(x_y, hx),
            ry = min(y_x, hy)
        )
        concat(mb_ellibox_rr_point(theta, hx, hy, rx, ry), [z]);

    function outer_idx(i, j) = i * (n_a + 1) + j;

    outer_count = (n_z + 1) * (n_a + 1);

    center_base = outer_count;
    function center_idx(i) = center_base + i;

    inner_base = outer_count;
        inner_scale = 0.95;

        function inner_idx(i, j) = inner_base + outer_idx(i, j);
        function inner_point(p) = [p[0] * inner_scale, p[1] * inner_scale, p[2] * inner_scale];


    if(shell == "hull"){
        
        points_outer = [
            for(i = [0 : n_z])
                let(z = z0 + (z1 - z0) * i / n_z)
                    for(j = [0 : n_a])
                        let(theta = theta0 + (theta1 - theta0) * j / n_a)
                            ring_point(z, theta)
        ];

        points = concat(
            points_outer,
            [for(p = points_outer) inner_point(p)]
        );

        outer_faces = [
            for(i = [0 : n_z - 1])
                for(j = [0 : n_a - 1])
                    [outer_idx(i,j), outer_idx(i,j+1), outer_idx(i+1,j+1), outer_idx(i+1,j)]
        ];

        inner_faces = [
            for(i = [0 : n_z - 1])
                for(j = [0 : n_a - 1])
                    [inner_idx(i,j), inner_idx(i+1,j), inner_idx(i+1,j+1), inner_idx(i,j+1)]
        ];

        edge_bottom = [
            for(j = [0 : n_a - 1])
                [outer_idx(0,j), inner_idx(0,j), inner_idx(0,j+1), outer_idx(0,j+1)]
        ];

        edge_top = [
            for(j = [0 : n_a - 1])
                [outer_idx(n_z,j+1), inner_idx(n_z,j+1), inner_idx(n_z,j), outer_idx(n_z,j)]
        ];

        edge_start = [
            for(i = [0 : n_z - 1])
                [outer_idx(i+1,0), inner_idx(i+1,0), inner_idx(i,0), outer_idx(i,0)]
        ];

        edge_end = [
            for(i = [0 : n_z - 1])
                [outer_idx(i,n_a), inner_idx(i,n_a), inner_idx(i+1,n_a), outer_idx(i+1,n_a)]
        ];

        polyhedron(
            points = points,
            faces = concat(
                outer_faces,
                inner_faces,
                edge_bottom,
                edge_top,
                edge_start,
                edge_end
            ),
            convexity = 10
        );
    }
    else if(shell){
        fill_center = outer_count;

        p00 = ring_point(z0, theta0);
        p01 = ring_point(z0, theta1);
        p10 = ring_point(z1, theta0);
        p11 = ring_point(z1, theta1);

        fc = [
            (p00[0] + p01[0] + p10[0] + p11[0]) / 4,
            (p00[1] + p01[1] + p10[1] + p11[1]) / 4,
            (p00[2] + p01[2] + p10[2] + p11[2]) / 4
        ];

        points = concat(
            [
                for(i = [0 : n_z])
                    let(z = z0 + (z1 - z0) * i / n_z)
                        for(j = [0 : n_a])
                            let(theta = theta0 + (theta1 - theta0) * j / n_a)
                                ring_point(z, theta)
            ],
            [fc]
        );

        curved_faces = [
            for(i = [0 : n_z - 1])
                for(j = [0 : n_a - 1])
                    [outer_idx(i,j), outer_idx(i,j+1), outer_idx(i+1,j+1), outer_idx(i+1,j)]
        ];

        fill_bottom = [
            for(j = [0 : n_a - 1])
                [fill_center, outer_idx(0,j), outer_idx(0,j+1)]
        ];

        fill_end = [
            for(i = [0 : n_z - 1])
                [fill_center, outer_idx(i,n_a), outer_idx(i+1,n_a)]
        ];

        fill_top = [
            for(j = [0 : n_a - 1])
                [fill_center, outer_idx(n_z,j+1), outer_idx(n_z,j)]
        ];

        fill_start = [
            for(i = [0 : n_z - 1])
                [fill_center, outer_idx(i+1,0), outer_idx(i,0)]
        ];

        polyhedron(
            points = points,
            faces = concat(curved_faces, fill_bottom, fill_end, fill_top, fill_start),
            convexity = 10
        );
    }
    else {
        

        points = concat(
            [
                for(i = [0 : n_z])
                    let(z = z0 + (z1 - z0) * i / n_z)
                        for(j = [0 : n_a])
                            let(theta = theta0 + (theta1 - theta0) * j / n_a)
                                ring_point(z, theta)
            ],
            [
                for(i = [0 : n_z])
                    let(z = z0 + (z1 - z0) * i / n_z)
                        [0, 0, z]
            ]
        );

        curved_faces = [
            for(i = [0 : n_z - 1])
                for(j = [0 : n_a - 1])
                    [outer_idx(i,j), outer_idx(i,j+1), outer_idx(i+1,j+1), outer_idx(i+1,j)]
        ];

        cut_start = [
            for(i = [0 : n_z - 1])
                [center_idx(i), center_idx(i+1), outer_idx(i+1,0), outer_idx(i,0)]
        ];

        cut_end = [
            for(i = [0 : n_z - 1])
                [center_idx(i), outer_idx(i,n_a), outer_idx(i+1,n_a), center_idx(i+1)]
        ];

        cap_bottom = [
            for(j = [0 : n_a - 1])
                [center_idx(0), outer_idx(0,j+1), outer_idx(0,j)]
        ];

        cap_top = [
            for(j = [0 : n_a - 1])
                [center_idx(n_z), outer_idx(n_z,j), outer_idx(n_z,j+1)]
        ];

        polyhedron(
            points = points,
            faces = concat(curved_faces, cut_start, cut_end, cap_bottom, cap_top),
            convexity = 10
        );
    }
}


module mb_ellibox(
    x_y, x_z,
    y_x, y_z,
    z_x, z_y,
    n_z = 48,
    n_a = 48,

    // [z_plane, corner_index]
    // z_plane: 0 = unten, 1 = oben
    // corner_index: 0=sw, 1=nw, 2=ne, 3=se
    corner = [0, 0]
){
    nz_oct = max(1, floor(n_z / 2));
    na_oct = max(1, floor(n_a / 4));

    mb_ellibox_octant(
        x_y = x_y,
        x_z = x_z,
        y_x = y_x,
        y_z = y_z,
        z_x = z_x,
        z_y = z_y,
        z_plane = corner[0],
        corner_index = corner[1],
        n_z = nz_oct,
        n_a = na_oct
    );
}


/*
* --------------
* START EXAMPLES
* --------------
*/



c = [0, 6];
rad = [[2,2], [3,3], [4,4]];

mb_ellibox(
    x_y = rad[0][0],
    y_x = rad[0][1],

    x_z = rad[1][0],
    z_x = rad[1][1],

    y_z = rad[2][0],
    z_y = rad[2][1],

    n_z = 64,
    n_a = 64,

    corner = c // oben, ne
);
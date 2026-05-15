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


module mb_ellibox(
    x_y, x_z,
    y_x, y_z,
    z_x, z_y,
    n_z = 48,
    n_a = 48
){
    rz = max(z_x, z_y);
    h  = 2 * rz;

    function ring(z) =
        let(
            ix = mb_ellibox_inset_cap(z, rz, z_x, x_z),
            iy = mb_ellibox_inset_cap(z, rz, z_y, y_z),

            hx = max(0.001, max(x_y, x_z) - ix),
            hy = max(0.001, max(y_x, y_z) - iy),

            rx = min(x_y, hx),
            ry = min(y_x, hy)
        )
        [
            for (a = [0 : n_a-1])
                let(theta = 360 * a / n_a)
                    concat(
                        mb_ellibox_rr_point(theta, hx, hy, rx, ry),
                        [z]
                    )
        ];

    // Punkte
    points = [
        for (i = [0 : n_z])
            let(z = -rz + i * h / n_z)
                each ring(z)
    ];

    // Faces
    faces = [
        for (i = [0 : n_z-1])
            for (j = [0 : n_a-1])
                let(
                    a = i*n_a + j,
                    b = i*n_a + (j+1)%n_a,
                    c = (i+1)*n_a + (j+1)%n_a,
                    d = (i+1)*n_a + j
                )
                [a,b,c,d]
    ];

    polyhedron(points = points, faces = faces, convexity = 10);
}

/*
* --------------
* START EXAMPLES
* --------------
*/


color("red")
// Test
mb_ellibox(
    x_y = 20,
    x_z = 40,
    y_x = 10,
    y_z = 20,
    z_x = 20,
    z_y = 10,

    n_z = 64,
    n_a = 64
);
function mb_loft_valid_point(p) =
    p[0] != undef;

function mb_loft_p3(p) =
    [p[0], p[1], p[2]];

function mb_loft_level_points(level) =
    [
        for (p = level)
        if (mb_loft_valid_point(p))
        mb_loft_p3(p)
    ];

function mb_loft_next(i, n) =
    (i + 1) % n;

function mb_loft_bottom_faces(n) =
    [for (i = [1 : n - 2]) [0, i, i + 1]];

function mb_loft_top_faces(n) =
    [for (i = [1 : n - 2]) [n, n + i + 1, n + i]];

function mb_loft_side_faces_a(n) =
    [
        for (i = [0 : n - 1])
        let(j = mb_loft_next(i, n))
        [i, n + i, n + j]
    ];

function mb_loft_side_faces_b(n) =
    [
        for (i = [0 : n - 1])
        let(j = mb_loft_next(i, n))
        [i, n + j, j]
    ];

function mb_loft_faces(n) =
    concat(
        mb_loft_bottom_faces(n),
        mb_loft_top_faces(n),
        mb_loft_side_faces_a(n),
        mb_loft_side_faces_b(n)
    );

module mb_loft_polyhedron(levels, convexity = 10) {
    bottom = mb_loft_level_points(levels[0]);
    top    = mb_loft_level_points(levels[1]);
    n      = len(bottom);
    echo(bottom = bottom, top = top);
    assert(len(levels) == 2);
    assert(n == len(top));
    assert(n >= 3);
    assert(n <= 8);

    polyhedron(
        points = concat(bottom, top),
        faces = mb_loft_faces(n),
        convexity = convexity
    );
}

mb_loft_polyhedron(
    [[[-23.9, -7.9, -4.8, [[0, 0], [0, 0], [0, 0]]], undef, [-23.9, 7.9, -4.8, [[0, 0], [0, 0], [0, 0]]], undef, [15.9, 7.9, -4.8, [[0, 0], [0, 0], [0, 0]]], undef, [15.9, -7.9, -4.8, [[0, 0], [0, 0], [0, 0]]], undef], [[-23.9, -7.9, 1.6, [[0, 0], [0, 0], [0, 0]]], undef, [-23.9, 7.9, 1.6, [[0, 0], [0, 0], [0, 0]]], undef, [15.9, 7.9, 1.6, [[0, 0], [0, 0], [0, 0]]], undef, [15.9, -7.9, 1.6, [[0, 0], [0, 0], [0, 0]]], undef]]
    , debug = false);


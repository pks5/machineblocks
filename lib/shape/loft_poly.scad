function mb_point3(p) =
    p == undef ? undef : [p[0], p[1], p[2]];

function mb_defined_points(level) =
    [for (p = level) if (p != undef) mb_point3(p)];

function mb_range(n) =
    [for (i = [0 : n - 1]) i];

module mb_loft_polyhedron(levels, convexity = 10) {
    bottom = mb_defined_points(levels[0]);
    top    = mb_defined_points(levels[1]);
    n      = len(bottom);

    assert(len(levels) == 2);
    assert(n == len(top));
    assert(n >= 3);
    assert(n <= 8);

    points = concat(bottom, top);

    faces = concat(
        [mb_range(n)],
        [[for (i = [n - 1 : -1 : 0]) n + i]],
        [
            for (i = [0 : n - 1])
            let(j = (i + 1) % n)
            [i, n + i, n + j, j]
        ]
    );

    polyhedron(points = points, faces = faces, convexity = convexity);
}
function mb_clamp(x, a, b) = max(a, min(b, x));
function mb_make_even(n)   = (n % 2 == 0) ? n : (n + 1);

function mb_fn_for_radius(
    r,
    q,

    // --- quality model ---
    seg_base,          // base mm per segment
    q_factors,         // array: per-class segment factors
    fn_min_by_q,       // array: per-class minimum $fn

    // --- global limits ---
    fn_max,

    // --- master quality knob ---
    fn_mult = 1.0
) =
    let(
        rr = max(0.01, r),
        seg = (seg_base * q_factors[q]) * fn_mult,
        fn_raw = (2 * PI * rr) / seg,
        fn_rounded = ceil(fn_raw),
        fn_min = fn_min_by_q[q]
    )
    mb_clamp(fn_rounded, fn_min, fn_max);

function mb_fn_even_for_radius(
    r,
    q,
    seg_base,
    q_factors,
    fn_min_by_q,
    fn_max,
    fn_mult = 1.0
) =
    mb_make_even(
        mb_fn_for_radius(
            r,
            q,
            seg_base,
            q_factors,
            fn_min_by_q,
            fn_max,
            fn_mult
        )
    );

// ------------------------------------------------------------
// Quality class enums (global ok)
MB_Q_FUNCTIONAL = 0;
MB_Q_VISUAL     = 1;
MB_Q_OTHER      = 2;
MB_Q_DRAFT      = 3;

// ------------------------------------------------------------
// Helpers
function mb_clamp(x, a, b) = max(a, min(b, x));
function mb_make_even(n)   = (n % 2 == 0) ? n : (n + 1);

// Map previewQuality 0..1 to a multiplier that reduces quality in preview.
// previewQuality=1 -> factor=1 (no change)
// previewQuality=0 -> factor=previewMaxMult (strong reduction)
function mb_preview_mult(previewQuality, previewMaxMult) =
    let(p = mb_clamp(previewQuality, 0, 1))
    1 + (1 - p) * (previewMaxMult - 1);

function mb_max_radius(r) =
    is_list(r)
      ? (len(r) == 0
          ? 0
          : max([ for (e = r) mb_max_radius(e) ]))
      : r;

// Main: radius + class -> $fn, with previewQuality applied only when $preview is true
function mb_fn_for_radius(
    r,
    q,

    // quality model
    seg_base,          // base mm per segment
    q_factors,         // array per class
    fn_min_by_q,       // array per class min $fn

    // limits
    fn_max,

    // master knob (final / normal)
    fn_mult = 1.0,

    // preview controls
    previewQuality = 1.0,     // 0..1
    previewMaxMult = 2.5,     // how much coarser at previewQuality=0
    is_preview = $preview     // allow override if desired
) =
    let(
        rr = max(0.01, mb_max_radius(r)),

        // preview reduces quality by INCREASING segment length
        // (bigger segment length => fewer segments => lower $fn)
        pm = is_preview ? mb_preview_mult(previewQuality, previewMaxMult) : 1.0,

        seg = (seg_base * q_factors[q]) * fn_mult * pm,
        fn_raw = (2 * PI * rr) / seg,
        fn_rounded = ceil(fn_raw),
        fn_min = fn_min_by_q[q]
    )
    mb_clamp(fn_rounded, fn_min, fn_max);

// Even wrapper
function mb_fn_even_for_radius(
    r, q,
    seg_base, q_factors, fn_min_by_q, fn_max,
    fn_mult = 1.0,
    previewQuality = 1.0,
    previewMaxMult = 2.5,
    is_preview = $preview
) =
    mb_make_even(
        mb_fn_for_radius(
            r, q,
            seg_base, q_factors, fn_min_by_q,
            fn_max,
            fn_mult,
            previewQuality,
            previewMaxMult,
            is_preview
        )
    );

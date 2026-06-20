// ============================================================================
// MachineBlocks Quality System
// Works with `use <...>` because all exported values are functions.
// ============================================================================

// ----------------------------------------------------------------------------
// Quality classes

function mb_q_functional() = 0; // fit-critical
function mb_q_visual()     = 1; // visible
function mb_q_hidden()     = 2; // internal / invisible

// ----------------------------------------------------------------------------
// User quality presets

function mb_q_preview() = 0;
function mb_q_normal()  = 1;
function mb_q_print()   = 2;
function mb_q_render()  = 3;

function mb_q_preset_from_quality(quality) =
    quality == "preview" ? mb_q_preview() :
    quality == "normal"  ? mb_q_normal()  :
    quality == "print"   ? mb_q_print()   :
    quality == "render"  ? mb_q_render()  :
                           mb_q_normal();

// ----------------------------------------------------------------------------
// Default mappings
//
// Profile row: [segment_length_mm, fn_max]
// Smaller segment length = higher quality.

function mb_q_default_profile() =
[
    [0.55, 32],    // preview
    [0.38, 48],    // normal
    [0.28, 64],    // print
    [0.16, 120]    // render
];

function mb_q_default_class_factors() =
[
    1.00,          // functional
    1.35,          // visual
    2.25           // hidden
];

function mb_q_default_class_min_fn() =
[
    16,            // functional
    12,            // visual
    8              // hidden
];

// ----------------------------------------------------------------------------
// Helpers

function mb_q_clamp(x, a, b) =
    max(a, min(b, x));

function mb_q_make_even(n) =
    (n % 2 == 0) ? n : (n + 1);

function mb_q_safe_class(q) =
    mb_q_clamp(q, mb_q_functional(), mb_q_hidden());

function mb_q_safe_preset(q) =
    mb_q_clamp(q, mb_q_preview(), mb_q_render());

function mb_q_max_radius(r) =
    is_list(r)
        ? (
            len(r) == 0
                ? 0
                : max([for (e = r) mb_q_max_radius(e)])
        )
        : r;

// ----------------------------------------------------------------------------
// Preview multiplier
//
// previewQuality:
//   1 = no preview reduction
//   0 = strongest preview reduction
//
// previewMaxMult is applied to segment length, not directly to fn.

function mb_q_preview_mult(previewQuality, previewMaxMult) =
    let(p = mb_q_clamp(previewQuality, 0, 1))
    1 + (1 - p) * (previewMaxMult - 1);

// ----------------------------------------------------------------------------
// Full-circle fn resolver
//
// Contract:
//   returned fn = segment count for a complete 360° circle.
//
// Responsibility:
//   Part/feature chooses class.
//   Shape receives only resolution/fn.

function mb_q_fn_for_radius(
    r,
    q,

    preset = undef,

    profile = undef,
    class_factors = undef,
    class_min_fn = undef,

    fn_mult = 1.0,

    previewQuality = 1.0,
    previewMaxMult = 2.5,
    is_preview = $preview
) =
    let(
        qq = mb_q_safe_class(q),

        pp = mb_q_safe_preset(
            is_undef(preset) ? mb_q_normal() : preset
        ),

        prof = is_undef(profile)
            ? mb_q_default_profile()
            : profile,

        factors = is_undef(class_factors)
            ? mb_q_default_class_factors()
            : class_factors,

        min_fn = is_undef(class_min_fn)
            ? mb_q_default_class_min_fn()
            : class_min_fn,

        rr = max(0.01, mb_q_max_radius(r)),

        seg_base = prof[pp][0],
        fn_max   = prof[pp][1],

        pm = is_preview
            ? mb_q_preview_mult(previewQuality, previewMaxMult)
            : 1.0,

        // Bigger segment length => fewer full-circle segments.
        seg = seg_base * factors[qq] * fn_mult * pm,

        fn_raw = (2 * PI * rr) / seg,
        fn_rounded = ceil(fn_raw)
    )
    mb_q_clamp(fn_rounded, min_fn[qq], fn_max);

// ----------------------------------------------------------------------------
// Even full-circle fn resolver
//
// Use for cylinders, tubes, studs, holes, and symmetric round geometry.

function mb_q_fn_even_for_radius(
    r,
    q,

    preset = undef,

    profile = undef,
    class_factors = undef,
    class_min_fn = undef,

    fn_mult = 1.0,

    previewQuality = 1.0,
    previewMaxMult = 2.5,
    is_preview = $preview
) =
    mb_q_make_even(
        mb_q_fn_for_radius(
            r = r,
            q = q,
            preset = preset,
            profile = profile,
            class_factors = class_factors,
            class_min_fn = class_min_fn,
            fn_mult = fn_mult,
            previewQuality = previewQuality,
            previewMaxMult = previewMaxMult,
            is_preview = is_preview
        )
    );

// ----------------------------------------------------------------------------
// Partial arc helpers
//
// Preserve the full-circle contract:
//
//   360° -> fn
//   180° -> fn / 2
//    90° -> fn / 4

function mb_q_fn_for_angle(fn, angle, min_n = 3) =
    max(min_n, ceil(fn * abs(angle) / 360));

function mb_q_fn_for_quarter(fn, min_n = 4) =
    mb_q_fn_for_angle(fn, 90, min_n);

function mb_q_fn_for_half(fn, min_n = 6) =
    mb_q_fn_for_angle(fn, 180, min_n);

// ============================================================================
// Usage examples
// ============================================================================

// Stud: functional
module example_q_stud(radius = 2.4, quality = undef) {
    fn = mb_q_fn_even_for_radius(
        r = radius,
        q = mb_q_functional(),
        preset = quality
    );

    cylinder(r = radius, h = 1.8, $fn = fn);
}

// Brick corner: visual
module example_q_brick_corner(radius = 1.0, quality = undef) {
    fn = mb_q_fn_for_radius(
        r = radius,
        q = mb_q_visual(),
        preset = quality
    );

    // mb_corner(radius = radius, resolution = fn);
}

// Groove: hidden
module example_q_groove(radius = 0.3, quality = undef) {
    fn = mb_q_fn_for_radius(
        r = radius,
        q = mb_q_hidden(),
        preset = quality
    );

    // mb_corner(radius = radius, resolution = fn);
}

// Shape-level quarter arc
module example_q_shape_corner(radius = 1.0, resolution = 64) {
    n_a = mb_q_fn_for_quarter(resolution);

    echo(full_circle_resolution = resolution);
    echo(quarter_arc_segments = n_a);
}
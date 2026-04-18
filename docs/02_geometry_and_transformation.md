# MachineBlocks — Geometry, Transformation & Structure Concepts

version: 2.0.0

## Purpose of this Document

This document explains the concepts and relationships behind MachineBlocks geometry, transformation, and structure parameters. It does not repeat parameter definitions — for all parameter details (types, defaults, formats, constraints), see `09_api_parameters_1_0_1.yml`.

---

# Core Geometry Concepts

## Bounding Box Principle

The bounding box is defined exclusively by `size`. No other parameter modifies the bounding box — only the visible geometry inside it. For simple blocks, the bounding box matches the visible geometry. For complex blocks (slopes, wedges, recess structures), the bounding box defines the structural outer space while visible geometry may be smaller.

> `size` defines the spatial contract of a block.

## Grid Aspect Ratio

The grid is asymmetric: X/Y use `unitGrid[0]` (default 5 mbu = 8 mm per unit) while Z uses `unitGrid[1]` (default 2 mbu = 3.2 mm per unit). This means the ratio of XY to Z is 2.5:1. A `size` of `[1,1,1]` does not produce a cube — it produces a flat plate (8×8×3.2 mm).

To produce a cube, the Z value must be 2.5 times the XY value. Since `size` values should be whole numbers for grid compatibility, the AI must approximate. For example, a cube-like block could be `[1,1,3]` (8×8×9.6 mm) or `[2,2,5]` (16×16×16 mm) or `[4,4,10]` (32×32×32 mm).

> AI must always account for the 1:2.5 XY-to-Z ratio when estimating sizes. Assuming 1:1 produces visually squashed models.

## Shape Modification

Core geometry parameters modify the block shape within the bounding box in distinct ways:

`size` defines space. `slope` modifies height per side — positive values slope the top surface, negative values create inverted slopes on the bottom. `bevel` modifies the footprint by shifting top corners in XY space, producing wedge shapes. `crop` applies hard cuts or extensions to the geometry.

### Key Relationships

Slope modifies height, not footprint. Bevel modifies footprint, not height. Slope and bevel cannot be combined — this is a hard constraint. Crop does not affect bounding box or positioning. Corner rounding is applied after cropping.

> Wedges are not a primitive — they emerge from bevel transformations.

## Cutouts

`cutouts` is an array of settings arrays. Each inner array defines one cutout volume using native parameters relevant to geometry and size (`size`, `offset`, `bevel`, `slope`, `*Adjustment`, `crop`, and any other parameters that affect the shape of the cut volume). The cutout is applied as a boolean subtraction from the block body — brutally, without regard to walls, recess, or other structure.

Not all parameters are meaningful in a cutout context. Parameters that only control surface features or rendering are ignored.

```scad
settings = [
    ["size", [8, 8, 8]],
    ["cutouts", [
        [["size", [1, 1, 1]], ["offset", [0, 1, 1]]],
        [["size", [1, 2, 3]], ["offset", [2, 1, 4]]]
    ]]
]
```

---

# Transformation Concepts

## Transformation Order

Transformations are applied in a strict order after geometry and children are built:

```text
1. Resolve parameters
2. Build own geometry (local space)
3. Build children (local space)
4. Apply direction
5. Apply align
6. Apply rotationOffset
7. Apply rotation
8. Apply rotationOffsetRevert
9. Apply offset
```

> Positioning parameters never change geometry — they only transform it.

## Direction vs Rotation

These two parameters serve fundamentally different purposes and must not be confused.

### direction — Semantic Orientation

`direction` is the semantic grid-aligned orientation of a block. It is applied before alignment, rotates the block in 90-degree increments, and affects the interpretation of `size` (swaps X/Y at 90 and 270 degrees). It does not change side numbering or corner indexing. It is grid-safe.

Blocks are always designed in west orientation. Direction is applied during placement.

**Direction integer values:**

```text
"west"  → 0
"north" → 1
"east"  → 2
"south" → 3
```

`mb_param_direction()` always returns an integer. String input is accepted and converted automatically.

### rotation — Free Geometric Rotation

`rotation` is a free geometric rotation applied after alignment. It is not grid-safe and can break alignment assumptions and connectivity. Children are rotated along with the parent. The pivot depends on the current alignment.

> Use `direction` for grid-aligned orientation. Use `rotation` only as a last-resort transformation.

### rotationOffset — Pivot Control

`rotationOffset` shifts the rotation pivot before rotation is applied. If `rotationOffsetRevert = true`, the offset is reversed after rotation.

> `rotationOffset` controls the pivot of rotation; `offset` controls final placement.

## Direction Arithmetic

Two directions can be combined using:

```scad
mb_direction_resolve(dir1, dir2)
```

This adds the two directions and wraps at 4. Accepts both strings and integers. Always returns an integer.

```text
Rule: (dir1_as_int + dir2_as_int) % 4

"west" + "north" = 0 + 1 = 1 → "north"
"north" + "east" = 1 + 2 = 3 → "south"
```

## Size Resolution by Direction

To resolve a size value according to a direction (swapping X and Y for north/south):

```scad
mb_size_resolve(size, direction)
```

Returns the size array with X and Y swapped if direction is north (1) or south (3).

## Alignment System

### align

`align` defines how a block is positioned relative to its reference space (per axis: `start`, `center`, `end`). It is applied after `direction` and is based strictly on the bounding box.

Alignment does NOT consider studs, slope, bevel, crop, or adjustments. It only considers the bounding box.

### alignChildren

`alignChildren` defines the origin inside a parent block for child positioning. Default is `["start","start","start"]` — the lower-left-near corner of the parent.

> `alignChildren` defines the reference frame — `align` positions within it.

### offset

`offset` is the final positional displacement, applied last in the transformation chain. It is not a rotation helper and is not rotated itself. If a block has no parent and uses default alignment, `offset` behaves like absolute placement in the global grid.

---

# Structure Concepts

## Four Structure Systems

Structure parameters form four distinct systems, each with a clear responsibility:

### 1. Body System

`base` controls whether the main body is generated. Setting `base = false` hides the body but retains all features and children. This is purely visual — it has no effect on bounding box, alignment, size, or calculations.

### 2. Underside System

`baseCutoutType` defines the underside structure:

`standard` provides the classic LEGO tube structure. `studs` provides individual holes per stud. `groove` is the counterpart to `tongue`. `none` provides a solid underside.

`baseWallGapsX` and `baseWallGapsY` restore grid compatibility in composite blocks where blocks cross each other's underside walls.

### 3. Enclosure System

`recess` creates a top-down cavity. `recessWallThickness` defines wall thickness per side. `recessWallGaps` creates controlled openings.

> Use `recessWallGaps` to create openings — never set `recessWallThickness = 0` for this purpose.

### 4. Connection System

**tongue + groove** — continuous connection strip. **connectors** — segmented side connection elements.

> Choose `tongue` for continuous connections. Choose `connectors` for angled or modular connections.

## Studs and studSink

`studSink` defines how deeply the stud is sunk into the block body (unit: mbu, default: 0.25). This is important for:

- Ensuring the model is geometrically connected (no floating stud)
- Preventing gaps when `grille` or `surfacePattern` is active
- Allowing body-less stud-only configurations in composite blocks (set to 0)

> `studSink = 0` is valid and intentional when a block has `base = false` but still renders studs.

## Geometry vs Structure

Geometry defines shape (what the block looks like). Structure defines function (how the block behaves physically). Both operate within the same bounding box but address different concerns.

---

# Composite Block Concepts

## Assembly System

The `assembly` parameter is a native parameter recognized by composite block modules (not by `mb_block()` itself). It controls how the parts of a composite block are displayed.

### Format

**String format:**
```text
"unassembled" | "assembled" | "merged"
```

**Array format** (required when this block is itself a child of another composite block):
```text
[mode, [sX, sY, sZ], direction]
```

Where `[sX, sY, sZ]` is the already direction-resolved size of the outer composite block, and `direction` is the aggregated direction through the full block tree. Both are only relevant for `unassembled` mode.

### Modes

`unassembled` — parts are laid out individually, spaced 4mm apart along the X-axis for printing. `assembled` — parts shown in connected position including internal geometry. `merged` — parts fused into a single body; tongue/groove and internal voids are suppressed.

### mb_assembly()

Inside a composite block module, always resolve assembly via:

```scad
assembly = mb_assembly(config, settings, size, direction);
```

This returns a normalized array `[mode, resolvedSize, aggregatedDirection]`. The function:
- Reads the raw `assembly` value from settings/config
- Resolves string format to array format
- Resolves `size` via `mb_size_resolve(size, direction)` for correct part layout
- Aggregates direction through the block tree using `mb_direction_resolve()`

Always use `assembly[0]` to check the mode string.

### mb_assembly_offset()

Pass the assembly result and the normal assembled offset to child parts:

```scad
["offset", mb_assembly_offset(assembly, [0, 0, size[2] - 1])]
```

Returns the unassembled layout offset when `assembly[0] == "unassembled"`, otherwise returns the normal offset.

### Direction Propagation in Assembly

The direction in the assembly parameter represents the **aggregated direction through the entire block tree**. When a parent has `direction = "north"` and a child has `direction = "east"`, the child receives `"south"` in its assembly parameter. `mb_assembly()` handles this automatically.

The size in the assembly parameter must already be direction-resolved (X and Y swapped for north/south). `mb_assembly()` handles this automatically via `mb_size_resolve()`.

## Named Side Adjustments

### The Problem

Consumer-grade 3D printers typically print slightly too wide, causing adjacent blocks not to fit together. `baseSideAdjustment` compensates by reducing each side by a small amount (e.g. -0.1mm). In a simple primitive this works directly. In a composite block whose parts do not overlap at their contact faces, a negative `baseSideAdjustment` creates a visible gap or zero-thickness wall between adjacent parts. OpenSCAD's `union()` only fuses geometry that actually overlaps — touching faces alone are not sufficient.

The fix is to ensure a small positive overlap (typically 0.01mm) at every internal contact face, while all outer faces still use the calibration value from `baseSideAdjustment`.

### baseSideAdjustment in Composite Blocks

A composite block reads `baseSideAdjustment` once and then manually builds the per-side array for each primitive. Side indices always refer to west orientation regardless of the primitive's `direction`. When a primitive is rotated, side indices must be remapped accordingly.

For primitives: set the calibration value (`baseSideAdjustment[0]`) on all outer sides, and `0.01` on all internal contact sides. Since `baseSideAdjustment` in config is always a single uniform value, `baseSideAdjustment[0]` is the canonical calibration value to use.

The getter always returns a 4-element array. After calling it, always access `baseSideAdjustment[0]` — never use the array variable directly as if it were a scalar.

```scad
// Read once at the top of the module
baseSideAdjustment = mb_param_baseSideAdjustment(config, settings);

// WRONG — baseSideAdjustment is an array, not a scalar
totalSizeY = size[1] * unitGrid[0] * unitMbu + 2 * baseSideAdjustment;

// CORRECT — always use [0] to extract the calibration value
totalSizeY = size[1] * unitGrid[0] * unitMbu + 2 * baseSideAdjustment[0];

// WRONG — passing the array directly to a primitive without building per-side values
mb_block(config = config, settings = [
    ["baseSideAdjustment", baseSideAdjustment]
]);

// CORRECT — build per-side array explicitly for each primitive
// Side 0 = x- (west outer face)   → calibration value
// Side 1 = x+ (east inner face)   → overlap (internal contact)
// Side 2 = y- (south outer face)  → calibration value
// Side 3 = y+ (north outer face)  → calibration value
mb_block(config = config, settings = [
    ["baseSideAdjustment", [baseSideAdjustment[0], 0.01, baseSideAdjustment[0], baseSideAdjustment[0]]]
]);
```

### namedSideAdjustments — For Composite-of-Composite Blocks

When an outer composite block places multiple child composite blocks adjacent to each other, the same gap problem arises at their contact faces. However, a child composite block can have more than 4 logical sides, so a 4-element `baseSideAdjustment` array is insufficient to address individual contact faces.

The solution: the child composite block defines **named sides** for its contact faces. The outer block then passes a `namedSideAdjustments` array to push those specific faces into overlap.

Inside the child composite block module, named sides are resolved using `mb_named_side_adjustments()`:

```scad
baseSideAdjustment = mb_param_baseSideAdjustment(config, settings);
namedSideAdjustments = mb_param_namedSideAdjustments(config, settings);
panelSideAdjustment = mb_named_side_adjustments(
    baseSideAdjustment,
    namedSideAdjustments,
    [[2, "start"], [3, "end"]]
);
```

The third argument maps side indices (always in west orientation) to named side keys. A fixed float value may also be used instead of a name, applying that value unconditionally for that side.

The fourth argument `useFirst` (default `true`) controls the base:
- `useFirst = true` (default): `baseSideAdjustment[0]` is used as the base value for all sides. Values `[1–3]` of `baseSideAdjustment` are ignored. This is correct for composite blocks with more than 4 sides.
- `useFirst = false`: the full 4-element `baseSideAdjustment` array is used as base. Only appropriate for composite blocks with exactly 4 sides that support full per-side calibration.

The outer block passes the adjustments to the child:

```scad
["namedSideAdjustments", [["start", 0.01], ["end", 0.01]]]
```

Composite blocks must never receive a `baseSideAdjustment` with differing values to control contact faces — use `namedSideAdjustments` instead.

### Pattern Summary

**Primitive:** Always use `baseSideAdjustment` directly. All 4 sides may differ. `bevel`, `crop`, and rounding are adjusted automatically.

**Composite with exactly 4 sides:** Two options:
1. Manual mapping — the module builds the per-primitive `baseSideAdjustment` arrays directly. All 4 values may differ (passed from outside).
2. Define 4 named sides — then the same rules as the next case apply.

**Composite with more than 4 sides:** Must use named sides + `mb_named_side_adjustments()` with `useFirst = true`. Only `baseSideAdjustment[0]` is ever used as the base value. `baseSideAdjustment` passed to this block from outside must be a single uniform value.

## Parts and Total Size

When a composite block derives its size from its parts rather than defining it explicitly:

```scad
parts = [
    [[4, 4, 9], "west", [0, 0, 0]],
    [[1, 8, 9], "west", [0, 4, 0]],
    [[4, 4, 9], "north", [0, 12, 0]]
];
size = mb_parts_total_size(parts);
```

Each entry in `parts` is `[size, direction, offset]`. The function computes the bounding box of all parts combined.

---

# Common Pitfalls

**`mb_base_side_adjustment()` no longer exists.** Use `mb_param_baseSideAdjustment()` + `mb_param_namedSideAdjustments()` + `mb_named_side_adjustments()` instead.

**`baseSideAdjustment` in config must always be a single uniform value.** Composite blocks use only `baseSideAdjustment[0]` as their calibration base. Differing values in config would be silently misapplied.

**Never pass differing `baseSideAdjustment` values to a composite block.** To control contact faces of a child composite block, use `namedSideAdjustments` instead.



**Offset is not a rotation tool.** Use `rotationOffset` for pivot control.

**Side indices never change with direction.** They always refer to west-oriented local block space.

**Align affects rotation results.** Different alignments produce different effective rotation results.

**Children are built before parent transforms.** They are built first in local space, then transformed together.

**baseWallThickness is not a design variable.** It is a compatibility constant. Use `baseWallThicknessAdjustment` in config for calibration.

**Wall openings must use recessWallGaps.** Setting `recessWallThickness = 0` does not create clean openings.

**tongue works without recess.** The tongue connection system does not require recess.

**assembly[0] is always the mode string.** Always check `assembly[0]` after resolving via `mb_assembly()`.

**Never use mb_param_*() for custom parameters.** Only use `mb_param_size()` etc. for parameters that are native to `mb_block()`.

---

## Parameter Reference

For all parameter definitions, types, defaults, formats, constraints, and AI usage guidelines, see `09_api_parameters_1_0_1.yml`.

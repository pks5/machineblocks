# MachineBlocks — Geometry, Transformation & Structure Concepts

version: 3.0.2

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

`size` defines space (integer values only). `sizeMod` provides semantic per-side modification while keeping the brick structurally intact. `slope` modifies height per side — positive values slope the top surface, negative values create inverted slopes on the bottom. `bevel` modifies the footprint by shifting top corners in XY space, producing wedge shapes. `crop` applies hard cuts or extensions to the geometry.

### Key Relationships

Slope modifies height, not footprint. Bevel modifies footprint, not height. Slope and bevel can be combined. `crop` is a hard cut — it does not preserve grid compatibility, walls, or structural features. Use `sizeMod` for semantic size changes that keep the brick intact. Crop does not affect bounding box or positioning. Corner rounding is applied after cropping.

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
["offset", mb_assembly_offset([0, 0, size[2] - 1], assembly, renderGroups, group_top)]
```

Returns the unassembled layout offset when `assembly[0] == "unassembled"`, otherwise returns the normal offset.

### Direction Propagation in Assembly

The direction in the assembly parameter represents the **aggregated direction through the entire block tree**. When a parent has `direction = "north"` and a child has `direction = "east"`, the child receives `"south"` in its assembly parameter. `mb_assembly()` handles this automatically.

The size in the assembly parameter must already be direction-resolved (X and Y swapped for north/south). `mb_assembly()` handles this automatically via `mb_size_resolve()`.

## Side and Size Adjustments

### The Problem

Consumer-grade 3D printers typically print slightly too wide, causing adjacent blocks not to fit together. `sizeAdjustment` and `baseAdjustment` compensate for this. In a simple primitive this works directly. In a composite block whose parts do not overlap at their contact faces, a negative side adjustment creates a visible gap or zero-thickness wall between adjacent parts. OpenSCAD's `union()` only fuses geometry that actually overlaps — touching faces alone are not sufficient.

The fix is to ensure a small positive overlap (typically 0.01mm) at every internal contact face, while all outer faces still use the calibration value.

### sizeAdjustment — Global Calibration (Since: V3)

`sizeAdjustment` is a 2-element array `[sideXYAdj, heightAdj]` in mm, typically set once in the global config.

```scad
// In mb_config:
["sizeAdjustment", [-0.1, 0]]
```

`mb_block()` applies `sideXYAdj` to all four horizontal sides (x-, x+, y-, y+) and `heightAdj` to the top face (z+) only. Default: `[-0.1, 0]`.

### baseAdjustment — Per-Block Fine-Tuning

`baseAdjustment` is a pseudo-map in the format `[["side", value], ...]`. It is always empty by default. `mb_block()` interprets only the standard sides: `"x-"`, `"x+"`, `"y-"`, `"y+"`, `"z-"`, `"z+"`. Sides may also be referenced by integer index (0–5), but string identifiers are preferred.

```scad
["baseAdjustment", [["x-", 0], ["z+", 0.1]]]
```

Unlike `sizeAdjustment`, `baseAdjustment` allows individual control over all six sides including `z-` and `z+`. This replaces the V2 `baseHeightAdjustment` parameter.

**z- special behaviour:** A `z-` value does not reduce block height from below. Instead it shifts the brick downward by the z- amount (independent of `offset`) and extends `z+` correspondingly. This is useful for closing gaps in composite blocks.

The same `z-` special behaviour applies to `sizeMod`. The difference is semantic: `baseAdjustment` is for printer calibration and composite block gap closing; `sizeMod` is for intentional geometry changes (e.g. half-bricks).

### Namespace Support in baseAdjustment

`baseAdjustment` supports namespaced keys for passing adjustments into child composite blocks. Namespace and side are separated by a dot:

```scad
["baseAdjustment", [["pbx.x+", 0.01], ["pty.z+", 0.1]]]
```

Inside the child composite block, `mb_params_filter()` extracts the values for a specific namespace, removing the prefix:

```scad
["baseAdjustment", mb_params_filter(baseAdjustment, "pbx")]
// [["pbx.x+", 0.01]] → [["x+", 0.01]]
```

Namespaces typically correspond to part names, but can be freely chosen.

### mb_params_filter()

```scad
mb_params_filter(param, namespace, overrides?)
```

Filters any `[[string, value]]` pseudo-map by namespace prefix. Entries without a namespace and entries with numeric keys are ignored. An optional third argument applies fixed overrides after filtering:

```scad
mb_params_filter(baseAdjustment, "pbx", [["x+", 0.1]])
// x+ is always 0.1 in the result, regardless of input
```

`mb_params_filter` is universal — it can be applied to any parameter using the pseudo-map format, such as `baseWallGaps`.

### Pattern Summary

**Simple primitive:** Use `sizeAdjustment` in config for global calibration. Use `baseAdjustment` for per-side fine-tuning where needed.

**Composite block:** Read `baseAdjustment` once at the top of the module. For each part, use `mb_params_filter(baseAdjustment, namespace)` to extract the relevant values. For internal contact faces, ensure a small positive overlap (0.01mm) by using fixed overrides in `mb_params_filter` or by including the contact-side explicitly.

**Composite-of-composite:** The outer block passes namespaced `baseAdjustment` entries to each child composite block. The child uses `mb_params_filter` to extract its values per namespace.

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

**`sizeAdjustment` is the global calibration entry point.** Set it once in config. Use `baseAdjustment` only for per-block or per-side overrides.

**`baseAdjustment` is a pseudo-map, not a scalar or 4-element array.** Always use the `[[side, value]]` format. `mb_block()` interprets only standard sides (x-, x+, y-, y+, z-, z+).

**Never pass differing namespaced `baseAdjustment` values to a composite block without using `mb_params_filter`.** The child composite block uses `mb_params_filter` to extract its namespace.

**`mb_params_filter` ignores entries without a namespace and entries with numeric keys.** Only `["namespace.side", value]` entries are accepted.

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

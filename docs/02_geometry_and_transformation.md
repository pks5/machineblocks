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

Adjacent parts in a composite block that do not overlap may produce gaps or zero-thickness walls when `baseSideAdjustment` is negative. `namedSideAdjustments` allows the outer composite block to specify per-part side extensions to create controlled minimal overlaps.

Inside the part module, named sides are defined via:

```scad
panelSideAdjustment = mb_base_side_adjustment(config, settings, [[2, "start"], [3, "end"]]);
```

This maps side index 2 to the name `"start"` and side index 3 to the name `"end"`. The outer block then passes:

```scad
["namedSideAdjustments", [["start", 0.01], ["end", 0.01]]]
```

The named sides receive the specified adjustment value (in mm, added to the normal `baseSideAdjustment`).

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

**Direction is not visual rotation.** Use `rotation` only when grid alignment is not possible.

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

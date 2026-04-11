# MachineBlocks — Geometry, Transformation & Structure Concepts

version: 1.0.0

## Purpose of this Document

This document explains the concepts and relationships behind MachineBlocks geometry, transformation, and structure parameters. It does not repeat parameter definitions — for all parameter details (types, defaults, formats, constraints), see `09_api_parameters_1_0_1.yml`.

---

# Core Geometry Concepts

## Bounding Box Principle

The bounding box is defined exclusively by `size`. No other parameter modifies the bounding box — only the visible geometry inside it. For simple blocks, the bounding box matches the visible geometry. For complex blocks (slopes, wedges, recess structures), the bounding box defines the structural outer space while visible geometry may be smaller.

> `size` defines the spatial contract of a block.

## Shape Modification

Core geometry parameters modify the block shape within the bounding box in distinct ways:

`size` defines space. `slope` modifies height per side — positive values slope the top surface, negative values create inverted slopes on the bottom. `bevel` modifies the footprint by shifting top corners in XY space, producing wedge shapes. `crop` applies hard cuts or extensions to the geometry.

### Key Relationships

Slope modifies height, not footprint. Bevel modifies footprint, not height. Slope and bevel cannot be combined — this is a hard constraint. Crop does not affect bounding box or positioning. Corner rounding is applied after cropping.

> Wedges are not a primitive — they emerge from bevel transformations.

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

Blocks are always designed in west orientation. Direction is applied during placement. Its primary role is placement in the grid; its secondary role is structural orientation in composite blocks.

### rotation — Free Geometric Rotation

`rotation` is a free geometric rotation applied after alignment. It is not grid-safe and can break alignment assumptions and connectivity. Children are rotated along with the parent. The pivot depends on the current alignment.

> Use `direction` for grid-aligned orientation. Use `rotation` only as a last-resort transformation.

### rotationOffset — Pivot Control

`rotationOffset` shifts the rotation pivot before rotation is applied. If `rotationOffsetRevert = true`, the offset is reversed after rotation.

> `rotationOffset` controls the pivot of rotation; `offset` controls final placement.

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

Use cases: wrapper blocks without own body, multiline text (plate with body + bricks with `base=false` for text only), composite bricks where only certain features are drawn in a sub-brick.

### 2. Underside System

`baseCutoutType` defines the underside structure. The choice of underside type determines connection behavior and print efficiency:

`standard` provides the classic LEGO tube structure. `studs` provides individual holes per stud — grid-compatible but only fits exactly on studs. `groove` is the counterpart to `tongue` for the tongue/groove attachment system. `none` provides a solid underside for embedded blocks in composite structures.

`baseWallThickness` controls the wall thickness of the standard underside. It is a compatibility constant, not a design variable — do not modify it directly. Use `baseWallThicknessAdjustment` for calibration.

`baseWallGapsX` and `baseWallGapsY` restore grid compatibility in composite blocks where blocks cross each other's underside walls.

### 3. Enclosure System

`recess` creates a top-down cavity, turning a block into a box-like structure. It is the foundation of all enclosure structures. When active with `baseCutoutType=standard`, the baseCutout depth is reduced to minimum.

`recessWallThickness` defines the wall thickness per side. `recessWallGaps` creates controlled openings in walls. Both affect tongue and groove behavior.

> Use `recessWallGaps` to create openings — never set `recessWallThickness = 0` for this purpose.

### 4. Connection System

Two connection mechanisms serve different purposes:

**tongue + groove** — continuous connection strip. Tongue wraps around the outermost ring of studs. Used both for connection and for splitting geometry into printable parts. Can be used with or without recess.

**connectors** — segmented side connection elements using triangles. Alternative to tongue/groove for side-by-side and angled (90-degree) connections.

> Choose `tongue` for continuous connections (typically vertical assembly). Choose `connectors` when continuous tongue is not suitable (angled structures, modular connections).

## Geometry vs Structure

These two domains serve different purposes:

Geometry defines shape (what the block looks like). Structure defines function (how the block behaves physically). For example, `slope` is a visual shape parameter while `recess` is a functional cavity parameter. Both operate within the same bounding box but address different concerns.

> Structure parameters define how a block behaves as a physical object — including enclosure, connection, and printability.

---

# Common Pitfalls

These are critical for correct AI reasoning:

**Direction is not visual rotation.** `direction` is semantic orientation and part of placement. Use `rotation` only for cases where grid alignment is not possible.

**Offset is not a rotation tool.** Use `rotationOffset` for pivot control, not `offset`.

**Side indices never change with direction.** They always refer to the west-oriented local block space, regardless of which direction is applied.

**Align affects rotation results.** Because rotation happens after alignment, different alignments produce different effective rotation results.

**Children are not positioned after the parent transform.** They are built first in local space, then transformed together with the parent.

**baseWallThickness is not a design variable.** It is a compatibility constant for the LEGO underside structure. Use `baseWallThicknessAdjustment` in config for calibration.

**Wall openings must use recessWallGaps.** Setting `recessWallThickness = 0` does not create clean openings — use `recessWallGaps` instead.

**tongue works without recess.** The tongue connection system does not require recess to be active.

---

## Parameter Reference

For all parameter definitions, types, defaults, formats, constraints, and AI usage guidelines, see `09_api_parameters_1_0_1.yml`.

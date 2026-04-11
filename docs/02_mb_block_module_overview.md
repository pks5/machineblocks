## Purpose of this Document

This document describes the central MachineBlocks module:

```text
mb_block(config = undef, settings = undef)
```

It explains:

* what `mb_block()` is
* what it is responsible for
* how parameters are resolved
* how geometry and children are built
* how transformations are applied
* what `mb_block()` can and cannot express

This document focuses on the **core module itself**, not on higher-level block patterns or editor workflows.

---

## Mental Model

`mb_block()` is the **universal parametric primitive generator** of MachineBlocks.

It is:

* the low-level geometry engine
* the single public core module
* the basis for all higher abstractions

It is not:

* a semantic block definition
* a complete device model
* a helper module
* a set definition

The semantic meaning of a block is always defined **outside** `mb_block()`, usually by a block module such as:

```text
mb_block__mm__anyclosure__floor(...)
```

---

## Core Responsibilities of `mb_block()`

`mb_block()` is responsible for:

* generating the local geometry of a block
* resolving parameter values
* applying LEGO-compatible base logic
* applying calibration-dependent behavior through `config`
* building and transforming nested child blocks
* rendering supported structural and surface features

Typical supported feature classes include:

* base geometry
* studs
* holes
* slopes
* wedges
* recesses
* text
* SVG / pattern surfaces
* connectors
* screw holes
* PCB mounting features
* rounding and shaping options

---

## Public Signature

The public call signature is:

```text
mb_block(config = undef, settings = undef)
```

Both arguments are optional arrays of key-value pairs.

Example:

```text
[
  ["size", [4, 2, 3]],
  ["align", "start"]
]
```

---

## Parameter Model

### config

`config` is the environment-level parameter set.

Typical responsibilities:

* printer profile
* filament calibration
* scaling presets
* tolerance-related values
* global rendering or manufacturing defaults

Properties:

* global
* typically passed through all nested block calls
* intended to stay stable across a whole structure

---

### settings

`settings` is the instance-level parameter set.

Typical responsibilities:

* block size
* position
* alignment
* surface features
* design-specific behavior
* local overrides

Properties:

* local
* specific to one block instance
* usually redefined for child blocks

---

## Parameter Resolution

The standard resolution order is:

```text
settings → config → default
```

This is typically implemented with:

```text
mb_params_resolve(config, settings, "key", default)
```

Meaning:

1. read from `settings`
2. if missing, read from `config`
3. if still missing, use the default

---

## Parameter Access Variants

### Read only from settings

```text
mb_params_get(settings, "size", default=[1,1,1])
```

Use this when the parameter is intentionally instance-local.

---

### Read only from config

```text
mb_params_get(config, "scale", default=1.0)
```

Use this when the parameter is intentionally environment-driven.

---

### Read from settings and config

```text
mb_params_resolve(config, settings, "size", default=[1,1,1])
```

Use this when the parameter can exist on both levels.

---

## Dedicated Getter Functions

Some important parameters have dedicated helper functions, for example:

```text
mb_params_get_unitMbu(settings)
mb_params_resolve_unitMbu(config, settings)
```

These exist to centralize critical defaults.

This is important because:

* defaults for core geometric behavior must stay consistent
* composite logic may depend on the same defaults
* local duplication of those defaults would create inconsistencies

### Rule

Important system parameters should use dedicated getter functions whenever available.

---

## Units and Grid

MachineBlocks uses a layered unit system:

```text
mm → mbu → grid → block geometry
```

---

### MachineBlocks Base Unit

```text
unitMbu = 1.6
```

`unitMbu` defines the base geometric unit in millimeters.

Most idealized block geometry is built as multiples of this base unit.

---

### Grid

Default:

```text
unitGrid = [5, 2]
```

Meaning:

* X = 5 mbu
* Y = 5 mbu
* Z = 2 mbu

This corresponds to the default 1×1 LEGO plate grid.

---

### Scale

```text
scale = 1.0
```

`scale` rescales the system globally.

Typical use cases:

* 2× LEGO-like blocks
* 3× scaled constructions
* alternative compatible systems

---

## Geometry vs Calibration

MachineBlocks separates idealized geometry from real-world calibration.

### Geometry layer

* based on `unitMbu`
* based on `unitGrid`
* deterministic
* scalable

### Calibration layer

All parameters containing `Adjustment` are calibration parameters.

Rule:

```text id="02015"
*Adjustment parameters are always expressed in millimeters
```

These are used for:

* printer compensation
* filament shrinkage
* fit tuning
* tolerance adjustments

They are not part of the idealized block coordinate system.

---

## Size and Bounding Box

### size

```text
size = [x, y, z]
```

`size` is the most important parameter.

It defines the **bounding box** of the block in grid units.

---

### Important distinction

For simple blocks:

```text
bounding box = visible geometry
```

For more complex blocks:

```text
bounding box ≠ exact visible geometry
```

Examples:

* slopes
* wedges
* recess structures

In those cases, `size` still defines the structural outer space of the block.

---

## Coordinate Systems

### Side indexing

Block sides are always indexed as:

```text
0 → -X
1 → +X
2 → -Y
3 → +Y
4 → -Z
5 → +Z
```

These side indices are always defined in the native **west-oriented coordinate system**.

They do not get renumbered by `direction`.

---

### Corner indexing

Corners are indexed from 0 to 3 per axis.

General rule:

* corner 0 = nearest to block origin
* numbering proceeds clockwise
* for the Z-axis, the viewing direction is inverted

This system is used for corner-aware geometric modifications such as rounding or beveling.

---

## Execution Pipeline of `mb_block()`

This is the most important internal mental model.

`mb_block()` does not immediately transform geometry.
It first builds geometry locally, then transforms the full result.

### Execution order

```text id="02020"
1. resolve parameters
2. build own geometry (local space)
3. build children (local space)
4. apply direction
5. apply align
6. apply rotation (with rotationOffset)
7. apply offset
```

---

## Important consequence

Children are built **before** transformations.

That means:

* children are built in local block space
* children are transformed together with the parent result
* direction, align, rotation and offset affect the entire local structure

### Core rule

```text id="02021"
Geometry and children are built first. Transformations are applied afterwards.
```

---

## Positioning Model

### align

`align` defines the block’s alignment relative to its reference space.

Allowed values per axis:

```text id="02022"
start
center
end
```

It can be written as:

* full vector, e.g. `["start","center","start"]`
* compact form, e.g. `"ccs"`
* shorthand `"start"` meaning `["start","start","start"]`

If a block has no parent, `align` defines global alignment.

---

### alignChildren

`alignChildren` defines the origin inside the parent block for its children.

Default:

```text
["start","start","start"]
```

This means the local child origin is at the lower-left-near corner of the parent.

Example:

```text
alignChildren = "ccs"
```

This moves the child origin to the horizontal center, resting on the floor.

### Core rule

```text
alignChildren defines the origin for children; align positions a child relative to that origin
```

---

### offset

`offset` is the final positional displacement.

It is applied last.

Important:

```text
offset positions the final result
```

It is not a rotation helper and is not rotated itself.

If a block has no parent and uses default alignment, `offset` behaves like absolute placement in the global grid.

---

## Direction vs Rotation

### direction

`direction` is the semantic grid-aligned orientation of a block.

Values:

```text
west  → 0°
north → 90°
east  → 180°
south → 270°
```

Properties:

* applied before alignment
* part of placement logic
* swaps X/Y interpretation at 90° and 270°
* does not change internal side or corner indexing

### Core rule

```text
Blocks are designed in west orientation. direction is applied during placement.
```

---

### rotation

`rotation` is a free geometric rotation.

Properties:

* applied after direction and align
* independent of grid compatibility
* visual / geometric transformation only

Use `rotation` when the block must be rotated freely, not when it must be semantically oriented on the grid.

---

### rotationOffset

`rotationOffset` shifts the rotation pivot before rotation is applied.

It affects rotation only, not direction.

If:

```text
rotationOffsetRevert = true
```

the offset is reversed after rotation.

### Core rule

```text id="02030"
rotationOffset controls the pivot of rotation; offset controls final placement
```

---

## Children and Nesting

`mb_block()` supports OpenSCAD `children()`.

Example:

```text
mb_block() {
    mb_block();
}
```

This allows hierarchical composition.

Important rules:

* `config` must usually be passed through to children
* child `settings` are usually local and explicit
* children are built in local space before parent transformations

This capability makes `mb_block()` not only a geometry primitive, but also a local composition container.

---

## What `mb_block()` Can Express Well

A single `mb_block()` is well suited for:

* classic bricks and plates
* stud variations
* Technic-compatible holes
* slopes
* wedges
* rounded blocks
* top recess structures
* single-line text
* PCB-compatible cavity geometries
* straight liftarms
* many single-body LEGO-like primitives

The common pattern behind all of them is:

```text
single-body geometry inside one structural bounding box
```

---

## What `mb_block()` Should Not Express Alone

A single `mb_block()` should not be used for:

* L-shaped structures
* T-shaped structures
* Cross-shaped structures
* brackets in Z direction
* bent liftarms
* panel-like side recess structures
* cable channels
* other branching or multi-segment support structures

These must currently be modeled as composites.

### Core rule

```text
If the shape branches, changes structural direction, or requires multiple independent segments, use composition
```

---

## Printability Matters

MachineBlocks is primarily a 3D-print-oriented system.

This means geometry decisions are not based on visual shape alone.

They also depend on:

* whether the part is printable without support
* whether it should be split into multiple parts
* whether a permanent connection such as tongue + groove is required

This is why some shapes that look simple are still composite in practice.

Example classes:

* panels
* cable channels
* enclosure corners

---

## Typical Usage Inside Block Modules

The most common higher-level usage pattern of `mb_block()` is:

```text
1. read parameters
2. assign defaults
3. map them into a new settings array
4. call mb_block(config, mapped_settings)
```

This is the basis of semantic block modules.

Simple wrappers may forward `settings` unchanged.
Composite modules may create multiple internal `mb_block()` calls around a wrapper block.

---

## Common Pitfalls

These are important for AI reasoning.

### Pitfall 1

```text
direction is not visual rotation
```

`direction` is semantic orientation and part of placement.

---

### Pitfall 2

```text
offset is not a rotation tool
```

Use `rotationOffset` for pivot control.

---

### Pitfall 3

```text
side indices never change with direction
```

They always refer to west-oriented local block space.

---

### Pitfall 4

```text
align affects rotation results
```

Because rotation happens after alignment, different alignments can produce different effective results.

---

### Pitfall 5

```text
children are not positioned after the parent transform
```

They are built first, then transformed together with the parent.

---

## Minimal Examples

### Example 1 — Simple primitive block

```text
mb_block(
  config = config,
  settings = [
    ["size", [4,2,3]]
  ]
);
```

A classic single-body primitive block.

---

### Example 2 — Grid-oriented block

```text
mb_block(
  config = config,
  settings = [
    ["size", [4,2,3]],
    ["direction", "north"]
  ]
);
```

The logical block is still designed in west orientation.
Its structural orientation is changed during placement.

---

### Example 3 — Nested local composition

```text
mb_block(
  config = config,
  settings = [
    ["size", [4,4,4]]
  ]
){
  mb_block(
    config = config,
    settings = [
      ["size", [2,2,2]],
      ["align", "ccs"]
    ]
  );
}
```

The child is built locally first, then transformed together with the parent.

---

## Final Principle

`mb_block()` is the universal low-level primitive of MachineBlocks.

It is extremely powerful, but it still has a clear boundary:

* it defines and generates single-body parametric block logic
* it supports local composition through children
* it does not define semantic meaning by itself
* it should not be forced to express structures that are fundamentally composite

All higher-level intelligence in MachineBlocks starts from understanding this boundary correctly.
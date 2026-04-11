# MachineBlocks — System

version: 1.0.0

## Purpose

MachineBlocks is an OpenSCAD-based system for generating parametric, LEGO-compatible 3D blocks. Its primary use case is 3D printing, but it can also be used for general 3D modeling (e.g. Unity or CAD workflows).

The system is designed as a foundation for generating real-world machines composed of modular, printable blocks.

---

## Core Principle

MachineBlocks follows a single-module architecture. There is one core module — `mb_block()` — and all geometry is defined through parameters (>200). Complexity is not created through multiple modules, but through parameter combinations, composition (multiple blocks), and nesting (`children()`).

---

## What mb_block() Is

`mb_block()` is the universal parametric primitive generator of MachineBlocks. It is the low-level geometry engine, the single public core module, and the basis for all higher abstractions.

It is not a semantic block definition, not a complete device model, not a helper module, and not a set definition. The semantic meaning of a block is always defined outside `mb_block()`, usually by a block module.

### Core Responsibilities

`mb_block()` is responsible for generating the local geometry of a block, resolving parameter values, applying LEGO-compatible base logic, applying calibration-dependent behavior through `config`, building and transforming nested child blocks, and rendering supported structural and surface features.

---

## Public Signature

```text
mb_block(config = undef, settings = undef)
```

Both arguments are optional arrays of key-value pairs:

```text
[
    ["size", [4,2,3]],
    ["align", "start"],
    ["direction", "west"]
]
```

---

## Parameter Model

### config

`config` is the environment-level parameter set. It defines printer profiles, filament calibration, scaling presets, tolerance-related values, and global rendering or manufacturing defaults. It is global — typically passed through all nested block calls and intended to stay stable across a whole structure.

### settings

`settings` is the instance-level parameter set. It defines block size, position, alignment, surface features, design-specific behavior, and local overrides. It is local — specific to one block instance and usually redefined for child blocks.

### Resolution Order

The library always resolves every parameter in this order:

```text
settings → config → default
```

This is implemented with:

```text
mb_params_resolve(config, settings, "key", default)
```

The library does not restrict any parameter to config-only or settings-only at the resolution level. Individual block modules may assume certain parameters are always provided in settings, but this is a module-level decision, not a library-level restriction.

### Parameter Access Variants

Read only from settings (when a parameter is intentionally instance-local):

```text
mb_params_get(settings, "size", default=[1,1,1])
```

Read only from config (when a parameter is intentionally environment-driven):

```text
mb_params_get(config, "scale", default=1.0)
```

Read from both (standard resolution):

```text
mb_params_resolve(config, settings, "size", default=[1,1,1])
```

### Dedicated Getter Functions

Some important parameters have dedicated helper functions:

```text
mb_params_get_unitMbu(settings)
mb_params_resolve_unitMbu(config, settings)
```

These exist to centralize critical defaults. Important system parameters should use dedicated getter functions whenever available, because defaults for core geometric behavior must stay consistent and local duplication of those defaults would create inconsistencies.

---

## Unit System

MachineBlocks uses a layered unit system:

```text
mm → mbu → grid → block geometry
```

The base unit (`unitMbu`) is 1.6 mm. Most idealized block geometry is built as multiples of this base unit.

The grid (`unitGrid = [5, 2]`) expresses the size of a 1×1 LEGO plate in mbu. X and Y share the first value (5 mbu), Z uses the second (2 mbu). A 1×1 plate = 8×8×3.2 mm at default settings.

The scale factor (`scale`) rescales the entire system globally. mbu values remain unchanged; only the resulting physical dimensions change.

### Absolute Size Formula

```text
absolute_mm = size[i] * unitGrid[0 or 1] * unitMbu * scale
```

X/Y use unitGrid[0], Z uses unitGrid[1].

> For all parameter details, defaults, and units see `09_api_parameters_1_0_1.yml`.

---

## Geometry vs Calibration

MachineBlocks separates idealized geometry from real-world calibration. These are two distinct domains that must not be mixed.

The geometry layer is based on `unitMbu` and `unitGrid`. It is deterministic and scalable.

The calibration layer consists of all parameters containing `Adjustment` in their name. Adjustment parameters are always expressed in millimeters, never scale with the `scale` parameter, and are used for printer compensation, filament shrinkage, fit tuning, and tolerance adjustments. They are not part of the idealized block coordinate system.

> AI must NOT use adjustment parameters in settings to modify individual bricks. AI MAY use them in config to assist the user with printer/material calibration.

---

## Coordinate Systems

### Side Indexing

Block sides are always indexed as:

```text
0 → -X (left)
1 → +X (right)
2 → -Y (front)
3 → +Y (back)
4 → -Z (bottom)
5 → +Z (top)
```

These side indices are always defined in the native west-oriented coordinate system. They do not get renumbered by `direction`.

### Corner Indexing

Corners are indexed from 0 to 3 per axis. When viewed frontally along the direction of an axis, numbering begins at the corner closest to the brick origin and proceeds clockwise. Exception: Z-axis uses inverted view direction (top to bottom).

---

## Execution Pipeline

This is the most important internal mental model. `mb_block()` does not immediately transform geometry. It first builds geometry locally, then transforms the full result.

### Execution Order

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

### Critical Consequence

Children are built before transformations. This means children are built in local block space, then transformed together with the parent result. Direction, align, rotation and offset affect the entire local structure.

> Geometry and children are built first. Transformations are applied afterwards.

---

## Composition

### Flat Composition

```text
mb_block();
mb_block();
```

Multiple blocks placed independently in the same scope.

### Nested Composition

```text
mb_block(){
    mb_block();
}
```

Uses OpenSCAD `children()`. Requires `config` propagation. Child `settings` are usually local and explicit. Children are built in local space before parent transformations.

This capability makes `mb_block()` not only a geometry primitive, but also a local composition container.

---

## Block Modules

Block modules are wrappers around `mb_block()`:

```text
mb_block__<package>
```

They share the same signature `(config, settings)`, map parameters to `mb_block`, and provide reusable abstractions.

Example:

```text
mb_block__mm__anyclosure__floor
```

### Typical Usage Pattern

The most common higher-level usage of `mb_block()` is:

```text
1. Read parameters
2. Assign defaults
3. Map them into a new settings array
4. Call mb_block(config, mapped_settings)
```

Simple wrappers may forward `settings` unchanged. Composite modules may create multiple internal `mb_block()` calls around a wrapper block.

---

## Block Structure (Editor Model)

### Block

The logical unit. A block represents a single functional or structural element.

### BlockPart

The SCAD-based unit. Contains `mb_block()` or equivalent. Multiple parts can form one block, combining multiple printable parts and external components into a single logical block.

### Components

Represent external objects such as PCBs, motors, etc. Defined by SCAD models. Used for fitting and mounting.

### Sets

Collections of blocks. Can represent assemblies or full devices.

---

## Versioning Model

All entities (Blocks, Components, Sets) are versioned. Only finalized versions can be referenced. Finalized means immutable. Changes require a new version, copying BlockParts, and re-finalization.

---

## Block Files

Each block file is a reusable module, contains its own example, and is directly executable in OpenSCAD. Use `use <file.scad>` to ignore example code when importing.

---

## System Role

MachineBlocks is not just a library. It is a parametric geometry system, a generation system for block modules, and a foundation for automated hardware creation.

The MachineBlocks editor acts as both human interface and AI interface. It generates block modules, uses them as executable artifacts, and functions as a 3D parameter interface.

---

## Documentation Architecture

This documentation is a formal, machine-readable specification of the system. Its purpose is to enable deterministic generation of valid block modules, correct interpretation of parameters and rules, and automated construction of complex structures.

The documentation consists of:

```text
01_system.md                     — this document (architecture, units, execution model)
02_geometry_and_transformation.md — concepts for geometry, positioning, and structure
03_patterns_and_examples.md       — structural patterns with concrete examples
04_decision_system.md             — AI decision framework and rules
09_api_parameters_1_0_1.yml       — Single Source of Truth for all parameter definitions
```

The YAML file is authoritative for all parameter definitions (types, defaults, formats, constraints). The Markdown documents explain concepts, relationships, and decision logic — they do not duplicate parameter definitions.

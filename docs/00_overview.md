# MachineBlocks — Overview

## Purpose

MachineBlocks is an OpenSCAD-based system for generating parametric, LEGO-compatible 3D blocks.
Its primary use case is 3D printing, but it can also be used for general 3D modeling (e.g. Unity or CAD workflows).

The system is designed as a foundation for generating real-world machines composed of modular, printable blocks.

---

## Core Principle

MachineBlocks follows a **single-module architecture**:

* One core module: `mb_block()`
* All geometry is defined through **parameters (>200)**

Complexity is not created through multiple modules, but through:

* parameter combinations
* composition (multiple blocks)
* nesting (`children()`)

---

## Execution Model

```text
mb_block(config, settings)
```

Both inputs are arrays of key-value pairs:

```text
[
    ["size", [4,2,3]],
    ["align", "start"],
    ["direction", "west"]
]
```

### Parameter Resolution

```text
settings → config → default
```

* `settings` override `config`
* defaults are applied if neither defines a value

---

## Config vs Settings

### config

* environment definition
* typically:

  * 3D printer profiles
  * material calibration
* propagated through nested blocks

### settings

* instance definition
* applies only to a single block
* defines geometry and behavior

---

## Measurement System

MachineBlocks uses a layered unit system:

```text
mm → mbu → grid → block
```

### Base Unit

* `unitMbu` = 1.6 mm

### Grid

* `unitGrid` = [5, 2]
* represents a 1×1 LEGO plate:

  * X/Y: 5 mbu
  * Z: 2 mbu

### Scale

* `scale` rescales the entire system
* allows larger or smaller block systems

---

## Geometry vs Calibration

Two separate domains:

### Geometry

* based on mbu and grid
* deterministic and scalable

### Calibration

* parameters containing `Adjustment`
* always defined in **mm**
* used for:

  * tolerances
  * printer/material compensation

---

## Block Model

### `size`

* defines the **bounding box** in grid units
* does not necessarily equal final geometry
* basis for positioning and composition

---

## Transformation Model

Blocks are always authored in **west orientation**.

### Direction (semantic rotation)

```text
west  → 0°
north → 90°
east  → 180°
south → 270°
```

* applied first
* swaps X/Y at 90° / 270°
* grid-aligned
* part of **placement**, not design

---

### Alignment System

#### `align`

* positions block relative to origin
* per axis: `start`, `center`, `end`

#### `alignChildren`

* defines origin inside parent block
* default: `["start","start","start"]`

---

### Final Transform Order

```text
1. direction
2. align
3. rotationOffset
4. rotation
5. rotationOffsetRevert (optional)
6. offset
```

---

### Rotation vs Direction

* `direction`:

  * grid-aligned
  * semantic orientation

* `rotation`:

  * free rotation
  * applied after alignment

---

### Rotation Pivot

* `rotationOffset` shifts pivot before rotation
* `rotationOffsetRevert` restores position after rotation

---

### Final Placement

* `offset` is applied last
* not affected by rotation
* defines final position

---

## Coordinate Systems

### Sides

```text
0 → -X
1 → +X
2 → -Y
3 → +Y
4 → -Z
5 → +Z
```

* fixed in west orientation
* not remapped by `direction`

---

### Corners

* indexed 0–3 per axis
* start at corner closest to origin
* proceed clockwise
* Z-axis uses inverted view direction

---

## Composition

### Flat Composition

```text
mb_block();
mb_block();
```

### Nested Composition

```text
mb_block(){
    mb_block();
}
```

* uses OpenSCAD `children()`
* requires `config` propagation

---

## Block Modules

Block modules are wrappers around `mb_block()`:

```text
mb_block__<package>
```

* same signature: `(config, settings)`
* map parameters to `mb_block`
* provide reusable abstractions

Example:

```text
mb_block__mm__anyclosure__floor
```

---

## Block Structure (Editor Model)

### Block

* logical unit

### BlockPart

* SCAD-based unit
* contains `mb_block()` or equivalent
* multiple parts can form one block

### Purpose

* combine:

  * multiple printable parts
  * external components
* into a single logical block

---

## Components

* represent external objects:

  * PCBs, motors, etc.
* defined by SCAD models
* used for:

  * fitting
  * mounting

---

## Sets

* collections of blocks
* can represent:

  * assemblies
  * full devices

---

## Versioning Model

All entities are versioned:

```text
Blocks
Components
Sets
```

Rules:

* only **finalized versions** can be referenced
* finalized = immutable
* changes require:

  * new version
  * copying BlockParts
  * re-finalization

---

## Block Files

Each block file:

* is a reusable module
* contains its own example
* is directly executable in OpenSCAD

Use:

```text
use <file.scad>
```

to ignore example code when importing.

---

## System Role

MachineBlocks is not just a library.

It is:

* a parametric geometry system
* a generation system for block modules
* a foundation for automated hardware creation

---

## Editor Role

The MachineBlocks editor acts as:

* human interface
* AI interface

It:

* generates block modules
* uses them as executable artifacts
* functions as a **3D parameter interface**

---

## Core Objective of This Documentation

This documentation is not descriptive.

It is:

> a formal, machine-readable specification of the system

Its purpose is to enable:

* deterministic generation of valid block modules
* correct interpretation of parameters and rules
* automated construction of complex structures

---

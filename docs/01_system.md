# MachineBlocks — System

version: 1.3.0

## Purpose

MachineBlocks is an OpenSCAD-based system for generating parametric, LEGO-compatible 3D blocks. Its primary use case is 3D printing, but it can also be used for general 3D modeling (e.g. Unity or CAD workflows).

The system is designed as a foundation for generating real-world machines composed of modular, printable blocks. The MachineBlocks Online Editor allows users to store, publish, share, remix blocks, generate sets, and build functional electronic devices composed of blocks containing electronic components.

---

## Core Principle

MachineBlocks follows a single-module architecture. There is one core module — `mb_block()` — and all geometry is defined through parameters (>200). Complexity is not created through multiple modules, but through parameter combinations, composition (multiple blocks), and nesting (`children()`).

---

## Key Terminology

### Block Module

An OpenSCAD module that uses `mb_block()` directly or indirectly. Follows the naming convention `mb_block__<package>` where package segments are separated by double underscores.

```text
module mb_block__my__package__wall(config = undef, settings = undef){ ... }
```

The Block Module is the reusable code unit. It always has the signature `(config, settings)`.

### Block File

An OpenSCAD `.scad` file that contains a Block Module plus a customizer section with variable definitions and the module call. The file is named after the module it contains.

```text
mb_block__my__package__wall.scad
```

A Block File is always self-contained and executable — it works standalone in OpenSCAD Desktop and in the MachineBlocks Online Editor. When imported via `use <file.scad>`, only the module definition is loaded; the customizer section is ignored.

> Block Module = the reusable SCAD module. Block File = the executable SCAD file containing the module.

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

The library does not restrict any parameter to config-only or settings-only at the resolution level. Individual block modules may assume certain parameters are always provided in settings, but this is a module-level decision, not a library-level restriction. Modules may deliberately use `mb_params_get(settings, ...)` to read only from settings and ignore config for specific parameters.

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

## Development Flow

### Offline Development

Block Files are typically developed on a local PC using OpenSCAD Desktop for preview and rendering, combined with an AI-capable IDE (e.g. Cursor, VS Code + Claude Code) for code generation and editing. The developer creates the Block File, tests it in OpenSCAD, and uploads the finished file to the MachineBlocks Online Editor.

### Online Editor

The Online Editor stores blocks, manages config profiles, and provides rendering. Block Files uploaded to the Online Editor are functionally identical to local files with one exception: import paths are automatically converted during upload.

### Path Conversion

Local development uses relative paths that depend on the project structure. The Online Editor uses fixed virtual paths.

```text
Local:   use <../../../machineblocks/lib/block.scad>;
Online:  use <machineblocks/lib/block.scad>;

Local:   include <../../config/mb_config.scad>;
Online:  include </mb_config.scad>;
```

The Online Editor converts paths automatically during upload. AI systems generating Block Files should use local paths by default and note that conversion happens on upload.

### Config Profiles

Locally, a `config/mb_config.scad` file includes the active printer/material profile:

```scad
// mb_config.scad
include <./mb_config_PRUSA_printer.scad>;
```

The profile defines the `mb_config` variable:

```scad
// mb_config_PRUSA_printer.scad
mb_config = [
    ["baseHeightAdjustment", -0.1]
];
```

In the Online Editor, config profiles are stored in the database. The editor generates a virtual `mb_config.scad` based on the active profile.

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

They share the same signature `(config, settings)`, map parameters to `mb_block`, and provide reusable abstractions. Sub-modules use extended package names: `mb_block__<package>__<sub>`. Global functions follow the same convention: `mb_block__<package>__<func_name>`.

Example:

```text
mb_block__mm__anyclosure__floor
```

### Typical Usage Pattern

The most common higher-level usage of `mb_block()` is:

```text
1. Read parameters from settings (and optionally config)
2. Assign defaults
3. Map them into a new settings array
4. Call mb_block(config, mapped_settings)
```

Simple wrappers may forward `settings` unchanged. Composite modules may create multiple internal `mb_block()` calls around a wrapper block.

---

## Block Structure (Editor Model)

### Block

The logical unit. A block represents a single functional or structural element. In the editor context, a block can itself consist of multiple sub-blocks.

### BlockPart

The SCAD-based unit. Contains `mb_block()` or equivalent. Multiple parts can form one block, combining multiple printable parts and external components into a single logical block.

### Components

Represent external objects such as PCBs, motors, etc. Defined by SCAD models. Used for fitting and mounting.

### Sets

Collections of blocks. Can represent assemblies or full devices. A device is a specialized form of a set.

---

## Versioning Model

All entities (Blocks, Components, Sets) are versioned. Only finalized versions can be referenced. Finalized means immutable. Changes require a new version, copying BlockParts, and re-finalization.

---

## Block Files

Each Block File is a self-contained `.scad` file that is directly executable in OpenSCAD. It contains a Block Module definition, customizer variables for interactive parameter control, and the module call with config propagation. When imported via `use <file.scad>`, only the module definition is loaded.

For the complete Block File structure, customizer syntax, config handling, and module patterns, see `03_patterns_and_examples.md`.

### Block File Natures

Block Files fall into two categories based on their purpose:

**Content Block Files** produce 3D-printable blocks. They are the core product of MachineBlocks — bricks, panels, enclosures, lids, and all other physical blocks. Content Block Files are typically authored by humans (with or without AI assistance) and uploaded to the Online Editor.

**Helper Block Files** serve editor and tooling functions. They are typically generated (not hand-authored) and use the same Block File structure and customizer system, but their purpose is not to produce printable blocks. Helper types include:

Preview Helpers — combine multiple Block Parts into a single composite view. Used by the Online Editor to render a complete block that consists of several parts. The customizer exposes assembly mode (unassembled/assembled/merged).

Placement Helpers — provide an interactive 3D interface for positioning a Block Part within a composite block. Customizer variables (offset, direction, align) are read back by the editor and stored. The active part is visually highlighted; other parts are shown semi-transparent.

Set Instruction Helpers — render step-by-step assembly instructions for Sets. A STEPS array defines the build order. Three modes control rendering: `total` (all instances), `step` (cumulative up to current step with highlight), and `instance` (single block). The customizer slider controls the current step.

> Content Block Files are authored. Helper Block Files are generated. Both follow the same Block File structure.

### Block Module Classification

Block Modules are classified along two independent axes:

**Pattern** (how the module is technically built): Primitive Wrapper, Simple Block, or Composite Block. See `03_patterns_and_examples.md` for details.

**Nature** (what the module's purpose is): Content or Helper.

These axes are independent — a Helper Block File can use any pattern internally.

---

## Legacy Module: machineblock()

### Overview

The legacy `machineblock()` module predates the `mb_block()` architecture. It uses direct OpenSCAD module parameters instead of the `config`/`settings` key-value pair system. It has no concept of config vs settings separation. Internally, `machineblock()` maps all its parameters into a settings array and calls `mb_block()`. It remains available for backward compatibility but is not recommended for new development because every call creates a settings array with all ~200 parameters, regardless of how many are actually used.

### Legacy File Structure

Legacy files are not standardized Block Files. They are regular OpenSCAD files with customizer variables that call `machineblock()` directly — typically without wrapping the call in a module. They often contain an `overrideConfig` boolean and `_ovr` suffixed variables that allowed users to override calibration values from the customizer. Deprecated parameters like `baseRoundingResolution`, `pillarRoundingResolution`, `holeRoundingResolution`, and `studRoundingResolution` may also be present.

### Converting Legacy Files to Block Files

AI systems should be able to convert legacy files to the modern Block File format. The conversion does not need to be perfect — manual refinement is expected. The goal is to automate the bulk of the structural work.

#### Step 1 — Create Block File Structure

Add the standard Block File structure: header, imports (with correct local paths), customizer section, module call, and module definition. Use the naming convention `mb_block__<package>__<name>`.

#### Step 2 — Replace machineblock() with mb_block()

Convert `machineblock(param1=val1, param2=val2)` to `mb_block(config=config, settings=[["param1", val1], ["param2", val2]])`. Only include parameters that are actually set — do not create entries for parameters left at their defaults.

#### Step 3 — Remove Legacy Calibration

Remove all `_ovr` suffixed customizer variables and the `overrideConfig` boolean. Calibration parameters belong in config profiles, not in Block Files. Remove deprecated parameters (`baseRoundingResolution`, `pillarRoundingResolution`, `holeRoundingResolution`, `studRoundingResolution`).

#### Step 4 — Wrap in Block Module

Encapsulate all `mb_block()` calls inside a Block Module with the standard `(config, settings)` signature.

#### Step 5 — Handle Multiple Calls

If the legacy file contains multiple `machineblock()` calls, insert a wrapper `mb_block()` with `base=false`, `studs=false` that contains the converted calls as children. If an `assembly` parameter exists, assign it to the wrapper. If a clear shared `size` exists, assign it to the wrapper and derive child sizes from it. If no clear shared size exists, keep sizes directly in the children.

#### Step 6 — Handle Alignment

If children used `align="ccs"`, set `alignChildren="ccs"` on the wrapper. Ideally remove `align="ccs"` from children and adjust their offsets accordingly, but this may require manual refinement to preserve the exact geometry.

#### Step 7 — Consolidate Composed Values

Legacy files often split complex parameter values across multiple customizer variables (e.g. `bevel0`, `bevel1`, `bevel2`, `bevel3` for the four corners, or `baseRoundingRadiusX`, `baseRoundingRadiusY`, `baseRoundingRadiusZ` for per-axis rounding). Keep the individual customizer variables for the UI, but combine them under `/* [Hidden] */` and pass the combined value to the module.

---

## System Role

MachineBlocks is not just a library. It is a parametric geometry system, a generation system for block modules, and a foundation for automated hardware creation.

The MachineBlocks editor acts as both human interface and AI interface. It generates block modules, uses them as executable artifacts, and functions as a 3D parameter interface.

---

## Documentation Architecture

This documentation is a formal, machine-readable specification of the system. Its purpose is to enable deterministic generation of valid block modules, correct interpretation of parameters and rules, and automated construction of complex structures.

The documentation consists of:

```text
01_system.md                     — this document (architecture, units, execution model, terminology)
02_geometry_and_transformation.md — concepts for geometry, positioning, and structure
03_patterns_and_examples.md       — block file structure, module patterns, and concrete examples
04_decision_system.md             — AI decision framework and rules
09_api_parameters_1_0_1.yml       — Single Source of Truth for all parameter definitions
```

The YAML file is authoritative for all parameter definitions (types, defaults, formats, constraints). The Markdown documents explain concepts, relationships, and decision logic — they do not duplicate parameter definitions.

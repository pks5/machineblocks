# MachineBlocks — System

version: 3.0.4

> **Render Output** — Compiler render artifact of MachineBlocks BML (SSOT), not an
> authored source. Primary sources:
> `com.machineblocks.bml.documentation.concept.*`,
> `com.machineblocks.bml.documentation.scad.*`, and related domain BML.
> Future builds regenerate this Markdown from BML. Do not edit as canonical —
> change BML first; keep this file in sync only as a transitional mirror.

## Purpose

MachineBlocks is a parametric system for generating LEGO-compatible 3D blocks, primarily for 3D printing but also applicable to general 3D modeling workflows (e.g. Unity or CAD).

This documentation describes the MachineBlocks V3 SCAD Library — the reference SCAD Render Target of the MachineBlocks ecosystem. OpenSCAD is not the canonical representation of blocks; it is the render target that produces STL and 3MF output for 3D printing. The canonical representation is MBOM (MachineBlocks Object Model), which is compiled from MBML (MachineBlocks Markup Language) source files.

Generating SCAD files directly — either manually or via AI — remains fully supported and is the current primary workflow. It is expected to become the exception as the MBML/MBOM toolchain matures.

The system is designed as a foundation for generating real-world machines composed of modular, printable blocks. The MachineBlocks Online Editor allows users to store, publish, share, remix blocks, generate sets, and build functional electronic devices composed of blocks containing electronic components.

---

## Architecture & Ecosystem

MachineBlocks follows a layered architecture:

```text
MBML (MachineBlocks Markup Language)
  ↓
MBOM (MachineBlocks Object Model)
  ↓
SCAD Render Target  ←  this documentation
  ↓
STL / 3MF
```

**MBML** is a declarative markup language for describing blocks, sets, and devices. It is the authoring format — the equivalent of HTML or SAPUI5 XML views. Blocks are described as typed, parameterized elements without any knowledge of SCAD.

**MBOM** is the renderer-independent object model. It is the canonical representation of all block data. The MBML compiler parses MBML and produces MBOM. MBOM defines all parameter types canonically — for type definitions and MBOM-to-SCAD mappings see `05_types_and_mapping.md`.

**SCAD** is the render target. The SCAD compiler serializes MBOM into OpenSCAD files, which are then rendered to STL or 3MF by OpenSCAD. This documentation is the complete specification of the SCAD render target — it defines all parameters, their SCAD formats, and their MBOM mappings.

**The Editor** is built entirely on MBOM. It has no knowledge of SCAD except for triggering the render pipeline. Block authoring, validation, snapping, layout, and all editor logic operate on MBOM exclusively.

**Direct SCAD generation** — writing or AI-generating `.scad` Block Files directly — is fully supported and is the current primary workflow for existing users. It bypasses MBML and MBOM entirely. This is expected to become a legacy/advanced path as the MBML toolchain matures.

---

## Status Convention

BlockML definitions and documentation express maturity via **status Block references** — not strings or boolean flags. See `02_mbml.md` — § Status.

**Default:** `status:Stable` at document root. Status is inherited downward; authors declare status **only when deviating** from the inherited effective status.

Core status blocks:

```text
status:Stable       — implemented, tested, and MBOM mapping complete. Behavior is reliable.
status:Draft        — V3 definition exists; implementation or MBOM mapping incomplete or untested. May change.
status:Stub         — placeholder; shape declared, behaviour not yet specified.
status:Deprecated   — retained for compatibility; do not use in new work.
```

Use `status:Draft` with an explicit note when SCAD implementation and MBOM target are misaligned (formerly labelled WIP in prose). Example:

```text
Status: status:Draft — MBOM canonical form defined; SCAD implementation reflects V2 behavior.
```

Status annotations apply independently to the SCAD implementation and to the MBOM mapping. A parameter can be `status:Stable` on the SCAD side and `status:Draft` on the MBOM mapping side.

Domain libraries may define additional status blocks. There is no implicit resolution of bare names — always use the `status:` prefix.

---

## Core Principle

MachineBlocks follows a single-module architecture. There is one core module — `mb_block()` — and all geometry is defined through parameters (>200). Complexity is not created through multiple modules, but through parameter combinations, composition (multiple blocks), and nesting (`children()`).

---

## Key Terminology

### Block Module

An OpenSCAD module that uses `mb_block()` directly or indirectly. Follows the naming convention `mb__<package>` where package segments are separated by double underscores.

```text
module mb__my__package__Wall(config = undef, settings = undef){ ... }
```

The Block Module is the reusable code unit. It always has the signature `(config, settings)`.

### Block File

An OpenSCAD `.scad` file that contains a Block Module plus a customizer section with variable definitions and the module call. The file is named after the module it contains.

```text
Wall.scad
```

A Block File is always self-contained and executable — it works standalone in OpenSCAD Desktop and in the MachineBlocks Online Editor. When imported via `use <file.scad>`, only the module definition is loaded; the customizer section is ignored.

> Block Module = the reusable SCAD module. Block File = the executable SCAD file containing the module.

---

## What mb_block() Is

`mb_block()` is the universal parametric primitive generator of MachineBlocks. It is the low-level geometry engine, the single public core module, and the basis for all higher abstractions.

It is not a semantic block definition, not a complete device model, not a helper module, and not a set definition. The semantic meaning of a block is always defined outside `mb_block()`, usually by a block module.

### Core Responsibilities

`mb_block()` is responsible for generating the local geometry of a block, resolving parameter values, applying LEGO-compatible base logic, applying calibration-dependent behavior through `config`, building and transforming nested child blocks, and rendering supported structural and surface features.

### Parameters Ignored by mb_block()

The following native parameters exist in the system but are intentionally ignored by `mb_block()`. They are only meaningful in composite block modules:

- `assembly` — controls assembly mode visualization in composite blocks
- `renderGroups` — controls which named render groups of a composite block are rendered

Note: `render` and `id` are processed by `mb_block()` directly.

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

### Native Parameters vs Custom Parameters

There are two kinds of parameters in MachineBlocks. The criterion is **NativeBlock**, not “whatever `mb_block()` happens to accept today”:

**Native parameters** — every property declared on `com.machineblocks.bml.core.NativeBlock`. In SCAD they MUST be read via the dedicated getter named after the property:

```scad
size = mb_param_size(config, settings);
baseAdjustment = mb_param_baseAdjustment(config, settings);
```

Optional third argument: block-specific default override (`mb_param_size(config, settings, [4, 2, 3])`).

**Custom parameters** — any other parameter (module-specific; not a NativeBlock property). They MUST be read via the generic getter:

```scad
myParam = mb_param(config, settings, "myParam", "myDefaultValue");
```

> All block modules MUST use `mb_param_[propertyName]()` for NativeBlock properties and `mb_param()` for everything else. Never invent a native getter for a custom name. Never use `mb_param()` for a NativeBlock property. Direct array access is not permitted.

**Reference:** `blocks/com/machineblocks/bml/examples/Cross.scad` (`mb__com__machineblocks__examples__Cross`) uses native getters for `size`, `studs`, `baseColor`, … and `mb_param()` for `brick1SizeY`, `brick2SizeX`, `brick1OffsetY`, `brick2OffsetX`.

### Format Resolution

Native parameter getters automatically resolve external formats to internal formats:

```text
direction:            "west" → 0,  "north" → 1,  "east" → 2,  "south" → 3

baseAdjustment:   pseudo-map format: [["x-", 0.1], ["z+", 0.1]]
                      mb_block() interprets only the standard sides x-, x+, y-, y+, z-, z+

align / alignChildren:
  "start"             → ["start", "start", "start"]
  "ccs"               → ["center", "center", "start"]
  "eee"               → ["end", "end", "end"]
  ["start","center"]  → ["start", "center", "start"]  (invalid entries → "start")
  (Since V3: getters always return a resolved 3-element array)
```

All other per-side parameters follow the same resolution pattern as `crop`.

### config

`config` is the environment-level parameter set. It defines printer profiles, filament calibration, scaling presets, tolerance-related values, and global rendering or manufacturing defaults. It is global — typically passed through all nested block calls and intended to stay stable across a whole structure.

### settings

`settings` is the instance-level parameter set. It defines block size, position, alignment, surface features, design-specific behavior, and local overrides. It is local — specific to one block instance and usually redefined for child blocks.

### Resolution Order

The library always resolves every parameter in this order:

```text
settings → config → default
```

The library does not restrict any parameter to config-only or settings-only at the resolution level.

### Merging Settings

To merge two settings arrays where the second overrides the first for duplicate keys:

```scad
mb_params_merge(a, b)
```

`mb_params_merge` is a semantic alias for `mb_map_merge` (from `utils.scad`). It is available directly from `block.scad` without a separate import. Use it in composite blocks to merge parameter maps.

Example:
```scad
mb_params_merge(
    [["size", [1,2,3]], ["baseColor", "#f0f0f0"]],
    [["baseColor", "#ffffff"]]
)
// → [["size", [1,2,3]], ["baseColor", "#ffffff"]]
```

### Filtering Parameters

To filter a pseudo-map parameter by namespace prefix:

```scad
mb_params_filter(param, namespace, overrides?)
```

`mb_params_filter` accepts any parameter in the format `[[key, value], ...]` where each key is a string. It returns only entries whose key starts with `namespace.`, removing the namespace prefix from the key. Entries without a namespace prefix and entries with numeric keys are silently ignored.

An optional third argument `overrides` applies fixed key-value pairs to the result after filtering, unconditionally overriding any matching values.

```scad
// Filter baseAdjustment for namespace "pbx"
mb_params_filter(baseAdjustment, "pbx")
// [["pbx.x+", 0.01]] → [["x+", 0.01]]

// With fixed override: x+ is always 0.1 regardless of input
mb_params_filter(baseAdjustment, "pbx", [["x+", 0.1]])

// Numeric keys and entries without namespace are ignored:
mb_params_filter([["x+", 0.1], [1, -0.1], ["pbx.z+", 0.1]], "pbx")
// → [["pbx.z+", 0.1]]
```

`mb_params_filter` is universal and can be applied to any parameter that uses the `[[string, value]]` pseudo-map format, such as `baseAdjustment` or `baseWallGaps`.

To read a raw value from a single parameter array without resolution, use `mb_params_get`:

```scad
function mb_params_get(params, key, default=undef) = mb_map_get(params, key, default);
```

`mb_params_get` reads the raw value from ONE parameter array without format resolution. It is a semantic alias for `mb_map_get`. It does NOT resolve shortcut formats (e.g. "ccs" stays "ccs", not ["center","center","start"]). Use this only in special cases in composite blocks. For native parameters always use the dedicated getters. For custom parameters use `mb_param()`.

---

## Development Flow

### Offline Development

Block Files are typically developed on a local PC using OpenSCAD Desktop for preview and rendering, combined with an AI-capable IDE (e.g. Cursor, VS Code + Claude Code) for code generation and editing. The developer creates the Block File, tests it in OpenSCAD, and uploads the finished file to the MachineBlocks Online Editor.

### Online Editor

The Online Editor stores blocks, manages config profiles, and provides rendering. Block Files uploaded to the Online Editor are functionally identical to local files with one exception: import paths are automatically converted during upload.

In the MBML/MBOM workflow, the Online Editor will accept MBML source files instead of SCAD Block Files. SCAD is then generated internally by the compiler and is not exposed to the user.

### Path Conversion

Local development uses relative paths that depend on the project structure. The Online Editor uses fixed virtual paths.

```text
Local:   use <../../../../../machineblocks/lib/block.scad>;
Online:  use <machineblocks/lib/block.scad>;

Local:   include <../../../../config/mb_config.scad>;
Online:  include </mb_config.scad>;
```

The Online Editor converts paths automatically during upload. AI systems generating Block Files should use local paths by default and note that conversion happens on upload.

### Config Profiles

Locally, a `config/mb_config.scad` file includes the active printer/material profile:

```scad
/**
* MachineBlocks Config File
*/

/*
* Profile
*
* PRUSA MK3s
*/
include <mb_config__prusa_mk3s.scad>;
```

The included profile file defines the `mb_config` variable:

```scad
/**
* MachineBlocks Config File Profile
*
* Profile: PRUSA MK3s
*/

/*
* MB Config
*/
mb_config = [
    ["studHeightAdjustment", 0]
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

> For all parameter details, defaults, and units see `09_api_parameters.yml`.

---

## Geometry vs Calibration

MachineBlocks separates idealized geometry from real-world calibration. These are two distinct domains that must not be mixed.

The geometry layer is based on `unitMbu` and `unitGrid`. It is deterministic and scalable.

The calibration layer consists of all parameters containing `Adjustment` in their name. Adjustment parameters are always expressed in millimeters, never scale with the `scale` parameter, and are used for printer compensation, filament shrinkage, fit tuning, and tolerance adjustments. They are not part of the idealized block coordinate system.

> AI must NOT use adjustment parameters in settings to modify individual bricks. AI MAY use them in config to assist the user with printer/material calibration.

---

## Coordinate Systems

### Side Indexing

Block sides are always indexed as integers (0–5) or string identifiers (V3+):

```text
0 / "x-" → -X (left)
1 / "x+" → +X (right)
2 / "y-" → -Y (front)
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
mb__<package>
```

They share the same signature `(config, settings)`, map parameters to `mb_block`, and provide reusable abstractions.

### Naming Conventions

Sub-modules (same signature as main module):
```text
mb__<package>__<SubName>
```

Helper modules (own arbitrary signature, uses subpackage `help`):
```text
mb__<package>__help__<helperName>
```

Global functions (uses subpackage `func`):
```text
mb__<package>__func__<funcName>
```

The names `func` and `help` are reserved and cannot be used as regular sub-module names.

### Typical Usage Pattern

```text
1. Read native parameters via mb_param_{name}()
2. Read custom parameters via mb_param()
3. Map them into a new settings array
4. Call mb_block(config, mapped_settings)
```

Simple wrappers may forward `settings` unchanged. Composite modules may create multiple internal `mb_block()` calls around a wrapper block.

---

## Library Structure

A MachineBlocks library has the following directory structure:

```text
{lib}/
    scad/            ← required
        user/        ← AI default target for generated blocks
    config/          ← optional
    lib/             ← optional
```

### Root Package

Every library has a root package, which may consist of multiple segments. Examples: `com.machineblocks` (MachineBlocks), `com.martianmicro` (MartianMicro).

### Package to Path Mapping

All package segments after the root package correspond to subdirectories under `/scad/`. The last segment is the class name (PascalCase) and maps to both the folder name and the filename:

```text
Package:  com.martianmicro.anyclosure.Wall
Root:     com.martianmicro
Path:     scad/com/martianmicro/anyclosure/
File:     Wall.scad
```

The module name uses all package segments with `__` separators, and the class segment is PascalCase:

```text
Module:   mb__com__martianmicro__anyclosure__Wall
```

### The /scad/user/ Folder

`/scad/user/` is the default target folder for AI-generated blocks when the user does not specify an explicit package. The generated block's package is:

```text
{root_package}.user.{ClassName}
```

This folder is in `.gitignore` and can be freely modified by the user.

### AI Block Generation — Output Summary

When generating a block in chat (without an explicit package), the AI must always end its response with a summary:

```text
Package:   com.martianmicro.user.MyBlock
Module:    mb__com__martianmicro__user__MyBlock
Filename:  MyBlock.scad
Location:  mylib/scad/com/martianmicro/user/MyBlock.scad
```

### Path Assumptions

The AI assumes `machineblocks/` is always a sibling to other libraries:

```text
mylib/
    config/
    scad/
        com/
            martianmicro/
                user/
                    MyBlock.scad
machineblocks/
    config/
    scad/
    lib/
```

Relative paths from a block file in `mylib/scad/com/martianmicro/user/`:

```text
use <../../../../../machineblocks/lib/block.scad>;
include <../../../../config/mb_config.scad>;
```

Paths adjust accordingly for deeper package nesting.

---

## Block Structure (Editor Model)

### Block

The logical unit. A block represents a single functional or structural element. In the editor context, a block can itself consist of multiple sub-blocks.

### BlockPart

The SCAD-based unit. Contains `mb_block()` or equivalent. Multiple parts can form one block, combining multiple printable parts and external components into a single logical block.

### Components

Represent external objects such as PCBs, motors, etc. Defined by SCAD models. Used for fitting and mounting.

### Sets

Collections of blocks. Can represent assemblies or full devices. A device is a specialized form of a set. See `10_set_example.scad` for the current set file format.

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

Set Instruction Helpers — render step-by-step assembly instructions for Sets. A STEPS array defines the build order. Four modes control rendering: `total` (fully assembled), `print` (individual parts laid out for printing), `step` (cumulative up to current step with highlight), and `instance` (single block). The customizer slider controls the current step.

> Content Block Files are authored. Helper Block Files are generated. Both follow the same Block File structure.

### Block Module Classification

Block Modules are classified along two independent axes:

**Pattern** (how the module is technically built): Primitive Wrapper, Simple Block, or Composite Block. See `03_patterns_and_examples.md` for details.

**Nature** (what the module's purpose is): Content or Helper.

These axes are independent — a Helper Block File can use any pattern internally.

---

## Legacy Conversion: block() / machineblock() → mb_block()

The legacy `machineblock()` module has been removed. However, converting legacy files to the modern Block File format remains a relevant task for AI systems.

### Version Identification

MachineBlocks has had three major module naming generations:

```text
v1:  block()        — earliest version, no nesting support
v2:  machineblock() — second generation, direct parameter style
v3:  mb_block() / mb__x__y__z() — current version, config/settings style
```

The legacy converter can reliably convert `machineblock()` (V2) to `mb_block()` or composite blocks (V3). This is the primary supported conversion path.

For `block()` (V1) files: structural conversion is possible and often helpful, since many V1 parameters are identical to V2. However, V1 does not support nesting, and behavioral differences may exist. The converter should attempt V1 conversion but always output a warning that manual testing is required after conversion.

Legacy files use direct OpenSCAD module parameters instead of the `config`/`settings` key-value pair system. They often contain an `overrideConfig` boolean, `_ovr` suffixed variables, and deprecated parameters (`baseRoundingResolution`, `pillarRoundingResolution`, `holeRoundingResolution`, `studRoundingResolution`).

### Conversion Steps

**Step 1 — Create Block File Structure**

Add the standard Block File structure: mandatory header, imports (with correct local paths), customizer section, module call, and module definition. Use the naming convention `mb__<package>__<ClassName>` where the class name is PascalCase.

**Step 2 — Replace machineblock() with mb_block()**

Convert `machineblock(param1=val1, param2=val2)` to `mb_block(config=config, settings=[["param1", val1], ["param2", val2]])`. Only include parameters that are actually set.

When referencing sides in converted code, always use string identifiers ("x-", "x+", "y-", "y+", "z-", "z+") instead of integers. This is the V3 standard.

**Step 3 — Remove Legacy Calibration**

Remove all `_ovr` suffixed customizer variables, the `overrideConfig` boolean, and all deprecated `*RoundingResolution` parameters. Calibration parameters belong in config profiles.

Replace `baseWallGapsX`/`baseWallGapsY` with `baseWallGaps`. Entries using "both sides" (old value 2) must be split into two separate entries. Replace integer side references with string identifiers.

**Step 4 — Wrap in Block Module**

Encapsulate all `mb_block()` calls inside a Block Module with the standard `(config, settings)` signature. Use `mb_param_*()` and `mb_param()` getters — no direct array access.

**Step 5 — Handle Multiple Calls**

If the legacy file contains multiple `machineblock()` calls, insert a wrapper `mb_block()` with `base=false`, `studs=false` that contains the converted calls as children. Use `mb_parts_total_size()` if no explicit shared size exists.

**Step 6 — Handle Alignment**

If children used `align="ccs"`, set `alignChildren="ccs"` on the wrapper. Adjust offsets as needed.

**Step 7 — Consolidate Composed Values**

Legacy files often split complex parameter values (e.g. `bevel0..3`, `baseRoundingRadiusX/Y/Z`) across multiple customizer variables. Keep the individual customizer variables for the UI, combine them under `/* [Hidden] */`, and pass the combined value to the module.

### Additional Conversion Rules

**Hidden Section — No Internal Module Computations**

The `/* [Hidden] */` block serves exclusively as customizer convenience. Its only valid use is defining helper variables that bridge customizer variables to module parameters — for example, combining multiple individual customizer values into a single array before passing it to the module.

Variables that are only computed and used internally by the module do NOT belong in the Hidden Section. They must be defined inside the module body only.

```scad
/* WRONG — internal computation in Hidden Section */
/* [Hidden] */
tunnelWidth = (secondColumn ? 1 : 2) * (size[0] - column1SizeX) * mb_unit_grid()[0] * mb_unit_mbu();

/* CORRECT — internal computation inside the module */
module mb__x__y__Z(config = undef, settings = undef){
    tunnelWidth = (secondColumn ? 1 : 2) * (size[0] - column1SizeX) * unitGrid[0] * unitMbu;
    ...
}
```

Native parameter getters (`mb_param_*()`) must NEVER be called in the Hidden Section. The `config` and `settings` parameters do not exist at file scope — they are only available inside the module body. Any attempt to call a getter outside a module will fail or produce incorrect results.

```scad
/* WRONG — getter called in Hidden Section, config/settings not available here */
/* [Hidden] */
bAdjustment = mb_param_baseAdjustment_default();

/* CORRECT — getter called inside the module body */
module mb__x__y__Z(config = undef, settings = undef){
    baseAdjustment = mb_param_baseAdjustment(config, settings);
    ...
}
```

A block module is completely self-contained and must NEVER access global variables.

**Native Parameters — Always Use Getters**

For every parameter read inside a block module, first check whether it is a native parameter (SSOT: `NativeBlock.bml`; SCAD mirror: `09_api_parameters.yml`). If it is native, always use its dedicated getter:

```scad
// Native parameter → getter
baseCutoutType = mb_param_baseCutoutType(config, settings);
pillars        = mb_param_pillars(config, settings);
```

Do not set an explicit default in the getter call unless a block-specific default is intentionally required. Never copy a default from the legacy code if it matches the YML default. Exception: `size` almost always benefits from a block-specific default:

```scad
size = mb_param_size(config, settings, [4, 1, 3]);
```

Custom parameters (not in the YML) continue to use `mb_param()`:

```scad
myParam = mb_param(config, settings, "myParam", "defaultValue");
```

**Legacy Global Variables — `unitMbu`, `unitGrid`, `scale`**

Legacy block files frequently use the variables `unitMbu`, `unitGrid`, and `scale` without defining them in the same file. These always originate from the old global config. In the converted module, they must be retrieved via their dedicated getters:

```scad
unitMbu  = mb_param_unitMbu(config, settings);
unitGrid = mb_param_unitGrid(config, settings);
scale    = mb_param_scale(config, settings);
```

This rule applies whenever these three variable names appear in a legacy file without a local definition.

---

## Documentation Architecture

These files under `scad-lib/docs/` are **Render Output** of MachineBlocks BML —
the same role as pre-rendered `.scad` artifacts under `scad-lib/blocks/`. They are
not the authored specification. The compiler will regenerate them from BML;
until that pipeline exists they remain transitional mirrors.

**SSOT (authored):**

```text
com.machineblocks.bml.documentation.concept.*   — renderer-agnostic concepts
com.machineblocks.bml.documentation.mbml.*      — MBML authoring docs
com.machineblocks.bml.documentation.scad.*      — SCAD render-target docs
com.machineblocks.bml.core.NativeBlock         — native parameter inventory
com.machineblocks.bml.type.*                   — type shapes
```

**Render output (this directory — do not treat as SSOT):**

```text
01_system.md                       — system / architecture / units / legacy (from concept + scad BML)
02_geometry_and_transformation.md  — geometry, transform, structure concepts (from concept BML)
03_patterns_and_examples.md        — Block File structure and module patterns (from scad BML)
04_decision_system.md              — decision framework (from concept + scad BML)
05_types_and_mapping.md            — type catalog and SCAD serialization (from type + scad BML)
09_api_parameters.yml              — SCAD-facing parameter mirror (from NativeBlock + type BML)
10_set_example.scad                — reference Set file format example
```

If Markdown or YAML conflicts with BML, **BML wins**. Update BML first, then
regenerate or sync these artifacts.

### Documentation Extensions

This documentation describes the base MachineBlocks library. Additional libraries may define their own documentation files that extend this base. Extension documents are fully standalone but treat these base documents as their foundation. They may define additional patterns, decision rules, and block module conventions specific to their domain.

Example: The MartianMicro library (`mm`) defines enclosure-specific patterns and decision rules in its own documents, building on MachineBlocks as the geometry foundation.

---

## System Role

MachineBlocks is a parametric geometry system, a generation system for block modules, and a foundation for automated hardware creation.

In the MBML/MBOM workflow, the MachineBlocks editor operates exclusively on MBOM. It functions as both human interface and AI interface for block authoring, validation, and layout. SCAD is invoked only for rendering — the editor has no knowledge of SCAD syntax or parameters.

In the direct SCAD workflow, the editor accepts hand-authored or AI-generated Block Files. This remains the current primary workflow and is fully supported.

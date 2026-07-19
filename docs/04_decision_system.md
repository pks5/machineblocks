# MachineBlocks — Decision System

version: 3.0.5

status: Draft

> **Render Output** — Compiler render artifact of MachineBlocks BML (SSOT), not an
> authored source. Primary sources:
> `com.machineblocks.bml.documentation.concept.DecisionFramework` (Draft) and
> `com.machineblocks.bml.documentation.scad.ScadDecisionRules`. Future builds
> regenerate this Markdown from BML. Do not edit as canonical — change BML first.
>
> Draft note — planned Decision Knowledge package `com.machineblocks.bml.decision.*`
> will own practices/rules; documentation.* stays reading guides.

## Purpose of this Document

This document defines the decision framework the AI must use when working with MachineBlocks. It constrains and guides AI behavior for generating valid block modules, making consistent architectural decisions, and respecting physical constraints.

---

## SCAD Renderer Context

This document defines the decision framework for direct SCAD generation — either manually or via AI. In the MBML/MBOM workflow, these decisions are made by the MBOM compiler; direct SCAD authoring is a legacy and advanced path. The decision rules and patterns described here remain valid for direct SCAD generation. The conceptual layers — semantic intent, pattern selection, parameter realization — are structurally similar to how MBML composition works, but MBML authoring is a separate context and outside the scope of this document. What is unambiguously legacy in the MBML world is custom SCAD block modules containing hand-authored SCAD geometry code.

---

## Fundamental Principle

> The AI does not start with parameters — it starts with intent.

The AI operates in three decision layers:

```text
1. Semantic Intent  (what is this?)
2. Pattern Selection (how is it structured?)
3. Parameter Realization (how is it built?)
```

---

# Decision Layer 1 — Semantic Intent

The AI first determines the purpose of the object by evaluating two modes.

## Semantic Mode (PRIMARY)

Question: What is the purpose of the block? Functional, structural, system-driven, printability-aware.

## Design Mode (SECONDARY)

Question: What should the block look like? LEGO-like, visual, aesthetic, surface features.

> Semantic Mode always has priority over Design Mode. Structure is defined by purpose, not appearance.

## Output Modes

**LEGO Mode** — playful, simplified, visual-first, less strict constraints.

**Device Mode** — functional, real-world usable, printability critical, strict constraints.

> Device Mode is stricter than LEGO Mode.

## Decision Order

```text
1. Semantic Mode (purpose)
2. Output Mode (LEGO or Device)
3. Design Mode (appearance)
```

---

# Decision Layer 2 — Pattern Selection

> The AI selects patterns before parameters.

## Decision Tree

Step 1 — Is it a simple block? Single-body geometry inside one bounding box → use `mb_block()` only.

Step 2 — Is it enclosure-related? → use the enclosure system (see `03_patterns_and_examples.md`).

Step 3 — Is it a wall structure? One side open → Panel. Two opposite sides open → Channel. Corner → Corner Panel or Corner Channel.

Step 4 — Is it multi-part? Multiple distinct bodies → composite block.

Step 5 — Is printability an issue? → split into parts using tongue/groove or connectors.

> Patterns define structure. Composite blocks implement patterns.

---

# Decision Layer 3 — Parameter Realization

After pattern selection, parameters are assigned from the appropriate groups:

Geometry: `size`, `slope`, `bevel`, `baseCrop`, `cutouts` (aggregation `NativeBlock[]`).
Structure: `base`, `recess`, `baseCutoutType`, `tongue`, `connectors`.
Positioning: `direction`, `align`, `offset`.
SCAD composite helpers (not NativeBlock): `assembly`, `renderGroups`. Also `render`, `id`.

> Parameters realize patterns — they do not define them.

> For all parameter definitions see `NativeBlock.bml` + type BML (sole SSOT).
> `09_api_parameters.yml` is a pointer stub only (no inventory).

---

# Block Module Patterns

## Pattern 1 — Primitive Wrapper

Thin pass-through around `mb_block()` with a curated default settings surface. No own logic beyond forwarding.

## Pattern 2 — Semantic / Simple Block

Named module with getters, block-specific defaults, and a focused customizer; still one `mb_block()` at the leaf. Production example: `com.machineblocks.scad.bricks.Standard` — every NativeBlock property via `mb_param_*()`.

## Pattern 3 — Composite Block

Multiple `mb_block()` calls. Must use a wrapper block with:

```text
base = false
studs = false
size defines bounding box
```

Must implement `mb_assembly()` if parts support SCAD assembly preview. Must implement `baseAdjustment` namespace filtering via `mb_params_filter()` if parts are adjacent without overlap. Must implement `renderGroups` via `mb_param_renderGroups()` and `mb_group_render()`. Examples: Cross, Frame.

## Pattern 4 — Helper / Form Module

Shared geometry helpers used by other modules — not end-user content products.

## Decision Logic

```text
if Helper → Pattern 4
else if no semantics → Pattern 1
else if fits capability whitelist → Pattern 2
else → Pattern 3
```

> When in doubt → Composite.

---

# mb_block() Capability Boundary

## Whitelist — Single mb_block()

A single `mb_block()` is well suited for:

Classic geometry (bricks, plates, stud variations, Technic holes). Slopes and wedges (may be combined in V3 — slope + bevel together is supported; V2 forbade it). Round geometry (rounded bricks, circular shapes). Recess structures (box-like top cutout, up to 4 walls, walls removable via gaps, corners always remain). Stud configuration (fully parametric: full, none, or selective). Single-line text on all sides except bottom (-Z). PCB-compatible cavity geometries. Straight Technic liftarms (no bends). Cutouts (brutally applied void subtraction via `cutouts` parameter).

## Blacklist — Composite Required

A single `mb_block()` should not be used for:

Multi-body shapes (L-shaped, T-shaped, cross-shaped). Brackets in Z-direction (vertical angle structures). Panels as side recess structures (require multi-part construction for printability). Cable channels (continuous side recess, enclosure structures). Bent liftarms (any directional change). Carrier structures (any multi-segment support geometry). Multi-line text (use plate with body + bricks with `base=false` for text only).

> If geometry branches, changes structural direction, or requires multiple independent segments → Composite.

---

# Deterministic Device Rules

These rules apply in Device Mode (Semantic Mode = Device).

**Base:** Single `mb_block()` plate.
**Walls:** Composite (panel pattern).
**Corners:** Composite (corner panel pattern).
**Top / Lid:** Single `mb_block()` without studs. Lid is always a separate block.
**Cable Routing:** Composite (panel with continuous recess / channel pattern).
**Inner Parts:** Use `baseCutoutType = "none"` for optimization.

---

# Core Decision Rules

**Rule 1 — Use mb_block when possible.** Simple brick-like shapes → single `mb_block()`.

**Rule 2 — Use composite for complexity.** Multiple parts or functions → composite.

**Rule 3 — Prefer patterns over raw parameters.** Panel pattern > manually configuring recess.

**Rule 4 — Design in west.** Always design in west orientation. Use `direction` for placement.

**Rule 5 — Avoid rotation.** Use `rotation` only if unavoidable. Prefer `direction`.

**Rule 6 — Never use adjustment parameters in settings.** AI must not use calibration parameters to modify individual bricks. They belong in config only.

**Rule 7 — Printability first (Device Mode).** Split geometry if needed for printability.

**Rule 8 — Connection selection.** LEGO connection → standard underside. Structural connection → tongue/groove. Flexible connection → connectors.

**Rule 9 — NativeBlock properties use `mb_param_[propertyName]()`.** Custom parameters use `mb_param()`. Never access settings arrays directly. Criterion: property on `NativeBlock` → native getter; otherwise → `mb_param()`. Reference: `blocks/com/machineblocks/scad/examples/Cross.scad`.

**Rule 10 — Default package for generated blocks.** When generating a block without an explicit package, use `{root_package}.user.{ClassName}`. Always end the response with the output summary (Package, Module, Filename, Location).

**Rule 11 — Block file naming and location (V3).** Filename = class name (PascalCase) `.scad`. Module name uses all Manifestation FQN segments with `__` separators. For MachineBlocks 1:1 SCAD, replace Definition segment `bml` → `scad`:
- Definition FQN `com.machineblocks.bml.bricks.Standard` → Manifestation `com.machineblocks.scad.bricks.Standard`
- Module: `mb__com__machineblocks__scad__bricks__Standard`
- Path: `scad-lib/blocks/com/machineblocks/scad/bricks/Standard.scad`
- Other packages without a `bml` definition segment keep their FQN as-is under `blocks/…`.

**Rule 12 — Face / Direction / Align (V3).** In SCAD settings/config always use Face `scad:value` strings (`"x-"`, `"x+"`, …). In MBML/BOM author enum member ids (`XNeg`, `XPos`, …) — never SCAD face strings as MBOM keys. Integer indices (0–5) are valid in SCAD but not preferred.

---

# Failure Prevention

## Do NOT

Use rotation for basic orientation (use direction instead). Use `baseWallThickness` for design (it is a compatibility constant). Open walls using `recessWallThickness = 0` (use `recessWallGaps`). Ignore underside collisions in composites (use `baseWallGaps`). Access settings arrays directly (use getter functions). Use adjustment parameters in settings (config only). Use `cutout` or `cutoutOffset` (removed in V3 — use `cutouts`). Use any `*RoundingResolution` parameter (removed in V3). Use `baseWallGapsX` or `baseWallGapsY` (removed in V3 — use `baseWallGaps`). Access `assembly[0]` without first resolving via `mb_assembly()`. Use `cutouts` for AI-generated blocks (experimental — do not use autonomously). Use `assemblyParts`, `namedSideAdjustments`, `mb_named_side_adjustments`, `mb_named_height_adjustments`, or `blockName` (removed/replaced in V3).

> Most errors come from using parameters directly instead of patterns.

---

# Mental Model

```text
Intent → Pattern → Composite → Parameters → Transform
```

> The AI builds structures by selecting patterns based on intent, then realizing them through parameters, while respecting printability and structural constraints.

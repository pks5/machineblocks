# MachineBlocks — Patterns and Examples

version: 1.0.0

## Purpose of this Document

This document defines structural patterns — semantic building blocks that combine parameters into meaningful, printable structures. Each pattern is accompanied by concrete examples.

Patterns are the primary abstraction layer for AI-driven design. They translate low-level parameters into functional, printable, and reusable structures.

> Parameters define geometry. Patterns define meaning.

> For all parameter definitions see `09_api_parameters_1_0_1.yml`.

---

## Pattern Hierarchy

```text
Block (mb_block)
→ Pattern (Panel, Channel, etc.)
→ Composite Structure (Enclosure)
```

---

# Simple Block

The simplest valid usage of `mb_block()`. A single-body geometry inside one structural bounding box.

```scad
mb_block(
    config = config,
    settings = [
        ["size", [4,2,3]]
    ]
);
```

No pattern needed. This is the baseline for all other constructions.

---

# Panel

## Semantics

A panel is a structure consisting of a surface with one or more vertical walls. Panels are side-oriented structures derived from recess.

## Implementation

Panels are created using `recess = true` with selective wall removal via `recessWallGaps`.

## Types

A simple panel has one wall with a flat base. A multi-wall panel has multiple walls with side openings.

## Example — Simple Panel

```scad
mb_block(
    config = config,
    settings = [
        ["size", [4,1,5]],
        ["recess", true],
        ["recessWallThickness", [1,0,0,0]]
    ]
);
```

One wall only — minimal panel configuration.

---

# Corner Panel

## Semantics

An L-shaped structure formed by combining two panels.

## Structure

Two panels, each consisting of 2 blocks, for a total of 4 blocks. The panels intersect in an L-shape with internal geometry overlap.

## Underside Correction

Corner panels require underside correction using `baseWallGapsX` and `baseWallGapsY` to maintain grid compatibility.

## Example — Key Parameters

```scad
["baseWallGapsX", [[0,1]]],
["baseWallGapsY", [[0,1]]]
```

---

# Channel

## Semantics

A channel is a panel with two opposing open walls. It creates a continuous path used for cables, airflow, or routing.

## Variants

Straight channels are linear structures. Corner channels have a 90° bend. T-channels have a branching structure.

## Implementation

Based on `recess` with openings defined via `recessWallGaps`.

## Example — Straight Channel

```scad
mb_block(
    config = config,
    settings = [
        ["size", [6,2,4]],
        ["recess", true],
        ["recessWallGaps", [[0,0,0],[1,0,0]]]
    ]
);
```

Uses gaps on sides 0 and 1 (x- and x+) to create a continuous path along the X-axis.

---

# Composite Panel (Printable)

## Semantics

A panel that can be printed without supports by splitting into two parts joined with tongue and groove.

## Structure

Two blocks — one with tongue, one with groove — printed separately and assembled after print.

## Example

```scad
// Part A — tongue
mb_block(
    config = config,
    settings = [
        ["size", [4,2,5]],
        ["recess", true],
        ["tongue", true]
    ]
);

// Part B — groove
mb_block(
    config = config,
    settings = [
        ["size", [4,2,1]],
        ["baseCutoutType", "groove"]
    ]
);
```

---

# Enclosure

## Semantics

A complete housing structure enclosing a device. Enclosures are always composite systems optimized for assembly.

## Standard Structure

```text
1 base plate
4 corner panels
4 wall panels
1 lid
```

The lid is always a separate block.

## Variants

Full loop walls, U-shaped halves, and modular segments are all valid enclosure variants.

## Example — Conceptual Layout

```scad
// Floor
mb_block(
    config = config,
    settings = [
        ["size", [10,10,1]]
    ]
);

// Walls → panels (see Panel pattern)
// Corners → corner panels (see Corner Panel pattern)

// Lid
mb_block(
    config = config,
    settings = [
        ["size", [10,10,1]],
        ["studs", false]
    ]
);
```

## Optimization

Inner parts in large enclosures should use `baseCutoutType = "none"` to reduce print time and material.

---

# Connection Patterns

Two connection systems exist for joining blocks.

## Tongue + Groove

Continuous connection — strong and precise. The tongue wraps around the outermost ring of studs. Can be used with or without recess. The counterpart is `baseCutoutType = "groove"`.

## Connectors

Segmented triangular connection — flexible and modular. Enables side-by-side and angled (90°) connections. Used when continuous tongue is not suitable.

> Choose connection type based on geometry and assembly needs.

---

# Side Feature Block

## Semantics

Adding studs or other features on a vertical surface.

## Structure

A base block combined with a rotated feature block using `base = false`.

## Example

```scad
// Base
mb_block(
    config = config,
    settings = [
        ["size", [4,2,3]]
    ]
);

// Side studs
mb_block(
    config = config,
    settings = [
        ["size", [4,2,3]],
        ["base", false],
        ["studs", true],
        ["rotation", [0,90,0]]
    ]
);
```

Uses `base = false` for the feature layer — demonstrates the combination of body toggle and transformation.

---

# Multi-Part Block (Hidden Split)

## Semantics

A visually single block that prints in multiple parts for improved printability.

## Structure

Split geometry using tongue and groove. The parts appear as one block when assembled.

## Key Insight

This pattern is used for complex geometry that cannot be printed as a single piece. It improves printability while maintaining the visual appearance of a monolithic block.

---

# Assembly Visualization

## Semantics

Showing different fabrication states of the same block.

## Parameters

```scad
["assembly", "unassembled"]  // parts separated
["assembly", "assembled"]    // parts joined
["assembly", "merged"]       // single merged body
```

Critical for UI and preview — separates design from fabrication.

---

# Pattern Relationships

```text
Panel         → 1 open side
Channel       → 2 open sides
Corner Panel  → 2 panels combined
Corner Channel→ 2 channels combined
T-Channel     → 3 channels combined
Enclosure     → panels + corners + base + lid
```

---

# Critical Implementation Rules

**Wall Removal:** Always use `recessWallGaps`, never `recessWallThickness = 0`.

**Connection Interaction:** Walls affect tongue and groove behavior. `recessWallGaps` creates matching openings in tongue and groove automatically.

**Underside Consistency:** Use `baseWallGapsX`/`baseWallGapsY` in composite blocks where blocks cross to maintain grid compatibility.

**Printability:** Complex structures should be split into printable parts using tongue/groove or connectors.

---

# Using Patterns

## When to use Patterns

Whenever functionality is required, whenever multiple blocks are combined, and whenever printability matters.

## When NOT to use single blocks

Enclosure structures, panel systems, and routing systems always require patterns.

## Reuse Rule

If a problem matches an existing pattern, reuse the pattern structure. Do not invent new patterns unnecessarily.

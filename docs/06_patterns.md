# Structural Patterns

## Overview

Patterns define **semantic building blocks** that combine parameters into meaningful structures.

They are higher-level constructs used by the AI to:

- design functional devices
- ensure printability
- organize complex geometry
- reuse proven construction logic

---

## Fundamental Rule

> Parameters define geometry.  
> Patterns define meaning.

---

## Pattern Hierarchy

```

Block (mb_block)
→ Pattern (Panel, Channel, etc.)
→ Composite Structure (Enclosure)

```

---

# Panel

## Semantics

A panel is a structure consisting of:

```

surface + one or more vertical walls

```

---

## Implementation

Panels are created using:

- `recess = true`
- selective wall removal

---

## Types

### Simple Panel

- 1 wall
- flat base

### Multi-Wall Panel

- multiple walls
- side opening

---

## Rule

> A panel is a side-oriented structure derived from recess.

---

# Corner Panel

## Semantics

An L-shaped structure formed by combining two panels.

---

## Structure

```

2 panels
→ each panel = 2 blocks
→ total = 4 blocks

```

---

## Behavior

- panels intersect in an L-shape
- geometry overlaps internally

---

## Underside Correction

Requires:

```

baseWallGapsX
baseWallGapsY

```

---

## Rule

> Corner panels require underside correction to maintain grid compatibility.

---

# Channel

## Semantics

A channel is a panel with:

```

two opposing open walls

```

---

## Behavior

- creates a continuous path
- used for cables, airflow, or routing

---

## Variants

### Straight Channel

- linear structure

### Corner Channel

- 90° bend

### T Channel

- branching structure

---

## Implementation

- based on `recess`
- openings defined via `recessWallGaps`

---

## Rule

> Channels are panel-derived routing structures.

---

# Enclosure

## Semantics

A complete housing structure enclosing a device.

---

## Standard Structure

```

1 base plate
4 corner panels
4 wall panels
1 lid

```

---

## Components

### Base

- flat plate
- often with studs

### Walls

- panels

### Corners

- corner panels

### Lid

- plate with mating structure

---

## Variants

- full loop wall
- U-shaped halves
- modular segments

---

## Rule

> Enclosures are always composite systems optimized for assembly.

---

# Connection Patterns

## Tongue + Groove

- continuous connection
- strong and precise

---

## Connectors

- segmented connection
- flexible and modular

---

## Rule

> Choose connection type based on geometry and assembly needs.

---

# Pattern Relationships

```

Panel        → 1 open side
Channel      → 2 open sides
CornerPanel  → 2 panels combined
CornerChannel→ 2 channels combined
TChannel     → 3 channels combined
Enclosure    → panels + corners + base + lid

```

---

# Printability Principle

Most patterns are designed for:

```

multi-part printing
→ assembly after print

```

---

## Rule

> Complex structures should be split into printable parts.

---

# Critical Implementation Rules

## Wall Removal

```

Use recessWallGaps
NOT recessWallThickness = 0

```

---

## Connection Interaction

```

Walls affect:

* tongue
* groove

```

---

## Underside Consistency

```

Use baseWallGapsX/Y when needed

```

---

# AI Design Rules

## When to use Patterns

- whenever functionality is required
- whenever multiple blocks are combined
- whenever printability matters

---

## When NOT to use single blocks

- enclosure structures
- panel systems
- routing systems

---

## Rule

> Patterns are the primary abstraction layer for AI-driven design.

---

# Final Principle

> Patterns translate low-level parameters into functional, printable, and reusable structures.
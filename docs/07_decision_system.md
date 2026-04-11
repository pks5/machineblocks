# Decision System

## Overview

The decision system defines **how the AI decides what to build and how to build it**.

It connects:

- geometry
- structure
- patterns
- constraints

into a coherent design process.

---

## Fundamental Principle

> The AI does not start with parameters — it starts with intent.

---

## Decision Layers

The AI operates in three layers:

```

1. Semantic Intent (what is this?)
2. Pattern Selection (how is it structured?)
3. Parameter Realization (how is it built?)

```

---

# 1. Semantic Intent

## Definition

The AI first determines the **purpose of the object**.

---

## Modes

### Semantic Mode

```

functional intent

```

Examples:

- enclosure
- support structure
- connector
- decorative block

---

### Design Mode

```

visual / LEGO-like intent

```

Examples:

- brick
- slope
- wedge
- tile

---

## Output Modes

### LEGO Mode

- playful
- simplified
- visually driven

---

### Device Mode

- functional
- structurally correct
- print-aware

---

## Rule

> Semantic intent determines everything that follows.

---

# 2. Pattern Selection

## Core Rule

> The AI selects patterns before parameters.

---

## Decision Tree

### Step 1 — Is it a simple block?

```

YES → use mb_block only
NO  → go to patterns

```

---

### Step 2 — Is it enclosure-related?

```

YES → use enclosure system

```

---

### Step 3 — Is it a wall structure?

```

1 side open → Panel
2 opposite sides open → Channel
corner → Corner Panel / Corner Channel

```

---

### Step 4 — Is it multi-part?

```

YES → composite block

```

---

### Step 5 — Is printability an issue?

```

YES → split into parts + tongue/groove or connectors

```

---

## Rule

> Patterns define structure. Composite blocks implement patterns.

---

# 3. Parameter Realization

After pattern selection, the AI assigns parameters.

---

## Geometry Layer

```

size
slope
bevel
crop

```

---

## Structure Layer

```

base
recess
baseCutoutType
tongue
connectors

```

---

## Positioning Layer

```

direction
align
offset

```

---

## Rule

> Parameters realize patterns — they do not define them.

---

# Core Decision Rules

---

## Rule 1 — Use mb_block when possible

```

simple brick-like shape → mb_block

```

---

## Rule 2 — Use composite for complexity

```

multiple parts or functions → composite

```

---

## Rule 3 — Prefer patterns over raw parameters

```

Panel > manually configuring recess

```

---

## Rule 4 — Design in west

```

direction = west during design

```

---

## Rule 5 — Avoid rotation

```

rotation only if unavoidable

```

---

## Rule 6 — Never use adjustment parameters

```

AI must ignore calibration

```

---

## Rule 7 — Printability first (Device Mode)

```

split geometry if needed

```

---

## Rule 8 — Connection selection

```

LEGO connection → standard
structural connection → tongue/groove
flexible connection → connectors

```

---

# Enclosure-Specific Rules

## Standard Layout

```

floor → mb_block plate
walls → panels
corners → corner panels
lid → plate

```

---

## Optimization

```

inner parts → baseCutoutType = none

```

---

## Channels

```

internal routing → channels

```

---

# Failure Prevention Rules

## Do NOT

- mix slope and bevel
- use rotation for basic orientation
- use baseWallThickness for design
- open walls using thickness=0 (use gaps)
- ignore underside collisions in composites

---

## Rule

> Most errors come from using parameters directly instead of patterns.

---

# Mental Model

```

Intent → Pattern → Composite → Parameters → Transform

```

---

# Final Principle

> The AI builds structures by selecting patterns based on intent, then realizing them through parameters, while respecting printability and structural constraints.
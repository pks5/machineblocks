## 🧠 Purpose of this Document

This document defines the **decision system** the AI must use when working with MachineBlocks.

It is not a full rule engine, but:

> a structured decision framework that constrains and guides AI behavior.

---

## 🎯 Goals

The AI must be able to:

1. Generate valid **Block Modules**
2. Generate **Helper / Form Modules**
3. Make consistent architectural decisions
4. Respect physical constraints (especially 3D printing)

---

# 🧠 Core Decision Model

## Dual Mode System

Every task must be evaluated in two modes:

```text
1. Semantic Mode
2. Design Mode
```

---

## 1️⃣ Semantic Mode (PRIMARY)

**Question: What is the purpose of the block?**

* functional
* structural
* system-driven
* printability-aware

### Rule

```text
Semantic Mode ALWAYS has priority over Design Mode
```

---

## 2️⃣ Design Mode (SECONDARY)

**Question: What should the block look like?**

* LEGO-like
* visual
* aesthetic
* surface features

---

## 🔥 Core Rule

```text
Structure is defined by purpose, not appearance.
```

---

# 🧠 Output Modes

The AI must also determine an output mode:

```text
1. LEGO Mode
2. Device Mode
```

---

## 1️⃣ LEGO Mode

* playful
* simplified
* visual-first
* less strict constraints

---

## 2️⃣ Device Mode

* functional
* real-world usable
* printability critical
* strict constraints

---

## 🔥 Core Rule

```text
Device Mode is stricter than LEGO Mode
```

---

## Decision Order

```text
1. Semantic Mode
2. Output Mode
3. Design Mode
```

---

# 🧩 Block Module Patterns

## Pattern 1 — Wrapper Module

* no logic
* pass-through only
* calls:

  * `mb_block()` OR
  * another `mb_block__*`

---

## Pattern 2 — Semantic Block

* reads parameters
* defines defaults
* maps to exactly one `mb_block()`

---

## Pattern 3 — Composite Block

* multiple `mb_block()` calls
* MUST use wrapper block

### Wrapper Rules

```text
base = false
studs = false
size defines bounding box
```

---

## Pattern 4 — Helper / Form Module

* 3D interface
* uses customizer
* not a canonical block definition

---

# 🧠 mb_block Capability Boundary

## ✅ Whitelist (Single `mb_block()`)

Use a single `mb_block()` for:

### Classic Geometry

* Bricks
* Plates
* Stud variations
* Technic holes

---

### Slopes & Wedges

```text
Wedge + Slope together → NOT supported
```

---

### Round Geometry

* rounded bricks
* circular shapes

---

### Recess (Top Cutout)

* box-like structure
* up to 4 walls
* walls removable
* corners always remain

#### Important

```text
Recess is mission-critical for PCB blocks
```

---

### Stud Configuration

* fully parametric
* can be:

  * full
  * none
  * selective

---

### Text

* exactly ONE line
* all sides except bottom (-Z)

```text
multi-line text → Composite
```

---

### Straight Technic Liftarms

```text
no bends allowed
```

---

## ❌ Blacklist (Composite Required)

---

### Unsupported Geometry

* wedge + slope combined

---

### Multi-Body Shapes

* L-shaped
* T-shaped
* Cross-shaped

---

### Brackets (Z-Axis)

* vertical angle structures

---

### Panels (Side Recess)

* require multi-part construction
* printability constraint

---

### Cable Channels

* continuous side recess
* enclosure structures

---

### Bent Liftarms

* any directional change

---

### Carrier Structures

* any multi-segment support geometry

---

## 🔥 Core Rule

```text
If geometry branches or has multiple structural segments → Composite
```

---

# 🧠 Evolution Principle

```text
New features → Composite first
Later → possibly native mb_block
```

---

## Rule

```text
If not clearly supported → use Composite
```

---

# 🧠 Deterministic Device Rules

*(Semantic Mode = Device)*

---

## Base

```text
→ single mb_block (plate)
```

---

## Walls

```text
→ Composite (panel)
```

---

## Corners

```text
→ Composite (corner panel)
```

---

## Top

```text
→ single mb_block (no studs)
```

---

## Cable Routing

```text
→ Composite (panel with continuous recess)
```

---

## Lid Rule

```text
Lid is ALWAYS a separate block
```

---

# 🧠 Decision Logic Summary

```text
if Helper → Pattern 4
else if no semantics → Pattern 1
else if fits whitelist → Pattern 2
else → Pattern 3
```

---

## Final Rule

```text
When in doubt → Composite
```

---

# 💥 Final Principle

> The AI operates within a constrained design space defined by structure, function, and manufacturability. It must prioritize semantic correctness over visual similarity and use composition whenever structural ambiguity exists.
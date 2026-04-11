# Core Geometry Parameters

## Overview

Core Geometry parameters define the **fundamental shape of a block within its bounding box**.

They operate entirely in the **local coordinate system** and are applied **before any positioning or transformation** (direction, align, rotation, offset).

---

## Fundamental Rule

> The bounding box is defined exclusively by `size`.  
> No other parameter modifies the bounding box — only the visible geometry inside it.

---

## Parameter Group

Core Geometry includes:

- `size`
- `slope`
- `bevel`
- `crop`

---

# size

## Definition

```

size = [x, y, z]

```

## Semantics

Defines the **bounding box** of the block.

---

## Behavior

- Represents the **maximum occupied space**
- Typically matches the real geometry for simple blocks
- Complex geometry (slope, bevel, crop) may reduce visible volume

---

## Grid Relation

```

size = unitGrid * unitMbu

```

- X/Y → studs
- Z → plates

---

## Critical Rule

> `size` defines the spatial contract of a block.

---

## Special Case

Wrapper blocks (`base=false`, `studs=false`) may use abstract sizes,  
but this can break correct alignment behavior.

---

# slope

## Definition

```

slope = [side0, side1, side2, side3]

```

---

## Semantics

Defines **linear height transformations** along block sides.

---

## Behavior

### Positive Values

- Apply slope on **top surface (+Z)**
- Reduce height toward the center

### Negative Values

- Apply slope on **bottom surface (-Z)**
- Create **overhangs (inverted slopes)**

---

## Combined Behavior

Mixed values can produce:

- tilted blocks
- parallelogram-like shapes

---

## Important Notes

- Does not change bounding box
- Supports functional structures (not only visual)

---

## Rule

> `slope` modifies height, not footprint.

---

# bevel

## Definition

```

bevel = [[x0,y0], [x1,y1], [x2,y2], [x3,y3]]

```

---

## Semantics

Shifts the **top corners in XY space**.

---

## Behavior

- Modifies footprint shape
- Combined with bounding box → produces **wedges**

---

## Important

> Wedges are not a primitive — they emerge from bevel transformations.

---

## Rule

> `bevel` modifies footprint, not height.

---

# crop

## Definition

```

crop = [side0, side1, side2, side3]

```

---

## Semantics

Applies **hard cuts or extensions** to the block.

---

## Behavior

- Positive values → cut geometry
- Negative values → extend geometry

---

## Use Cases

- Cross sections
- debugging
- composite filling
- visual slicing

---

## Special Rule

> Corner rounding is applied AFTER cropping.

---

## Rule

> `crop` directly modifies geometry, not via transformation.

---

# Geometry vs Calibration

## Important Distinction

Adjustment parameters (e.g. `baseSideAdjustment`, `baseHeightAdjustment`) are:

- NOT part of Core Geometry
- NOT used for design
- defined in millimeters
- NOT scaled

---

## Rule

> Geometry defines design.  
> Adjustments define physical calibration.

---

## AI Constraint

AI systems:

- MUST NOT generate or modify adjustment parameters
- MUST treat them as external calibration inputs

---

# Summary

```

size   → defines space
slope  → modifies height
bevel  → modifies footprint
crop   → applies hard cuts

```

---

## Final Principle

> Core Geometry defines how a block exists in space —  
> everything else defines how it is placed, connected, or rendered.
